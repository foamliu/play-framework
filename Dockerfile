FROM centos:7
MAINTAINER Foam Liu <foamliu@yeah.net>

# Create editor userspace
RUN groupadd play
RUN useradd play -m -g play -s /bin/bash
RUN passwd -u play
RUN echo "play ALL=(ALL) NOPASSWD:ALL" > /etc/sudoers.d/play
RUN chmod 0440 /etc/sudoers.d/play
RUN mkdir /home/play/Code
RUN chown -R play:play /home/play/Code

# Install dependencies
ENV ACTIVATOR_VERSION 1.3.7
RUN yum update
RUN yum install -y git 
RUN yum install -y build-essential 
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
	
# Install Java and dependencies
RUN \
echo oracle-java8-installer shared/accepted-oracle-license-v1-1 select true | debconf-set-selections && \
add-apt-repository -y ppa:webupd8team/java && \
apt-get update && \
apt-get install -y oracle-java8-installer wget unzip tar && \
rm -rf /var/lib/apt/lists/* && \
rm -rf /var/cache/oracle-jdk8-installer
# Define commonly used JAVA_HOME variable
ENV JAVA_HOME /usr/lib/jvm/java-8-oracle
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