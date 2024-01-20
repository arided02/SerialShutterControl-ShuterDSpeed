#!/bin/bash
SECONDS=0
gphoto2 --set-config imagequality=4
gphoto2 --set-config capturetarget=1
gphoto2 --set-config iso=400
settime1=$SECONDS
echo "set spent $((settime1)) seconds"
a=$SECONDS
timethread=40 ##30 for r8 seconds per 5 div; 42 for d810 >2 sec exposure >40 1.3s will trig star eater loop per $ony sensor which will induced 10s treatment
five=0 ## mod 5 =0 interval 5
rej=0
startno=0
endno=40 ##4.0s
frames=0
for ((i=${startno}; i<=${endno}; i=i+2 ));
do
	b=$SECONDS
	echo $i;
	if [ $i -lt ${timethread} ]; then        
	#	if [ $(( $i % 5 )) -ne 0 ]; then
                   gphoto2 --set-config shutterspeed=$i
                   /home/aigo/serial_rts   ##release shutter 
                   sleep 0.3 #extra 2 seconds to write
        #        else
        #           rej = $((rej+1))   
	#	fi   
	else    ##>42 2sec exp time
	    sleep 6
	    gphoto2 --set-config shutterspeed=$i
	    sleep 0.5
	    #gphoto2 --capture-image
	    /home/aigo/serial_rts
	
            sleep 3  #longer wait time
	fi
	duration=$SECONDS
	((  frames= frames + 1 ))
	echo "$(( duration - b )) seconds"
done
sleep 2 ##longest clear buffer
for (( j=${endno}-2;j>=${startno};j=j-2)); 
do

	c=$SECONDS
	echo $j
	if [  $j -lt ${timethread} ]; then
	#        
	#	if [ $(( $j % 5 )) -ne 0 ]; then
	#           echo $j;
 	           gphoto2 --set-config shutterspeed=$j
	#           gphoto2 --capture-image
	           /home/aigo/serial_rts    ##trigger shutter
	           sleep 0.3
	#        else
	#           rej = $((rej+1))   
	#	fi
	else
	   sleep 4 ###wait to clear buffer
	   gphoto2 --set-config shutterspeed=$j
	   sleep  0.5
           #gphoto2 --capture-image
           /home/aigo/serial_rts    ##trigger shutter
           sleep 4
        fi	   
	(( frames= $frames + 1 ))
	duration=$SECONDS
	echo "$(( duration - c )) seconds"
done
duration=$SECONDS
echo ${rej},${frames}
echo "Total $(( duration - a )) + $((settime1))  seconds"
echo "average D810gg $(( ((${frames})/1+0)/(duration-a)*60 )) fpm"

