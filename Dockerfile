FROM centos:7
MAINTAINER Foam Liu <foamliu@yeah.net>

# Create editor userspace
RUN groupadd play
RUN useradd play -m -g play -s /bin/bash
RUN mkdir /home/play/Code
RUN chown -R play:play /home/play/Code

# Install dependencies
ENV ACTIVATOR_VERSION 1.3.7

RUN yum install -y git 
RUN yum install -y make 
RUN yum install -y curl 
RUN yum install -y wget 
RUN yum install -y zip 
RUN yum install -y unzip

WORKDIR /tmp

# Install play
RUN wget http://downloads.typesafe.com/typesafe-activator/${ACTIVATOR_VERSION}/typesafe-activator-${ACTIVATOR_VERSION}.zip && \
    unzip typesafe-activator-${ACTIVATOR_VERSION}.zip && \
    mv activator-dist-${ACTIVATOR_VERSION} /opt/activator && \
    chown -R play:play /opt/activator && \
    rm typesafe-activator-${ACTIVATOR_VERSION}.zip

# Change user, launch bash
USER play
WORKDIR /home/play
CMD ["/bin/bash"]

# Expose Code volume and play ports 9000 default 9999 debug 8888 activator ui
VOLUME "/home/play/Code"
EXPOSE 9000
EXPOSE 9999
EXPOSE 8888
WORKDIR /home/play/Code