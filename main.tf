module "container_vpnserver" {
  source    = "github.com/studio-telephus/tel-iac-modules-lxd.git//instance?ref=develop"
  name      = "container-vpnserver"
  profiles  = ["limits", "fs-dir", "nw-adm"]
  autostart = true
  nic = {
    name = "eth0"
    properties = {
      nictype        = "bridged"
      parent         = "adm-network"
      "ipv4.address" = "10.0.10.110"
    }
  }
  mount_dirs = [
    "${path.cwd}/filesystem-shared-ca-certificates",
    "${path.cwd}/filesystem",
  ]
  exec = {
    enabled     = true
    entrypoint  = "/mnt/install.sh"
    environment = var.container_environment
  }
}
