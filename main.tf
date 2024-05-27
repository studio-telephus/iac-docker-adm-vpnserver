locals {
  docker_image_name = "tel-adm-vpnserver"
  container_name    = "container-adm-vpnserver"
}

resource "docker_image" "vpnserver" {
  name         = local.docker_image_name
  keep_locally = false
  build {
    context = path.module
    build_args = {
      RANDOM_STRING = "a3408005-12b5-487c-b15c-81b012507e02"
    }
  }
}

module "container_adm_vpnserver" {
  source     = "github.com/studio-telephus/terraform-docker-container.git?ref=1.0.3"
  name       = local.container_name
  image      = docker_image.vpnserver.image_id
  privileged = true
  networks_advanced = [
    {
      name         = "adm-docker"
      ipv4_address = "10.10.0.110"
    }
  ]
  environment = {
    RANDOM_STRING = "db3cdb39-b7af-4136-989d-8a592c126605"
  }
  command = ["supervisord"]
}
