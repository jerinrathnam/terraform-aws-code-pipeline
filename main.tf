
###################### CODE PIPELINE #########################

resource "aws_codepipeline" "this" {
  count = var.create_pipeline ? 1 : 0

  name     = var.name
  role_arn = var.pipeline_role_arn == null ? one(aws_iam_role.pipeline_role[*].arn) : var.pipeline_role_arn

  artifact_store {
    location = local.s3_bucket
    type     = var.codepipeline_artifact_type
    region   = var.codepipeline_artifact_region

    dynamic "encryption_key" {
      for_each = var.encryption_key != null ? var.encryption_key : {}

      content {
        id   = encryption_key.value.id
        type = lookup(encryption_key.value, "type", "KMS")
      }
    }
  }

  stage {
    name = "Source"

    action {
      name             = "Source"
      category         = "Source"
      owner            = var.source_owner
      provider         = var.source_provider
      version          = "1"
      output_artifacts = ["source_output"]

      configuration = {
        ConnectionArn    = var.codestar_connection_arn
        FullRepositoryId = var.repository_id
        RepositoryName   = var.repository_name
        BranchName       = var.branch_name
      }
    }
  }

  dynamic "stage" {
    for_each = (var.build_deployment || var.ecs_deployment) ? [1] : []

    content {
      name = "Build"

      action {
        name             = "Build"
        category         = "Build"
        owner            = "AWS"
        provider         = "CodeBuild"
        input_artifacts  = ["source_output"]
        output_artifacts = ["build_output"]
        version          = "1"

        configuration = {
          ProjectName = one(aws_codebuild_project.this[*].name)
        }
      }
    }
  }

  dynamic "stage" {
    for_each = var.build_deployment ? [] : [1]

    content {
      name = "Deploy"

      action {
        name            = "Deploy"
        category        = "Deploy"
        owner           = "AWS"
        provider        = "CodeDeploy"
        input_artifacts = var.ec2_deployment ? ["source_output"] : ["build_output"]
        version         = "1"

        configuration = {
          "ApplicationName"     = (var.ec2_deployment == false) ? null : (var.create_deploy_group ? one(aws_codedeploy_app.this[*].name) : var.codedeploy_app)
          "DeploymentGroupName" = (var.ec2_deployment == false) ? null : (var.create_deploy_group ? one(aws_codedeploy_deployment_group.this[*].deployment_group_name) : var.deployment_group)
          "ClusterName"         = var.ecs_deployment ? var.cluster_name : null
          "ServiceName"         = var.ecs_deployment ? var.service_name : null
          "FileName"            = var.ecs_deployment ? var.ecs_file_name : null
        }
      }
    }
  }

  tags = merge(
    {
      "Name" = var.name
    },
    var.tags
  )
}

################ CODE BUILD PROJECT #########################

resource "aws_codebuild_project" "this" {
  count = var.ec2_deployment == false ? 1 : 0

  name                 = var.name
  description          = "Codebuild for the ECS app"
  service_role         = var.build_role_arn == null ? one(aws_iam_role.build_role[*].arn) : var.build_role_arn
  encryption_key       = var.build_encryption_key
  project_visibility   = var.build_project_visibility
  resource_access_role = var.resource_access_role
  queued_timeout       = var.queued_timeout
  source_version       = var.build_source_version

  artifacts {
    bucket_owner_access    = var.artifact_bucket_owner_access
    encryption_disabled    = var.artifact_encryption_disabled
    location               = var.build_artifact_location
    name                   = var.artifact_output_name
    namespace_type         = var.artifact_namespace_type
    override_artifact_name = var.override_artifact_name
    packaging              = var.build_artifact_packaging
    path                   = var.build_atrifact_path
    type                   = var.build_artifact_type
  }

  environment {
    compute_type                = var.compute_type
    image                       = var.image_identifier
    type                        = var.environment_type
    image_pull_credentials_type = var.image_pull_credentials_type
    privileged_mode             = var.privileged_mode

    dynamic "environment_variable" {
      for_each = var.env_vars != null ? var.env_vars : {}

      content {
        name  = environment_variable.key
        type  = var.build_env_type
        value = environment_variable.value
      }
    }

    dynamic "registry_credential" {
      for_each = var.registry_credential != null ? [1] : []

      content {
        credential          = var.registry_credential
        credential_provider = "SECRETS_MANAGER"
      }
    }
  }

  source {
    buildspec           = var.buildspec
    location            = var.build_source_location
    report_build_status = var.report_build_status
    type                = var.build_source_type

    dynamic "build_status_config" {
      for_each = var.build_status_config != null ? var.build_status_config : {}

      content {
        context    = lookup(build_status_config.value, "context", null)
        target_url = lookup(build_status_config.value, "target_url", null)
      }
    }

    dynamic "git_submodules_config" {
      for_each = var.git_submodules_config != null ? [1] : []

      content {
        fetch_submodules = var.git_submodules_config
      }
    }
  }

  dynamic "logs_config" {
    for_each = var.enable_build_logs ? [1] : []

    content {
      dynamic "cloudwatch_logs" {
        for_each = var.build_cloudwatch_logs != null ? var.build_cloudwatch_logs : {}

        content {
          group_name  = lookup(cloudwatch_logs.value, "group_name", null)
          status      = lookup(cloudwatch_logs.value, "status", "ENABLED")
          stream_name = lookup(cloudwatch_logs.value, "stream_name", null)
        }
      }

      dynamic "s3_logs" {
        for_each = var.build_s3_logs != null ? var.build_s3_logs : {}

        content {
          bucket_owner_access = lookup(s3_logs.value, "bucket_owner_access", null)
          encryption_disabled = lookup(s3_logs.value, "encryption_disabled", false)
          location            = lookup(s3_logs.value, "location", null)
          status              = lookup(s3_logs.value, "status", "DISABLED")
        }
      }
    }
  }

  dynamic "vpc_config" {
    for_each = var.vpc_config != null ? var.vpc_config : {}

    content {
      security_group_ids = split(",", vpc_config.value.security_group_ids)
      subnets            = split(",", vpc_config.value.subnets)
      vpc_id             = vpc_config.value.vpc_id
    }
  }

  tags = merge(
    {
      "Name" = var.name
    },
    var.tags
  )
}

############### CODE DEPLOY APP & GROUP ######################

resource "aws_codedeploy_app" "this" {
  count = var.ec2_deployment && var.create_deploy_group ? 1 : 0

  compute_platform = var.deployment_compute_platform
  name             = var.name

  tags = merge(
    {
      "Name" = var.name
    },
    var.tags
  )
}

resource "aws_codedeploy_deployment_group" "this" {
  count = var.ec2_deployment && var.create_deploy_group ? 1 : 0

  app_name              = aws_codedeploy_app.this[0].name
  deployment_group_name = var.name
  service_role_arn      = var.deploy_role_arn == null ? one(aws_iam_role.deploy_role[*].arn) : var.deploy_role_arn

  autoscaling_groups     = var.deployment_autoscaling_groups
  deployment_config_name = var.deployment_config_name

  ec2_tag_set {
    dynamic "ec2_tag_filter" {
      for_each = var.ec2_tag_filters

      content {
        key   = ec2_tag_filter.key
        type  = var.ec2_tag_filter_type
        value = ec2_tag_filter.value
      }
    }
  }

  dynamic "deployment_style" {
    for_each = var.deployment_style != null ? var.deployment_style : {}

    content {
      deployment_option = lookup(deploment_style.value, "deployment_option", "WITHOUT_TRAFFIC_CONTROL")
      deployment_type   = lookup(deploment_style.value, "deployment_type", "IN_PLACE")
    }
  }

  dynamic "auto_rollback_configuration" {
    for_each = var.deployment_auto_rollback != null ? var.deployment_auto_rollback : {}

    content {
      enabled = lookup(auto_rollback_configuration.value, "enabled", null)
      events  = [lookup(auto_rollback_configuration.value, "events", null)]
    }
  }

  dynamic "alarm_configuration" {
    for_each = var.deployment_alarm != null ? var.deployment_alarm : {}

    content {
      alarms                    = try(split(",", alarm_configuration.value.alarms), null)
      enabled                   = lookup(alarm_configuration.value, "enabled", null)
      ignore_poll_alarm_failure = lookup(alarm_configuration.value, "ignore_poll_alarm_failure", false)
    }
  }

  dynamic "blue_green_deployment_config" {
    for_each = var.enable_blue_green_deployment ? [1] : []

    content {
      dynamic "deployment_ready_option" {
        for_each = var.deployment_ready_option != null ? var.deployment_ready_option : {}

        content {
          action_on_timeout    = lookup(deployment_ready_option.value, "action_on_timeout", null)
          wait_time_in_minutes = lookup(deployment_ready_option.value, "wait_time_in_minutes", null)
        }
      }

      dynamic "green_fleet_provisioning_option" {
        for_each = var.green_fleet_provisioning_option != null ? var.green_fleet_provisioning_option : {}

        content {
          action = green_fleet_provisioning_option.value.action
        }
      }

      dynamic "terminate_blue_instances_on_deployment_success" {
        for_each = var.terminate_blue_instances_on_deployment_success != null ? var.terminate_blue_instances_on_deployment_success : {}

        content {
          action                           = lookup(terminate_blue_instances_on_deployment_success.value, "action", null)
          termination_wait_time_in_minutes = lookup(terminate_blue_instances_on_deployment_success.value, "termination_wait_time_in_minutes", null)
        }
      }
    }
  }

  dynamic "load_balancer_info" {
    for_each = var.enable_load_balancer ? [1] : []

    content {
      dynamic "elb_info" {
        for_each = var.deploment_elb_name != null ? [1] : []

        content {
          name = var.deploment_elb_name
        }
      }

      dynamic "target_group_info" {
        for_each = var.deployment_target_group_name != null ? [1] : []

        content {
          name = var.deployment_target_group_name
        }
      }

      dynamic "target_group_pair_info" {
        for_each = var.target_group_pair_info != null ? var.target_group_pair_info : {}

        content {
          prod_traffic_route {
            listener_arns = split(",", target_group_pair_info.value.prod_traffic_listener_arns)
          }

          target_group {
            name = target_group_pair_info.value.target_group_name
          }

          dynamic "test_traffic_route" {
            for_each = target_group_pair_info.value.test_traffic_listener_arns != null ? [target_group_pair_info.value.test_traffic_listener_arns] : []

            content {
              listener_arns = split(",", target_group_pair_info.value.test_traffic_listener_arns)
            }
          }
        }
      }
    }
  }

  dynamic "on_premises_instance_tag_filter" {
    for_each = var.on_premises_instance_tag_filter != null ? var.on_premises_instance_tag_filter : {}

    content {
      key   = on_premises_instance_tag_filter.key
      value = on_premises_instance_tag_filter.value
      type  = var.ec2_tag_filter_type
    }
  }

  dynamic "trigger_configuration" {
    for_each = var.trigger_configuration != null ? var.trigger_configuration : {}

    content {
      trigger_events     = split(",", trigger_configuration.value.trigger_events)
      trigger_name       = trigger_configuration.value.trigger_name
      trigger_target_arn = trigger_configuration.value.trigger_target_arn
    }
  }

  tags = merge(
    {
      "Name" = var.name
    },
    var.tags
  )
}