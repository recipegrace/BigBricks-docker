#
# Scala and sbt Dockerfile
#
# https://github.com/hseeberger/scala-sbt
#

# Pull base image
FROM  openjdk:8

ENV SBT_VERSION 0.13.13
ENV SCALA_VERSION 2.11.8
# Scala expects this file
RUN touch /usr/lib/jvm/java-8-openjdk-amd64/release

# Install Scala
## Piping curl directly in tar
RUN \
  curl -fsL http://downloads.typesafe.com/scala/$SCALA_VERSION/scala-$SCALA_VERSION.tgz | tar xfz - -C /root/ && \
  echo >> /root/.bashrc && \
  echo 'export PATH=~/scala-$SCALA_VERSION/bin:$PATH' >> /root/.bashrc

# Install sbt
RUN \
  curl -L -o sbt-$SBT_VERSION.deb http://dl.bintray.com/sbt/debian/sbt-$SBT_VERSION.deb && \
  dpkg -i sbt-$SBT_VERSION.deb && \
  rm sbt-$SBT_VERSION.deb && \
  apt-get update && \
  apt-get install sbt && \
  sbt sbtVersion


RUN wget http://repo.typesafe.com/typesafe/ivy-releases/org.scala-sbt/sbt-launch//$SBT_VERSION/sbt-launch.jar && \
    export SBTJAR=`pwd`"sbt-launch.jar" && \
    git clone https://github.com/homedepot/BigBricks-delegates.git && \
    cd BigBricks-delegates && \
    git checkout main-class && \
    sbt assembly && \
    mkdir -p ~/bigbricks && \
    cp target/scala-2.11/bigbricks-assembly.jar ~/bigbricks 


# Define working directory
WORKDIR /root
