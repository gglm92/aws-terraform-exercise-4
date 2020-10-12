variable "aws_region" {
    type        = string
    description = "AWS Region"
}

variable "replication_aws_region" {
    type        = string
    description = "Replication AWS Region"
}

variable "aws_access_key" {
    type        = string
    description = "AWS Access Key"
}

variable "aws_secret_key" {
    type        = string
    description = "AWS Secret Key"
}

variable "environment" {
    type        = string
    description = "Environment"
}

variable "kms_encryption" {
    type        = string
    description = "KMS Encryption name"
}

variable "principal_bucket" {
    type        = string
    description = "Principal bucket name"
}

variable "replication_bucket" {
    type        = string
    description = "Replication bucket name"
}

variable "log_bucket" {
    type        = string
    description = "Logging bucket name"
}
