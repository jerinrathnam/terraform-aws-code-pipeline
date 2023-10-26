################################### CODEPIPELINE ROLE ###############################################

resource "aws_iam_role" "pipeline_role" {
  count = var.pipeline_role_arn == null ? 1 : 0

  name = "${var.name}-pipeline-role"

  assume_role_policy = jsonencode(
    {
      Version = "2012-10-17"
      Statement = [
        {
          Action = "sts:AssumeRole"
          Effect = "Allow"
          Principal = {
            Service = "codepipeline.amazonaws.com"
          }
        }
      ]
    }
  )

  tags = merge(
    {
      "Name" = "${var.name}-pipeline-role"
    },
    var.tags
  )
}

resource "aws_iam_role_policy" "pipeline_policy" {
  count = var.pipeline_role_arn == null ? 1 : 0

  name = "${var.name}-pipeline-policy"
  role = one(aws_iam_role.pipeline_role[*].id)

  policy = jsonencode(
    {
      Version = "2012-10-17"
      Statement = [
        {
          Action = [
            "iam:PassRole"
          ]
          Effect = "Allow"
          Resource = [
            "*"
          ]
          Condition = {
            StringEqualsIfExists = {
              "iam:PassedToService" : [
                "cloudformation.amazonaws.com",
                "elasticbeanstalk.amazonaws.com",
                "ec2.amazonaws.com",
                "ecs-tasks.amazonaws.com"
              ]
            }
          }
        },
        {
          Action = [
            "codecommit:CancelUploadArchive",
            "codecommit:GetBranch",
            "codecommit:GetCommit",
            "codecommit:GetRepository",
            "codecommit:GetUploadArchiveStatus",
            "codecommit:UploadArchive",
            "codedeploy:CreateDeployment",
            "codedeploy:GetApplication",
            "codedeploy:GetApplicationRevision",
            "codedeploy:GetDeployment",
            "codedeploy:GetDeploymentConfig",
            "codedeploy:RegisterApplicationRevision",
            "codestar-connections:UseConnection",
            "lambda:InvokeFunction",
            "lambda:ListFunctions",
            "opsworks:CreateDeployment",
            "opsworks:DescribeApps",
            "opsworks:DescribeCommands",
            "opsworks:DescribeDeployments",
            "opsworks:DescribeInstances",
            "opsworks:DescribeStacks",
            "opsworks:UpdateApp",
            "opsworks:UpdateStack",
            "cloudformation:CreateStack",
            "cloudformation:DeleteStack",
            "cloudformation:DescribeStacks",
            "cloudformation:UpdateStack",
            "cloudformation:CreateChangeSet",
            "cloudformation:DeleteChangeSet",
            "cloudformation:DescribeChangeSet",
            "cloudformation:ExecuteChangeSet",
            "cloudformation:SetStackPolicy",
            "cloudformation:ValidateTemplate",
            "codebuild:BatchGetBuilds",
            "codebuild:StartBuild",
            "codebuild:BatchGetBuildBatches",
            "codebuild:StartBuildBatch",
            "devicefarm:ListProjects",
            "devicefarm:ListDevicePools",
            "devicefarm:GetRun",
            "devicefarm:GetUpload",
            "devicefarm:CreateUpload",
            "devicefarm:ScheduleRun",
            "servicecatalog:ListProvisioningArtifacts",
            "servicecatalog:CreateProvisioningArtifact",
            "servicecatalog:DescribeProvisioningArtifact",
            "servicecatalog:DeleteProvisioningArtifact",
            "servicecatalog:UpdateProduct",
            "ecr:DescribeImages",
            "states:DescribeExecution",
            "states:DescribeStateMachine",
            "states:StartExecution",
            "appconfig:StartDeployment",
            "appconfig:StopDeployment",
            "appconfig:GetDeployment",
          ]
          Effect   = "Allow"
          Resource = [
            "*"
          ]
        },
        {
          Action   = var.pipeline_policy["actions"]
          Effect   = "Allow"
          Resource = var.pipeline_policy["resources"]
        }
      ]
    }
  )
}


################################### CODEBUILD ROLE ###############################################

resource "aws_iam_role" "build_role" {
  count = var.ec2_deployment == false ? 1 : 0

  name = "${var.name}-build-role"

  assume_role_policy = jsonencode(
    {
      Version = "2012-10-17"
      Statement = [
        {
          Action = "sts:AssumeRole"
          Effect = "Allow"
          Principal = {
            Service = [
              "codebuild.amazonaws.com"
            ]
          }
        }
      ]
    }
  )

  tags = merge(
    {
      "Name" = "${var.name}-build-role"
    },
    var.tags
  )
}

resource "aws_iam_role_policy" "build_policy" {
  count = var.ec2_deployment == false ? 1 : 0

  name = "${var.name}-build-policy"
  role = aws_iam_role.build_role[0].id

  policy = jsonencode(
    {
      Version = "2012-10-17"
      Statement = [
        {
          Action = [
            "ec2:CreateNetworkInterface",
            "ec2:DescribeDhcpOptions",
            "ec2:DescribeNetworkInterfaces",
            "ec2:DeleteNetworkInterface",
            "ec2:DescribeSubnets",
            "ec2:DescribeSecurityGroups",
            "ec2:DescribeVpcs",
            "logs:*"
          ]
          Effect   = "Allow"
          Resource = "*"
        },
        {
          Action = [
            "ec2:CreateNetworkInterfacePermission"
          ]
          Effect = "Allow"
          Resource = [
            "arn:aws:ec2:${local.region}:${local.account_id}:network-interface/*"
          ]
          Condition = {
            StringEquals = {
              "ec2:Subnet" : ["*"],
              "ec2:AuthorizedService" : "codebuild.amazonaws.com"
            }
          }
        },
        {
          Action = [
            "ecr:*",
            "s3:*",
            "codebuild:CreateReportGroup",
            "codebuild:CreateReport",
            "codebuild:UpdateReport",
            "codebuild:BatchPutTestCases",
          ]
          Effect = "Allow"
          Resource = [
            "*"
          ]
        }
      ]
    }
  )
}

############################### CODEDEPLOY ROLE ######################################

resource "aws_iam_role" "deploy_role" {
  count = var.ec2_deployment ? 1 : 0

  name = "${var.name}-deploy-role"

  assume_role_policy = jsonencode(
    {
      Version = "2012-10-17"
      Statement = [
        {
          Action = "sts:AssumeRole"
          Effect = "Allow"
          Principal = {
            Service = "codedeploy.amazonaws.com"
          }
        }
      ]
    }
  )

  tags = merge(
    {
      "Name" = "${var.name}-deploy-role"
    },
    var.tags
  )
}

resource "aws_iam_role_policy" "deploy_policy" {
  count = var.ec2_deployment ? 1 : 0

  name = "${var.name}-deploy-policy"
  role = aws_iam_role.deploy_role[0].id

  policy = jsonencode(
    {
      Version = "2012-10-17"
      Statement = [
        {
          Action = [
            "autoscaling:CompleteLifecycleAction",
            "autoscaling:DeleteLifecycleHook",
            "autoscaling:DescribeAutoScalingGroups",
            "autoscaling:DescribeLifecycleHooks",
            "autoscaling:PutLifecycleHook",
            "autoscaling:RecordLifecycleActionHeartbeat",
            "autoscaling:CreateAutoScalingGroup",
            "autoscaling:UpdateAutoScalingGroup",
            "autoscaling:EnableMetricsCollection",
            "autoscaling:DescribePolicies",
            "autoscaling:DescribeScheduledActions",
            "autoscaling:DescribeNotificationConfigurations",
            "autoscaling:SuspendProcesses",
            "autoscaling:ResumeProcesses",
            "autoscaling:AttachLoadBalancers",
            "autoscaling:AttachLoadBalancerTargetGroups",
            "autoscaling:PutScalingPolicy",
            "autoscaling:PutScheduledUpdateGroupAction",
            "autoscaling:PutNotificationConfiguration",
            "autoscaling:PutWarmPool",
            "autoscaling:DescribeScalingActivities",
            "autoscaling:DeleteAutoScalingGroup",
            "ec2:DescribeInstances",
            "ec2:DescribeInstanceStatus",
            "ec2:TerminateInstances",
            "tag:GetResources",
            "sns:Publish",
            "cloudwatch:DescribeAlarms",
            "cloudwatch:PutMetricAlarm",
            "elasticloadbalancing:DescribeLoadBalancers",
            "elasticloadbalancing:DescribeInstanceHealth",
            "elasticloadbalancing:RegisterInstancesWithLoadBalancer",
            "elasticloadbalancing:DeregisterInstancesFromLoadBalancer",
            "elasticloadbalancing:DescribeTargetGroups",
            "elasticloadbalancing:DescribeTargetHealth",
            "elasticloadbalancing:RegisterTargets",
            "elasticloadbalancing:DeregisterTargets"
          ]
          Effect   = "Allow"
          Resource = "*"
        }
      ]
    }
  )
}