locals {
  op = [
    "OPERATOR_USER=${var.operator_user_name}",
    "OPERATOR_GROUP=${var.operator_user_name}",
  ]

  etc_hosts = "sed -i \"s/raspberrypi/$(hostname)/\" /etc/hosts"

  builds = [
    "source.arm-image.base",
  ]
}

source "arm-image" "base" {
  iso_url           = var.source_iso_url
  iso_checksum      = var.source_iso_checksum
  image_type        = "raspberrypi"
  output_filename   = "${var.output_directory}/${formatdate("YYYYMMDD-hhmmss", timestamp())}_arm64.img"
  qemu_binary       = "qemu-aarch64-static"
  target_image_size = 3 * 1024 * 1024 * 1024
}

build {
  name = "base"
  sources = local.builds

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
