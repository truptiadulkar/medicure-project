resource "aws_instance" "medicure-pro" {
  ami                    = "ami-0f5ee92e2d63afc18"
  instance_type          = "t2.micro"
  key_name               = "keypairpem"
  vpc_security_group_ids = ["sg-0a5b8d6ca31ae2d81"]
  tags = {
    Name = "medicure-pro"
  }
  
  provisioner "local-exec" {
    command = "sleep 60 && echo 'Instance ready'"
  }
  
  connection {
    type        = "ssh"
    user        = "ubuntu"
    private_key = file("./keypairpem.pem")
    host        = self.public_ip 
  }
   
  provisioner "local-exec" {
    command = "echo ${aws_instance.medicure-pro.public_ip} > inventory"
  }

  provisioner "local-exec" {
    command = "ansible-playbook /var/lib/jenkins/workspace/medicure-pro/medicure-project/bankdeployplaybook.yml"
  }
}

