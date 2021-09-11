# Code Server Update
[![Github Discussions](https://camo.githubusercontent.com/d226573a5a15024ca4fed6a7fc389f4bb310c2258050508ead1c34a0ac29b1be/68747470733a2f2f696d672e736869656c64732e696f2f62616467652f2532304769744875622d25323044697363757373696f6e732d677261792e7376673f6c6f6e6743616368653d74727565266c6f676f3d67697468756226636f6c6f72423d707572706c65)](https://github.com/cdr/code-server/discussions) [![join us](https://camo.githubusercontent.com/6f603da6663957ad0f2c3f81e1c1ea3eb1b3eb1161b04c297aa12615db92cc11/68747470733a2f2f696d672e736869656c64732e696f2f62616467652f6a6f696e2d75732532306f6e253230736c61636b2d677261792e7376673f6c6f6e6743616368653d74727565266c6f676f3d736c61636b26636f6c6f72423d627269676874677265656e)](https://cdr.co/join-community) [![twitter](https://camo.githubusercontent.com/0631514174426e6e816bb06b8aeef112b257054d909d9bc8dcc76e56c8b739b0/68747470733a2f2f696d672e736869656c64732e696f2f747769747465722f666f6c6c6f772f436f64657248513f6c6162656c3d253430436f6465724851267374796c653d736f6369616c)](https://twitter.com/coderhq) [![code-server](https://camo.githubusercontent.com/f90f789fb22cdcde8bfce02b86a0ef288d4bc390269afba4a5302dd89f88e759/68747470733a2f2f636f6465636f762e696f2f67682f6364722f636f64652d7365727665722f6272616e63682f6d61696e2f67726170682f62616467652e7376673f746f6b656e3d35694d396661726a6e43)](https://codecov.io/gh/cdr/code-server) [![docs](https://camo.githubusercontent.com/16395db790a2420b9cc8da37572f0c65203b58a4a735df752cfa724fc3939af3/68747470733a2f2f696d672e736869656c64732e696f2f7374617469632f76313f6c6162656c3d446f6373266d6573736167653d73656525323076332e31312e3125323026636f6c6f723d626c7565)](https://github.com/cdr/code-server/tree/v3.11.1/docs) [![Docker Automated Build](https://img.shields.io/docker/automated/xrsec/vscode?label=Build&logo=docker&style=flat-square)](https://hub.docker.com/r/xrsec/vscode) [![Docker Build File](https://img.shields.io/badge/Dockerfile-Github-da282a)](https://github.com/XRSec/Code-Server-Update)

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

