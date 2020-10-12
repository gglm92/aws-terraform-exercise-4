# resource "aws_kms_key" "kms_encryption" {
#   description             = var.kms_encryption
#   deletion_window_in_days = 7
# }

resource "aws_iam_role" "replication" {
  name = "tf-iam-role-replication"

  assume_role_policy = <<POLICY
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": "sts:AssumeRole",
      "Principal": {
        "Service": "s3.amazonaws.com"
      },
      "Effect": "Allow",
      "Sid": ""
    }
  ]
}
POLICY
}

resource "aws_iam_policy" "replication" {
  name = "tf-iam-role-policy-replication"

  policy = <<POLICY
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": [
        "s3:GetReplicationConfiguration",
        "s3:ListBucket"
      ],
      "Effect": "Allow",
      "Resource": [
        "${aws_s3_bucket.principal_bucket.arn}"
      ]
    },
    {
      "Action": [
        "s3:GetObjectVersion",
        "s3:GetObjectVersionAcl"
      ],
      "Effect": "Allow",
      "Resource": [
        "${aws_s3_bucket.principal_bucket.arn}/*"
      ]
    },
    {
      "Action": [
        "s3:ReplicateObject",
        "s3:ReplicateDelete"
      ],
      "Effect": "Allow",
      "Resource": "${aws_s3_bucket.replication_bucket.arn}/*"
    }
  ]
}
POLICY
}

resource "aws_iam_role_policy_attachment" "replication" {
  role       = aws_iam_role.replication.name
  policy_arn = aws_iam_policy.replication.arn
}

resource "aws_s3_bucket" "replication_bucket" {
  bucket = var.replication_bucket
  provider = aws.west

  versioning {
    enabled = true
  }
}

resource "aws_s3_bucket" "log_bucket" {
  bucket = var.log_bucket
  acl    = "log-delivery-write"
}

resource "aws_s3_bucket" "principal_bucket" {
  bucket = var.principal_bucket
  acl    = "private"

  versioning {
    enabled = true
  }

  logging {
      target_bucket = aws_s3_bucket.log_bucket.id
      target_prefix = "log/"
  }

  replication_configuration{
      role = aws_iam_role.replication.arn

      rules {

          status = "Enabled"

          destination {
              bucket        = aws_s3_bucket.replication_bucket.arn
              storage_class = "STANDARD"
          }
      }
  }

#   server_side_encryption_configuration {
#     rule {
#       apply_server_side_encryption_by_default {
#         kms_master_key_id = aws_kms_key.kms_encryption.arn
#         sse_algorithm     = "aws:kms"
#       }
#     }
#   }


}
