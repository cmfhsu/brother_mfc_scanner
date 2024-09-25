#! /bin/bash
# scantofile
#
mkdir -p ~/brscan
sleep 0.2

if [ -e ~/.brscan-skey/scantofile.config ];then
   source ~/.brscan-skey/scantofile.config
elif [ -e /etc//opt/brother/scanner/brscan-skey/scantofile.config ];then
   source /etc//opt/brother/scanner/brscan-skey/scantofile.config
fi



SCANIMAGE="/opt/brother/scanner/brscan-skey/skey-scanimage"
OUTPUT=/mnt/media/media10tb/brscan/brscan_"$(date +%Y-%m-%d-%H-%M-%S)"
OPT_OTHER=""



if [ "$resolution" != '' ];then
   OPT_RESO="--resolution $resolution" 
else
   OPT_RESO="--resolution 100" 
fi

if [ "$source" != '' ];then
   OPT_SRC="--source $source" 
else
   OPT_SRC="--source FB" 
fi

if [ "$size" != '' ];then
   OPT_SIZE="--size $size" 
else
   OPT_SIZE="--size Letter" 
fi

if [ "$duplex" = 'ON' ];then
   OPT_DUP="--duplex"
   OPT_SRC="--source ADF_C" 
else
   OPT_DUP=""
fi
OPT_FILE="--outputfile  $OUTPUT".tif

OPT_DEV="--device-name $1"

OPT="$OPT_DEV $OPT_RESO $OPT_SRC $OPT_SIZE $OPT_DUP $OPT_OTHER $OPT_FILE"

if [ "$(echo "$1" | grep net)" != '' ];then
    sleep 1
fi

echo  "$SCANIMAGE $OPT"
$SCANIMAGE $OPT

if [ ! -e "$OUTPUT".tif ];then
   sleep 1
   $SCANIMAGE $OPT
fi

tiffcp -c lzw "$OUTPUT".tif "$OUTPUT".lzw.tif
tiff2pdf -z -o "$OUTPUT".pdf -p "letter" -F "$OUTPUT".lzw.tif
rm -f "$OUTPUT".tif
rm -f "$OUTPUT".lzw.tif

echo "$OUTPUT".pdf is created.
