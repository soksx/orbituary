locals {
  dns_records = [
    "k3s",
    "auth"
  ]
  proxied_records = {
    "k3s"       = true,
    "auth"      = true,
    "@"         = true
  }
}

resource "cloudflare_record" "dns" {
  for_each = toset(local.dns_records)

  zone_id = var.cloudflare_zone_id
  name    = each.key
  type    = "A"
  value   = module.kube-hetzner.ingress_public_ipv4
  ttl     = 1
  proxied = lookup(local.proxied_records, each.key, false)
}
