#!/bin/bash

#start ssh agent
eval $(ssh-agent)

#add keys for github signing 
ssh-add /home/nizar/.ssh/csna-nizar-key
ssh-add /home/nizar/.ssh/id_rsa

#add keys for woopen bastion
# ls -la 
# .ssh -> /mnt/c/Users/nizarajroud/.ssh
# rm .ssh
# cd /tmp
# ssh-keygen
# # then copy the pub key to gitlab ou github 
# chmod 600 csna-nizar
# -rw------- 1 nizar nizar 2602 Apr 16 18:19 csna-nizar
# cp csna-nizar /mnt/c/Users/nizarajroud/.ssh 
# ln -s /mnt/c/Users/nizarajroud/.ssh ~/.ssh  
# # add the key to sgh 
#  wsl.exe --terminate Ubuntu-22.04




