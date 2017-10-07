## Introduction
This project implements a solution to spin up a simple sinatra 'Hello World!' web server on a Linux host (physical or virtual). The web page is served via docker container on TCP port 80. The sinatra web app is kept in GitHub. The new docker image can push to Docker Hub. 

## Base Docker Image
- [ruby:2.4-onbuild](https://hub.docker.com/_/ruby/)

## simple-sinatra-app 
- [simple-sinatra-app](https://github.com/fen9li/simple-sinatra-app.git) 

## Installation
1. Create docker mother host (Linux / CentOS7) & install software packages

```sh
~]# uname -a
Linux docker03.fen9.li 3.10.0-693.2.2.el7.x86_64 #1 SMP Tue Sep 12 22:26:13 UTC 2017 x86_64 x86_64 x86_64 GNU/Linux
~]# cat /etc/os-release
NAME="CentOS Linux"
VERSION="7 (Core)"
... ...
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

4. Ensure login user is in docker group, create working directory and git clone [fen9li/docker-sinatra-app](https://github.com/fen9li/docker-sinatra-app.git)

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

## Change directory 'docker-sinatra-app', create docker image and spinup docker simple-sinatra-app service

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
> The new docker image will build to serve this ruby simple-sinatra-app.

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
Successfully built 428274244150
Successfully tagged local/simple-sinatra-app:latest

#########################

Container simple-sinatra-app with ID edaaae79588c2bbeaf44db95be60bf358a87c59ab19b3c1591e609b0720c5a81 has spinned up succefully.

To test it, run command 'curl http://localhost' on docker mother host, and should see 'Hello World!' message.

To test it, enter 'http://<docker-mother-host-IP-address>' in browser url bar from other hosts, should also see 'Hello World!' message.

#########################
 docker-sinatra-app]$
```

## Test simple-sinatra-app Service 
1. On docker mother host

```sh
 docker-sinatra-app]$ curl http://localhost
Hello World![xxx@xxxxxxxx docker-sinatra-app]$
```

2. On other hosts
> On other hosts who can see docker mother host ip address.
> Enter 'http://[docker-mother-host-IP-address]' in its browser url bar and should also see 'Hello World!' message. 

## Frequently Asked Questions (FAQ)
### How to push the new docker image to Docker Hub?
1. Update dockerImageName="[your-docker-hub-user-name]/$appRepoName" in spinup.sh 

```sh
# change dockerImageName to dockerhub user name
# if the docker image needs to push dockerhub later
# dockerImageName="[your-docker-hub-user-name]/$appRepoName"
dockerImageName="local/$appRepoName"
```

2. Run spinup.sh. 
3. Run command 'docker images' to ensure the new image is ready.
4. Push new image to Docker Hub.

### Can't browse simple sinatra app web page from other hosts
1. Ensure can visit web page from local host.
2. Ensure 'http' service added to docker mother host firewall rule.
3. check other settings outside local host.
