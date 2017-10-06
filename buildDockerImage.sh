#!/bin/bash
source buildDockerImage.conf

# change to workingDir and git clone simple-sintra-app
cd $workingDir
git clone -b $appRepoBranch $appRepo

# copy Dockerfile next to app Gemfile
appRepoName=`echo "$appRepo" | cut -d'/' -f 5 | cut -d'.' -f 1`
\cp Dockerfile "./$appRepoName"

# generate Gemfile.lock
cd "$appRepoName"
docker run --rm -v "$PWD":/usr/src/app -w /usr/src/app ruby:2.4 bundle install

if [-e "Gemfile.lock"]
  echo "Failed to generate Gemfile.lock."
  exit 1
fi

# build docker image
dockerImageName="local/$appRepoName"
docker build -t "$dockerImageName" .

# spinup docker container as service upon new docker image, expose port 80
docker run -d --name ruby-sinatra -p 80:4567 fen9li/ruby-sinatra ruby helloworld.rb

# test simple sinatra web service
curl http://localhost
