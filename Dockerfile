ARG RESTY_IMAGE
ARG RESTY_IMAGE_VERSION

FROM ${RESTY_IMAGE}:${RESTY_IMAGE_VERSION}

LABEL maintainer="Italo Maia <italo.maia@gmail.com>"

RUN echo "Installing rocks dependencies" \
  && apk add --no-cache --update \
    openssl \
    openssl-dev \
  && echo "Installing rocks" \
  && USER=root luarocks install moonscript \
  && USER=root luarocks install luaossl \
  && USER=root luarocks install lapis
