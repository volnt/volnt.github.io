# Providers

terraform {
  required_providers {
    cloudflare = {
      source = "cloudflare/cloudflare"
      version = "~> 3.0"
    }
  }

  required_version = ">= 0.14.9"
}

# Variables

variable "dns_zone_name" {
  type        = string
  description = "The name of the DNS zone (eg. 'example.com')"
}

variable "github_ips" {
  type = list(string)
  description = "The list of IPs for Github Pages"
  default = ["185.199.108.153", "185.199.109.153", "185.199.110.153", "185.199.111.153"]
}

variable "github_domain" {
  type        = string
  description = "The Github Pages domain (<user>.github.io or <organization>.github.io)"
}

# Resources

data "cloudflare_zones" "this" {
  filter {
    name = var.dns_zone_name
  }
}

resource "cloudflare_record" "github_a" {
  for_each = toset(var.github_ips)
  zone_id = data.cloudflare_zones.this.zones[0].id
  name    = "@"
  value   = each.key
  type    = "A"

  ttl     = 1
  proxied = true
}

resource "cloudflare_record" "github_cname" {
  zone_id = data.cloudflare_zones.this.zones[0].id
  name    = "www"
  value   = var.github_domain
  type    = "CNAME"

  ttl     = 1
  proxied = true
}
