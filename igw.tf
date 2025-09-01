# 创建互联网网关并附加到 VPC
resource "aws_internet_gateway" "main_igw" {
  vpc_id = aws_vpc.main_vpc.id

  tags = {
    Name = "yiming-igw"
  }
}