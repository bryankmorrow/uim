This is an example of running a UIM robot from a Centos7 image in docker.

The key things to watch are the ports you expose for each robot, they need to map to the docker host ports and the robotip_alias
needs to be set to the docker host IP in the nms-robot-vars.cfg.

docker build --rm=true -t mcs-robot1:1.00 .

docker run -itd --privileged -v /sys/fs/cgroup:/sys/fs/cgroup:ro -p 49000-49025:49000-49025 --name robotname mcs-robot1:1.00
