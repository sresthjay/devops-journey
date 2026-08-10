# main.tf

# 1. Configure the AWS Provider
# Replace 'your-region' with your actual region (e.g., us-east-1)
provider "aws" {
  region = "us-east-1" # UPDATE THIS!

  # Note: We will use environment variables for credentials (see next step)
  # Alternatively, you can use profiles, but env vars are easier for now.
}

# 2. Create a Security Group to allow traffic
resource "aws_security_group" "web_sg" {
  name        = "terraform-web-sg"
  description = "Allow HTTP and SSH traffic"

  ingress {
    from_port   = 8080
    to_port     = 8080
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"] # Allow internet access
  }

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["27.60.50.159/32"] # Allow SSH (for learning/testing)
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "terraform-web-sg"
  }
}

# 3. Define your EC2 Instance
resource "aws_instance" "web_server" {
  ami                    = "ami-0009f0e33a034b86c" # Ubuntu 24.04 AMI ID (Update for your region!)
  instance_type          = "t4g.micro"
  vpc_security_group_ids = [aws_security_group.web_sg.id]

  key_name = "my-devops-key"

  user_data = <<-EOF
              #!/bin/bash
              apt-get update
              apt-get install -y docker.io
              systemctl start docker
              systemctl enable docker
              usermod -a -G docker ubuntu

              # Clean up any old container
              docker rm -f my-cloud-app || true
              
              # Pull your Docker image and run it
              docker pull sresthjay/my-python-app:latest
              docker run -d \
                --name my-cloud-app \
                --restart unless-stopped \
                -p 8080:8080 \
                sresthjay/my-python-app:latest
             

             EOF

  tags = {
    Name = "terraform-ec2-web"
  }
}

# 4. Output the Public IP
output "instance_public_ip" {
  value       = aws_instance.web_server.public_ip
  description = "The public IP address of your EC2 instance"
}
