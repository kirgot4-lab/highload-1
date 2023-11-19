
#create network
resource "yandex_vpc_network" "lab1" {
  name        = var.network_name
  description = "network for creating vm"
  folder_id   = var.folder_id
  labels      = var.labels
}

#create subnet
resource "yandex_vpc_subnet" "lab-subnet-a" {
  v4_cidr_blocks = var.local_subnet
  zone           = var.default_zone
  network_id     = yandex_vpc_network.lab1.id
  labels         = var.labels
}

#create vm
resource "yandex_compute_instance" "nginx01" {
  name        = var.vm_name
  platform_id = var.platform_id
  zone        = var.default_zone
  hostname    = var.vm_name
  labels      = var.labels

  resources {
    cores  = var.cores
    memory = var.memory
  }

  boot_disk {
    initialize_params {
      image_id = var.image_id
    }
  }

  network_interface {
    subnet_id = yandex_vpc_subnet.lab-subnet-a.id
    nat       = true
  }

  metadata = {
    user-data = "${templatefile("bootstrap/metadata.yaml.tftpl", { admin_user = var.admin_user, ssh_public_key = file(var.ssh_public_key) })}"
  }

  provisioner "remote-exec" {
    inline = ["echo 'SSH connected'"]

    connection {
      type        = "ssh"
      user        = var.admin_user
      private_key = file(var.ssh_privite_key)
      host        = yandex_compute_instance.nginx01.network_interface.0.nat_ip_address
    }

  }

  provisioner "local-exec" {
    command = "ansible-playbook  -i ${yandex_compute_instance.nginx01.network_interface.0.nat_ip_address}, --private-key ${var.ssh_privite_key} nginx.yaml -e 'ansible_user=${var.admin_user}' -D"
  }
}

output "public_ip" {
  value = yandex_compute_instance.nginx01.network_interface.0.nat_ip_address
}

output "public_url" {
  value       = "http://${yandex_compute_instance.nginx01.network_interface.0.nat_ip_address}"
  description = "make sure that nginx installed and running by following the link"
}
