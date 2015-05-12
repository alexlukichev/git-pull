FROM debian:8

RUN apt-get update && apt-get install -y git-core && apt-get clean -y

ENV BRANCH null

ENV REPO null

ADD loop.sh /

VOLUME /repo

WORKDIR /repo

CMD ["/loop.sh"]

