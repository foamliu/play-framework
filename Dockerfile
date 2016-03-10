FROM centos:7
MAINTAINER Foam Liu <foamliu@yeah.net>

# Create editor userspace
RUN groupadd play
RUN useradd play -m -g play -s /bin/bash
RUN passwd -d play
RUN sudo echo "play ALL=(ALL) NOPASSWD:ALL" > /etc/sudoers.d/play
RUN sudo chmod 0440 /etc/sudoers.d/play
RUN mkdir /home/play/Code
RUN chown -R play:play /home/play/Code

# Install dependencies
ENV ACTIVATOR_VERSION 1.3.7

RUN yum install -y epel-release
RUN yum install -y git make curl wget zip unzip
RUN yum install -y java-1.8.0-openjdk
RUN yum install -y nodejs npm
# Define JAVA_HOME variable
ENV JAVA_HOME /usr/lib/jvm/jre-1.8.0-openjdk
WORKDIR /tmp

# Install play
RUN wget http://downloads.typesafe.com/typesafe-activator/${ACTIVATOR_VERSION}/typesafe-activator-${ACTIVATOR_VERSION}.zip && \
    unzip typesafe-activator-${ACTIVATOR_VERSION}.zip && \
    mv activator-dist-${ACTIVATOR_VERSION} /opt/activator && \
    chown -R play:play /opt/activator && \
    rm typesafe-activator-${ACTIVATOR_VERSION}.zip
RUN echo "export PATH=$PATH:/opt/activator" >> /home/play/.bashrc	
# Define user home. Activator will store ivy2 and sbt caches on /home/play/Code volume
RUN echo "export _JAVA_OPTIONS='-Duser.home=/home/play/Code'" >> /home/play/.bashrc

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