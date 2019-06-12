#!/usr/bin/env bash

push=0

if [ "$1" == "push" ]
then
  push=1
fi

for build in {release,debug,mpich,mpich-debug}
do
  docker build -t benbrock/bcl:$build .
  if [ $push -eq 1 ]
  then
    docker push benbrock/bcl:$build
  fi
  cd ..
done
