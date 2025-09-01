# 创建 EC2 实例的 IAM 角色
resource "aws_iam_role" "ec2_role" {
  name = "ec2-role-for-ssm"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Principal = {
          Service = "ec2.amazonaws.com"
        }
      }
    ]
  })
}

# 为 IAM 角色附加 AmazonSSMManagedInstanceCore 策略
resource "aws_iam_role_policy_attachment" "ssm_policy" {
  role       = aws_iam_role.ec2_role.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonSSMManagedInstanceCore"
}

# 创建实例配置文件
resource "aws_iam_instance_profile" "ec2_profile" {
  name = "ec2-instance-profile"
  role = aws_iam_role.ec2_role.name
}

# 查找最新的 Ubuntu 22.04 LTS AMI
data "aws_ami" "ubuntu" {
  most_recent = true

  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-jammy-22.04-amd64-server-*"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }

  owners = ["099720109477"] # Canonical 的官方账户ID
}

# 创建 EC2 实例
resource "aws_instance" "web_server" {
  ami                         = data.aws_ami.ubuntu.id
  instance_type               = "t3.micro"
  subnet_id                   = aws_subnet.public_subnet_1.id
  vpc_security_group_ids      = [aws_security_group.web_sg.id]
  key_name                    = aws_key_pair.web_server_key.key_name # 指定密钥对
  associate_public_ip_address = true
  iam_instance_profile        = aws_iam_instance_profile.ec2_profile.name

# 用户数据脚本 - 实例启动时自动安装和配置 Nginx
  user_data = <<-EOF
              #!/bin/bash
              apt-get update
              apt-get install -y nginx
              systemctl start nginx
              systemctl enable nginx
              echo "<html><body><h1>Welcome to My Web Server!</h1><p> Designed by Pengchao in Shanghai</p><p>Instance ID: $(curl -s http://169.254.169.254/latest/meta-data/instance-id)</p><p>Public IP: $(curl -s http://169.254.169.254/latest/meta-data/public-ipv4)</p></body></html>" > /var/www/html/index.html
              systemctl restart nginx
              EOF

  tags = {
    Name = "ubuntu-web-server"
  }

  user_data_replace_on_change = true
}
