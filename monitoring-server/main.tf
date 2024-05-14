resource "aws_security_group" "sg" {
  name        = "monitoring-server-sg"
  description = "Allow 9090 and 3000 ports"
  vpc_id      = var.vpc_id

  ingress {
    description = "Allow 9090 port"
    from_port   = 9090
    to_port     = 9090
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description = "HTTPS"
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description = "SSH"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description = "Allow 3000 port"
    from_port   = 3000
    to_port     = 3000
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description = "Node Exporter"
    from_port   = 9100
    to_port     = 9100
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    description = "All traffic"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_instance" "web" {
  ami                    = var.ami
  instance_type          = var.instance_type
  subnet_id              = var.subnet_id
  key_name               = var.key_pair
  vpc_security_group_ids = [aws_security_group.sg.id]

  root_block_device {
    volume_size = 25
    volume_type = "gp3"
  }

  user_data = file("userdata.sh")

  tags = {
    Name        = "monitoring-server"
    Environment = "dev"
  }
}

resource "aws_eip" "eip" {
  instance = aws_instance.web.id
  domain   = "vpc"

  tags = {
    "Name" = "eip-monitoring-server"
  }
}