terraform {
  required_version = ">= 1.0.0"
  required_providers {
    docker = {
      source  = "kreuzwerker/docker"
      version = "~> 3.0.0"
    }
  }
}

provider "docker" {
  host = "ssh://elderreebs@192.168.4.68:22"

  # Identify exactly where my new Windows private key file is sitting
  ssh_opts = ["-o", "IdentityFile=~/.ssh/id_rsa"]
}