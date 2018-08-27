FROM jenkins/jenkins:lts

MAINTAINER Michael Fong <mcfong.open@gmail.com>


USER root

RUN apt-get update && apt-get install -y g++

####################################################### 
# SDKMan
RUN apt-get update && \
        apt-get install -y zip unzip;

RUN curl -s "https://get.sdkman.io" | bash
ENV SDKMAN_DIR /root/.sdkman/
RUN set -x \
    && echo "sdkman_auto_answer=true" > $SDKMAN_DIR/etc/config \
    && echo "sdkman_auto_selfupdate=false" >> $SDKMAN_DIR/etc/config \
    && echo "sdkman_insecure_ssl=false" >> $SDKMAN_DIR/etc/config

# Maven
RUN /bin/bash -c " source $SDKMAN_DIR/bin/sdkman-init.sh && sdk install maven"

RUN chown -R jenkins:jenkins $SDKMAN_DIR
#######################################################
WORKDIR /var/jenkins_home

USER jenkins

VOLUME /var/jenkins_home

EXPOSE 8080

EXPOSE 50000

