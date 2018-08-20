FROM nextcloud:13-apache

RUN mkdir -p /usr/share/man/man1/ && \
 apt-get update && \
 apt-get -y install \
    openjdk-8-jdk-headless \
    maven \
    git \
    libfuse-dev \
    vim \
    procps \
    lsyncd \
    net-tools \
    iputils-ping \
    fuse

WORKDIR /usr/src/safecloudfs

# Install dependency libs contained in DepSpace
ENV JAVA_HOME /usr/lib/jvm/java-8-openjdk-amd64
RUN git clone https://github.com/inesc-id/DepSpacito.git
RUN cd DepSpacito && mvn clean && mvn install

# Docker, Inc. decided to make COPY behave totally different from cp(1). To
# copy a dir, the only way is to say 
#   COPY dir/ dir/
# while
#   COPY dir/ target/
# will copy the *content* of dir/ to target/. True Story!
COPY config/ config/
COPY lib/ lib/
COPY src/ src/
COPY install.sh \
     pom.xml \
     ./

COPY docker/.vimrc \
     docker/.bashrc \
     /root/

# Install SafeCloudFS
RUN sh install.sh

# Overwrite settings from nextcloud base image
ENTRYPOINT ["/bin/sh", "-c"]
CMD []
