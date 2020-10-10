#!/bin/sh

if [ $# -gt 0 ] ; then
    target=$1
else
    target=${target:="baidu.com"}
fi
export TZ="CST-08:00:00"
logfile="/root/${target%\.com}_$(date +%Y-%m-%d).log"
printf "%10s %8s %15s %4s %4s %4s %8s %8s %8s\n" DATE TIME IP TC RC LOSS MIN AVG MAX >> ${logfile}
changeday=$(date +%d)
while : ; do
    currday=$(date +%d)
    if [ ${currday} -ne ${changeday} ]; then
        logfile="${logfile%_*}_$(date +%Y-%m-%d).log"
        printf "%10s %8s %15s %4s %4s %4s %8s %8s %8s\n" DATE TIME IP TC RC LOSS MIN AVG MAX >> ${logfile}
        changeday=${currday}
    fi
    time=$(date "+%Y-%m-%d %H:%M:%S")
    res=$(ping -q -4 -I eth0 -w 60 ${target})
    # res=$(cat <<EOF )
    # PING 220.181.38.148 (220.181.38.148): 56 data bytes

    # --- 220.181.38.148 ping statistics ---
    # 10 packets transmitted, 10 packets received, 0% packet loss
    # round-trip min/avg/max = 60.447/157.975/301.467 ms
    # EOF
    # echo $res
    ip=$(echo $res | sed -n 's/^[^(]*(\([^)]*\)).*$/\1/gp')
    tc=$(echo $res | sed -n 's/^.* \([0-9][0-9]*\) packets transmitted.*$/\1/gp')
    rc=$(echo $res | sed -n 's/^.* \([0-9][0-9]*\) packets received.*$/\1/gp')
    loss=$(echo $res | sed -n 's/^.* \([0-9][0-9]*%\) packet loss.*$/\1/gp')
    min=$(echo $res | sed -n 's,^.* \([0-9][0-9]*\.[0-9][0-9]*\)/.*$,\1,gp')
    avg=$(echo $res | sed -n 's,^.*/\([0-9][0-9]*\.[0-9][0-9]*\)/.*$,\1,gp')
    max=$(echo $res | sed -n 's,^.*/\([0-9][0-9]*\.[0-9][0-9]*\) ms.*$,\1,gp')

    printf "%s %15s %4s %4s %4s %8s %8s %8s\n" "$time" $ip $tc $rc $loss $min $avg $max >> ${logfile}
done
