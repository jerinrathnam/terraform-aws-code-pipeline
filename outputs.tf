# CODE BUILD PROJECT

output "build_project_arn" {
  description = "ARN of the Code Builf Project"
  value       = one(aws_codebuild_project.this[*].arn)
}

# CODE DEPLOY APP

output "deploy_app_arn" {
  description = "ARN of the Code Deploy Application"
  value       = one(aws_codedeploy_app.this[*].arn)
}

output "deploy_app_id" {
  description = "Application ID of the Code Deploy Application"
  value       = one(aws_codedeploy_app.this[*].application_id)
}

output "deploy_group_arn" {
  description = "ARN of the Code Deployment Group"
  value       = one(aws_codedeploy_deployment_group.this[*].arn)
}

output "deployment_group_id" {
  description = "The ID of the CodeDeploy deployment group."
  value       = one(aws_codedeploy_deployment_group.this[*].deployment_group_id)
}

output "deploy_group_id" {
  description = "Application name and deployment group name."
  value       = one(aws_codedeploy_deployment_group.this[*].id)
}

# CODE PIPELINE

output "code_pipeline_id" {
  description = "ID of the Code Pipeline"
  value       = one(aws_codepipeline.this[*].id)
}

output "code_pipeline_arn" {
  description = "ARN of the Code Pipeline"
  value       = one(aws_codepipeline.this[*].arn)
}