# Pull down the verified Pi-hole image from Docker Hub
resource "docker_image" "pihole" {
  name = "pihole/pihole:latest"
}

# Provision and maintain the actual network core container
resource "docker_container" "pihole" {
  name    = "pihole_core"
  image   = docker_image.pihole.image_id
  restart = "unless-stopped"

  # Core DNS Routing Ports
  ports {
    internal = 53
    external = 53
    protocol = "udp"
  }
  ports {
    internal = 53
    external = 53
    protocol = "tcp"
  }

  # Web Admin Console Panel Port
  ports {
    internal = 80
    external = 80
    protocol = "tcp"
  }

  # Injecting decoupled operational configurations
  env = [
    "TZ=${var.pihole_timezone}",
    "WEBPASSWORD=${var.pihole_password}"
  ]

  # This hook will fire off the Python automation 
  # the exact second the container build finishes successfully.
  provisioner "local-exec" {
    command = "python ./scripts/sync_blocklists.py"
  }
}

# Create a persistent volume for Uptime Kuma's configurations
resource "docker_volume" "kuma_data" {
  name = "kuma_data"
}

# Provision the Uptime Kuma Monitoring Engine
resource "docker_container" "uptime_kuma" {
  name    = "uptime_kuma"
  image   = "louislam/uptime-kuma:1"
  restart = "unless-stopped"

  # Web Interface Port mapping
  ports {
    internal = 3001
    external = 3001
    protocol = "tcp"
  }

  volumes {
    volume_name    = docker_volume.kuma_data.name
    container_path = "/app/data"
  }
}