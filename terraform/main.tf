provider "aws" {
    region = "us-east-2"
}

variable "server_port" {
    description  = "The port the server will use for HTTP requests"
    type = number
    default = 8080
}

# This makes it easy to do 
# curl http://$(tf output -raw public_ip):8080
output "public_ip" {
    value = aws_instance.example.public_ip
    description = "The public IP address for the server"
}


resource "aws_instance" "example" {
    ami = "ami-0c55b159cbfafe1f0"  # `aws ec2 describe-images --image-ids ami-0c55b159cbfafe1f0` says this is a safe image
    instance_type = "t2.micro"
    vpc_security_group_ids = [aws_security_group.instance.id]
    key_name = aws_key_pair.my_key_pair.key_name

    user_data = <<-EOF
                #!/bin/bash
                echo "Hello, World" > index.html
                nohup busybox httpd -f -p ${var.server_port} &
                EOF

    tags = {
        Name = "my instance"
    }
}

resource "aws_key_pair" "my_key_pair" {
  key_name   = "tims_m2_mbp"
  public_key = file("~/.ssh/tims_m2_mbp.pub")
}

# I'm just going along with the book and following their naming conventions
# but "instance" is a terrible name, like calling a variable "variable".
# Even if I had a use case for only one security group, at least 
# give it a name that emphasizes the "one"-ness of it like "singleton"
resource "aws_security_group" "instance" {
    name = "terraform-example-instance"

    ingress {
        from_port = var.server_port
        to_port = var.server_port
        protocol = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
    }

    # TODO define a variable for this and just use `curl ifconfig.me`
    ingress {
        from_port   = 22
        to_port     = 22
        protocol    = "tcp"
        cidr_blocks = ["73.231.224.243/32"]
    }
}