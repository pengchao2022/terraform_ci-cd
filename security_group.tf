# 创建安全组，允许 SSH HTTPS 和 HTTP 访问
resource "aws_security_group" "web_sg" {
  name        = "web-security-group"
  description = " Allow ssh,http,https traffic"
  vpc_id      = aws_vpc.main_vpc.id

  # 允许 SSH 访问
  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"] # 生产环境中应该限制为特定IP
  }

  # 允许 HTTP 访问
  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  # 允许 HTTPS 访问
  ingress {
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  # 允许所有出站流量
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "web-security-group"
  }
}