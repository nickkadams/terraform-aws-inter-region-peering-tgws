variable "aws_profile" {
  default     = "default"
  description = "AWS profile"
  type        = string
}

variable "aws_region" {
  default     = "us-east-1"
  description = "AWS region"
  type        = string
}

variable "aws_assume_account_dev" {
  description = "AWS assume account ID for dev"
  type        = number
}

variable "aws_assume_account_tgw" {
  description = "AWS assume account ID for tgw"
  type        = number
}

variable "aws_assume_role" {
  description = "AWS assume role name"
  type        = string
}

variable "tag_cont" {
  default     = ""
  description = "Tag: Contact"
  type        = string
}

variable "tag_cost" {
  default     = ""
  description = "Tag: Cost"
  type        = string
}

variable "tag_cust" {
  default     = ""
  description = "Tag: Customer"
  type        = string
}

variable "tag_proj" {
  default     = ""
  description = "Tag: Project"
  type        = string
}

variable "tag_conf" {
  default     = "public"
  description = "Tag: Confidentiality"
  type        = string
}

variable "tag_comp" {
  default     = "CIS"
  description = "Tag: Compliance"
  type        = string
}