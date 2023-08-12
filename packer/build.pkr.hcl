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

  provisioner "shell" {
    script = "scripts/systemd-post.sh"
  }

  provisioner "shell" {
    script = "scripts/wired-post.sh"
  }
}
