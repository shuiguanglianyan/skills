terraform {
  required_version = ">= 1.5.0"

  required_providers {
    volcengine = {
      source  = "volcengine/volcengine"
      version = ">= 0.0.140"
    }
  }
}

provider "volcengine" {
  region = var.region
}
