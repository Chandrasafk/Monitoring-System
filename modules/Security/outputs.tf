output "security_group_id" {
   value = aws_security_group.allow_tls.id
}

output "lambda_role_arn" {
  value = aws_iam_role.iamforlambda.arn
}

output "ec2_instance_profile_name" {
  value = aws_iam_instance_profile.iamforec2_profile.name
}