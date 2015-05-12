Running
=======

    docker run -i -t --rm \
           -e REPO=<repo>
           -e BRANCH=<branch>
           -v <workspace dir>:/repo 
           alexlukichev/git-pull
