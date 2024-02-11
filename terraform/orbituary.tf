module "kube-hetzner" {
  providers = {
      hcloud = hcloud
  }

  hcloud_token = var.hcloud_token

  cluster_name = "orbituary"
  use_cluster_name_in_node_name = true

  source = "kube-hetzner/kube-hetzner/hcloud"

  ssh_public_key = var.ssh_public_key
  ssh_private_key = null

  network_region = "eu-central"

  enable_wireguard = true
  automatically_upgrade_os = false

  control_plane_nodepools = [
    {
      name        = "cp-arm-fsn1",
      server_type = "cax11",
      location    = "fsn1",
      labels      = [],
      taints      = [],
      count       = 1
    }
  ]

  agent_nodepools = [
    {
      name        = "agent-arm-fsn1",
      server_type = "cax11",
      location    = "fsn1",
      labels      = [],
      taints      = [],
      count       = 2
    }
  ]

  load_balancer_type     = "lb11"
  load_balancer_location = "fsn1"
  lb_hostname = "k3s.sok.sx"

  dns_servers = [
    "1.1.1.1",
    "8.8.8.8",
    "2606:4700:4700::1111",
  ]

  traefik_additional_trusted_ips = [
    "173.245.48.0/20",
    "103.21.244.0/22",
    "103.22.200.0/22",
    "103.31.4.0/22",
    "141.101.64.0/18",
    "108.162.192.0/18",
    "190.93.240.0/20",
    "188.114.96.0/20",
    "197.234.240.0/22",
    "198.41.128.0/17",
    "162.158.0.0/15",
    "104.16.0.0/13",
    "104.24.0.0/14",
    "172.64.0.0/13",
    "131.0.72.0/22",
    "2400:cb00::/32",
    "2606:4700::/32",
    "2803:f800::/32",
    "2405:b500::/32",
    "2405:8100::/32",
    "2a06:98c0::/29",
    "2c0f:f248::/32"
  ]

  // firewall_ssh_source = null

  k3s_registries = <<-EOT
    mirrors:
      ghcr.io:
        endpoint:
          - "ghcr.io"
    configs:
      ghcr.io:
        auth:
          username: USERNAME
          password: ${var.github_token}
  EOT

  create_kubeconfig = false
}

output "kubeconfig" {
  value     = module.kube-hetzner.kubeconfig
  sensitive = true
}

output "ingress_public_ipv4" {
  value     = module.kube-hetzner.ingress_public_ipv4
  sensitive = true
}