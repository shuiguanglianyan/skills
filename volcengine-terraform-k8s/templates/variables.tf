variable "region" {
  description = "Volcengine region, e.g. cn-beijing"
  type        = string
  default     = "cn-beijing"
}

variable "zone" {
  description = "Volcengine zone, e.g. cn-beijing-a"
  type        = string
  default     = "cn-beijing-a"
}

variable "cluster_name" {
  description = "VKE cluster name"
  type        = string
  default     = "tf-created-vke-serverless"
}

variable "kubernetes_version" {
  description = "VKE kubernetes version in x.y format"
  type        = string
  default     = "1.26"
}

variable "vpc_cidr" {
  description = "VPC CIDR block"
  type        = string
  default     = "172.16.0.0/16"
}

variable "subnet_cidr" {
  description = "Subnet CIDR block"
  type        = string
  default     = "172.16.0.0/24"
}

variable "api_server_public_access_enabled" {
  description = "Whether to expose API Server publicly"
  type        = bool
  default     = true
}

variable "api_server_bandwidth" {
  description = "Public API server EIP bandwidth"
  type        = number
  default     = 10
}

variable "delete_protection_enabled" {
  description = "Whether to enable delete protection"
  type        = bool
  default     = true
}
