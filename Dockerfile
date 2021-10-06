FROM xrsec/code-server:init
LABEL maintainer="xrsec"
LABEL mail="troy@zygd.site"
ARG TARGETPLATFORM

# INIT
RUN curl -fsSL https://code-server.dev/install.sh | sh

# PATH
RUN mkdir -p /root/.config/code-server \
    && echo "bind-addr: 0.0.0.0:8765" > /root/.config/code-server/config.yaml \
    && echo "auth: password" >> /root/.config/code-server/config.yaml \
    && echo "password: `openssl rand -base64 12`" >> /root/.config/code-server/config.yaml \
    && echo "cert: false" >> /root/.config/code-server/config.yaml \
    && sed -i "s/false/true/g" /root/.config/code-server/config.yaml \
    && mkdir -p /root/.local/share/code-server/ \
    && cp /www/bak/ssl_cert/vscode.crt /root/.local/share/code-server/localhost.crt \
    && cp /www/bak/ssl_cert/vscode.key /root/.local/share/code-server/localhost.key

ENTRYPOINT ["/vscode.sh"]

EXPOSE 22 5050 5051 8765 31000 31001 31002 31003

ENV TZ='Asia/Shanghai'
ENV LANG 'zh_CN.UTF-8'

STOPSIGNAL SIGQUIT

CMD ["/vscode.sh"]
