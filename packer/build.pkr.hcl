source "arm-image" "base" {
  iso_url           = var.source_iso_url
  iso_checksum      = var.source_iso_checksum
  image_type        = "raspberrypi"
  output_filename   = "${formatdate("YYYYMMDD-hhmmss", timestamp())}_arm64.img"
  qemu_binary       = "qemu-aarch64-static"
  target_image_size = 3 * 1024 * 1024 * 1024
}

build {
  name = "base"
  sources = [
    "source.arm-image.base",
  ]

  provisioner "shell" {
    script = "${path.cwd}/scripts/common.sh"
  }

  provisioner "shell" {
    script = "${path.cwd}/scripts/systemd.sh"
  }

  provisioner "shell" {
    script = "${path.cwd}/scripts/systemd-post.sh"
  }

  provisioner "shell" {
    script = "${path.cwd}/scripts/wired-post.sh"
  }
}
