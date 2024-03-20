#!/bin/bash

#start ssh agent
eval $(ssh-agent)

#add keys for github signing 
ssh-add /home/nizar/.ssh/id_ed25519-woop-git-sign
ssh-add /home/nizar/.ssh/id_rsa
ssh-add /home/nizar/.ssh/stevevk

#add keys for woopen bastion
 ssh-add ~/.ssh/id_rsa-wpbdev