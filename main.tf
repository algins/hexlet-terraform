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

resource "digitalocean_droplet" "web1" {
  name = "web1"
  region = "ams3"
  size = "s-1vcpu-1gb"
  image = "ubuntu-24-04-x64"
}

resource "digitalocean_droplet" "web2" {
  name = "web2"
  region = "ams3"
  size = "s-1vcpu-1gb"
  image = "ubuntu-24-04-x64"
}