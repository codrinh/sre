variable "env" {
  description = "Environment type: dev, prd"
  type        = string
}

variable "billing_account" {
  type = string
}

variable "github_org" {
  type = string
}

variable "github_repo" {
  type = string
}