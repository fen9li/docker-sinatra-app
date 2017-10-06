## Base Docker Image
- [ruby:2.4-onbuild](https://hub.docker.com/_/ruby/)
## Installation
1. Create docker mother host (Linux / CentOS7) & install software packages
```sh
~]# uname -a
Linux docker03.fen9.li 3.10.0-693.2.2.el7.x86_64 #1 SMP Tue Sep 12 22:26:13 UTC 2017 x86_64 x86_64 x86_64 GNU/Linux
~]# cat /etc/os-release
NAME="CentOS Linux"
VERSION="7 (Core)"
ID="centos"
ID_LIKE="rhel fedora"
VERSION_ID="7"
PRETTY_NAME="CentOS Linux 7 (Core)"
ANSI_COLOR="0;31"
CPE_NAME="cpe:/o:centos:centos:7"
HOME_URL="https://www.centos.org/"
BUG_REPORT_URL="https://bugs.centos.org/"

CENTOS_MANTISBT_PROJECT="CentOS-7"
CENTOS_MANTISBT_PROJECT_VERSION="7"
REDHAT_SUPPORT_PRODUCT="centos"
REDHAT_SUPPORT_PRODUCT_VERSION="7"
~]#

~]# yum -y install wget tree git
```
2. Install docker, start, enable docker service & add user to docker group
```sh
~]# wget https://download.docker.com/linux/centos/docker-ce.repo -O /etc/yum.repos.d/docker-ce.repo
~]# yum -y install docker-ce
~]# systemctl start docker; systemctl enable docker
~]# docker --version
Docker version 17.09.0-ce, build afdb6d4
~]#
~]# usermod -aG docker fli
```
3. Add http service to firewall rule
```sh
~]# firewall-cmd --permanent --add-service=http
~]# firewall-cmd --reload
```
4. Ensure login user is in docker group, create test directory and git clone [fen9li/docker-sinatra-app](https://github.com/fen9li/docker-sinatra-app.git)
```sh
 ~]$ id
uid=1000(fli) gid=1000(fli) groups=1000(fli),995(docker) context=unconfined_u:unconfined_r:unconfined_t:s0-s0:c0.c1023
 ~]$

 ~]$ mkdir test
 ~]$ cd test/
 test]$ git clone https://github.com/fen9li/docker-sinatra-app.git
Cloning into 'docker-sinatra-app'...
remote: Counting objects: 15, done.
remote: Compressing objects: 100% (12/12), done.
remote: Total 15 (delta 2), reused 10 (delta 1), pack-reused 0
Unpacking objects: 100% (15/15), done.
 test]$ 
 ```
 5. Expected files and directories structure
 ```sh
 test]$ pwd
/.../.../test
 test]$ tree
.
└── docker-sinatra-app
    ├── buildDockerImage.conf
    ├── buildDockerImage.sh
    ├── Dockerfile
    ├── LICENSE
    └── README.md

1 directory, 5 files
 test]$
```





