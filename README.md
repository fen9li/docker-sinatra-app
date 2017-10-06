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

## Change directory, create docker image and spinup docker simple-sinatra-app service
1. Ensure files and directories as below:
```sh
 test]$ cd docker-sinatra-app/
 docker-sinatra-app]$ tree
.
├── Dockerfile
├── LICENSE
├── README.md
├── spinup.conf
└── spinup.sh

0 directories, 5 files
 docker-sinatra-app]$
```

2. Configure spinup.conf 
> This is the ruby simple-sinatra-app's GitHub repo and branch.
> The new docker image will be build to serve this ruby simple-sinatra-app.
```sh
 docker-sinatra-app]$ egrep -v '^#|^$' spinup.conf
appRepo="https://github.com/fen9li/simple-sinatra-app.git"
appRepoBranch="develop"
 docker-sinatra-app]$
```

3. Run spinup.sh
```sh
 docker-sinatra-app]$ bash spinup.sh
... ...
Successfully built e4b9ea8c191e
Successfully tagged local/simple-sinatra-app:latest

#########################

Container simple-sinatra-app has spinned up succefully.

To test it, run command 'curl http://localhost' on docker mother host, and should see 'Hello World!' message.

To test it, enter url 'http://<docker-mother-host-IP-address>' in browser in other host, should also see 'Hello World!' message.

#########################
 docker-sinatra-app]$
```
## Test simple-sinatra-app Service 
1. On Docker Mother Host
```sh
 docker-sinatra-app]$ curl http://localhost
Hello World![fli@docker03 docker-sinatra-app]$
```
2. On other Hosts
> On other hosts who can see docker mother host ip address.
> Enter 'http://[docker-mother-host-IP-address]' in its browser url bar and should also see 'Hello World!' message. 


