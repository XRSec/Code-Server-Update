#!/usr/bin/env python
# _*_ coding: utf-8 _*_
import os, re, requests, sys
code_server_version =  requests.get("https://api.github.com/repos/cdr/code-server/releases/latest").json()["tag_name"]
# if code_server_version == open("code-server_version").read():
#     print("sure")
# else:
#     print(open("code-server_version").read())

for path,dir_list,file_list in os.walk("./"):
    for file_name in file_list:
        print(os.path.join(path, file_name))
print(os.getcwd())
# https://raw.githubusercontent.com/XRSec/Code-Server-Update/main/.github/code-server_version/code-server_version