resource "aws_s3_bucket" "rollback-app" {
  bucket = "rollback-frontend-app"
  tags = {
    "name" = "website-bucket"
    "env"  = "dev"
  }
  force_destroy = true
}
resource "aws_s3_bucket_acl" "rollback-app-acl" {
  bucket = aws_s3_bucket.rollback-app.id
  acl    = "private"
}

data "aws_iam_policy_document" "s3_policy" {
  statement {
    actions   = ["s3:GetObject"]
    resources = ["${aws_s3_bucket.rollback-app.arn}/*"]

    principals {
      type        = "AWS"
      identifiers = [aws_cloudfront_origin_access_identity.origin_access_identity.iam_arn]
    }
  }
}

resource "aws_s3_bucket_policy" "bucket-policy" {
  bucket = aws_s3_bucket.rollback-app.id
  policy = data.aws_iam_policy_document.s3_policy.json
}

resource "aws_s3_bucket_public_access_block" "block-access-rollback-app" {
  bucket = aws_s3_bucket.rollback-app.id

  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}


resource "aws_s3_bucket" "rollback-app-backup" {
  bucket = "rollback-frontend-app-backup"
  tags = {
    name = "website-bucket-backup"
    env  = "dev"
  }
  force_destroy = true
}

resource "aws_s3_bucket_acl" "rollback-app-backup-acl" {
  bucket = aws_s3_bucket.rollback-app-backup.id
  acl    = "private"
}

data "aws_iam_policy_document" "s3-backup_policy" {
  statement {
    actions   = ["s3:GetObject"]
    resources = ["${aws_s3_bucket.rollback-app-backup.arn}/*"]

    principals {
      type        = "AWS"
      identifiers = [aws_cloudfront_origin_access_identity.origin_access_identity.iam_arn]
    }
  }
}

resource "aws_s3_bucket_policy" "bucket-backup-policy" {
  bucket = aws_s3_bucket.rollback-app-backup.id
  policy = data.aws_iam_policy_document.s3-backup_policy.json
}


resource "aws_s3_bucket_public_access_block" "block-access-rollback-app-backup" {
  bucket = aws_s3_bucket.rollback-app-backup.id

  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}