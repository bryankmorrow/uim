This is the base Dockerfile for running a secondary hub.

You will need to copy the UIM Centos/RHEL RPM into the install directory of this repo before building the container.

You will need to pass the following variables during the run process:

* HUB\_NAME
* HUB\_PORT
* DOMAIN
* REMOTE\_HUB\_NAME
* REMOTE\_HUB\_IP
* REMOTE\_HUB\_ROBOT
* FIRST\_PORT
* CONTROLLER\_PORT
* SPOOLER\_PORT

Docker run example: 

**docker run -itd --name secondary-hub -e "DOMAIN=Test" -e "HUB\_NAME=secondary" -e "HUB\_PORT=48002" -e "REMOTE\_HUB\_NAME=primary" -e "REMOTE\_HUB\_IP=192.168.1.111" -e "REMOTE\_HUB\_ROBOT=primary-robot" -e "ROBOT\_NAME=secondary-robot" -e "FIRST\_PORT=48000" -e "SPOOLER\_PORT=48001" -e "CONTROLLER\_PORT=48000" hub:latest**
