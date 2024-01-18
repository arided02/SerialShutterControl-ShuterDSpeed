#!/usr/bin/env bash
gphoto2 --set-config imageformat=21
gphoto2 --set-config capturetarget=1
gphoto2 --set-config iso=100
SECONDS=0
a=$SECONDS
for i  in {55..15};
do
        b=$SECONDS
        echo $i;
        gphoto2 --set-config shutterspeed=$i
        gphoto2 --capture-image
        sleep 0.4
        duration=$SECONDS
        echo "$(( duration - b )) seconds"
done
for j in {15..55};
do

        c=$SECONDS
        echo $j;
        gphoto2 --set-config shutterspeed=$j
        gphoto2 --capture-image
        sleep 0.3
        duration=$SECONDS
        echo "$(( duration - c )) seconds"
done
duration=$SECONDS
echo "average EOS R8 $(((duration-a)/(55-15+1)/2)) fpm"


