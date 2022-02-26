#!/bin/bash
a="indi_"
b="phd2.bin"
c="/dev/ttyUSB1" #serial port # by USBto232 
d="18" ## for dithering wait seconds need user tune to fit user's equatorial mounts dithering to stable time.
pgrep ${a}  &> /dev/null && uuuid0=0 || uuuid0=1
pgrep ${b}  &> /dev/null && uuuid1=0 || uuuid1=1
ps ax|grep ${c}|grep -v grep  &> /dev/null && uuuid2=0 || uuuid2=1 
echo "check ${a}/${b}/${c}:" $uuuid0 / $uuuid1 / $uuuid2 "0 means pre-executed"
## if no ind_* nor phd2 then exit

#check indi_* drivers and phd2 executed
if [ "${uuuid0}" == 1 ] || [ "${uuuid1}" == 1 ]; then
    echo "Both ${a}** drivers and ${b} need to be executed..please preload indi_ drivers in INDISTARTER or manual execute it"
    sleep 6
    exit 1
fi
#check /ttyUSB0 occupied by other sscv2
if [ "${uuuid2}" == 0 ]; then
    echo "Serial port ${c} was occupied, please try another /dev/ttyUSBn..."
    sleep 3
    exit 1
#else  ##recheck again if in phd2 dithering period
#    echo "check if phd in dithering phase"
#    sleep ${d}
#    ps ax|grep ${c}|grep -v grep  &> /dev/null && uuuid3=0 || uuuid3=1
#    if [ "${uuuid3}" == 0 ]; then
#        echo "Serial port ${c} was occupied on post dithering. Try another /dev/ttyUSBnnn serial port"
#        sleep 3
#        exit 1
#    fi
#    echo "nor occupied or phd2 dithering"
fi


echo "${c} was not occupied, ready to use sscv2 to shoot stars, have a good night."

now=$(date +"%Y%m%d_%H%M%S")

echo $now ":start exposure with dither"
/usr/bin/sscv2 -s ${c} -c 30 -t 478 -p ${d} -d 2 -m 2  ## >> ~/PHD2/ssc_$now.txt
now=$(date +"%Y/%m/%d_%H:%M:%S")
echo $now ":finished exposure."
#echo "Press enter....."
read -p "Press enter to close"
