#!/usr/bin/env python
# _*_ coding: utf-8 _*_
import os, re, requests, sys
code_server_version =  requests.get("https://api.github.com/repos/cdr/code-server/releases/latest").json()["tag_name"]
if code_server_version == open(".github/code-server_version/code-server_version").read():
    print("sure")
else:
    print(open(".github/code-server_version/code-server_version").read())
# https://raw.githubusercontent.com/XRSec/Code-Server-Update/main/.github/code-server_version/code-server_version