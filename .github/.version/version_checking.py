#!/usr/bin/env python
# _*_ coding: utf-8 _*_
import os, re, requests, sys
requests.get("https://api.github.com/repos/cdr/code-server/releases/latest").json()["tag_name"]
