#!/bin/bash
source spinup.conf
appRepoName=`echo "$appRepo" | cut -d'/' -f 5 | cut -d'.' -f 1`
dockerImageName="local/$appRepoName"

# delete possible legacy docker image
docker rmi "$dockerImageName" 2>/dev/null

# get simple-sinatra-app
git clone -b $appRepoBranch $appRepo

# copy Dockerfile next to app Gemfile
\cp Dockerfile "./$appRepoName"

# generate Gemfile.lock
cd "$appRepoName"
docker run --rm -v "$PWD":/usr/src/app -w /usr/src/app ruby:2.4 bundle install

if [ ! -e "Gemfile.lock"]
  echo "Failed to generate Gemfile.lock."
  exit 1
fi

echo `pwd`
# build docker image
docker build -t "$dockerImageName" .

# spinup docker container as service upon new docker image, expose port 80
containerId=`docker run -d --name "$appRepoName" -p 80:4567 fen9li/ruby-sinatra ruby helloworld.rb`

# report
echo "Container "$appRepoName" has spinned up succefully."
echo "Run command 'curl http://localhost' now, and you should see 'Hello World!' message."
echo "Try browser url 'http://<docker-mother-host-IP-address>', you should also see 'Hello World!' message."

exit 0


