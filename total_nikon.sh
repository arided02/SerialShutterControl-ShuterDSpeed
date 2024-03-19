#!/bin/bash
# Search for USB devices containing "Nikon" or "Canon"
USB_DEVICES=$(lsusb | grep -E 'Canon|Nikon|Sony|Fuji|Pentax' )
CANON_USB_DEVICES=$( grep 'Canon' <<< $USB_DEVICES )
NIKON_USB_DEVICES=$( grep  'Nikon'<<< $USB_DEVICES )
SONY_USB_DEVICES=$( grep  'Sony'<<< $USB_DEVICES )
FUJI_USB_DEVICES=$( grep  'Fuji'<<< $USB_DEVICES )
PENTAX_USB_DEVICES=$( grep  'Pentax'<<< $USB_DEVICES )


# init cameras
canon_cameras=()
nikon_cameras=()
sony_cameras=()
fuji_cameras=()
pentax_cameras=()
SECONDS=0
echo $CANON_USB_DEVICES$'\n'$NIKON_USB_DEVICES
# Extract Canon bus, device, and product ID information
i_canon=0
while read -r line; do
    bus=$(echo "$line" | awk '{print $2}')
    device=$(echo "$line" | awk '{print $4}' | sed 's/:$//')
    product_id=$(echo "$line" | awk '{print $9" "$10" "$11}')
    echo "usb:$bus,$device $product_id"
    canon_cameras[i_canon]="usb:$bus,$device"
    i_canon=$(($i_canon+1))
done <<< "$CANON_USB_DEVICES"
echo ${canon_cameras[@]}, $i_canon' CANON cameras'

# Extract Nikon bus, device, and product ID information
i_nikon=0
while read -r line; do
    bus=$(echo "$line" | awk '{print $2}')
    device=$(echo "$line" | awk '{print $4}' | sed 's/:$//')
    product_id=$(echo "$line" | awk '{print $9" "$10" "$11}')
    echo "usb:$bus,$device $product_id"
    nikon_cameras[i_nikon]="usb:$bus,$device"
    i_nikon=$(($i_nikon+1))
done <<< "$NIKON_USB_DEVICES"
echo ${nikon_cameras[@]}, $i_nikon' Nikon cameras'

# Extract Sony bus, device, and product ID information
i_sony=0
while read -r line; do
    bus=$(echo "$line" | awk '{print $2}')
    device=$(echo "$line" | awk '{print $4}' | sed 's/:$//')
    product_id=$(echo "$line" | awk '{print $9" "$10" "$11}')
    echo "usb:$bus,$device $product_id"
    sony_cameras[i]="usb:$bus,$device"
    i_sony=$(($i_sony+1))
done <<< "$SONY_USB_DEVICES"
echo ${sony_cameras[@]}, $i_sony' Sony cameras'

# Extract Fuji bus, device, and product ID information
i_fuji=0
while read -r line; do
    bus=$(echo "$line" | awk '{print $2}')
    device=$(echo "$line" | awk '{print $4}' | sed 's/:$//')
    product_id=$(echo "$line" | awk '{print $9" "$10" "$11}')
    echo "usb:$bus,$device $product_id"
    fuji_cameras[i_sony]="usb:$bus,$device"
    i_fuji=$(($i_fuji+1))
done <<< "$FUJI_USB_DEVICES"
echo ${fuji_cameras[@]}, $i_fuji' Fujifilm cameras'

totalCameras=$(($i_canon+$i_nikon))
echo 'Total '$totalCameras' camera devices'

## start set-up
#set exposure list
exptime=("1/8000" "1/6400" "1/5000" "1/4000" "1/3200" "1/2500" "1/2000" "1/1600" "1/1250" "1/1000" "1/800" "1/640" "1/500" "1/400" "1/320" "1/250" "1/200" "1/160" "1/125" "1/100" "1/80" "1/60" "1/50" "1/40" "1/30" "1/25" "1/20" "1/15" "1/13" "1/10" "1/8" "1/6" "1/5" "1/4" "1/3" "10/25" "1/2" "10/16" "10/13" "1" "1.3" "1.6" "2" "2.5" "3" "4")
exptimeCan=( "1/2000" "1/1000" "1/500" "1/250" "1/125" "1/60" "1/30" "1/15" "1/8" "1/4" "1/2" "1" "2" )
exptimeNik=( "1/2000" "1/1000" "1/500" "1/250"  "1/125" "1/60"  "1/30" "1/15" "1/8" "1/4" "1/2" "1/1" "2/1" )
isoCan=100
isoNik=100
##set up
i_canon=0  #define canon exlude
echo 'canon '${i_canon}' nikon' ${i_nikon}

if [ "$i_canon" -gt 0 ]; then
 for ((i=0;i<$i_canon;i++))
 do
    gphoto2 --port ${canon_cameras[i]} --set-config imageformat=31 
    gphoto2 --port ${canon_cameras[i]}  --set-config iso=${isoCan}   
    gphoto2 --port ${canon_cameras[i]} --set-config capturetarget=1   #store on camaera body    #RAW files of Canon
   
   
    echo ${canon_cameras[i]}' settled'
 done
fi

if [ "$i_nikon" -gt 0 ]; then
for ((i=0;i<$i_nikon;i++))
do
   gphoto2 --port ${nikon_cameras[i]} --set-config   imagequality=4 
   gphoto2 --port ${nikon_cameras[i]}  --set-config   capturetarget=1 
   gphoto2 --port ${nikon_cameras[i]}  --set-config iso=${isoNik}    #store on camaera body   #RAW files of Nikon
  
  # gphoto2 --port ${nikon_cameras[i]}  --set-config iso=${isoNik}          #iso..iso..isooooo
  # gphoto2 --port $nikon_cameras[i] --set-config /main/other/d033=0              #FX mode
   echo ${nikon_cameras[i]} ' settled'
done
fi
## partial exposure in every 5 minutes
#another script
## start continuous shoot for diamond ring only for Canon had this drivemode.
mytime=$SECONDS
##:'  ##debug stop start
echo 'Diamond Ring mode ... CH setting' ${mytime} 'sec'

if [ "$i_canon" -gt 0 ]; then
 for ((i=0;i<$i_canon;i++))
 do
    gphoto2 --port ${canon_cameras[i]}   --set-config drivemode=1 || gphoto2 --port ${canon_cameras[i]}  --set-config-value /main/capturesettings/shutterspeed="${exptime[9]}"   #Burst of Canon
     #store on camaera body
   
    echo ${canon_cameras[i]} ${exptime[9]}' settled'
 done
fi

if [ "$i_nikon" -gt 0 ]; then
##Nikon need to manual tweek wheel to CL or CH
 echo "Manaul tweek wheel of Nikon... to CL/CH modes"

 for ((i=0;i<$i_nikon;i++))
 do   
   #gphoto2 --port $nikon_cameras[i] --set-config /main/other/d033=1              #DX mode
   ##gphoto2 --port $nikon_cameras[i] --set-config-value /main/capturesettings/capturemode=2 ##cl mode for z7ii
   gphoto2 --port ${nikon_cameras[i]}   --set-config-value /main/capturesettings/shutterspeed="${exptime[10]}"     #1/1000s
   #gphoto2 --port ${nikon_cameras[i]}  --set-config-value /main/capturesettings/shutterspeed2=1/1600     #1/1000s D610
   
   sleep 0.3
   echo ${nikon_cameras[i]} ${exptime[10]}' settled'
   
 done
fi
b=$SECONDS
## start trigger
echo 'diamond ring trig-on',${b}
~/apr/SerialShutterControl-ShuterDSpeed/serial_rts_long /dev/ttyUSB0 3050 &
~/apr/SerialShutterControl-ShuterDSpeed/serial_rts_long /dev/ttyUSB1 3050 &
sleep 1.25   ##clear buffer
#~/apr/SerialShutterControl-ShuterDSpeed/serial_rts_long /dev/ttyUSB0 2050 &
#~/apr/SerialShutterControl-ShuterDSpeed/serial_rts_long /dev/ttyUSB1 2050 &
#sleep 1.0   ##clear buffer
## again
#~/apr/SerialShutterControl-ShuterDSpeed/serial_rts_long /dev/ttyUSB0 2050 &
#~/apr/SerialShutterControl-ShuterDSpeed/serial_rts_long /dev/ttyUSB1 2050 &
#sleep 0.25   ##clear buffer
#~/apr/SerialShutterControl-ShuterDSpeed/serial_rts_long /dev/ttyUSB0 1001 &
#~/apr/SerialShutterControl-ShuterDSpeed/serial_rts_long /dev/ttyUSB1 1001 &
sleep 4   ##clear buffer
c=$SECONDS
echo 'diamond ring trig-off', ${c}

echo "Berry pearl start"
if [ "$i_canon" -gt 0 ]; then
 for ((i=0;i<$i_canon;i++))
 do
   # gphoto2 --port $canon_cameras[i] --set-config drivemode=1     #RAW files of Canon
    gphoto2 --port ${canon_cameras[i]} --set-config-value /main/capturesettings/shutterspeed="${exptime[7]}"   #store on camaera body
   
    echo ${canon_cameras[i]} ${exptime[7]}' settled Canon'
 done
fi
if [ "$i_nikon" -gt 0 ]; then
##for ((i=0;i<$i_nikon;i++))
##do
   #gphoto2 --port ${nikon_cameras[i]} --set-config /main/other/d033=1              #DX mode
   ##parallel process.
   gphoto2 --port ${nikon_cameras[0]}  --set-config-value /main/capturesettings/shutterspeed="${exptime[7]}"  || gphoto2 --port ${nikon_cameras[1]}  --set-config-value /main/capturesettings/shutterspeed="${exptime[7]}" || gphoto2 --port ${nikon_cameras[2]}  --set-config-value /main/capturesettings/shutterspeed="${exptime[7]}"   #1/1000s
   #gphoto2 --port ${nikon_cameras[i]} --set-config-value /main/capturesettings/shutterspeed2=1/2000     #1/1000s D610
   
   sleep 0.1
   echo ${nikon_cameras[i]} ${exptime[7]}' settled Nikon'
fi   
##done
d=$SECONDS
## start trigger Berry Pearl
echo 'diamond ring trig-on',${d}
~/apr/SerialShutterControl-ShuterDSpeed/serial_rts_long /dev/ttyUSB0 3050 &
~/apr/SerialShutterControl-ShuterDSpeed/serial_rts_long /dev/ttyUSB1 3050 &
#sleep 1.25   ##clear buffer
#~/apr/SerialShutterControl-ShuterDSpeed/serial_rts_long /dev/ttyUSB0 2050 &
#~/apr/SerialShutterControl-ShuterDSpeed/serial_rts_long /dev/ttyUSB1 2050 &
#sleep 1.0   ##clear buffer
## again
#~/apr/SerialShutterControl-ShuterDSpeed/serial_rts_long /dev/ttyUSB0 2050 &
#~/apr/SerialShutterControl-ShuterDSpeed/serial_rts_long /dev/ttyUSB1 2050 &
#sleep 0.25   ##clear buffer
#~/apr/SerialShutterControl-ShuterDSpeed/serial_rts_long /dev/ttyUSB0 1001 &
#~/apr/SerialShutterControl-ShuterDSpeed/serial_rts_long /dev/ttyUSB1 1001 &
echo 'Clean buffer........'
sleep 8   ##clear buffer 
e=$SECONDS
echo 'diamond ring trig-off', ${e}

#'  ##debug stop end

##set back DX mode to FX
#for ((i=0;i<$i_nikon;i++))
#do
#   #gphoto2 --port $nikon_cameras[i] --set-config shutterspeed=7     #RAW files of Canon
#   gphoto2 --port $nikon_cameras[i] --set-config /main/other/d033=0              #DX mode 
#   echo ${nikon_cameras[i]}' back to FX mode'
#done

##start HDR exposure
##setback Canon's burst mode
if [ "$i_canon" -gt 0 ]; then
 #for ((j=0;j<i_canon;j++))
 #do 
    gphoto2 --port ${canon_cameras[0]}   --set-config /main/capturesettings/drivemode=0 
 #done
 echo 'Canon bust mode off'
fi
##count the matrix length of exposure time for HDR stops.
#if [ "${#exptimeCan[@]}" -ge "${#exptimeNik[@]}" ]; then
   hdrExpCount=${#exptimeCan[@]} 
#else
#   hdrExpCount=${#exptimeNik[@]} 
#fi

##start exposure tuning
for ((i=0;i<hdrExpCount;i++))
do
 if [ "$i_canon" -gt 0 ]; then
   for ((j=0;j<i_canon;j++))
   do 
   
     gphoto2 --port ${canon_cameras[j]} --set-config-value /main/capturesettings/shutterspeed="${exptimeCan[i]}"
    sleep 0.0
   done
  fi
  if [ "$i_nikon" -gt 0 ]; then 
   for ((j=0;j<i_nikon;j++))
   do
      gphoto2 --port ${nikon_cameras[j]}  --set-config-value /main/capturesettings/shutterspeed="${exptimeNik[i]}"  
      #gphoto2 --port ${nikon_cameras[1]}  --set-config-value /main/capturesettings/shutterspeed="${exptimeNik[i]}" 
      #gphoto2 --port ${nikon_cameras[2]}  --set-config-value /main/capturesettings/shutterspeed="${exptimeNik[i]}" 
   done
  fi  
  now="$(date +"%D %T")"
  echo ${now} ${exptimeCan[i]} ${i}' exposure'
  ~/apr/SerialShutterControl-ShuterDSpeed/serial_rts_long /dev/ttyUSB0 1 &
  #~/apr/SerialShutterControl-ShuterDSpeed/serial_rts_long /dev/ttyUSB1 1 &

  if [ "$i" -ge 8 ]; then
    echo "long exposure time delay...$(($i - 8)). Delay" $(echo "scale=2; 0.25 * ($i - 7)" | bc) "seconds"
    sleep $(echo "scale=2; 0.25 * ($i - 7)" | bc)  # Clear long exposure buffer, by Copilot... TKS!!!
  fi
  f=$SECONDS
  echo ${f} ' seconds'
done

sleep 0.5

for ((i=hdrExpCount-2;i>-1;i--))
do
 if [ "$i_canon" -gt 0 ]; then
  for ((j=0;j<i_canon;j++))
  do 
    gphoto2 --port ${canon_cameras[j]}  --set-config-value /main/capturesettings/shutterspeed="${exptimeCan[i]}" 
  done
  sleep 0.0
 fi
 if [ "$i_nikon" -gt 0 ]; then
  for ((j=0;j<i_nikon;j++))
   do
     gphoto2 --port ${nikon_cameras[j]}  --set-config-value /main/capturesettings/shutterspeed="${exptimeNik[i]}"
 # gphoto2 --port ${nikon_cameras[1]}  --set-config-value /main/capturesettings/shutterspeed="${exptimeNik[i]}" 
 # gphoto2 --port ${nikon_cameras[2]}  --set-config-value /main/capturesettings/shutterspeed="${exptimeNik[i]}" 
  done 
 fi 
  now="$(date +"%D %T")"
  echo ${now} ${exptimeCan[i]} ${i}' exposure'
  ~/apr/SerialShutterControl-ShuterDSpeed/serial_rts_long /dev/ttyUSB0 1 &
  #~/apr/SerialShutterControl-ShuterDSpeed/serial_rts_long /dev/ttyUSB1 1 &

  
   if [ "$i" -ge 8 ]; then
    echo "long exposure time delay...$(($i - 8)). Delay " $(echo "scale=2; 0.25 * ($i - 7)" | bc) "seconds"
    sleep $(echo "scale=2; 0.25 * ($i - 7)" | bc)  # Clear long exposure buffer, by Copilot... TKS!!!
  fi
  g=$SECONDS
  echo ${g} ' seconds'
done

sleep 3
echo 'hdr end'

##canon burst mode on

echo 'Canon bust mode on~~'

echo "Berry pearl start"
if [ "$i_canon" -gt 0 ]; then
 for ((i=0;i<$i_canon;i++))
 do
    gphoto2 --port ${canon_cameras[i]} --set-config drivemode=1     #Rburst mode of Canon
    gphoto2 --port ${canon_cameras[i]} --set-config-value /main/capturesettings/shutterspeed="${exptime[7]}"   #store on camaera body
   
    echo ${canon_cameras[i]} ${exptime[7]}' settled Canon'
 done
fi 

if [ "$i_nikon" -gt 0 ]; then
##for ((i=0;i<$i_nikon;i++))
##do
   #gphoto2 --port ${nikon_cameras[i]} --set-config /main/other/d033=1              #DX mode
   ##parallel process.
   gphoto2 --port ${nikon_cameras[0]}  --set-config-value /main/capturesettings/shutterspeed="${exptime[7]}"  || gphoto2 --port ${nikon_cameras[1]}  --set-config-value /main/capturesettings/shutterspeed="${exptime[7]}" || gphoto2 --port ${nikon_cameras[2]}  --set-config-value /main/capturesettings/shutterspeed="${exptime[7]}"   #1/1000s
   #gphoto2 --port ${nikon_cameras[i]} --set-config-value /main/capturesettings/shutterspeed2=1/2000     #1/1000s D610
   
   sleep 0.1
   echo ${nikon_cameras[i]} ${exptime[7]}' settled Nikon'
fi   
##done
d=$SECONDS
## start trigger Berry Pearl
echo 'diamond ring trig-on',${d}
~/apr/SerialShutterControl-ShuterDSpeed/serial_rts_long /dev/ttyUSB0 3050 &
~/apr/SerialShutterControl-ShuterDSpeed/serial_rts_long /dev/ttyUSB1 3050 &
#sleep 1.25   ##clear buffer
#~/apr/SerialShutterControl-ShuterDSpeed/serial_rts_long /dev/ttyUSB0 2050 &
#~/apr/SerialShutterControl-ShuterDSpeed/serial_rts_long /dev/ttyUSB1 2050 &
#sleep 1.0   ##clear buffer
## again
#~/apr/SerialShutterControl-ShuterDSpeed/serial_rts_long /dev/ttyUSB0 2050 &
#~/apr/SerialShutterControl-ShuterDSpeed/serial_rts_long /dev/ttyUSB1 2050 &
#sleep 0.25   ##clear buffer
#~/apr/SerialShutterControl-ShuterDSpeed/serial_rts_long /dev/ttyUSB0 1001 &
#~/apr/SerialShutterControl-ShuterDSpeed/serial_rts_long /dev/ttyUSB1 1001 &
echo 'Clean buffer........'
sleep 8   ##clear buffer 
e=$SECONDS
echo 'diamond ring trig-off', ${e}

echo 'Diamond Ring mode ... CH setting' ${mytime} 'sec'

if [ "$i_canon" -gt 0 ]; then
 for ((i=0;i<$i_canon;i++))
 do
    gphoto2 --port ${canon_cameras[i]}   --set-config drivemode=1 || gphoto2 --port ${canon_cameras[i]}  --set-config-value /main/capturesettings/shutterspeed="${exptime[9]}"   #Burst of Canon
      #store on camaera body
   
    echo ${canon_cameras[i]} ${exptime[9]}' settled'
 done
fi


##Nikon need to manual tweek wheel to CL or CH
echo "Manaul tweek wheel of Nikon... to CL/CH modes"
if [ "$i_nikon" -gt 0 ]; then
 for ((i=0;i<$i_nikon;i++))
 do   
    #gphoto2 --port $nikon_cameras[i] --set-config /main/other/d033=1              #DX mode
    ##gphoto2 --port $nikon_cameras[i] --set-config-value /main/capturesettings/capturemode=2 ##cl mode for z7ii
    gphoto2 --port ${nikon_cameras[i]}   --set-config-value /main/capturesettings/shutterspeed="${exptime[10]}"     #1/1000s
    #gphoto2 --port ${nikon_cameras[i]}  --set-config-value /main/capturesettings/shutterspeed2=1/1600     #1/1000s D610
   
    sleep 0.3
    echo ${nikon_cameras[i]} ${exptime[10]}' settled'
   
 done
fi
b=$SECONDS
## start trigger
echo 'diamond ring trig-on',${b}
~/apr/SerialShutterControl-ShuterDSpeed/serial_rts_long /dev/ttyUSB0 3050 &
~/apr/SerialShutterControl-ShuterDSpeed/serial_rts_long /dev/ttyUSB1 3050 &
sleep 1.25   ##clear buffer
#~/apr/SerialShutterControl-ShuterDSpeed/serial_rts_long /dev/ttyUSB0 2050 &
#~/apr/SerialShutterControl-ShuterDSpeed/serial_rts_long /dev/ttyUSB1 2050 &
#sleep 1.0   ##clear buffer
## again
#~/apr/SerialShutterControl-ShuterDSpeed/serial_rts_long /dev/ttyUSB0 2050 &
#~/apr/SerialShutterControl-ShuterDSpeed/serial_rts_long /dev/ttyUSB1 2050 &
#sleep 0.25   ##clear buffer
#~/apr/SerialShutterControl-ShuterDSpeed/serial_rts_long /dev/ttyUSB0 1001 &
#~/apr/SerialShutterControl-ShuterDSpeed/serial_rts_long /dev/ttyUSB1 1001 &
sleep 4   ##clear buffer

