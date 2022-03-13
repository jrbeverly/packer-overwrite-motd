packer {
  required_plugins {
    amazon = {
      version = ">= 0.0.2"
      source  = "github.com/hashicorp/amazon"
    }
  }
}

source "amazon-ebs" "ubuntu" {
  ami_name      = "ubuntu-motd-20.04-${uuidv4()}"
  instance_type = "t2.micro"
  region        = "ca-central-1"
  source_ami_filter {
    filters = {
      name                = "ubuntu/images/*ubuntu-focal-20.04-amd64-server-*"
      root-device-type    = "ebs"
      virtualization-type = "hvm"
    }
    most_recent = true
    owners      = ["099720109477"]
  }
  ssh_username = "ubuntu"
}

build {
  name = "motd"
  sources = [
    "source.amazon-ebs.ubuntu"
  ]

  provisioner "shell" {
    inline = [
      "sudo snap install amazon-ssm-agent --classic",
    ]
  }

  provisioner "file" {
    source = "motd.sh"
    destination = "/tmp/00-motd"
  }

  provisioner "shell" {
    inline = [
      "sudo rm /etc/update-motd.d/*",
      "sudo mv /tmp/00-motd /etc/update-motd.d/00-motd",
      "sudo chmod +x /etc/update-motd.d/00-motd",
    ]
  }
}