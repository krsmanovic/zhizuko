resource "aws_s3_bucket" "artifacts" {
  bucket = "${var.application_name}-artifacts"

  tags = merge(local.mandatory_tags, var.backend_specific_tags)

  lifecycle {
    prevent_destroy = true
    ignore_changes = [
      tags["CreationTimestamp"],
    ]
  }
}

resource "aws_s3_bucket_versioning" "artifacts" {
  bucket = aws_s3_bucket.artifacts.id

  versioning_configuration {
    status = "Enabled"
  }
}

resource "aws_s3_bucket_public_access_block" "artifacts" {
  bucket = aws_s3_bucket.artifacts.id

  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}

resource "aws_s3_bucket_server_side_encryption_configuration" "artifacts" {
  bucket = aws_s3_bucket.artifacts.id

  rule {
    apply_server_side_encryption_by_default {
      sse_algorithm = "AES256"
    }
  }
}

resource "aws_s3_bucket_policy" "allow_zhizuko_server" {
  bucket = aws_s3_bucket.artifacts.id
  policy = data.aws_iam_policy_document.allow_zhizuko_server.json
}

data "aws_iam_policy_document" "allow_zhizuko_server" {
  statement {
    sid    = "allowOnlyZhizukoServerDownload"
    effect = "Allow"

    principals {
      type        = "*"
      identifiers = ["*"]
    }

    actions = [
      "s3:GetObject",
    ]

    resources = [
      aws_s3_bucket.artifacts.arn,
      "${aws_s3_bucket.artifacts.arn}/*",
    ]

    condition {
      test     = "IpAddress"
      variable = "aws:SourceIp"
      values = [
        "${data.aws_ssm_parameter.server_public_ip.value}"
      ]
    }
  }
}

data "aws_ssm_parameter" "server_public_ip" {
  name            = "/uvek-sa-decom/hcloud/server/ip"
  with_decryption = true
}