variable "cloud_id" {
  type = string
}

variable "folder_id" {
  type = string
}

variable "token" {
  type = string
}

variable "ssh_public_key" {
  type        = string
  description = "path to public ssh key for provisioning"
}

variable "ssh_privite_key" {
  type        = string
  description = "path to privite ssh key for provisioning"
}

variable "default_zone" {
  type    = string
  default = "ru-central1-a"
}

variable "admin_user" {
  type    = string
  default = "cloudadmin"
  description = "admin user for target vm (sudo without password)"
}

variable "local_subnet" {
  type    = list(string)
  default = ["192.168.1.0/24"]
}

variable "image_id" {
  # (ubuntu-22-04-lts-v20230925) , all images you can see by execting command: 
  # yc compute image list --folder-id standard-images
  type        = string
  default     = "fd80bm0rh4rkepi5ksdi"
  description = "boot image for created vm"
}

variable "network_name" {
  type    = string
  default = "network-1"
}

variable "vm_name" {
  type    = string
  default = "nginx01"
}

variable "platform_id" {
  type    = string
  default = "standard-v1"
  description = "type of hardware resources https://cloud.yandex.ru/docs/compute/concepts/vm-platforms"
  # available values:
  # standard-v1
  # standard-v2
  # standard-v3
  # highfreq-v3
}

variable "cores" {
  type        = number
  default     = 2
  description = "number of cores for created vm (should be appropriate to platform_id)"
}

variable "memory" {
  type        = number
  default     = 2
  description = "number memory size in GB for created vm (should be appropriate to platform_id)"
}

variable "labels" {
  type = map(string)
  default = {
    "dev" = "yes"
  }
  description = "arbitary labels sticking to created resources"
}



