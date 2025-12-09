terraform {
  required_providers {
    digitalocean = {
      source = "digitalocean/digitalocean"
      version = "~> 2.0"
    }
  }
}

variable "do_token" {}

provider "digitalocean" {
  token = var.do_token
}

resource "digitalocean_database_cluster" "db" {
  name = "db"
  engine = "pg"
  version = "18"
  region = "ams3"
  size = "db-s-1vcpu-1gb"
  node_count = 1
  private_network_uuid = "18dc1289-502f-45bd-87bf-a0d807dd6ffc"
}

resource "digitalocean_droplet" "web1" {
  name = "web1"
  region = "ams3"
  size = "s-1vcpu-1gb"
  image = "ubuntu-24-04-x64"
  vpc_uuid = "18dc1289-502f-45bd-87bf-a0d807dd6ffc"
  depends_on = [digitalocean_database_cluster.db]
}

resource "digitalocean_droplet" "web2" {
  name = "web2"
  region = "ams3"
  size = "s-1vcpu-1gb"
  image = "ubuntu-24-04-x64"
  vpc_uuid = "18dc1289-502f-45bd-87bf-a0d807dd6ffc"
  depends_on = [digitalocean_database_cluster.db]
}

resource "digitalocean_loadbalancer" "lb" {
  name = "lb"
  region = "ams3"
  redirect_http_to_https = true
  enable_backend_keepalive = true
  vpc_uuid = "18dc1289-502f-45bd-87bf-a0d807dd6ffc"

  droplet_ids = [
    digitalocean_droplet.web1.id,
    digitalocean_droplet.web2.id
  ]

  depends_on = [
    digitalocean_droplet.web1,
    digitalocean_droplet.web2
  ]

  forwarding_rule {
    entry_protocol = "http"
    entry_port = 80
    target_protocol = "http"
    target_port = 80
  }

  forwarding_rule {
    entry_protocol = "https"
    entry_port = 443
    target_protocol = "http"
    target_port = 80
    certificate_name = "source.id.lv"
  }

  healthcheck {
    protocol = "http"
    port = 80
    path = "/login"
    check_interval_seconds = 10
    response_timeout_seconds = 5
    healthy_threshold = 5
    unhealthy_threshold = 3
  }
}
