provider "aws" {
  region = "us-east-2"
}

terraform {
  backend "s3" {
	bucket = "bucket-for-managing-terraform-state-files-by-kul"
	key = "kul_zabbix_infra.tfstate"
	region = "us-east-2"
  }
}

variable "servers" {
  default = 1
}

resource "aws_instance" "master" {
  instance_type = "t2.medium"
  key_name = "kul-labs"
  ami = "ami-08962a4068733a2b6"
  tags = {
      Name = "kul-zabbix"
  }
}

resource "aws_instance" "participants_servers" {
  count = var.servers
  instance_type = "t2.medium"
  key_name = "kul-labs"
  ami = "ami-08962a4068733a2b6"
  tags = {
      Name = "kul-zabbix"
  }
}

resource "null_resource" "copy_files" {
  provisioner "file" {  
    connection {
        type = "ssh"
        user = "ubuntu"
        host = aws_instance.master.public_ip
        private_key = file("c:/training/kul-labs.pem")
    }
    source = "c:/training/kul-labs.pem"
    destination = "~/ansible/kul-labs.pem"
  }
  provisioner "file" {  
    connection {
        type = "ssh"
        user = "ubuntu"
        host = aws_instance.master.public_ip
        private_key = file("c:/training/kul-labs.pem")
    }
    source = "ansible.cfg"
    destination = "~/ansible/ansible.cfg"
  }
  provisioner "file" {  
    connection {
        type = "ssh"
        user = "ubuntu"
        host = aws_instance.master.public_ip
        private_key = file("c:/training/kul-labs.pem")
    }
    source = "installZabbix.yaml"
    destination = "~/ansible/installZabbix.yaml"
  }
  provisioner "file" {  
    connection {
        type = "ssh"
        user = "ubuntu"
        host = aws_instance.master.public_ip
        private_key = file("c:/training/kul-labs.pem")
    }
    source = "./zabbix_server.conf"
    destination = "~/ansible/zabbix_server.conf"
  }
  provisioner "file" {  
    connection {
        type = "ssh"
        user = "ubuntu"
        host = aws_instance.master.public_ip
        private_key = file("c:/training/kul-labs.pem")
    }
    source = "./apache.conf"
    destination = "~/ansible/apache.conf"
  }
}

resource "null_resource" "add_master_servers_in_ansible_hosts" {
  triggers = {
    "build" = timestamp()
  }
  depends_on = [ null_resource.copy_files  ]
  provisioner "remote-exec" {  
    connection {
        type = "ssh"
        user = "ubuntu"
        host = aws_instance.master.public_ip
        private_key = file("c:/training/kul-labs.pem")
    }
    inline = [
      "sudo chmod 400 ~/ansible/kul-labs.pem",
      "sudo apt-get update -y && sudo apt-get install -y ansible && mkdir -p ~/ansible",
      "echo [master] > ~/ansible/hosts && echo ${aws_instance.master.public_ip} >> ~/ansible/hosts && echo [nodes] >> ~/ansible/hosts"
    ]
  }
}

resource "null_resource" "add_participants_servers_in_ansible_hosts" {
  triggers = {
    "build" = timestamp()
  }
  count = var.servers
  depends_on = [ null_resource.add_master_servers_in_ansible_hosts,null_resource.copy_files  ]
  provisioner "remote-exec" {  
    connection {
        type = "ssh"
        user = "ubuntu"
        host = aws_instance.master.public_ip
        private_key = file("c:/training/kul-labs.pem")
    }
    inline = [
      "echo ${aws_instance.participants_servers[count.index].public_ip} >> ~/ansible/hosts"
    ]
  }
}

resource "null_resource" "setupZabbix" {
  triggers = {
    "build" = timestamp()
  }  
  depends_on = [ null_resource.add_participants_servers_in_ansible_hosts,null_resource.copy_files   ]
  provisioner "remote-exec" {  
    connection {
        type = "ssh"
        user = "ubuntu"
        host = aws_instance.master.public_ip
        private_key = file("c:/training/kul-labs.pem")
    }
    inline = [
      "cd ~/ansible && ansible-playbook installZabbix.yaml"
    ]
  }
}

output "public_ip_master" {
  value = aws_instance.master.public_ip
}

output "public_ip_participants" {
  value = aws_instance.participants_servers.*.public_ip
}