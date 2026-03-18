resource "volcengine_vpc" "this" {
  vpc_name   = "${var.cluster_name}-vpc"
  cidr_block = var.vpc_cidr
}

resource "volcengine_subnet" "this" {
  subnet_name = "${var.cluster_name}-subnet"
  cidr_block  = var.subnet_cidr
  zone_id     = var.zone
  vpc_id      = volcengine_vpc.this.id
}

resource "volcengine_vke_cluster" "this" {
  name                      = var.cluster_name
  kubernetes_version        = var.kubernetes_version
  description               = "created by terraform"
  delete_protection_enabled = var.delete_protection_enabled

  cluster_config {
    subnet_ids                              = [volcengine_subnet.this.id]
    api_server_public_access_enabled        = var.api_server_public_access_enabled
    resource_public_access_default_enabled  = true

    api_server_public_access_config {
      public_access_network_config {
        billing_type = "PostPaidByTraffic"
        bandwidth    = var.api_server_bandwidth
      }
    }
  }

  pods_config {
    pod_network_mode = "VpcCniShared"
  }
}
