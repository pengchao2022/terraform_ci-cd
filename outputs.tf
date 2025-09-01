output "instance_public_ip" {
  description = "EC2 实例的实际公有 IP"
  value       = aws_instance.web_server.public_ip
}


# 输出 EC2 实例 ID
output "ec2_instance_id" {
  description = "EC2 实例的 ID"
  value       = aws_instance.web_server.id
}