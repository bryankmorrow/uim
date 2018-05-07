#!/bin/bash

cd /opt

if [ ! -f "/opt/nimsoft/hub/hub" ];then
  echo 'Modifying variables'
  sed -i 's:$HUB_NAME:'"$HUB_NAME"':g' hub.cfg
  sed -i 's:$HUB_PORT:'"$HUB_PORT"':g' hub.cfg
  sed -i 's:$DOMAIN:'"$DOMAIN"':g' hub.cfg
  sed -i 's:$REMOTE_HUB_NAME:'"$REMOTE_HUB_NAME"':g' hub.cfg
  sed -i 's:$REMOTE_HUB_IP:'"$REMOTE_HUB_IP"':g' hub.cfg
  sed -i 's:$REMOTE_HUB_ROBOT:'"$REMOTE_HUB_ROBOT"':g' hub.cfg
  sed -i 's:$ROBOT_NAME:'"$ROBOT_NAME"':g' nms-robot-vars.cfg
  sed -i 's:$REMOTE_HUB_NAME:'"$REMOTE_HUB_NAME"':g' nms-robot-vars.cfg
  sed -i 's:$REMOTE_HUB_ROBOT:'"$REMOTE_HUB_ROBOT"':g' nms-robot-vars.cfg
  sed -i 's:$DOMAIN:'"$DOMAIN"':g' nms-robot-vars.cfg
  sed -i 's:$REMOTE_HUB_IP:'"$REMOTE_HUB_IP"':g' nms-robot-vars.cfg
  sed -i 's:$FIRST_PORT:'"$FIRST_PORT"':g' nms-robot-vars.cfg
  sed -i 's:$CONTROLLER_PORT:'"$CONTROLLER_PORT"':g' nms-robot-vars.cfg
  sed -i 's:$SPOOLER_PORT:'"$SPOOLER_PORT"':g' nms-robot-vars.cfg

  rpm -ivh nimsoft-robot.x86_64.rpm
  /opt/nimsoft/install/RobotConfigurer.sh
  mkdir /opt/nimsoft/hub
  mv /opt/hub.cfg /opt/nimsoft/hub
  mv /opt/request.cfg /opt/nimsoft
  systemctl enable nimbus.service
  service nimbus restart
else
  service nimbus restart
fi
sleep infinity
