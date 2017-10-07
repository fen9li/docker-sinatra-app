#!/bin/bash
source spinup.conf
appRepoName=`echo "$appRepo" | cut -d'/' -f 5 | cut -d'.' -f 1`
echo $appRepoName

# change dockerImageName to dockerhub user name
# if the docker image needs to push dockerhub later 
# dockerImageName="fen9li/$appRepoName"
dockerImageName="local/$appRepoName"
echo $dockerImageName

# delete possible legacy resources
docker stop "$appRepoName" # 2>/dev/null
docker rm "$appRepoName" # 2>/dev/null
docker rmi "$dockerImageName" # 2>/dev/null
\rm -Rf "./$appRepoName" # 2>/dev/null

# get simple-sinatra-app
git clone -b $appRepoBranch $appRepo

# copy Dockerfile next to app Gemfile
\cp Dockerfile "./$appRepoName"

# generate Gemfile.lock
cd "$appRepoName"
docker run --rm -v "$PWD":/usr/src/app -w /usr/src/app ruby:2.4 bundle install

if [ ! -e "Gemfile.lock"]; then
  echo "Failed to generate Gemfile.lock."
  exit 1
fi

echo `pwd`
# build docker image
docker build -t "$dockerImageName" .

# spinup docker container as service upon new docker image, expose port 80
containerId=`docker run -d --name "$appRepoName" -p 80:4567 "$dockerImageName" ruby helloworld.rb`

# report
echo ""
echo "#########################"
echo ""
echo "Container "$appRepoName" has spinned up succefully."
echo ""
echo "To test it, run command 'curl http://localhost' on docker mother host, and should see 'Hello World!' message."
echo ""
echo "To test it, enter 'http://<docker-mother-host-IP-address>' in browser url bar from other hosts, should also see 'Hello World!' message."

echo ""
echo "#########################"
exit 0


