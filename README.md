# terraform-openstack-dataiku

[![CI](https://github.com/pli01/terraform-openstack-dataiku/actions/workflows/main.yml/badge.svg)](https://github.com/pli01/terraform-openstack-dataiku/actions/workflows/main.yml)

Terraform modules which creates multiple customized dataiku resources on an Openstack Project/Tenant
Dataiku nodes are:
 - design
 - automation
 - apideployer
 - api
 - (optional kubernetes Compute resources)


This module create the following resources
  * 1 network/subnet
  * floating ips
  * security group/rule for bastion/http_proxy/loadbalancer/logs/app
  * 1 root volume acting as template snapshot volume for other instances
  * 1 bastion stack instance (for ssh acces)
  * 1 http_proxy stack instance (corporate proxy)
  * 1 log stack instance (override with your own url log_install_script)
  * N load-balancer stack instances (override with your own url lb_install_script) with traefik http-provider to swift
  * N app, application stack instances (override with your own url app_install_script)
  * Terraform backend state stored in swift

![Schema](doc/terraform-openstack-app.png)

# Notes:

Prereq:
  * openstack credentials / tenant
  * (optional) dockerhub credentials
  * (optional) corporate http proxy credentials

this terraform module
  * provision openstack resources (network,volume,floating-ip security group,swift object)
  * provision instances with heat stack template (use wait_condition) and cloud_config template
  * customize cloud-init install script with install_script variables

Custom install script used:
  * [load balancer docker stack (traefik+http-provider,nginx,openstack swift)](https://github.com/pli01/simple-traefik-http-provider)
  * [EFK log docker stack (Elastic,Kibana,Fluentd,Curator)](https://github.com/pli01/log-stack/)
  * [beat docker stack (metricbeat,heartbeat)](https://github.com/pli01/beat-stack/)
  * [sample app ](./samples/)

### Terraform variables
See details in `terraform/variables.tf` file and `examples` dir

Common variables
| Name | description | Value |
| --- | --- | --- |
| `prefix_name` | environment prefix | `test` |
| `image` | cloud image | `debian9-latest` |
| `vol_size` | root volume size (Go) | `10` |
| `vol_type` | volume type | `ceph` |
| `key_name` | key_name to allow ssh connection  | `debian` |
| `bastion_count` | bastion count (0 = disable, 1=enable) | `1` |
| `bastion_flavor` | bastion flavor | `standard-2.2` |
| `bastion_data_enable` | data added disk (true or false)| `false` |
| `bastion_data_size` | data disk size (Go)| `0` |
| `http_proxy_count` | http_proxy count (0 = disable, 1=enable) | `1` |
| `http_proxy_flavor` | http_proxy flavor | `standard-2.2` |
| `tinyproxy_upstream` | default tinyproxy_upstream | `["upstream proxy1:3128"]` |
| `tinyproxy_proxy_authorization` | tinyproxy_proxy_authorization | `base64(login:password)` |
| `dockerhub_login` | dockerhub_login | `login` |
| `dockerhub_token` | dockerhub_token | `token` |
| `github_token` | github_token | `github_token` |
| `docker_registry_username` | docker_registry_username | `docker_registry_username` |
| `docker_registry_token` | docker_registry_token | `docker_registry_token` |
| `syslog_relay` | syslog_relay  | `floating ip log stack` |
| `log_count` | log instance count (0 = disable, 1=enable) | `1` |
| `log_flavor` | log flavor | `standard-2.2` |
| `log_data_enable` | data added disk (true or false)| `false` |
| `log_data_size` | data disk size (Go)| `0` |
| `log_install_script` | log install script url to deploy | `https://raw.githubusercontent.com/pli01/log-stack/master/ci/docker-deploy.sh` |
| `log_variables` | log_variables map ({ VAR=value, VAR2=value2}) | `{}` |
| `metric_enable` | metric_enable on app instances (false, true) | `false` |
| `metric_install_script` | metric_install_script url to deploy | `https://raw.githubusercontent.com/pli01/beat-stack/master/ci/docker-deploy.sh` |
| `lb_count` | lb instance count (0 = disable, 1=enable) | `1` |
| `lb_flavor` | lb flavor | `standard-2.2` |
| `lb_metric_variables` | metric_enable on app instances | `{}` |
| `lb_install_script` | lb install script url to deploy | `https://raw.githubusercontent.com/pli01/simple-traefik-http-provider/main/ci/docker-deploy.sh` |
| `lb_variables` | lb_variables map ({ VAR=value, VAR2=value2}) | `{}` |
| `app_count` | app instance count (0 = disable, 1,2,3...N) | `1` |
| `app_flavor` | app flavor | `standard-2.2` |
| `app_data_enable` | data added disk (true or false)| `false` |
| `app_data_size` | data disk size (Go)| `0` |
| `app_metric_variables` | metric_enable on app instances ({ VAR=value, VAR2=value2}) | `{}` |
| `app_install_script` | app install script url to deploy | `https://raw.githubusercontent.com/pli01/terraform-openstack-app/main/samples/app/whoami/whoami-docker-deploy.sh` |
| `app_variables` | app_variables map ({ VAR=value, VAR2=value2}) | `{}` |

### Variables
You can override terraform variables
```
Variable Openstack credentials
OS_PROJECT_NAME=<CHANGE_DEV_TENANT>
OS_USERNAME=<CHANGE_USER>
OS_PASSWORD=<CHANGE_PASSWORD>
OS_AUTH_URL=https://identity.api.my-cloud.org/v3
OS_CACERT=/etc/ssl/certs/ca-certificates.crt
OS_IDENTITY_API_VERSION=3
OS_INTERFACE=public
OS_PROJECT_DOMAIN_NAME=tech
OS_REGION_NAME=region1
OS_USER_DOMAIN_NAME=tech
OS_INSECURE=true
export OS_AUTH_URL OS_CACERT OS_IDENTITY_API_VERSION OS_INTERFACE OS_PROJECT_DOMAIN_NAME OS_USER_DOMAIN_NAME OS_REGION_NAME OS_PROJECT_NAME OS_USERNAME OS_PASSWORD OS_INSECURE

Variable TF_VAR_xxxx
TF_VAR_tinyproxy_proxy_authorization = base64(login:password)

```

## Local build terraform

You can also test,validate,plan,apply terraform file from the local docker image before commit your work

* Build docker image with terraform/terragrunt
```
make build
```
* Test, plan, deploy
```
make tf-format PROJECT="terraform"
make tf-validate PROJECT="terraform"
make tf-plan PROJECT="terraform" TF_VAR_FILE="-var-file=/data/terraform/env/dev/config.auto.vars"
make tf-apply PROJECT="terraform" TF_VAR_FILE="-var-file=/data/terraform/env/dev/config.auto.vars"
# or
make tf-deploy PROJECT="terraform" TF_VAR_FILE="-var-file=/data/terraform/env/dev/config.auto.vars"
```

# How does it work?

This is a tool that deploys a `Dataiku` project via `OpenStack`: 

- `OpenStack` is a cloud orchestration platform that manages resources, they do not host the compute - they let that out to the platform on which you are orchestrating.
- `Dataiku` is a low-code/no-code platform in which data engineers and business anlaysts can work together. Essentially Palantir but for the broader business world. Like `OpenStack` it uses external compute.

The challenge that I'm facing is that I can't even build the project. The project is built using a `Makefile`, which is another orchestration tool:

- `Makefiles` are simple bash scripts that is used to compile code. It is called via the `make` command line argument, it can take parameters like so:

```Makefile
# ./Makefile
all:
    echo "build|deploy|destroy"
build:
    echo "building"
deploy:
    echo "deploy"
destroy:
    echo "destroy"
```

So to call this:

```sh
make build
>> echo "building"
>> building
```

They simply exist to speed up deployment of complex code.

test action