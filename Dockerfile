#
# Scala and sbt Dockerfile
#
# https://github.com/hseeberger/scala-sbt
#

# Pull base image
FROM  openjdk:8

ENV SBT_VERSION 0.13.13
ENV SCALA_VERSION 2.11.8
ENV BIGBRICKS_HOME /usr/local/bigbricks
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
  apt-get install maven && \
  sbt sbtVersion

#Install bigbricks

WORKDIR $BIGBRICKS_HOME

RUN git clone https://github.com/homedepot/BigBricks-delegates.git && \
    cd BigBricks-delegates && \
    git checkout main-class && \
    sbt assembly && \
    cp target/scala-2.11/bigbricks-assembly.jar $BIGBRICKS_HOME 


WORKDIR /root
#COPY BigBricks-delegates/target/scala-2.11/bigbricks-assembly.jar /opt/ 
# Define working directory
