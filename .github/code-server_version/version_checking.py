#!/usr/bin/env python
# _*_ coding: utf-8 _*_
import os, re, requests, sys
print(requests.get("https://api.github.com/repos/cdr/code-server/releases/latest").json()["tag_name"])
# https://raw.githubusercontent.com/XRSec/Code-Server-Update/main/.github/code-server_version/code-server_version