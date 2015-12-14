#!/bin/bash
ifconfig wlan0 | grep 'inet addr' | awk '{print $2}' | cut -d ':' -f 2
