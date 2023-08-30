provider "aws" {
    region = "us-east-2"
}

variable "server_port" {
    description  = "The port the server will use for HTTP requests"
    type = number
    default = 8080
}

# # This makes it easy to do 
# # curl http://$(tf output -raw public_ip):8080
# output "public_ip" {
#     value = aws_instance.example.public_ip
#     description = "The public IP address for the server"
# }

output "alb_dns_name" {
    value = aws_lb.example.dns_name
    description = "The domain name of the load balancer"
}

data "aws_vpc" "default" {
    default = true
}

data "aws_subnet_ids" "default" {
    vpc_id = data.aws_vpc.default.id
}


resource "aws_lb" "example" {
    name = "terraform-asg-example"
    load_balancer_type = "application"
    subnets = data.aws_subnet_ids.default.ids
    security_groups = [aws_security_group.alb.id]
}

resource "aws_lb_listener" "http" {
    load_balancer_arn = aws_lb.example.load_balancer_arn
    port = 80
    protocol = "HTTP"

    default_action {
        type = "fixed-response"

        fixed_response {
            content_type = "text/plain"
            message_body = "404: page not found"
            status_code = 404
        }
    }
}

resource "aws_lb_target_group" "asg" {
    name = "terraform-asg-example"
    port = var.server_port
    protocol = "HTTP"
    vpc_id = data.aws_vpc.default.id

    health_check {
        path = "/"
        protocol = "HTTP"
        matcher = "200"
        interval = 15
        timeout = 3
        healthy_threshold = 2
        unhealthy_threshold = 2
    }
}

resource "aws_lb_listener_rule" "asg" {
    listener_arn = aws_lb_listener.http.arn
    priority = 100

    condition {
        path_pattern {
            values = ["*"]
        }
    }

    action {
        type = "forward"
        target_group_arn = aws_lb_target_group.asg.arn
    }
}

resource "aws_security_group" "alb" {
    name = "terraform-example-alb"

    ingress {
        from_port = 80
        to_port = 80
        protocol = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
    }

    egress {
        from_port = 0
        to_port = 0
        protocol = "-1"
        cidr_blocks = ["0.0.0.0/0"]
    }
}

resource "aws_launch_configuration" "example" {
    image_id = "ami-0c55b159cbfafe1f0"  # `aws ec2 describe-images --image-ids ami-0c55b159cbfafe1f0` says this is a safe image
    instance_type = "t2.micro"
    security_groups = [aws_security_group.instance.id]
    key_name = aws_key_pair.my_key_pair.key_name
    user_data = <<-EOF
                #!/bin/bash
                echo "Hello, World" > index.html
                nohup busybox httpd -f -p ${var.server_port} &
                EOF
    
    lifecycle {
        create_before_destroy = true
    }
}


resource "aws_autoscaling_group" "example" {
    launch_configuration = aws_launch_configuration.example.name
    vpc_zone_identifier = data.aws_subnet_ids.default.ids

    target_group_arns = [aws_lb_target_group.asg.arn]
    health_check_type = "ELB"
    
    min_size = 2
    max_size = 10

    tag {
        key = "Name"
        value = "terraform-asg-example"
        propagate_at_launch = true
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

