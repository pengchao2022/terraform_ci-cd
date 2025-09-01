# 指定所需的 Terraform 提供商和版本
terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }

  required_version = ">= 1.0"
}

# 配置 AWS 提供商
provider "aws" {
  region = "us-east-1" # 请根据您的需求更改区域
}
