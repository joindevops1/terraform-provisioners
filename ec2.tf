resource "aws_instance" "web" {
  ami           = "ami-0f3c7d07486cad139" #devops-practice
  instance_type = "t2.micro"
  vpc_security_group_ids = [aws_security_group.roboshop-all.id]
  tags = {
    Name = "provisioner"
  }

  provisioner "local-exec" {
    command = "echo this will excute at tha time of creation you can other trigger other system like email sending alerts"  # self = aws_instance.web
  }

  provisioner "local-exec" {
    command = "echo ${self.private_ip} > inventory"  # self = aws_instance.web
  }

#   provisioner "local-exec" {
#     command = "ansible-playbook -i web.yaml" # self = aws_instance.web
#   }

  provisioner "local-exec" {
    when = destroy
    command = "echo this will excute at tha time of destroy you can other trigger other system like email sending alerts"  # self = aws_instance.we 
  }

  connection {
    type  = "ssh"
    user  = "centos"
    password = "DevOps321"
    host = self.public_ip
  }

  provisioner "remote-exec" {
    inline = [ 
        "echo 'this is from remote exec' > /tmp/remote.txt",
        "sudo yum install nginx -y",
        "sudo systemctl start nginx"
    ]
  }
}

resource "aws_security_group" "roboshop-all" { 
    name        = provisioner # this is for AWS
    
    ingress {
        description      = "Allow All ports"
        from_port        = 22 
        to_port          = 22
        protocol         = "tcp"
        cidr_blocks      = ["0.0.0.0/0"]
    }

    ingress {
        description      = "Allow All ports"
        from_port        = 80
        to_port          = 80
        protocol         = "tcp"
        cidr_blocks      = ["0.0.0.0/0"]
    }

    egress {
        from_port        = 0
        to_port          = 0
        protocol         = "-1"
        cidr_blocks      = ["0.0.0.0/0"]
        #ipv6_cidr_blocks = ["::/0"]
    }

    tags = {
        Name = "provisioner"
    }
}
