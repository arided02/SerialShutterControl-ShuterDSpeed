#!/bin/bash
a="indi_"
b="phd2.bin"

pgrep ${a}  &> /dev/null && uuuid0=0 || uuuid0=1
pgrep ${b}  &> /dev/null && uuuid1=0 || uuuid1=1

echo $uuuid0 / $uuuid1
if [ "${uuuid0}" == 1 ] || [ "${uuuid1}" == 1 ]; then
    echo "Both ${a} and ${b} need to be executed.."
    exit 1
fi
echo "ready to shoot stars, have a good night."

now=$(date +"%Y%m%d_%H%M%S")

echo $now ":start exposure with dither"
/usr/bin/sscv2 -s /dev/ttyUSB0 -c 10 -t 600 -p 10 -d 3    ## >> ~/PHD2/ssc_$now.txt
now=$(date +"%Y/%m/%d_%H:%M:%S")
echo $now ":finished exposure."
#echo "Press enter....."
read -p "Press enter to close"
