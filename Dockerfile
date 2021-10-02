FROM centos:latest
LABEL maintainer="xrsec"
LABEL mail="troy@zygd.site"

# 初始化文件夹
RUN mkdir /www /www/server /www/wwwroot /www/env /www/bak /www/server/php74 /www/server/php56 /www/wwwroot/myapp \
    && yum update -y \
    && yum install -y nodejs wget zsh vim make cmake gcc gcc-c++ libxml2 libxml2-devel git \
    zip unzip sqlite-devel m4 autoconf nginx tree ncurses \
    krb5-devel openssl openssl-devel curl curl-devel libjpeg \
    libjpeg-devel libpng libpng-devel freetype freetype-devel \
    pcre pcre-devel libxslt libxslt-devel bzip2 bzip2-devel \
    openssh-server iputils net-tools oniguruma sudo go nss -y \
    && yum upgrade \
    && ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && echo $TZ > /etc/timezone


# Download the ZSH configuration
RUN sh -c "$(curl -fsSL https://raw.github.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" \
    && git clone https://github.com/zsh-users/zsh-autosuggestions ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-autosuggestions \
    && git clone https://github.com/zsh-users/zsh-syntax-highlighting.git ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-syntax-highlighting \
    && sed -i "s/plugins=(git)/plugins=(git zsh-syntax-highlighting zsh-autosuggestions)/g" /root/.zshrc


# Download middleware https://github.com/cdr/code-server/
RUN wget -O /www/bak/code-server.rpm https://github.com/cdr/code-server/releases/download/v3.12.0/code-server-3.12.0-machine.rpm --no-cookie --no-check-certificate \
    && wget -O /www/bak/php74.tar.gz https://www.php.net/distributions/php-7.4.16.tar.gz --no-cookie --no-check-certificate \
    && wget -O /www/bak/php56.tar.gz https://www.php.net/distributions/php-5.6.40.tar.gz --no-cookie --no-check-certificate \
    && wget -O /www/bak/oniguruma.tar.gz https://github.com/kkos/oniguruma/releases/download/v6.9.7.1/onig-6.9.7.1.tar.gz --no-cookie --no-check-certificate \
    && wget -O /www/bak/xdebug-2.5.5.tar https://pecl.php.net/get/xdebug-2.5.5.tgz --no-cookie --no-check-certificate \
    && wget -O /www/bak/xdebug-3.0.2.tar https://pecl.php.net/get/xdebug-3.0.2.tar --no-cookie --no-check-certificate


# copy file
COPY . /www/bak
COPY vscode.sh /vscode.sh

RUN chmod 777 /vscode.sh \
    # Unzip the files
    && tar -xzvf /www/bak/php74.tar.gz -C /www/bak \
    && tar -xzvf /www/bak/php56.tar.gz -C /www/bak \
    && tar -zxvf /www/bak/oniguruma.tar.gz -C /www/bak \
    && rpm -ivh /www/bak/code-server.rpm


# Compile and install Oniguruma
RUN cd /www/bak/onig-6.9.7 \
    && ./configure --prefix=/usr \
    && make && make install


# Compile and install PHP74
RUN cd /www/bak/php-7.4.16 \
    && ./configure --prefix=/www/server/php74 --with-curl \
    --with-gettext --with-iconv-dir --with-kerberos --with-libdir=lib64 \
    --with-mysqli --with-openssl --with-pdo-mysql --with-pdo-sqlite --with-pear \
    --with-xmlrpc --with-xsl --with-zlib --with-bz2 --with-mhash \
    --enable-fpm --enable-bcmath --enable-inline-optimization \
    --enable-mbregex --enable-mbstring --enable-opcache --enable-pcntl --enable-shmop --enable-soap \
    --enable-sockets --enable-sysvsem --enable-sysvshm --enable-xml \
    && make && make install \
    && /www/bak/php-7.4.16/build/shtool install -c ext/phar/phar.phar /www/server/php74/bin/phar.phar \
    && ln -s -f phar.phar /www/server/php74/bin/phar \
    && /www/server/php74/bin/pecl install /www/bak/xdebug-3.0.2.tar


# PHP74 configuration files
RUN cp /www/bak/php-7.4.16/php.ini-development /www/server/php74/lib/php.ini \
    && echo "zend_extension=/www/server/php74/lib/php/extensions/no-debug-non-zts-20190902/xdebug.so" >> /www/server/php74/lib/php.ini \
    && echo "xdebug.mode = debug" >>/www/server/php74/lib/php.ini \
    && echo "debug.remote_handler = dbgp" >>/www/server/php74/lib/php.ini \
    && echo "xdebug.client_host = docker.for.mac.localhost" >>/www/server/php74/lib/php.ini \
    && echo "xdebug.start_with_request = yes" >>/www/server/php74/lib/php.ini \
    && echo "xdebug.client_port = 9003" >>/www/server/php74/lib/php.ini \
    && echo "xdebug.idekey = \"PHPSTORM\"" >>/www/server/php74/lib/php.ini \
    && ln -s /www/server/php74/bin/php /www/env/php74 \
    && ln -s /www/server/php74/sbin/php-fpm /www/env/php74-fpm \
    && ln -s /www/server/php74/bin/pecl /www/env/php74-pecl \
    && ln -s /www/server/php74/bin/pear /www/env/php74-pear \
    && cp /www/server/php74/etc/php-fpm.conf.default /www/server/php74/etc/php-fpm.conf \
    && cp /www/server/php74/etc/php-fpm.d/www.conf.default /www/server/php74/etc/php-fpm.d/www.conf \
    && sed -i "s/group = nobody/group = nginx/g" /www/server/php74/etc/php-fpm.d/www.conf \
    && sed -i "s/user = nobody/user = nginx/g" /www/server/php74/etc/php-fpm.d/www.conf


# Compile and install PHP56
RUN cd /www/bak/php-5.6.40 \
    && ./configure --prefix=/www/server/php56 --with-curl \
    --with-gettext --with-iconv-dir --with-kerberos --with-libdir=lib64 \
    --with-mysqli --with-pdo-mysql --with-pdo-sqlite --with-pear \
    --with-xmlrpc --with-xsl --with-zlib --with-bz2 --with-mhash \
    --enable-fpm --enable-bcmath --enable-inline-optimization \
    --enable-mbregex --enable-mbstring --enable-opcache --enable-pcntl --enable-shmop --enable-soap \
    --enable-sockets --enable-sysvsem --enable-sysvshm --enable-xml \
    && make && make install \
    && /www/bak/php-5.6.40/build/shtool install -c ext/phar/phar.phar /www/server/php56/bin \
    && ln -s -f phar.phar /www/server/php56/bin/phar \
    && /www/server/php56/bin/pecl install /www/bak/xdebug-2.5.5.tar

# PHP56 configuration files
RUN cp /www/bak/php-5.6.40/php.ini-development /www/server/php56/lib/php.ini \
    && echo "zend_extension=/www/server/php56/lib/php/extensions/no-debug-non-zts-20131226/xdebug.so" >> /www/server/php56/lib/php.ini \
    && echo "xdebug.remote_enable = on" >>/www/server/php56/lib/php.ini \
    && echo "xdebug.remote_host = docker.for.mac.localhost" >>/www/server/php56/lib/php.ini \
    && echo "xdebug.remote_port = 9003" >>/www/server/php56/lib/php.ini \
    && echo 'xdebug.idekey="PHPSTORM"' >>/www/server/php56/lib/php.ini \
    && echo "xdebug.remote_autostart = 1" >>/www/server/php56/lib/php.ini \
    && echo "xdebug.remote_connect_back = 1" >>/www/server/php56/lib/php.ini \
    && echo "xdebug.remote_handler = \"dbgp\"" >>/www/server/php56/lib/php.ini \
    && ln -s /www/server/php56/sbin/php-fpm /www/env/php56-fpm \
    && ln -s /www/server/php56/bin/php /www/env/php56 \
    && ln -s /www/server/php56/bin/pecl /www/env/php56-pecl \
    && ln -s /www/server/php56/bin/pear /www/env/php56-pear \
    && cp /www/server/php56/etc/php-fpm.conf.default /www/server/php56/etc/php-fpm.conf \
    && sed -i "s/group = nobody/group = nginx/g" /www/server/php56/etc/php-fpm.conf \
    && sed -i "s/user = nobody/user = nginx/g" /www/server/php56/etc/php-fpm.conf


# NGINX https://www.digitalocean.com/
RUN echo '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' | base64 --decode | tee /www/bak/nginxconfig.io-localhost.tar.gz > /dev/null \
    && tar -xzvf /www/bak/nginxconfig.io-localhost.tar.gz -C /etc/nginx \
    && sed -i "s/443/31003/g" /etc/nginx/sites-available/localhost.conf \
    && sed -i "s:unix\:/var/run/php/php-fpm.sock:127.0.0.1\:9000:g" /etc/nginx/sites-available/localhost.conf \
    && openssl dhparam -out /etc/nginx/dhparam.pem 2048 \
    && sed -i "s/ssl_stapling           on/ssl_stapling           off/g" /etc/nginx/nginx.conf \
    && sed -i "s/ssl_stapling_verify    on/ssl_stapling_verify           off/g" /etc/nginx/nginx.conf \
    && sed -i "s/keepalive_timeout  65/keepalive_timeout  300/g" /etc/nginx/nginx.conf.default


# PATH
RUN echo "export vscode=\"/www/env\"" >> /etc/profile \
    && echo "export PATH=\$PATH:\$vscode" >> /etc/profile \
    && echo "export vscode=\"/www/env\"" >> /root/.zshrc \
    && echo "export PATH=\$PATH:\$vscode" >> /root/.zshrc \
    && sed -i "s/#PubkeyAuthentication yes/PubkeyAuthentication yes/g" /etc/ssh/sshd_config \
    && sed -i "s/PasswordAuthentication yes/PasswordAuthentication no/g" /etc/ssh/sshd_config \
    && echo "AllowUsers root" >> /etc/ssh/sshd_config \
    && mkdir -p /root/.config/code-server \
    && echo "bind-addr: 0.0.0.0:8765" > /root/.config/code-server/config.yaml \
    && echo "auth: password" >> /root/.config/code-server/config.yaml \
    && echo "password: `openssl rand -base64 12`" >> /root/.config/code-server/config.yaml \
    && echo "cert: false" >> /root/.config/code-server/config.yaml \
    && ln -s /etc/nginx/sites-available/localhost.conf /www/server/localhost.conf \
    && ln -s /etc/profile /www/server/profile \
    && echo -e '<?php phpinfo(); ?>' > /www/wwwroot/myapp/index.php \
    && echo "source /etc/profile" >> /root/.bashrc


# Certificate of the module https://github.com/milkfr/certs
RUN git clone https://github.com/milkfr/certs.git /www/bak/ssl_cert \
    && sed -i "s/zhejiang/Sichuan/g" /www/bak/ssl_cert/openssl.cnf \
    && sed -i "s/hangzhou/ChengDu/g" /www/bak/ssl_cert/openssl.cnf \
    && sed -i "s/Organization Name (eg, company)/vscode/g" /www/bak/ssl_cert/openssl.cnf \
    && sed -i "s/milkfr/vscode/g" /www/bak/ssl_cert/openssl.cnf \
    && sed -i "s/291509722@qq.com/vscode@localhost.com/g" /www/bak/ssl_cert/openssl.cnf \
    && sed -i "s/Email Address/vscode@localhost.com/g" /www/bak/ssl_cert/openssl.cnf \
    && sed -i "s/Common Name (e.g. server FQDN or YOUR name)/vscode/g" /www/bak/ssl_cert/openssl.cnf \
    && sed -i "s/vscode.github.io/vscode/g" /www/bak/ssl_cert/openssl.cnf \
    && sed -i "s/Organizational Unit Name (eg, section)/vscode/g" /www/bak/ssl_cert/openssl.cnf \
    && sed -i "s/Locality Name (eg, city)/ChengDu/g" /www/bak/ssl_cert/openssl.cnf \
    && sed -i "s/State or Province Name (full name)/Sichuan/g" /www/bak/ssl_cert/openssl.cnf \
    && sed -i "s/Country Name (2 letter code)/CN/g" /www/bak/ssl_cert/openssl.cnf \
    && sed -i "s/1/KzAYsECwt6gdLCzN7xEcnoaHXb4dtp/g" /www/bak/ssl_cert/openssl-gen.sh \
    && sed -i "s:-out ca.pem:-out ca.pem -subj \"/C=CN/ST=Sichuan/L=ChengDu/O=vscode/OU=vscode/CN=vscode/emailAddress=vscode@localhost.com\":g" /www/bak/ssl_cert/openssl-gen.sh \
    && sed -i "s: ca.: \${0/openssl-gen.sh}ca.:g" /www/bak/ssl_cert/openssl-gen.sh \
    && sed -i "s:openssl.cnf:\${0/openssl-gen.sh}openssl.cnf:g" /www/bak/ssl_cert/openssl-gen.sh \
    && sh /www/bak/ssl_cert/openssl-gen.sh \
    && sed -i "s/milkfr/vscode/g" /www/bak/ssl_cert/main.go \
    && sed -i "s/vscode.github.io/localhost/g" /www/bak/ssl_cert/main.go \
    && cd /www/bak/ssl_cert \
    && go run main.go -hostname localhost \
    && mv /www/bak/ssl_cert/ca.crt /www/bak/ssl_cert/vscode.crt \
    && mv /www/bak/ssl_cert/ca.key /www/bak/ssl_cert/vscode.key \
    && sed -i "s/false/true/g" /root/.config/code-server/config.yaml \
    && mkdir -p /root/.local/share/code-server/ \
    && cp /www/bak/ssl_cert/vscode.crt /root/.local/share/code-server/localhost.crt \
    && cp /www/bak/ssl_cert/vscode.key /root/.local/share/code-server/localhost.key


# configuration code-server
RUN cp /www/bak/resources/favicon.svg /usr/lib/code-server/src/browser/media/favicon-dark-support.svg \
    && cp /www/bak/resources/favicon.ico /usr/lib/code-server/src/browser/media/favicon.ico \
    && cp /www/bak/resources/favicon.svg /usr/lib/code-server/src/browser/media/favicon.svg \
    && cp /www/bak/resources/favicon.png /usr/lib/code-server/src/browser/media/pwa-icon-192.png \
    && cp /www/bak/resources/favicon.png /usr/lib/code-server/src/browser/media/pwa-icon-512.png \
    && cp /www/bak/resources/favicon.png /usr/lib/code-server/src/browser/media/pwa-icon.png \
    && sed -i "s/code-server/Visual Studio Code/g" /usr/lib/code-server/src/browser/media/manifest.json \
    && sed -i "s/Run editors on a remote server./Copyright (C) 2021 Microsoft. All rights reserved/g" /usr/lib/code-server/src/browser/media/manifest.json


ENTRYPOINT ["/vscode.sh"]

EXPOSE 22 5050 5051 8765 31000 31001 31002 31003

ENV TZ='Asia/Shanghai'
ENV LANG 'zh_CN.UTF-8'

STOPSIGNAL SIGQUIT

CMD ["/vscode.sh"]
