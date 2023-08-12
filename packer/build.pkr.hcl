locals {
  op = [
    "OPERATOR_USER=${var.operator_user_name}",
    "OPERATOR_GROUP=${var.operator_user_name}",
  ]

  etc_hosts = "sed -i \"s/raspberrypi/$(hostname)/\" /etc/hosts"

  builds = [
    "source.arm-image.prod",
    "source.arm-image.uat",
    "source.arm-image.dev"
  ]
}

build {
  sources = local.builds

  name = "base"

  provisioner "shell" {
    script = "scripts/common.sh"
  }

  provisioner "shell" {
    script = "scripts/systemd.sh"
  }

  provisioner "file" {
    only = ["arm-image.home"]

    destination = "/etc/cloud/cloud.cfg.d/home.cfg"
    content = templatefile("templates/cloud-init-common.tmpl", {
      hostname = "home"
      cmds : [
        local.etc_hosts,
        "cd /srv/docker/home-assistant && docker compose up -d",
      ]
    })
  }

  provisioner "file" {
    only = ["arm-image.media"]

    destination = "/etc/cloud/cloud.cfg.d/media.cfg"
    content = templatefile("templates/cloud-init-common.tmpl", {
      hostname = "media"
      cmds : [
        local.etc_hosts,
      ]
    })
  }

  provisioner "shell" {
    only = local.server_builds
    script = "scripts/systemd-post.sh"
  }

  provisioner "shell" {
    only = ["arm-image.infra", "arm-image.home"]
    script = "scripts/wired-post.sh"
  }
}
