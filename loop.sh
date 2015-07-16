#!/bin/bash
# BRANCH - the name of the branch to check out
# REPO - the URL of the repository
# REPOKEY - (optional) the SSH private key to access the protected repo (the URL must be SSH)

if [ -z $BRANCH ]; then
  echo "BRANCH not set" && exit 1
fi

if [ -z $REPO ]; then
  echo "REPO not set" && exit 1
fi

echo "BRANCH=$BRANCH"
echo "REPO=$REPO"

git_pull() {
  if [ -z $REPOKEY ]; then
    git pull origin $BRANCH
  else    
    mkdir -p ~/.ssh
    if ! [ -f ~/.ssh/known_hosts] || ! grep "$KNOWN_HOST" ~/.ssh/known_hosts; then
      echo "$KNOWN_HOST" >> ~/.ssh/known_hosts
    fi
    ssh-agent bash -c "ssh-add $REPOKEY && git pull origin $BRANCH"
  fi
}

git_clone() {
  if [ -z $REPOKEY ]; then
    git clone --single-branch -b $BRANCH $REPO .
  else    
    mkdir -p ~/.ssh
    if ! [ -f ~/.ssh/known_hosts] || ! grep "$KNOWN_HOST" ~/.ssh/known_hosts; then
      echo "$KNOWN_HOST" >> ~/.ssh/known_hosts
    fi
    ssh-agent bash -c "ssh-add $REPOKEY && git clone --single-branch -b $BRANCH $REPO ."
  fi
}

while true; do
  if [ -d .git ]; then
    git_pull
  else
    git_clone 
  fi
  newrev=`git rev-parse $BRANCH`
  if [ ! -f .revision ] || ! [ `cat .revision` = $newrev ]; then
    echo $newrev > .revision 
    echo "Set .restart to TRUE"
    touch .restart
  fi
  sleep 15
done

