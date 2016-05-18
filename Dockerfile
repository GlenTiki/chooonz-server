FROM ibmcom/swift-ubuntu:latest
EXPOSE 8090
USER root
RUN apt-get update
RUN apt-get install -y git \
                      build-essential \
                      automake \
                      clang \
                      libicu-dev \
                      autoconf \
                      libtool \
                      libkqueue-dev \
                      libkqueue0 \
                      libdispatch-dev \
                      libdispatch0 \
                      libhttp-parser-dev \
                      libcurl4-openssl-dev \
                      libhiredis-dev \
                      libbsd-dev
COPY ./pcre2-10.20 /root/
RUN cd /root && ./configure && make && make install
RUN cd /root && mkdir chooonz
COPY . /root/chooonz/
RUN cd /root/chooonz && swift build -Xcc -fblocks -Xswiftc -I/usr/local/include -Xlinker -L/usr/local/lib
CMD cd /root/chooonz && /root/chooonz/.build/debug/chooonz-server
