#!/bin/bash

if [ -z $BRANCH ]; then
  echo "BRANCH not set" && exit 1
fi

if [ -z $REPO ]; then
  echo "REPO not set" && exit 1
fi

echo "BRANCH=$BRANCH"
echo "REPO=$REPO"

while true; do
  if [ -d .git ]; then
    git pull origin $BRANCH
  else
    git clone --single-branch -b $BRANCH $REPO . 
  fi
  newrev=`git rev-parse $BRANCH`
  if [ ! -f .revision ] || ! [ `cat .revision` = $newrev ]; then
    echo $newrev > .revision 
    echo "Set .restart to TRUE"
    touch .restart
  fi
  sleep 15
done

