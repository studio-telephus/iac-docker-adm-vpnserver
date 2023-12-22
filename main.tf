module "container_adm_vpnserver" {
  source    = "github.com/studio-telephus/terraform-lxd-instance.git?ref=1.0.1"
  name      = "container-adm-vpnserver"
  image     = "images:debian/bookworm"
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
  exec_enabled = true
  exec         = "/mnt/install.sh"
  environment = {
    RANDOM_STRING = "db3cdb39-b7af-4136-989d-8a592c126605"
  }
}
