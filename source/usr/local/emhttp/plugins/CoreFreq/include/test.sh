#!/bin/bash
if [ ! -z "$(lsmod | grep "corefreqk")" ]; then
  echo "---Module for CoreFreq already loaded!---"
  if [ "$(cat /boot/config/plugins/corefreq/settings.cfg | grep "module_tested=" | cut -d '=' -f2)" != "true" ]; then
    sed -i "/module_tested=/c\module_tested=true" "/boot/config/plugins/corefreq/settings.cfg"
    sleep 1
  fi
else
  if modprobe corefreqk ; then
    echo "---Module successfully loaded---"
    sed -i "/module_tested=/c\module_tested=true" "/boot/config/plugins/corefreq/settings.cfg"
    sleep 1
  else
    echo "---Something went horribly wrong, can't load moduel for Corefreq!---"
  fi
fi
