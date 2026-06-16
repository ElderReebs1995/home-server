# Pull down the verified Pi-hole image from Docker Hub
resource "docker_image" "pihole" {
  name = "pihole/pihole:latest"
}

# Provision and maintain the actual network core container
resource "docker_container" "pihole" {
  name    = "pihole_core"
  image   = docker_image.pihole.image_id
  restart = "unless-stopped"

  # -------------------------------------------------------------------
  # Host Networking: Attaches the container directly to the Pi's hardware.
  # This makes individual client device IPs visible in the dashboard.
  # -------------------------------------------------------------------
  network_mode = "host"

  # NOTE: The explicit "ports" blocks have been completely removed.
  # Host mode automatically exposes ports 53, 80, and 443 directly.

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

  # -------------------------------------------------------------------
  # Senior Safeguard: Adjusted to allow network adjustments
  # -------------------------------------------------------------------
  lifecycle {
    ignore_changes = [
      env,
      # "network_mode" MUST BE REMOVED FROM THIS LIST so Terraform can apply it!
      healthcheck,
      command,
      entrypoint
    ]
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

  # -------------------------------------------------------------------
  # Senior Safeguard: Ignore structural drift to prevent service drop
  # -------------------------------------------------------------------
  lifecycle {
    ignore_changes = [
      env,
      network_mode,
      healthcheck,
      command,
      entrypoint,
      image
    ]
  }
}