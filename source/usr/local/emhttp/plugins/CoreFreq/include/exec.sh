#!/bin/bash

function get_test(){
echo -e "$(cat /boot/config/plugins/corefreq/settings.cfg | grep "module_tested=" | cut -d '=' -f2)"
}

function get_status(){
if [ ! -z "$(pidof corefreqd)" ]; then
  echo -e "running"
else
  echo -e "stopped"
fi
}

function get_autostart(){
echo -e "$(cat /boot/config/plugins/corefreq/settings.cfg | grep "autostart_corefreq=" | cut -d '=' -f2)"
}

function start_corefreqd(){
if [ -z "$(lsmod | grep "corefreqk")" ]; then
  modprobe corefreqk
fi
if [ ! -d /root/.config/CoreFreq ]; then
  mkdir -p /root/.config/CoreFreq
fi
ln -s /boot/config/plugins/corefreq/corefreq.cfg /root/.config/CoreFreq/corefreq.cfg 2>/dev/null
echo "corefreqd" | at now
sleep 1
}

function stop_corefreqd(){
kill -SIGINT $(pidof corefreqd)
sleep 1
}

function enable_autostart(){
sed -i "/autostart_corefreq=/c\autostart_corefreq=true" "/boot/config/plugins/corefreq/settings.cfg"
sleep 1
}

function disable_autostart(){
sed -i "/autostart_corefreq=/c\autostart_corefreq=false" "/boot/config/plugins/corefreq/settings.cfg"
sleep 1
}

$@
