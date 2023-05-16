# syntax=docker/dockerfile:1.4

ARG PYTHON_VERSION

FROM bitnami/minideb:bullseye as python_build

SHELL ["/bin/bash", "-o", "pipefail", "-c"]
ARG PYTHON_VERSION
ARG TARGETARCH
ARG BUILDARCH

COPY --link prebuildfs/ /
RUN mkdir -p /opt/blacksmith-sandbox
RUN install_packages ca-certificates curl git wget build-essential libreadline-dev libncursesw5-dev libsqlite3-dev libssl-dev libc6-dev libbz2-dev libffi-dev liblzma-dev zlib1g-dev xz-utils

WORKDIR /bitnami/blacksmith-sandbox

ADD --link https://www.python.org/ftp/python/${PYTHON_VERSION}/Python-${PYTHON_VERSION}.tar.xz python.tar.xz
RUN <<EOT bash
    set -ex
    tar -Jxf python.tar.xz
    cd Python-${PYTHON_VERSION}
    OPTIM_FLAG="--enable-optimizations"
    if [ "$TARGETARCH" != "$BUILDARCH" ]; then
        OPTIM_FLAG=""
    fi

    ./configure --with-lto $OPTIM_FLAG --enable-shared --without-static-libpython --prefix=/opt/bitnami/python
EOT

RUN cd Python-${PYTHON_VERSION} && make -j$(nproc)
RUN cd Python-${PYTHON_VERSION} && make install
RUN find /opt/bitnami/python/lib/ -name libpython*.a -delete -print
RUN find /opt/bitnami/python/lib/ -name python.o -delete -print

ENV PATH=/opt/bitnami/python/bin:$PATH
ENV LD_LIBRARY_PATH=/opt/bitnami/python/lib/

RUN python3 -m pip install virtualenv setuptools
RUN find /opt/bitnami/ -name "*.so*" -type f | xargs strip --strip-debug
RUN find /opt/bitnami/ -executable -type f | xargs strip --strip-unneeded || true

ARG DIRS_TO_TRIM="/opt/bitnami/python/share \
"

RUN <<EOT bash
    for DIR in $DIRS_TO_TRIM; do
      find \$DIR/ -delete -print
    done
EOT

FROM bitnami/minideb:bullseye as stage-0

SHELL ["/bin/bash", "-o", "pipefail", "-c"]
ARG DIRS_TO_TRIM="/usr/share/man \
    /var/cache/apt \
    /var/log \
    /usr/share/info \
    /tmp \
"

COPY --from=python_build /opt/bitnami /opt/bitnami

RUN <<EOT bash
    set -e
    install_packages build-essential bzip2 ca-certificates curl git libreadline8 libsqlite3-dev libssl-dev make pkg-config procps readline-common unzip wget xz-utils
    ln -sv python3 /opt/bitnami/python/bin/python
    ln -sv pip3 /opt/bitnami/python/bin/pip

    for DIR in $DIRS_TO_TRIM; do
      find \$DIR/ -delete -print
    done

    mkdir -p /app
    mkdir -p /var/log/apt
    mkdir -p /tmp
    chmod 1777 /tmp
    sed -i 's/^PASS_MAX_DAYS.*/PASS_MAX_DAYS    90/' /etc/login.defs
    sed -i 's/^PASS_MIN_DAYS.*/PASS_MIN_DAYS    0/' /etc/login.defs
    sed -i 's/sha512/sha512 minlen=8/' /etc/pam.d/common-password
    find /usr/share/doc -mindepth 2 -not -name copyright -not -type d -delete
    find /usr/share/doc -mindepth 1 -type d -empty -delete
EOT

ARG PYTHON_VERSION
ARG TARGETARCH
ENV APP_VERSION=$PYTHON_VERSION \
    BITNAMI_APP_NAME=python \
    BITNAMI_IMAGE_VERSION="${PYTHON_VERSION}-prod-debian-11" \
    PATH="/opt/bitnami/python/bin:$PATH" \
    LD_LIBRARY_PATH=/opt/bitnami/python/lib/ \
    OS_ARCH=$TARGETARCH \
    OS_FLAVOUR="debian-11" \
    OS_NAME="linux"

EXPOSE 8000
WORKDIR /app

CMD [ "python" ]

