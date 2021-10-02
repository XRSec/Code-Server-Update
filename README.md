# Code Server Update
[!["GitHub Discussions"](https://img.shields.io/badge/%20GitHub-%20Discussions-gray.svg?longCache=true&logo=github&colorB=purple)](https://github.com/cdr/code-server/discussions) [!["Join us on Slack"](https://img.shields.io/badge/join-us%20on%20slack-gray.svg?longCache=true&logo=slack&colorB=brightgreen)](https://cdr.co/join-community) [![Twitter Follow](https://img.shields.io/twitter/follow/CoderHQ?label=%40CoderHQ&style=social)](https://twitter.com/coderhq) [![codecov](https://codecov.io/gh/cdr/code-server/branch/main/graph/badge.svg?token=5iM9farjnC)](https://codecov.io/gh/cdr/code-server) [![See v3.11.1 docs](https://img.shields.io/static/v1?label=Docs&message=see%20v3.11.1%20&color=blue)](https://github.com/cdr/code-server/tree/v3.11.1/docs) [![Docker Automated Build](https://img.shields.io/docker/automated/xrsec/vscode?label=Build&logo=docker&style=flat-square)](https://hub.docker.com/r/xrsec/vscode) [![Code Server Update](https://github.com/XRSec/Code-Server-Update/actions/workflows/docker-publish.yml/badge.svg?branch=main)](https://github.com/XRSec/Code-Server-Update/actions/workflows/docker-publish.yml)

Run [VS Code](https://github.com/Microsoft/vscode) on any machine anywhere and access it in the browser.

## Highlights

- Code on any device with a consistent development environment
- Use cloud servers to speed up tests, compilations, downloads, and more
- Preserve battery life when you're on the go; all intensive tasks run on your server

## Requirements

See [requirements](https://github.com/cdr/code-server/blob/v3.11.1/docs/requirements.md) for minimum specs, as well as instructions on how to set up a Google VM on which you can install code-server.

**TL;DR:** Linux machine with WebSockets enabled, 1 GB RAM, and 2 CPUs


## Preview

![screenshot.png](https://cdn.jsdelivr.net/gh/cdr/code-server@master/docs/assets/screenshot.png)

![image-20210414055205574](https://rmt.ladydaily.com/fetch/ZYGG/storage/20210429025318419611.png?w=1280&fmt=jpg)

![image-20210414055235174](https://rmt.ladydaily.com/fetch/ZYGG/storage/20210429025328484604.png?w=1280&fmt=jpg)

![image-20210414055414719](https://rmt.ladydaily.com/fetch/ZYGG/storage/20210429025337591529.png?w=1280&fmt=jpg)

Open the folder where you want XDebug

![image-20210414055539161](https://rmt.ladydaily.com/fetch/ZYGG/storage/20210429025400286705.png?w=1280&fmt=jpg)

![image-20210414055812313](https://rmt.ladydaily.com/fetch/ZYGG/storage/20210429025411261774.png?w=1280&fmt=jpg)

![image-20210414061136419](https://rmt.ladydaily.com/fetch/ZYGG/storage/20210429025430379273.png?w=1280&fmt=jpg)

![image-20210414061302145](https://rmt.ladydaily.com/fetch/ZYGG/storage/20210429025437679754.png?w=1280&fmt=jpg)

![image-20210414061343415](https://rmt.ladydaily.com/fetch/ZYGG/storage/20210429025447226680.png?w=1280&fmt=jpg)

## Getting started

```bash
docker run -it -d \
	--name vscode \
	-p 31004:22 \
	-p 5050-5051:5050-5051 \
	-p 8765:8765 \
	-p 31000-31003:31000-31003 \
	xrsec/vscode:latest

# If you need auto start, please revamp

docker run -it -d \
	--name vscode \
	--restart=always \
	-p 31004:22 \
	-p 5050-5051:5050-5051 \
	-p 8765:8765 \
	-p 31000-31003:31000-31003 \
	xrsec/vscode:latest

# Docker
# 5050-5051:5050 	: vscode live server
# 8765:8765	:https web port
# 31004：22	：ssh
# 31000-31003	：liveserver & more
# -v "/home/admin/Document/code:/www/wwwroot" ：Site path

# SSL && PassWord
# Password [$ docker logs vscode]
# ca.pem [$ docker cp vscode:/www/bak/ssl_cert/ca.pem .] or vist https://localhost:8765/?folder=/www/bak/ssl_cert to download ca.pem
# Exporting certificates first, then trusting, facilitates PWA technology implementation
# Edit Password
# vist https://localhost:8765/?folder=/root/.config/code-server/ & edit config.yaml then [$ docker restart vscode ]

# PHP
# $ pkill php && php56 && nginx
# $ pkill php && php74 && nginx
```

You can also take a [look at this article see](https://blog.zygd.site/Online%20Config%20VS%20Code.html)

## About

- Xdebug mode supporting `php7` and` PHP5`
- Convenient and fast, of course, it also comes with PHP environment and
- Based on docker container, without any manual operation, the source code can be viewed
- With the `code plug-in library`,  it is a sharp tool for `code audit`


> XRSec has the right to modify and interpret this article. If you want to reprint or disseminate this article, you must ensure the integrity of this article, including all contents such as copyright notice. Without the permission of the author, the content of this article shall not be modified or increased or decreased arbitrarily, and it shall not be used for commercial purposes in any way
