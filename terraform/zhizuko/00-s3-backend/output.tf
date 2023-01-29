output "tf_state_lock_dynamodb_table_name" {
  value       = aws_dynamodb_table.terraform_state_lock.name
  description = "Name of the DynamoDB terraform state lock table"
}

output "tf_state_s3_bucket_name" {
  value       = aws_s3_bucket.terraform_state.bucket
  description = "Name of the S3 bucket used to store all terraform remote state files"
}
