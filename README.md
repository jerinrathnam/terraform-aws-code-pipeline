## Introduction

This Terraform module for AWS CodePipeline, in conjunction with AWS CodeBuild, CodeDeploy, and the associated IAM roles and policies, offers a comprehensive solution for automating your software delivery and deployment workflows. This module empowers you to set up a full-fledged Continuous Integration/Continuous Deployment (CI/CD) pipeline within AWS, enabling you to manage, build, test, and deploy your applications efficiently.

AWS CodePipeline is a fully managed CI/CD service that orchestrates the release process. AWS CodeBuild is a scalable build service, and AWS CodeDeploy is an automated application deployment service. Together, these services create a seamless pipeline for your software delivery needs.

The Terraform module for AWS CodePipeline, CodeBuild, and CodeDeploy simplifies the following aspects of CI/CD pipeline configuration:

**CodePipeline Configuration:** You can define your CI/CD pipeline, including the source code repository, build and deployment stages, and approval actions. This module streamlines the process of creating a pipeline that automates the movement of your code from source to production.

**CodeBuild Project:** This module enables you to specify the build environment and build specifications, including build scripts, source code location, and build artifacts.

**CodeDeploy Deployment Group and Application:** You can create and configure deployment groups and applications, define deployment strategies, and specify target instances.

**IAM Role and Policies:** Proper IAM role and policy configuration is crucial for secure and authorized pipeline operations. With this module, you can define the necessary roles and policies, ensuring that the pipeline, CodeBuild, and CodeDeploy have the appropriate permissions.

By utilizing this Terraform module, you can manage your CI/CD pipeline as code. This approach offers version control and consistency across different environments, making it easier to manage and replicate your software delivery process. It promotes collaboration among development and operations teams, streamlining the development lifecycle and enabling you to quickly deliver new features and updates to your applications.

This Terraform module for AWS CodePipeline simplifies the setup of a robust CI/CD pipeline with other related services. It empowers you to automate your software delivery and deployment processes efficiently and securely within the AWS ecosystem.

## Examples

#### Example of ECS Deployment
```
  module "pipeline" {
    source  = "jerinrathnam/code-pipeline/aws"

    name             = var.name
    s3_bucket_name   = var.s3_bucket_name
    repository_name  = var.repository_name
    branch_name      = var.branch_name
    cluster_name     = var.cluster_name
    service_name     = var.ecs_service_name
    ecs_file_name    = "imagedefinitions.json"

    env_vars = {
      key = "value"
    }

    tags = {
      "Env" = "developement"
    }
  }
```

#### Example of EC2 Deployment
```
  module "pipeline" {
    source  = "jerinrathnam/code-pipeline/aws"

    ecs_deployment     = false
    ec2_deployment     = true
    name               = var.name
    s3_bucket_name     = var.s3_bucket_name
    repository_name    = var.repository_name
    branch_name        = var.branch_name

    ec2_tag_filters = {
      "Name" = var.ec2_name
    }

    tags = {
      "Env" = "developement"
    }
  }
```

#### Example of Build Deployment
```
  module "pipeline" {
    source  = "jerinrathnam/code-pipeline/aws"

    ecs_deployment     = false
    build_deployment   = true
    name               = var.name
    s3_bucket_name     = var.s3_bucket_name
    repository_name    = var.repository_name
    branch_name        = var.branch_name

    env_vars = {
      key = "value"
    }

    tags = {
      "Env" = "developement"
    }
  }
```

## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 0.13.1 |
| <a name="requirement_aws"></a> [aws](#requirement\_aws) | >= 4.20.0 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_aws"></a> [aws](#provider\_aws) | 5.6.1 |

## Description

This module will create a code pipeline, Code Build Project, Code Deployment Application and Group along with their respective IAM Roles and Policies.

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [aws_codebuild_project.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/codebuild_project) | resource |
| [aws_codedeploy_app.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/codedeploy_app) | resource |
| [aws_codedeploy_deployment_group.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/codedeploy_deployment_group) | resource |
| [aws_codepipeline.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/codepipeline) | resource |
| [aws_iam_role.build_role](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role) | resource |
| [aws_iam_role.deploy_role](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role) | resource |
| [aws_iam_role.pipeline_role](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role) | resource |
| [aws_iam_role_policy.build_policy](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role_policy) | resource |
| [aws_iam_role_policy.deploy_policy](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role_policy) | resource |
| [aws_iam_role_policy.pipeline_policy](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role_policy) | resource |
| [aws_caller_identity.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/caller_identity) | data source |
| [aws_region.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/region) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_artifact_bucket_owner_access"></a> [artifact\_bucket\_owner\_access](#input\_artifact\_bucket\_owner\_access) | Specifies the bucket owner's access for objects that another account uploads to their Amazon S3 bucket. Valid values are NONE, READ\_ONLY, and FULL | `string` | `null` | no |
| <a name="input_artifact_encryption_disabled"></a> [artifact\_encryption\_disabled](#input\_artifact\_encryption\_disabled) | Whether to disable encrypting output artifacts. If type is set to NO\_ARTIFACTS, this value is ignored | `bool` | `null` | no |
| <a name="input_artifact_namespace_type"></a> [artifact\_namespace\_type](#input\_artifact\_namespace\_type) | Namespace to use in storing build artifacts. If type is set to S3, then valid values are BUILD\_ID, NONE | `string` | `null` | no |
| <a name="input_artifact_output_name"></a> [artifact\_output\_name](#input\_artifact\_output\_name) | Name of the project. If type is set to S3, this is the name of the output artifact object | `string` | `null` | no |
| <a name="input_branch_name"></a> [branch\_name](#input\_branch\_name) | Name of the source code branch name | `string` | `null` | no |
| <a name="input_build_artifact_location"></a> [build\_artifact\_location](#input\_build\_artifact\_location) | Information about the build output artifact location. | `string` | `null` | no |
| <a name="input_build_artifact_packaging"></a> [build\_artifact\_packaging](#input\_build\_artifact\_packaging) | Type of build output artifact to create. If type is set to S3, valid values are NONE, ZIP | `string` | `null` | no |
| <a name="input_build_artifact_type"></a> [build\_artifact\_type](#input\_build\_artifact\_type) | Build output artifact's type. Valid values: CODEPIPELINE, NO\_ARTIFACTS, S3. | `string` | `"CODEPIPELINE"` | no |
| <a name="input_build_atrifact_path"></a> [build\_atrifact\_path](#input\_build\_atrifact\_path) | If type is set to S3, this is the path to the output artifact. | `string` | `null` | no |
| <a name="input_build_cloudwatch_logs"></a> [build\_cloudwatch\_logs](#input\_build\_cloudwatch\_logs) | Send build outputs to cloudwatch log group | <pre>object({<br>    group_name  = optional(string)<br>    status      = optional(string)<br>    stream_name = optional(string)<br>  })</pre> | `null` | no |
| <a name="input_build_deployment"></a> [build\_deployment](#input\_build\_deployment) | For the deployment from build | `bool` | `false` | no |
| <a name="input_build_encryption_key"></a> [build\_encryption\_key](#input\_build\_encryption\_key) | AWS Key Management Service (AWS KMS) customer master key (CMK) to be used for encrypting the build project's build output artifacts. | `string` | `null` | no |
| <a name="input_build_env_type"></a> [build\_env\_type](#input\_build\_env\_type) | The type of the environment variables | `string` | `"PLAINTEXT"` | no |
| <a name="input_build_project_visibility"></a> [build\_project\_visibility](#input\_build\_project\_visibility) | Specifies the visibility of the project's builds. | `string` | `"PRIVATE"` | no |
| <a name="input_build_role_arn"></a> [build\_role\_arn](#input\_build\_role\_arn) | IAM role ARN for AWS Code Build | `string` | `null` | no |
| <a name="input_build_s3_logs"></a> [build\_s3\_logs](#input\_build\_s3\_logs) | Send build outputs to s3 bucket | <pre>object({<br>    encryption_disabled = optional(bool)<br>    status              = optional(string)<br>    location            = optional(string)<br>    bucket_owner_access = optional(string)<br>  })</pre> | `null` | no |
| <a name="input_build_source_location"></a> [build\_source\_location](#input\_build\_source\_location) | Location of the source code from git or s3. | `string` | `null` | no |
| <a name="input_build_source_type"></a> [build\_source\_type](#input\_build\_source\_type) | Type of repository that contains the source code to be built. | `string` | `"CODEPIPELINE"` | no |
| <a name="input_build_source_version"></a> [build\_source\_version](#input\_build\_source\_version) | Version of the build input to be built for this project. If not specified, the latest version is used. | `string` | `null` | no |
| <a name="input_build_status_config"></a> [build\_status\_config](#input\_build\_status\_config) | Configuration block that contains information that defines how the build project reports the build status to the source provider. | <pre>object({<br>    context    = optional(string)<br>    target_url = optional(string)<br>  })</pre> | `null` | no |
| <a name="input_buildspec"></a> [buildspec](#input\_buildspec) | Build specification to use for this build project's related builds. | `string` | `null` | no |
| <a name="input_cluster_name"></a> [cluster\_name](#input\_cluster\_name) | Name of the ECS Cluster name | `string` | `null` | no |
| <a name="input_codedeploy_app"></a> [codedeploy\_app](#input\_codedeploy\_app) | Name of the code deployment app. Is needed if 'create\_deploy\_group' is set to 'false' | `string` | `null` | no |
| <a name="input_codepipeline_artifact_region"></a> [codepipeline\_artifact\_region](#input\_codepipeline\_artifact\_region) | The region where the artifact store is located | `string` | `null` | no |
| <a name="input_codepipeline_artifact_type"></a> [codepipeline\_artifact\_type](#input\_codepipeline\_artifact\_type) | The type of the artifact store, such as Amazon S3 | `string` | `"S3"` | no |
| <a name="input_codestar_connection_arn"></a> [codestar\_connection\_arn](#input\_codestar\_connection\_arn) | ARN of the code star connection | `string` | `null` | no |
| <a name="input_compute_type"></a> [compute\_type](#input\_compute\_type) | Information about the compute resources the build project will use. | `string` | `"BUILD_GENERAL1_SMALL"` | no |
| <a name="input_create_deploy_group"></a> [create\_deploy\_group](#input\_create\_deploy\_group) | Whether the deployment group shoul be create or not | `bool` | `true` | no |
| <a name="input_create_pipeline"></a> [create\_pipeline](#input\_create\_pipeline) | Whether to create pipeline | `bool` | `true` | no |
| <a name="input_deploment_elb_name"></a> [deploment\_elb\_name](#input\_deploment\_elb\_name) | The name of the load balancer that will be used to route traffic from original instances to replacement instances in a blue/green deployment | `string` | `null` | no |
| <a name="input_deploy_role_arn"></a> [deploy\_role\_arn](#input\_deploy\_role\_arn) | IAM role ARN for AWS Code Deployment Group | `string` | `null` | no |
| <a name="input_deployment_alarm"></a> [deployment\_alarm](#input\_deployment\_alarm) | Configuration block of alarms associated with the deployment group | <pre>object({<br>    alarms                    = optional(string) # A list of alarms configured for the deployment group in string type<br>    enabled                   = optional(bool)<br>    ignore_poll_alarm_failure = optional(bool)<br>  })</pre> | `null` | no |
| <a name="input_deployment_auto_rollback"></a> [deployment\_auto\_rollback](#input\_deployment\_auto\_rollback) | Configuration block of the automatic rollback configuration associated with the deployment group | <pre>object({<br>    enabled = optional(bool)<br>    events  = optional(string)<br>  })</pre> | <pre>{<br>  "enabled": true,<br>  "events": "DEPLOYMENT_FAILURE"<br>}</pre> | no |
| <a name="input_deployment_autoscaling_groups"></a> [deployment\_autoscaling\_groups](#input\_deployment\_autoscaling\_groups) | Autoscaling groups associated with the deployment group. | `list(string)` | `null` | no |
| <a name="input_deployment_compute_platform"></a> [deployment\_compute\_platform](#input\_deployment\_compute\_platform) | The compute platform can either be ECS, Lambda, or Server | `string` | `"Server"` | no |
| <a name="input_deployment_config_name"></a> [deployment\_config\_name](#input\_deployment\_config\_name) | The name of the group's deployment config. The default is 'CodeDeployDefault.OneAtATime' | `string` | `"CodeDeployDefault.OneAtATime"` | no |
| <a name="input_deployment_group"></a> [deployment\_group](#input\_deployment\_group) | Name of the code deployment group. Is needed if 'create\_deploy\_group' is set to 'false' | `string` | `null` | no |
| <a name="input_deployment_ready_option"></a> [deployment\_ready\_option](#input\_deployment\_ready\_option) | Information about the action to take when newly provisioned instances are ready to receive traffic in a blue/green deployment | <pre>object({<br>    action_on_timeout       = optional(string)<br>    deployment_ready_option = optional(number)<br>  })</pre> | `null` | no |
| <a name="input_deployment_style"></a> [deployment\_style](#input\_deployment\_style) | either in-place or blue/green, you want to run and whether to route deployment traffic behind a load balancer | <pre>object({<br>    deployment_type   = optional(string)<br>    deployment_option = optional(string)<br>  })</pre> | `null` | no |
| <a name="input_deployment_target_group_name"></a> [deployment\_target\_group\_name](#input\_deployment\_target\_group\_name) | The name of the target group that instances in the original environment are deregistered from, and instances in the replacement environment registered with. | `string` | `null` | no |
| <a name="input_ec2_deployment"></a> [ec2\_deployment](#input\_ec2\_deployment) | For the EC2 deployment | `bool` | `false` | no |
| <a name="input_ec2_tag_filter_type"></a> [ec2\_tag\_filter\_type](#input\_ec2\_tag\_filter\_type) | The type of the tag filter | `string` | `"KEY_AND_VALUE"` | no |
| <a name="input_ec2_tag_filters"></a> [ec2\_tag\_filters](#input\_ec2\_tag\_filters) | Key and value pairs of ec2 instance tags for code deployment group | `map(string)` | `null` | no |
| <a name="input_ecs_deployment"></a> [ecs\_deployment](#input\_ecs\_deployment) | For the ECS deployment | `bool` | `true` | no |
| <a name="input_ecs_file_name"></a> [ecs\_file\_name](#input\_ecs\_file\_name) | Name of the file for ECS deployment | `string` | `"imagedefinitions.json"` | no |
| <a name="input_enable_blue_green_deployment"></a> [enable\_blue\_green\_deployment](#input\_enable\_blue\_green\_deployment) | Whether to enable blue green deployment | `bool` | `false` | no |
| <a name="input_enable_build_logs"></a> [enable\_build\_logs](#input\_enable\_build\_logs) | Whether to enable build logs sent to s3 or cloudeatch logs | `string` | `false` | no |
| <a name="input_enable_load_balancer"></a> [enable\_load\_balancer](#input\_enable\_load\_balancer) | whetheer to enable the load balancer to use in a blue/green deployment | `bool` | `false` | no |
| <a name="input_encryption_key"></a> [encryption\_key](#input\_encryption\_key) | The encryption key block AWS CodePipeline uses to encrypt the data in the artifact store, such as an AWS Key Management Service (AWS KMS) key. | <pre>object({<br>    id   = string<br>    type = string<br>  })</pre> | `null` | no |
| <a name="input_env_vars"></a> [env\_vars](#input\_env\_vars) | key and value pair of environment variables for code build project | `map(string)` | `null` | no |
| <a name="input_environment_type"></a> [environment\_type](#input\_environment\_type) | Type of build environment to use for related builds | `string` | `"LINUX_CONTAINER"` | no |
| <a name="input_git_submodules_config"></a> [git\_submodules\_config](#input\_git\_submodules\_config) | Whether to fetch Git submodules for the AWS CodeBuild build project. | `string` | `null` | no |
| <a name="input_green_fleet_provisioning_option"></a> [green\_fleet\_provisioning\_option](#input\_green\_fleet\_provisioning\_option) | Information about how instances are provisioned for a replacement environment in a blue/green deployment | <pre>object({<br>    action = string<br>  })</pre> | `null` | no |
| <a name="input_image_identifier"></a> [image\_identifier](#input\_image\_identifier) | Docker image to use for this build project. | `string` | `"aws/codebuild/amazonlinux2-x86_64-standard:3.0"` | no |
| <a name="input_image_pull_credentials_type"></a> [image\_pull\_credentials\_type](#input\_image\_pull\_credentials\_type) | ype of credentials AWS CodeBuild uses to pull images in your build. | `string` | `"CODEBUILD"` | no |
| <a name="input_name"></a> [name](#input\_name) | Name for this infrastructure | `string` | n/a | yes |
| <a name="input_on_premises_instance_tag_filter"></a> [on\_premises\_instance\_tag\_filter](#input\_on\_premises\_instance\_tag\_filter) | On premise tag filters associated with the group. | `map(string)` | `null` | no |
| <a name="input_override_artifact_name"></a> [override\_artifact\_name](#input\_override\_artifact\_name) | Whether a name specified in the build specification overrides the artifact name. | `string` | `null` | no |
| <a name="input_pipeline_policy"></a> [pipeline\_policy](#input\_pipeline\_policy) | List of actions and resources need to give access to pipeline | `map` | <pre>{<br>  "actions": [<br>    "elasticbeanstalk:*",<br>    "ec2:*",<br>    "elasticloadbalancing:*",<br>    "autoscaling:*",<br>    "cloudwatch:*",<br>    "s3:*",<br>    "sns:*",<br>    "cloudformation:*",<br>    "rds:*",<br>    "sqs:*",<br>    "ecs:*"<br>  ],<br>  "resources": [<br>    "*"<br>  ]<br>}</pre> | no |
| <a name="input_pipeline_role_arn"></a> [pipeline\_role\_arn](#input\_pipeline\_role\_arn) | IAM role ARN for AWS Code Pipeline | `string` | `null` | no |
| <a name="input_privileged_mode"></a> [privileged\_mode](#input\_privileged\_mode) | Whether to enable running the Docker daemon inside a Docker container. | `bool` | `true` | no |
| <a name="input_queued_timeout"></a> [queued\_timeout](#input\_queued\_timeout) | Number of minutes, from 5 to 480 (8 hours), a build is allowed to be queued before it times out. The default is 8 hours. | `number` | `480` | no |
| <a name="input_registry_credential"></a> [registry\_credential](#input\_registry\_credential) | ARN or name of credentials created using AWS Secrets Manager. | `string` | `null` | no |
| <a name="input_report_build_status"></a> [report\_build\_status](#input\_report\_build\_status) | Whether to report the status of a build's start and finish to your source provider. | `any` | `null` | no |
| <a name="input_repository_id"></a> [repository\_id](#input\_repository\_id) | ID of the github or any other provider's repository | `string` | `null` | no |
| <a name="input_repository_name"></a> [repository\_name](#input\_repository\_name) | Name of the code commit repository | `string` | `null` | no |
| <a name="input_resource_access_role"></a> [resource\_access\_role](#input\_resource\_access\_role) | The ARN of the IAM role that enables CodeBuild to access the CloudWatch Logs and Amazon S3 artifacts for the project's builds. | `string` | `null` | no |
| <a name="input_s3_bucket_name"></a> [s3\_bucket\_name](#input\_s3\_bucket\_name) | Name of the pipeline s3 bucket. | `string` | `null` | no |
| <a name="input_service_name"></a> [service\_name](#input\_service\_name) | Name of the ECS Service name | `string` | `null` | no |
| <a name="input_source_owner"></a> [source\_owner](#input\_source\_owner) | Owner of the source provider for the code pipeline | `string` | `"AWS"` | no |
| <a name="input_source_provider"></a> [source\_provider](#input\_source\_provider) | Name of the source provider for the code pipeline | `string` | `"CodeCommit"` | no |
| <a name="input_tags"></a> [tags](#input\_tags) | Tags for this infrastructure | `map(string)` | `{}` | no |
| <a name="input_target_group_pair_info"></a> [target\_group\_pair\_info](#input\_target\_group\_pair\_info) | The (Application/Network Load Balancer) target group pair to use in a deployment. | <pre>object({<br>    prod_traffic_listener_arns = string<br>    target_group_name          = string<br>    test_traffic_listener_arns = optional(string)<br>  })</pre> | `null` | no |
| <a name="input_terminate_blue_instances_on_deployment_success"></a> [terminate\_blue\_instances\_on\_deployment\_success](#input\_terminate\_blue\_instances\_on\_deployment\_success) | Information about whether to terminate instances in the original fleet during a blue/green deployment | <pre>object({<br>    action                           = optional(string)<br>    termination_wait_time_in_minutes = optional(number)<br>  })</pre> | n/a | yes |
| <a name="input_trigger_configuration"></a> [trigger\_configuration](#input\_trigger\_configuration) | Configuration block(s) of the triggers for the deployment group | <pre>object({<br>    trigger_events     = string<br>    trigger_name       = string<br>    trigger_target_arn = string<br>  })</pre> | `null` | no |
| <a name="input_vpc_config"></a> [vpc\_config](#input\_vpc\_config) | Configuration for VPC | <pre>object({<br>    security_group_ids = string # List of security group ids in string<br>    subnets            = string # List of subnet ids in string<br>    vpc_id             = string<br>  })</pre> | `null` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_build_project_arn"></a> [build\_project\_arn](#output\_build\_project\_arn) | ARN of the Code Builf Project |
| <a name="output_code_pipeline_arn"></a> [code\_pipeline\_arn](#output\_code\_pipeline\_arn) | ARN of the Code Pipeline |
| <a name="output_code_pipeline_id"></a> [code\_pipeline\_id](#output\_code\_pipeline\_id) | ID of the Code Pipeline |
| <a name="output_deploy_app_arn"></a> [deploy\_app\_arn](#output\_deploy\_app\_arn) | ARN of the Code Deploy Application |
| <a name="output_deploy_app_id"></a> [deploy\_app\_id](#output\_deploy\_app\_id) | Application ID of the Code Deploy Application |
| <a name="output_deploy_group_arn"></a> [deploy\_group\_arn](#output\_deploy\_group\_arn) | ARN of the Code Deployment Group |
| <a name="output_deploy_group_id"></a> [deploy\_group\_id](#output\_deploy\_group\_id) | Application name and deployment group name. |
| <a name="output_deployment_group_id"></a> [deployment\_group\_id](#output\_deployment\_group\_id) | The ID of the CodeDeploy deployment group. |


## Authors
Module is maintained by [Jerin Rathnam](https://github.com/jerinrathnam).

**LinkedIn:** _[Jerin Rathnam](https://www.linkedin.com/in/jerin-rathnam)_.

## License
Apache 2 Licensed. See [LICENSE](https://github.com/jerinrathnam/terraform-aws-code-pipeline/blob/master/LICENSE) for full details.