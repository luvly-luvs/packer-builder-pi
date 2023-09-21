packer {
  required_plugins {
    arm-image = {
      source  = "github.com/solo-io/arm-image"
      version = "~> 0.2.7"
    }

    ansible = {
      version = "~> 1.1.0"
      source  = "github.com/hashicorp/ansible"
    }
  }
}

source "arm-image" "raspberry_pi_os" {
  chroot_mounts = [
    ["proc", "proc", "/proc"],
    ["sysfs", "sysfs", "/sys"],
    ["bind", "/dev", "/dev"],
    ["devpts", "devpts", "/dev/pts"],
    ["binfmt_misc", "binfmt_misc", "/proc/sys/fs/binfmt_misc"],
  ]
  iso_checksum = "sha256:b5e3a1d984a7eaa402a6e078d707b506b962f6804d331dcc0daa61debae3a19a"
  iso_url      = "https://downloads.raspberrypi.org/raspios_lite_armhf/images/raspios_lite_armhf-2023-05-03/2023-05-03-raspios-bullseye-armhf-lite.img.xz"
  target_image_size    = 5368709120
}

build {
  sources = ["source.arm-image.raspberry_pi_os"]

  provisioner "ansible" {
    playbook_file    = "./ansible/bootstrap.playbook.yml"
    ansible_env_vars = [
      "ANSIBLE_FORCE_COLOR=1",
      "PYTHONUNBUFFERED=1",
    ]
    extra_arguments  = [
      # The following arguments are required for running Ansible within a chroot
      # See https://www.packer.io/plugins/provisioners/ansible/ansible#chroot-communicator for details
      "--connection=chroot",
      "--become-user=root",
      #  Ansible needs this to find the mount path
      "-e ansible_host=${build.MountPath}"
    ]
  }
}