variable "pihole_timezone" {
  type        = string
  default     = "America/New_York"
  description = "The timezone for the container application log layers"
}

variable "pihole_password" {
  type        = string
  sensitive   = true
  description = "The web admin dashboard entry password"
}