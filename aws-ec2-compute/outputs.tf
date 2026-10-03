output "instance_id" {
  description = "The ID of the EC2 instance"
  value       = aws_instance.web.id
}

output "public_ip" {
  description = "Public IP address of the web server"
  value       = aws_instance.web.public_ip
}

output "website_url" {
  description = "Direct URL to access the deployed web page"
  value       = "http://${aws_instance.web.public_ip}"
}
