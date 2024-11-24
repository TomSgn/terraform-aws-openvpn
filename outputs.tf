output "instance_public_ip" {
  description = "Adresse IP publique de l'instance VPN"
  value       = aws_instance.vpn_instance.public_ip
}

output "vpn_connection_port" {
  description = "Port pour la connexion VPN"
  value       = 1194
}
