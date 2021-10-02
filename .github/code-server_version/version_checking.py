#!/usr/bin/env python
# _*_ coding: utf-8 _*_
import os, re, requests, platform
code_server_version =  requests.get("https://api.github.com/repos/cdr/code-server/releases/latest").json()["tag_name"]
if code_server_version == open(".github/code-server_version/code-server_version").read():
    print("It's the latest edition! version: " + code_server_version)
    os._exit("It's the latest edition! version: ", code_server_version)
else:
    open(".github/code-server_version/code-server_version", "w").write(code_server_version)