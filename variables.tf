variable "create_pipeline" {
  type        = bool
  description = "Whether to create pipeline"
  default     = true
}
variable "ecs_deployment" {
  type        = bool
  description = "For the ECS deployment"
  default     = true
}

variable "build_deployment" {
  type        = bool
  description = "For the deployment from build"
  default     = false
}

variable "ec2_deployment" {
  type        = bool
  description = "For the EC2 deployment"
  default     = false
}

variable "name" {
  type        = string
  description = "Name for this infrastructure"
}

variable "s3_bucket_name" {
  type        = string
  description = "Name of the pipeline s3 bucket."
  default     = null
}

variable "codepipeline_artifact_type" {
  type        = string
  description = "The type of the artifact store, such as Amazon S3"
  default     = "S3"
}

variable "codepipeline_artifact_region" {
  type        = string
  description = "The region where the artifact store is located"
  default     = null
}

variable "encryption_key" {
  type = object({
    id   = string
    type = string
  })
  description = " The encryption key block AWS CodePipeline uses to encrypt the data in the artifact store, such as an AWS Key Management Service (AWS KMS) key."
  default     = null
}

variable "source_provider" {
  type        = string
  description = "Name of the source provider for the code pipeline"
  default     = "CodeCommit"
}

variable "source_owner" {
  type        = string
  description = "Owner of the source provider for the code pipeline"
  default     = "AWS"
}

variable "repository_id" {
  type        = string
  description = "ID of the github or any other provider's repository"
  default     = null
}

variable "repository_name" {
  type        = string
  description = "Name of the code commit repository"
  default     = null
}

variable "branch_name" {
  type        = string
  description = "Name of the source code branch name"
  default     = null
}

variable "codestar_connection_arn" {
  type        = string
  description = "ARN of the code star connection"
  default     = null
}

variable "cluster_name" {
  type        = string
  description = "Name of the ECS Cluster name"
  default     = null
}

variable "service_name" {
  type        = string
  description = "Name of the ECS Service name"
  default     = null
}

variable "ecs_file_name" {
  type        = string
  description = "Name of the file for ECS deployment"
  default     = "imagedefinitions.json"
}

variable "tags" {
  type        = map(string)
  description = "Tags for this infrastructure"
  default     = {}
}

variable "pipeline_policy_actions" {
  type        = list(string)
  description = "List of actions need to give access to pipeline"
  default = [
    "elasticbeanstalk:*",
    "ec2:*",
    "elasticloadbalancing:*",
    "autoscaling:*",
    "cloudwatch:*",
    "s3:*",
    "sns:*",
    "cloudformation:*",
    "rds:*",
    "sqs:*",
    "ecs:*"
  ]
}

variable "pipeline_role_arn" {
  type        = string
  description = "IAM role ARN for AWS Code Pipeline"
  default     = null
}

# BUILD PROJECT

variable "env_vars" {
  type        = map(string)
  description = "key and value pair of environment variables for code build project"
  default     = null
}

variable "privileged_mode" {
  type        = bool
  description = "Whether to enable running the Docker daemon inside a Docker container."
  default     = true
}

variable "image_identifier" {
  type        = string
  description = "Docker image to use for this build project."
  default     = "aws/codebuild/amazonlinux2-x86_64-standard:3.0"
}

variable "build_env_type" {
  type        = string
  description = "The type of the environment variables"
  default     = "PLAINTEXT"
}

variable "build_artifact_type" {
  type        = string
  description = " Build output artifact's type. Valid values: CODEPIPELINE, NO_ARTIFACTS, S3."
  default     = "CODEPIPELINE"
}

variable "build_role_arn" {
  type        = string
  description = "IAM role ARN for AWS Code Build"
  default     = null
}

variable "artifact_bucket_owner_access" {
  type        = string
  description = " Specifies the bucket owner's access for objects that another account uploads to their Amazon S3 bucket. Valid values are NONE, READ_ONLY, and FULL"
  default     = null
}

variable "artifact_encryption_disabled" {
  type        = bool
  description = "Whether to disable encrypting output artifacts. If type is set to NO_ARTIFACTS, this value is ignored"
  default     = null
}

variable "build_artifact_location" {
  type        = string
  description = "Information about the build output artifact location."
  default     = null
}

variable "artifact_output_name" {
  type        = string
  description = "Name of the project. If type is set to S3, this is the name of the output artifact object"
  default     = null
}

variable "artifact_namespace_type" {
  type        = string
  description = "Namespace to use in storing build artifacts. If type is set to S3, then valid values are BUILD_ID, NONE"
  default     = null
}

variable "override_artifact_name" {
  type        = string
  description = "Whether a name specified in the build specification overrides the artifact name."
  default     = null
}

variable "build_artifact_packaging" {
  type        = string
  description = "Type of build output artifact to create. If type is set to S3, valid values are NONE, ZIP"
  default     = null
}

variable "build_atrifact_path" {
  type        = string
  description = "If type is set to S3, this is the path to the output artifact."
  default     = null
}

variable "compute_type" {
  type        = string
  description = " Information about the compute resources the build project will use."
  default     = "BUILD_GENERAL1_SMALL"
}

variable "image_pull_credentials_type" {
  type        = string
  description = "ype of credentials AWS CodeBuild uses to pull images in your build."
  default     = "CODEBUILD"
}

variable "environment_type" {
  type        = string
  description = "Type of build environment to use for related builds"
  default     = "LINUX_CONTAINER"
}

variable "registry_credential" {
  type        = string
  description = "ARN or name of credentials created using AWS Secrets Manager."
  default     = null
}

variable "build_source_type" {
  type        = string
  description = "Type of repository that contains the source code to be built."
  default     = "CODEPIPELINE"
}

variable "buildspec" {
  type        = string
  description = "Build specification to use for this build project's related builds."
  default     = null
}

variable "git_submodules_config" {
  type        = string
  description = "Whether to fetch Git submodules for the AWS CodeBuild build project."
  default     = null
}

variable "build_status_config" {
  type = object({
    context    = optional(string)
    target_url = optional(string)
  })
  description = "Configuration block that contains information that defines how the build project reports the build status to the source provider."
  default     = null
}

variable "build_source_location" {
  type        = string
  description = " Location of the source code from git or s3."
  default     = null
}

variable "report_build_status" {
  type        = any
  description = "Whether to report the status of a build's start and finish to your source provider."
  default     = null
}

variable "build_encryption_key" {
  type        = string
  description = "AWS Key Management Service (AWS KMS) customer master key (CMK) to be used for encrypting the build project's build output artifacts."
  default     = null
}

variable "enable_build_logs" {
  type        = string
  description = "Whether to enable build logs sent to s3 or cloudeatch logs"
  default     = false
}

variable "build_cloudwatch_logs" {
  type = object({
    group_name  = optional(string)
    status      = optional(string)
    stream_name = optional(string)
  })
  description = "Send build outputs to cloudwatch log group"
  default     = null
}

variable "build_s3_logs" {
  type = object({
    encryption_disabled = optional(bool)
    status              = optional(string)
    location            = optional(string)
    bucket_owner_access = optional(string)
  })
  description = "Send build outputs to s3 bucket"
  default     = null
}

variable "build_project_visibility" {
  type        = string
  description = "Specifies the visibility of the project's builds."
  default     = "PRIVATE"
}

variable "resource_access_role" {
  type        = string
  description = "The ARN of the IAM role that enables CodeBuild to access the CloudWatch Logs and Amazon S3 artifacts for the project's builds."
  default     = null
}

variable "queued_timeout" {
  type        = number
  description = "Number of minutes, from 5 to 480 (8 hours), a build is allowed to be queued before it times out. The default is 8 hours."
  default     = 480
}

variable "build_source_version" {
  type        = string
  description = "Version of the build input to be built for this project. If not specified, the latest version is used."
  default     = null
}

variable "vpc_config" {
  type = object({
    security_group_ids = string # List of security group ids in string
    subnets            = string # List of subnet ids in string
    vpc_id             = string
  })
  description = "Configuration for VPC"
  default     = null
}

# DEPLOYMENT GROUP

variable "create_deploy_group" {
  type        = bool
  description = "Whether the deployment group shoul be create or not"
  default     = true
}

variable "codedeploy_app" {
  type        = string
  description = "Name of the code deployment app. Is needed if 'create_deploy_group' is set to 'false'"
  default     = null
}

variable "deployment_group" {
  type        = string
  description = "Name of the code deployment group. Is needed if 'create_deploy_group' is set to 'false'"
  default     = null
}

variable "deployment_compute_platform" {
  type        = string
  description = "The compute platform can either be ECS, Lambda, or Server"
  default     = "Server"
}

variable "deploy_role_arn" {
  type        = string
  description = "IAM role ARN for AWS Code Deployment Group"
  default     = null
}

variable "ec2_tag_filters" {
  type        = map(string)
  description = "Key and value pairs of ec2 instance tags for code deployment group"
  default     = null
}

variable "deployment_alarm" {
  type = object({
    alarms                    = optional(string) # A list of alarms configured for the deployment group in string type
    enabled                   = optional(bool)
    ignore_poll_alarm_failure = optional(bool)
  })
  description = "Configuration block of alarms associated with the deployment group"
  default     = null
}

variable "deployment_auto_rollback" {
  type = object({
    enabled = optional(bool)
    events  = optional(string)
  })
  description = "Configuration block of the automatic rollback configuration associated with the deployment group"
  default = {
    enabled = true
    events  = "DEPLOYMENT_FAILURE"
  }
}

variable "deployment_autoscaling_groups" {
  type        = list(string)
  description = "Autoscaling groups associated with the deployment group."
  default     = null
}

variable "enable_blue_green_deployment" {
  type        = bool
  description = "Whether to enable blue green deployment"
  default     = false
}

variable "deployment_ready_option" {
  type = object({
    action_on_timeout       = optional(string)
    deployment_ready_option = optional(number)
  })
  description = "Information about the action to take when newly provisioned instances are ready to receive traffic in a blue/green deployment"
  default     = null
}

variable "green_fleet_provisioning_option" {
  type = object({
    action = string
  })
  description = "Information about how instances are provisioned for a replacement environment in a blue/green deployment"
  default     = null
}

variable "terminate_blue_instances_on_deployment_success" {
  type = object({
    action                           = optional(string)
    termination_wait_time_in_minutes = optional(number)
  })
  description = "Information about whether to terminate instances in the original fleet during a blue/green deployment"
}

variable "deployment_config_name" {
  type        = string
  description = "The name of the group's deployment config. The default is 'CodeDeployDefault.OneAtATime'"
  default     = "CodeDeployDefault.OneAtATime"
}

variable "deployment_style" {
  type = object({
    deployment_type   = optional(string)
    deployment_option = optional(string)
  })
  description = "either in-place or blue/green, you want to run and whether to route deployment traffic behind a load balancer"
  default     = null
}

variable "enable_load_balancer" {
  type        = bool
  description = "whetheer to enable the load balancer to use in a blue/green deployment"
  default     = false
}

variable "deploment_elb_name" {
  type        = string
  description = "The name of the load balancer that will be used to route traffic from original instances to replacement instances in a blue/green deployment"
  default     = null
}

variable "deployment_target_group_name" {
  type        = string
  description = " The name of the target group that instances in the original environment are deregistered from, and instances in the replacement environment registered with."
  default     = null
}

variable "target_group_pair_info" {
  type = object({
    prod_traffic_listener_arns = string
    target_group_name          = string
    test_traffic_listener_arns = optional(string)
  })
  description = "The (Application/Network Load Balancer) target group pair to use in a deployment."
  default     = null
}

variable "on_premises_instance_tag_filter" {
  type        = map(string)
  description = "On premise tag filters associated with the group."
  default     = null
}

variable "ec2_tag_filter_type" {
  type        = string
  description = "The type of the tag filter"
  default     = "KEY_AND_VALUE"
}

variable "trigger_configuration" {
  type = object({
    trigger_events     = string
    trigger_name       = string
    trigger_target_arn = string
  })
  description = "Configuration block(s) of the triggers for the deployment group"
  default     = null
}