FROM debian:bullseye


ARG TARGETPLATFORM
RUN echo "I'm building for $TARGETPLATFORM"

#RUN sed -i 's/archive.ubuntu.com/mirror.aarnet.edu.au\/pub\/ubuntu\/archive/g' /etc/apt/sources.list
#RUN sed -i.bak -e "s%http://[^ ]\+%http://ftp.jaist.ac.jp/pub/Linux/debian/%g" /etc/apt/sources.list

RUN apt-get -y update && apt-get install -y  curl libsrtp2-dev libnice-dev nginx

RUN rm -rf /var/lib/apt/lists/*
RUN apt-get -y update && apt-get install -y libmicrohttpd-dev \
    libjansson-dev \
    libnice-dev \
    libssl-dev \
    libsrtp2-dev \
    libsofia-sip-ua-dev \
    libglib2.0-dev \
    libopus-dev \
    libogg-dev \
    libini-config-dev \
    libcollection-dev \
    libconfig-dev \
    pkg-config \
    gengetopt \
    libtool \
    automake \
    build-essential \
    subversion \
    git \
    cmake \
    unzip \
    zip \
    libavutil-dev libavcodec-dev libavformat-dev \
    lsof wget vim sudo rsync cron default-mysql-client openssh-server supervisor locate \
    libusrsctp-dev libwebsockets-dev

# Boringssl build section
# If you want to use the openssl instead of boringssl
# RUN apt-get update -y && apt-get install -y libssl-dev
RUN apt-get -y update && apt-get install -y --no-install-recommends \
        g++ \
        gcc \
        libc6-dev \
        make \
        pkg-config \
    && rm -rf /var/lib/apt/lists/*
#ENV GOLANG_VERSION 1.7.5
#ENV GOLANG_DOWNLOAD_URL https://golang.org/dl/go$GOLANG_VERSION.linux-amd64.tar.gz
#ENV GOLANG_DOWNLOAD_SHA256 2e4dd6c44f0693bef4e7b46cc701513d74c3cc44f2419bf519d7868b12931ac3
#RUN curl -fsSL "$GOLANG_DOWNLOAD_URL" -o golang.tar.gz \
#    && echo "$GOLANG_DOWNLOAD_SHA256  golang.tar.gz" | sha256sum -c - \
#    && tar -C /usr/local -xzf golang.tar.gz \
#    && rm golang.tar.gz
#
#ENV GOPATH /go
#ENV PATH $GOPATH/bin:/usr/local/go/bin:$PATH
#RUN mkdir -p "$GOPATH/src" "$GOPATH/bin" && chmod -R 777 "$GOPATH"



# https://boringssl.googlesource.com/boringssl/+/chromium-stable
#RUN git clone https://boringssl.googlesource.com/boringssl && \
#    cd boringssl && \
#    git reset --hard c7db3232c397aa3feb1d474d63a1c4dd674b6349 && \
#    sed -i s/" -Werror"//g CMakeLists.txt && \
#    mkdir -p build  && \
#    cd build  && \
#    cmake -DCMAKE_CXX_FLAGS="-lrt" ..  && \
#    make  && \
#    cd ..  && \
#    sudo mkdir -p /opt/boringssl  && \
#    sudo cp -R include /opt/boringssl/  && \
#    sudo mkdir -p /opt/boringssl/lib  && \
#    sudo cp build/ssl/libssl.a /opt/boringssl/lib/  && \
#    sudo cp build/crypto/libcrypto.a /opt/boringssl/lib/



# 8 March, 2019 1 commit 67807a17ce983a860804d7732aaf7d2fb56150ba
#RUN apt-get remove -y libnice-dev libnice10 && \
#    apt-get -y update && apt-get install -y  gtk-doc-tools libgnutls28-dev libglib2.0-0 && \
#    git clone https://gitlab.freedesktop.org/libnice/libnice.git && \
#    cd libnice && \
#    git checkout 67807a17ce983a860804d7732aaf7d2fb56150ba && \
#    bash autogen.sh && \
#    ./configure --prefix=/usr && \
#    make && \
#    make install

# tag v0.7.4 https://github.com/meetecho/janus-gateway/commit/5ff6907fc9cc6c64d8dc3342969abebad74cc964
RUN cd / && git clone https://github.com/q09029/janus-gateway.git && cd /janus-gateway && \
    sh autogen.sh &&  \
#    git checkout origin/master && git reset --hard 5ff6907fc9cc6c64d8dc3342969abebad74cc964 && \
    ./configure \
#    --enable-post-processing \
#    --enable-boringssl \
    --enable-data-channels \
#    --disable-rabbitmq \
#    --disable-mqtt \
#    --disable-unix-sockets \
#    --enable-dtls-settimeout \
#    --enable-plugin-echotest \
#    --enable-plugin-recordplay \
#    --enable-plugin-sip \
#    --enable-plugin-videocall \
#    --enable-plugin-voicemail \
#    --enable-plugin-textroom \
#    --enable-plugin-audiobridge \
#    --enable-plugin-nosip \
#    --enable-all-handlers && \
     --disable-websockets --disable-rabbitmq --disable-mqtt &&\
    make && make install && make configs && ldconfig

COPY nginx.conf /etc/nginx/nginx.conf

CMD nginx && janus
