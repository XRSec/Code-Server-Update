#!/bin/bash
clear
echo -e "\033[1;35m #*#*#*#*#*#*#*#*#*#*#*#*#*#*#*#* \n\033[0m"
# /usr/sbin/sshd -D &
# echo "start sshd succers"
echo -e "\n\033[1;34m __  __  ____                      \033[0m"
echo -e "\033[1;32m \ \/ / |  _ \   ___    ___    ___  \033[0m"
echo -e "\033[1;36m  \  /  | |_) | / __|  / _ \  / __| \033[0m"
echo -e "\033[1;31m  /  \  |  _ <  \__ \ |  __/ | (__  \033[0m"
echo -e "\033[1;35m /_/\_\ |_| \_\ |___/  \___|  \___| \n\033[0m"
echo -e "\033[1;32m start code-server succers \033[0m"
echo -e "\033[1;31m [help] \n\033[0m"
echo -e "\033[1;36m Your" "`/usr/bin/grep password /root/.config/code-server/config.yaml | grep -v "auth: password"` \033[0m"
echo -e "\033[1;35m php56-fpm & nginx  \n\n\n\033[0m"
/usr/bin/code-server >> /dev/null &
/bin/bash
