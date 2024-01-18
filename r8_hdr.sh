#!/usr/bin/env bash
gphoto2 --set-config imageformat=21
gphoto2 --set-config capturetarget=1
gphoto2 --set-config iso=100
SECONDS=0
a=$SECONDS
timethread=30 ##30 for r8 seconds per 5 div
five=0 ## mod 5 =0 interval 5
rej=0
startno=55
endno=1
for i  in {55..14};
do
	b=$SECONDS
	echo $i;
	if [ $i -le 30 ]; then
	        
		if [ $(( $i % 5 )) -ne 0 ]; then
                   gphoto2 --set-config shutterspeed=$i
                   gphoto2 --capture-image
                else
                   rej = $((rej+1))   
		fi   
	else
	    gphoto2 --set-config shutterspeed=$i
	    gphoto2 --capture-image
	fi   
        sleep 0.05
	duration=$SECONDS
	echo "$(( duration - b )) seconds"
done
for j in {14..55};
do

	c=$SECONDS
	if [  $j -le $timethread ]; then
	        
		if [ $(( $j % 5 )) -ne 0 ]; then
	           echo $j;
 	           gphoto2 --set-config shutterspeed=$j
	           gphoto2 --capture-image
	        else
	           rej = $((rej+1))   
		fi
	else
	   gphoto2 --set-config shutterspeed=$j
           gphoto2 --capture-image
        fi	   
	sleep 0.05
	duration=$SECONDS
	echo "$(( duration - c )) seconds"
done
duration=$SECONDS
echo $rej
echo "Total $(( duration - a )) seconds"
echo "average EOS R8 $(( ((55-14+1)*2+$rej)/(duration-a)*60 )) fpm"
