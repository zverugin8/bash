#!/usr/bin/bash
case "$1" in 
start)
if [ -e ~/run/hw9_my_service.pid ]; then #if1
echo "Service already started"
else 
sleep 9999 &
echo "[1] $!" 
echo "Service started" 
strarr=$!
pid_dir=~/run
if [ -d $pid_dir ]; then echo $strarr>$pid_dir/hw9_my_service.pid #if2
else 
mkdir $pid_dir
touch $pid_dir/hw9_my_service.pid
echo $strarr>$pid_dir/hw9_my_service.pid
fi #if2
fi #if1
;;
stop)
   if [ -e ~/run/hw9_my_service.pid ]; then
      kill $(cat ~/run/hw9_my_service.pid)
      info1=$(cat ~/run/hw9_my_service.pid)
      echo "[2] + $info1 terminated $0"
      rm ~/run/hw9_my_service.pid
      echo "Service stopped"
   else
      echo $0 is NOT running
      exit 1
    fi
      ;;
restart)
   if [ -f ~/run/hw9_my_service.pid ]; then $0 stop
   fi
   $0 start
   ;;
status)
   if [ -e ~/run/hw9_my_service.pid ]; then
      echo $0 is running, pid=$(cat ~/run/hw9_my_service.pid)
   else
      echo $0 is NOT running
      exit 1
   fi
   ;;
*)
   echo "Usage: $0 [start|stop|status|restart]"
esac
