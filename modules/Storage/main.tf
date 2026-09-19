#creating s3 bucket
resource "aws_s3_bucket" "example" {
  bucket = var.s3_bucket_name
  tags = {
    Name        = "My bucket"
    Environment = "prod"
  }
}

#creating bucket public access block
resource "aws_s3_bucket_public_access_block" "example" {
  bucket = var.s3_bucket_id
  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}

#s3 lifecycle configuration
resource "aws_s3_bucket_lifecycle_configuration" "example" {
  bucket = var.s3_bucket_id
  rule {
    id     = "log"
    status = "Enabled"
    transition {
      days = 30
      storage_class = "GLACIER"
    }
  }
}