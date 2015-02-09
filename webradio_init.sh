### BEGIN INIT INFO
# Provides: LCD - date / time / ip address
# Required-Start: $remote_fs $syslog
# Required-Stop: $remote_fs $syslog
# Default-Start: 2 3 4 5
# Default-Stop: 0 1 6
# Short-Description: Liquid Crystal Display
# Description: date / time / ip address
### END INIT INFO


#! /bin/sh
# /etc/init.d/webradio


export HOME
case "$1" in
    start)
        echo "Starting webradio"
        /home/pi/Adafruit-Raspberry-Pi-Python-Code/Adafruit_CharLCD/webradio.py  2>&1 &
    ;;
    stop)
        echo "Stopping webradio"
        LCD_PID=`ps auxwww | grep webradio.py | head -1 | awk '{print $2}'`
        kill -9 $LCD_PID
    ;;
    *)
        echo "Usage: /etc/init.d/webradio {start|stop}"
        exit 1
    ;;
esac
exit 0