variable "prefix_name" {
  default = "test"
}

variable "heat_wait_condition_timeout" {
  type    = number
  default = 1200
}


variable "bastion_count" {
  type    = number
  default = 1
}

variable "http_proxy_count" {
  type    = number
  default = 1
}

variable "log_count" {
  type    = number
  default = 1
}

# lb
variable "lb_count" {
  type    = number
  default = 1
}
variable "lb_flavor" {
  type    = string
  default = "t1.small"
}



# Params file for variables

#### GLANCE
variable "image" {
  type    = string
  default = "debian-latest"
}
variable "most_recent_image" {
  # default = "true"
  default = "false"
}
#### NEUTRON
variable "external_network" {
  type    = string
  default = "external-network"
}

variable "dns_nameservers" {
  type    = list(string)
  default = ["8.8.8.8", "8.8.8.4"]
}

variable "network_worker" {
  type = map(string)
  default = {
    subnet_name = "subnet-worker"
    cidr        = "192.168.1.0/24"
  }
}

#### MAIN DISK SIZE FOR WORKER
variable "vol_size" {
  type    = number
  default = 10
}

variable "vol_type" {
  type    = string
  default = "default"
}

#### VM parameters ####
variable "key_name" {
  type    = string
  default = "debian"
}

variable "bastion_flavor" {
  type    = string
  default = "t1.small"
}
variable "http_proxy_flavor" {
  type    = string
  default = "t1.small"
}
variable "log_flavor" {
  type    = string
  default = "t1.small"
}


#### Variable used in heat and cloud-init
variable "no_proxy" {
  type    = string
  default = "localhost"
}

variable "ssh_access_cidr" {
  type    = string
  default = "0.0.0.0/0"
}

variable "ssh_authorized_keys" {
  type    = list(string)
  default = []
}

#### http_proxy #####
variable "tinyproxy_upstream" {
  default = ""
}
variable "tinyproxy_proxy_authorization" {
  default = ""
}
variable "dns_domainname" {
  type    = list(string)
  default = []
}
variable "nexus_server" {
  default = ""
}
variable "mirror_docker" {
  default = "https://download.docker.com/linux/debian"
}
variable "mirror_docker_key" {
  default = "https://download.docker.com/linux/debian/gpg"
}
variable "docker_version" {
  default = "docker-ce=5:19.03.11~3-0~debian-stretch"
}
variable "docker_compose_version" {
  default = "1.21.2"
}

variable "dockerhub_login" {
  default = ""
}
variable "dockerhub_token" {
  default = ""
}
variable "github_token" {
  default = ""
}

variable "docker_registry_username" {
  default = ""
}

variable "docker_registry_token" {
  default = ""
}
# enable metric
variable "metric_enable" {
  type = bool
  default = false
}
variable "lb_metric_variables" {
   type = map
   default = {}
}

variable "log_variables" {
  type = map
  default = {}
}
variable "lb_install_script" {
  default = ""
}
variable "lb_variables" {
  type = map
  default = {}
}

variable "bastion_data_enable" {
  type = bool
}
variable "bastion_data_size" {
  type = number
}
variable "log_data_enable" {
  type = bool
}
variable "log_data_size" {
  type = number
}


variable "dss_flavor" {
  type    = string
  default = "t1.small"
}
variable "dss_count" {
  type    = number
  default = 1
}
variable "dss_metric_variables" {
   type = map
   default = {}
}
variable "dss_install_script" {
  default = ""
}
variable "dss_variables" {
   type = map
   default = {}
}
variable "dss_data_enable" {
  type = bool
}
variable "dss_data_size" {
  type = number
}


variable "automation_flavor" {
  type    = string
  default = "t1.small"
}
variable "automation_count" {
  type    = number
  default = 1
}
variable "automation_metric_variables" {
   type = map
   default = {}
}
variable "automation_install_script" {
  default = ""
}
variable "automation_variables" {
   type = map
   default = {}
}
variable "automation_data_enable" {
  type = bool
}
variable "automation_data_size" {
  type = number
}


variable "tableau_flavor" {
  type    = string
  default = "t1.small"
}
variable "tableau_count" {
  type    = number
  default = 1
}
variable "tableau_metric_variables" {
   type = map
   default = {}
}
variable "tableau_install_script" {
  default = ""
}
variable "tableau_variables" {
   type = map
   default = {}
}
variable "tableau_data_enable" {
  type = bool
}
variable "tableau_data_size" {
  type = number
}

variable "postgresql_flavor" {
  type    = string
  default = "t1.small"
}
variable "postgresql_count" {
  type    = number
  default = 1
}
variable "postgresql_metric_variables" {
   type = map
   default = {}
}
variable "postgresql_install_script" {
  default = ""
}
variable "postgresql_variables" {
   type = map
   default = {}
}
variable "postgresql_data_enable" {
  type = bool
}
variable "postgresql_data_size" {
  type = number
}
