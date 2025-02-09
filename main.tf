locals {
  docker_image_name = "tel-adm-openvpn"
  container_name    = "container-adm-openvpn"
}

resource "docker_image" "openvpn" {
  name         = local.docker_image_name
  keep_locally = false
  build {
    context = path.module
    build_args = {
      RANDOM_STRING = "a3408005-12b5-487c-b15c-81b012507e02"
    }
  }
}

resource "docker_container" "openvpn" {
  name  = local.container_name
  image = docker_image.openvpn.image_id
  restart    = "unless-stopped"
  hostname   = local.container_name

  capabilities {
    add = ["NET_ADMIN"]
  }

  # Allow sysctl modifications inside the container
  sysctls = {
    "net.ipv4.conf.all.send_redirects" = "0"
    "net.ipv4.ip_forward"              = "1"
  }

  devices {
    host_path = "/dev/net/tun"
  }

  ports {
    internal = 11150
    external = 11150
    protocol = "udp"
  }

  networks_advanced {
    name         = "adm-docker"
    ipv4_address = "10.10.0.110"
  }

  log_driver = "json-file"
  log_opts = {
    "max-size" = "100m"
    "max-file" = "1"
  }

  volumes {
    volume_name    = docker_volume.openvpn_config.name
    container_path = "/etc/openvpn"
    read_only      = false
  }

  command = ["supervisord"]
}

resource "docker_volume" "openvpn_config" {
  name = "volume-adm-openvpn-config"
}
