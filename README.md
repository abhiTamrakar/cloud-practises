# cloud-practises

## pre-requisites
```
python
pip
terraform >=0.11.7
```
#### install requirements
```
sudo pip install -r requirements.txt
```

#### run terraform to provision infrastructure (untested - need to test)
 * Make sure the access and secret keys are provided.
 * If you are looking to change the assigned values to variables, kindly do so in vars.tf file fo each module.
 * Only bastion host can ssh to the private subnet machines.
 * This practise is intended to test the architecture and its sample deployment and therefore has an ELB with only 1 instance. Should it be needed at any time to produce a real live infrastructure, one should increase the instance count.

```
git clone https://github.com/abhiTamrakar/cloud-practises.git
cd cloud-practises/terraform
terraform init
terraform plan -out /path/to/outputfile.plan
# when done
terraform apply /path/to/outputfile.plan
```

#### run ansible to configure.
 * Only bastion host can ssh to the private subnet machines.
 * Since there was not much time given to this practise, docker images from docker hub are used instead of creating the images from dockerfile.
 * Make sure to make changes in inventory/hosts to ssh via bastion or use sshuttle.
> if you are using sshuttle, make sure to run it before running the ansible playbook.
> Use of '-b' with ansible playbook is advised in case, docker is installed as root user.
```
cd cloud-practises/playbook
ansible-playbook -i inventory --private-key /path/to/private/key.pem play.yml -b
```

###### sample output on localhost
```
$ ansible-playbook -i inventory play.yml -b --connection=local

PLAY [Run with inline v2 compose] **************************************************************************

TASK [docker_service] **************************************************************************************
changed: [localhost]

TASK [debug] ***********************************************************************************************
ok: [localhost] => {
    "output": {
        "ansible_facts": {
            "postgres": {
                "airflow_postgres_1": {
                    "cmd": [
                        "postgres"
                    ], 
                    "image": "postgres:9.6", 
                    "labels": {
                        "com.docker.compose.config-hash": "af6d4c79db3e3f4d114c09fcdb5ee3af172611a2b50f9024fe496d9d5fbd21e1", 
                        "com.docker.compose.container-number": "1", 
                        "com.docker.compose.oneoff": "False", 
                        "com.docker.compose.project": "airflow", 
                        "com.docker.compose.service": "postgres", 
                        "com.docker.compose.version": "1.21.2"
                    }, 
                    "networks": {
                        "airflow_default": {
                            "IPAddress": "172.18.0.2", 
                            "IPPrefixLen": 16, 
                            "aliases": [
                                "7b833a368937", 
                                "postgres"
                            ], 
                            "globalIPv6": "", 
                            "globalIPv6PrefixLen": 0, 
                            "links": null, 
                            "macAddress": "02:42:ac:12:00:02"
                        }
                    }, 
                    "state": {
                        "running": true, 
                        "status": "running"
                    }
                }
            }, 
            "redis": {
                "airflow_redis_1": {
                    "cmd": [
                        "redis-server"
                    ], 
                    "image": "redis:latest", 
                    "labels": {
                        "com.docker.compose.config-hash": "e326846e136fa3f284aee125edc484da6a961589b69629b290bbfc23ce3cc285", 
                        "com.docker.compose.container-number": "1", 
                        "com.docker.compose.oneoff": "False", 
                        "com.docker.compose.project": "airflow", 
                        "com.docker.compose.service": "redis", 
                        "com.docker.compose.version": "1.21.2"
                    }, 
                    "networks": {
                        "airflow_default": {
                            "IPAddress": "172.18.0.3", 
                            "IPPrefixLen": 16, 
                            "aliases": [
                                "redis", 
                                "d5471e34e17d"
                            ], 
                            "globalIPv6": "", 
                            "globalIPv6PrefixLen": 0, 
                            "links": null, 
                            "macAddress": "02:42:ac:12:00:03"
                        }
                    }, 
                    "state": {
                        "running": true, 
                        "status": "running"
                    }
                }
            }, 
            "webserver": {
                "airflow_webserver_1": {
                    "cmd": [
                        "webserver"
                    ], 
                    "image": "puckel/docker-airflow:1.9.0-4", 
                    "labels": {
                        "com.docker.compose.config-hash": "8e7a93b7d06834a41b69ca519e39edf5f79309cac0cf6f148e12740f9a82c191", 
                        "com.docker.compose.container-number": "1", 
                        "com.docker.compose.oneoff": "False", 
                        "com.docker.compose.project": "airflow", 
                        "com.docker.compose.service": "webserver", 
                        "com.docker.compose.version": "1.21.2", 
                        "maintainer": "Puckel_"
                    }, 
                    "networks": {
                        "airflow_default": {
                            "IPAddress": "172.18.0.4", 
                            "IPPrefixLen": 16, 
                            "aliases": [
                                "webserver", 
                                "a32ccf177f8b"
                            ], 
                            "globalIPv6": "", 
                            "globalIPv6PrefixLen": 0, 
                            "links": null, 
                            "macAddress": "02:42:ac:12:00:04"
                        }
                    }, 
                    "state": {
                        "running": true, 
                        "status": "running"
                    }
                }
            }
        }, 
        "changed": true, 
        "failed": false
    }
}

TASK [assert] **********************************************************************************************
ok: [localhost] => {
    "changed": false, 
    "msg": "All assertions passed"
}

PLAY RECAP *************************************************************************************************
localhost                  : ok=3    changed=1    unreachable=0    failed=0


```

#### access application UI using LB address.
[![output](https://github.com/abhiTamrakar/cloud-practise/blob/master/ansible-output.png)]
