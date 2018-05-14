FROM centos:7

LABEL maintainer="matr1xc0in"

USER root

ARG ETH_USER
ARG ETH_UID
ARG ETH_GID

# Configurating all necessary stuff
ENV SHELL=/bin/bash \
    ETH_USER=$ETH_USER \
    ETH_UID=$ETH_UID \
    ETH_GID=$ETH_GID \
    CONDA_DIR=/opt/conda \
    SHELL=/bin/bash \
    LC_ALL=en_US.UTF-8 \
    LANG=en_US.UTF-8 \
    LANGUAGE=en_US.UTF-8

ENV PATH=$CONDA_DIR/bin:$PATH \
    HOME=/home/$ETH_USER

COPY update-permission /usr/local/bin/update-permission

# Setup conda for all python stuff
# Setup nodejs
RUN groupadd -g $ETH_GID $ETH_USER && \
    useradd -u $ETH_UID -g $ETH_GID -d $HOME -ms /bin/bash $ETH_USER && \
    chmod g+w /etc/passwd /etc/group ; \
    mkdir -p $CONDA_DIR ; \
    chown -R $ETH_USER:$ETH_GID $CONDA_DIR ; \    
    chown -R $ETH_USER:$ETH_GID $HOME ; \    
    update-permission $HOME && \
    update-permission $CONDA_DIR ; \
    curl --silent --location https://rpm.nodesource.com/setup_9.x | bash -

# Pre-install all required pkgs
RUN yum clean all && rpm --rebuilddb && \
    yum update -y && \
    yum install -y \
      git \
      bzip2 \
      unzip \
      make \
      gcc \
      gcc-c++ \
      python-setuptools \
      nodejs \
      gd-devel GeoIP-devel gperftools-devel libxslt-devel pcre-devel perl-ExtUtils-Embed redhat-rpm-config zlib-devel \
      && yum clean all && rm -rf /var/cache/yum ; \
      npm install -g pm2

# Build nginx
RUN cd tmp ; mkdir github ; cd github ; \
    git clone -b OpenSSL_1_0_2-stable --depth 0 git://git.openssl.org/openssl.git ; \
    git clone -b stable-1.14-linux --depth 0 https://github.com/matr1xc0in/nginx.git ; \
    cd nginx ; \
    ./auto/configure --prefix=/usr/share/nginx \
    --sbin-path=/usr/sbin/nginx \
    --modules-path=/usr/lib64/nginx/modules \
    --conf-path=/etc/nginx/nginx.conf \
    --error-log-path=/var/log/nginx/error.log \
    --http-log-path=/var/log/nginx/access.log \
    --http-client-body-temp-path=/var/lib/nginx/tmp/client_body \
    --http-proxy-temp-path=/var/lib/nginx/tmp/proxy \
    --http-fastcgi-temp-path=/var/lib/nginx/tmp/fastcgi \
    --http-uwsgi-temp-path=/var/lib/nginx/tmp/uwsgi \
    --http-scgi-temp-path=/var/lib/nginx/tmp/scgi \
    --pid-path=/run/nginx.pid \
    --lock-path=/run/lock/subsys/nginx \
    --user=nginx --group=nginx \
    --with-file-aio \
    --with-http_ssl_module \
    --with-http_v2_module \
    --with-http_realip_module \
    --with-http_addition_module \
    --with-http_xslt_module=dynamic \
    --with-http_image_filter_module=dynamic \
    --with-http_geoip_module=dynamic \
    --with-http_sub_module \
    --with-http_dav_module \
    --with-http_flv_module \
    --with-http_mp4_module \
    --with-http_gunzip_module \
    --with-http_gzip_static_module \
    --with-http_random_index_module \
    --with-http_secure_link_module \
    --with-http_degradation_module \
    --with-http_slice_module \
    --with-http_stub_status_module \
    --with-http_perl_module=dynamic \
    --with-openssl=$(pwd)/../openssl \
    --with-openssl-opt='-shared' \
    --with-mail=dynamic \
    --with-mail_ssl_module \
    --with-pcre \
    --with-pcre-jit \
    --with-stream=dynamic \
    --with-stream_ssl_module \
    --with-google_perftools_module \
    --with-debug \
    --with-cc-opt='-O2 -g -pipe -Wall -Wp,-D_FORTIFY_SOURCE=2 -fexceptions -fstack-protector-strong --param=ssp-buffer-size=4 -grecord-gcc-switches -specs=/usr/lib/rpm/redhat/redhat-hardened-cc1 -m64 -mtune=generic' \
    --with-ld-opt='-Wl,-z,relro -specs=/usr/lib/rpm/redhat/redhat-hardened-ld -Wl,-E' && \
    make && make install

WORKDIR $HOME

# Install conda
ENV MINICONDA_VER 4.5.1
RUN cd /tmp && \
    curl -s --output Miniconda3-${MINICONDA_VER}-Linux-x86_64.sh https://repo.continuum.io/miniconda/Miniconda3-${MINICONDA_VER}-Linux-x86_64.sh && \
    echo "0c28787e3126238df24c5d4858bd0744 *Miniconda3-${MINICONDA_VER}-Linux-x86_64.sh" | md5sum -c - && \
    /bin/bash Miniconda3-${MINICONDA_VER}-Linux-x86_64.sh -b -f -p $CONDA_DIR && \
    rm Miniconda3-${MINICONDA_VER}-Linux-x86_64.sh && \
    $CONDA_DIR/bin/conda config --system --set auto_update_conda false && \
    $CONDA_DIR/bin/conda config --system --prepend channels conda-forge && \
    $CONDA_DIR/bin/conda config --system --set show_channel_urls true && \
    $CONDA_DIR/bin/conda update --all --quiet --yes && \
    conda clean -tipsy && \
    update-permission $CONDA_DIR && \
    update-permission /home/$ETH_USER

# Installing telegram bot
# RUN cd /home/$ETH_USER; git clone --depth 0 https://github.com/python-telegram-bot/python-telegram-bot --recursive && \
ADD ./python-telegram-bot.tar.gz /home/$ETH_USER/

RUN cd /home/$ETH_USER/python-telegram-bot ; python setup.py install ; \
    chown -R $ETH_USER:$ETH_GID $CONDA_DIR ; \
    chown -R $ETH_USER:$ETH_GID $HOME ; \
    update-permission $HOME && \
    update-permission $CONDA_DIR

USER $ETH_UID
