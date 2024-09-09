#!/bin/bash

sketchybar --set $NAME label="$(LC_TIME=zh_CN.UTF-8 date '+%m月%d号 %A %H:%M')"
# sketchybar --set $NAME icon="$(date '+%a %d. %b')" label="$(date '+%H:%M')"
