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

resource "digitalocean_droplet" "example" {
  name = "ubuntu-s-1vcpu-512mb-10gb-ams3-01"
  region = "ams3"
  size = "s-1vcpu-1gb"
  image = "ubuntu-24-04-x64"
}