FROM alpine:3.8

LABEL maintainer="Italo Maia <italo.maia@gmail.com>"

ARG LUAROCKS_VERSION="3.0.4"

ARG RESTY_PREFIX="/usr/local/openresty"
ARG RESTY_J="1"
ARG RESTY_VERSION="1.13.6.2"
ARG RESTY_PCRE_VERSION="8.42"
ARG RESTY_OPENSSL_VERSION="1.0.2p"
ARG RESTY_CONFIG_OPTIONS="\
  --prefix=${RESTY_PREFIX} \
  --with-luajit \
  --with-file-aio \
  --with-http_addition_module \
  --with-http_auth_request_module \
  --with-http_dav_module \
  --with-http_flv_module \
  --with-http_geoip_module=dynamic \
  --with-http_gunzip_module \
  --with-http_gzip_static_module \
  --with-http_image_filter_module=dynamic \
  --with-http_mp4_module \
  --with-http_random_index_module \
  --with-http_realip_module \
  --with-http_secure_link_module \
  --with-http_slice_module \
  --with-http_ssl_module \
  --with-http_stub_status_module \
  --with-http_sub_module \
  --with-http_v2_module \
  --with-http_xslt_module=dynamic \
  --with-ipv6 \
  --with-mail \
  --with-mail_ssl_module \
  --with-md5-asm \
  --with-pcre-jit \
  --with-sha1-asm \
  --with-stream \
  --with-stream_ssl_module \
  --with-threads\
  --without-http_ssi_module\
  --without-http_userid_module\
  --without-http_uwsgi_module\
  --without-http_scgi_module"

# use this to add more options
ARG RESTY_CONFIG_OPTIONS_MORE=""

# These are not intended to be user-specified
ARG _RESTY_CONFIG_DEPS="--with-openssl=/tmp/openssl-${RESTY_OPENSSL_VERSION} --with-pcre=/tmp/pcre-${RESTY_PCRE_VERSION}"

LABEL resty_version="${RESTY_VERSION}"
LABEL resty_openssl_version="${RESTY_OPENSSL_VERSION}"
LABEL resty_pcre_version="${RESTY_PCRE_VERSION}"
LABEL resty_config_options="${RESTY_CONFIG_OPTIONS}"
LABEL resty_config_options_more="${RESTY_CONFIG_OPTIONS_MORE}"
LABEL luarocks_version="${LUAROCKS_VERSION}"

ENV USR nonroot
ENV HME /home/${USR}
ENV PROJECT_DIR ${HME}/code
ENV PATH ${PATH}:${RESTY_PREFIX}/nginx/sbin:${RESTY_PREFIX}/bin

RUN apk update \
  && apk add --no-cache --update --virtual .build-deps shadow \
  && groupadd -g 1000 -r $USR \
  && useradd -u 1000 -g 1000 -d $HME -m -r $USR \
  && apk del .build-deps

RUN apk update \
  && apk add --no-cache --update \
    mdocml-apropos \
    fish \
    gd \
    geoip \
    libgcc \
    libxslt \
    zlib

# install openresty
RUN apk update\
  && apk add --no-cache --virtual .build-deps \
    build-base \
    curl \
    gd-dev \
    geoip-dev \
    libxslt-dev \
    linux-headers \
    make \
    perl-dev \
    readline-dev \
    zlib-dev \
  && cd /tmp \
  && curl -fSL https://www.openssl.org/source/openssl-${RESTY_OPENSSL_VERSION}.tar.gz | tar -xvz \
  && curl -fSL https://ftp.pcre.org/pub/pcre/pcre-${RESTY_PCRE_VERSION}.tar.gz | tar -xvz \
  && curl -fSL https://openresty.org/download/openresty-${RESTY_VERSION}.tar.gz | tar -xvz \
  && cd /tmp/openresty-${RESTY_VERSION} \
  && ./configure -j${RESTY_J} ${_RESTY_CONFIG_DEPS} ${RESTY_CONFIG_OPTIONS} ${RESTY_CONFIG_OPTIONS_MORE} \
  && make -j${RESTY_J} \
  && make -j${RESTY_J} install \
  && ln -sf /dev/stdout /usr/local/openresty/nginx/logs/access.log \
  && ln -sf /dev/stderr /usr/local/openresty/nginx/logs/error.log \
  && ln -sf ${RESTY_PREFIX}/luajit/bin/luajit-* ${RESTY_PREFIX}/luajit/bin/lua \
  && ln -sf ${RESTY_PREFIX}/luajit/bin/luajit-* /usr/local/bin/lua \
  && apk del .build-deps \
  && rm -rf /tmp/*

# install luarocks
RUN apk update \
  && apk add --no-cache --virtual .build-deps \
    make \
    gcc \
    musl-dev \
    pcre-dev \
    openssl-dev \
    zlib-dev \
    ncurses-dev \
    readline-dev \
    curl \
  && cd /tmp \
  && curl -fSL http://luarocks.github.io/luarocks/releases/luarocks-${LUAROCKS_VERSION}.tar.gz | tar -xvz \
  && cd /tmp/luarocks-${LUAROCKS_VERSION} \
  && ./configure --with-lua=${RESTY_PREFIX}/luajit \
  && make build \
  && make install \
  && apk del .build-deps \
  && rm -rf /tmp/*

# Copy nginx configuration files
# COPY nginx.conf /usr/local/openresty/nginx/conf/nginx.conf
# COPY nginx.vh.default.conf /etc/nginx/conf.d/default.conf

RUN luarocks install \
  moonscript \
  lapis

USER $USR
RUN mkdir -p $PROJECT_DIR
WORKDIR $PROJECT_DIR

# RUN eval $(luarocks path)

# CMD ["/usr/local/openresty/bin/openresty", "-g", "daemon off;"]
