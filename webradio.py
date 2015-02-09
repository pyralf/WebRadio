#!/usr/bin/python

from Adafruit_CharLCD import Adafruit_CharLCD
from subprocess import *
from time import sleep, strftime
from datetime import datetime
import os
import RPi.GPIO as GPIO

def run_cmd(cmd):
    p = Popen(cmd, shell=True, stdout=PIPE)
    output = p.communicate()[0]
    return output
    
GPIO.setmode(GPIO.BCM)
GPIO.setup(18, GPIO.IN)

os.system('mpc clear')
os.system('mpc load http://mp3-live.swr3.de/swr3_m.m3u')
os.system('mpc load http://mp3-live.swr.de/swr2_m.m3u')
os.system('mpc volume 100')
sleep(0.5)
current = 1
length = run_cmd("mpc playlist | wc -l")
print(length)
os.system('mpc play %s 2>&1 &' % (current))

lcd = Adafruit_CharLCD()
lcd.begin(16, 1)
lcd.clear()
ip = run_cmd("ip addr show wlan0 | grep inet | awk '{print $2}' | cut -d/ -f1")
title = run_cmd('mpc current')[6:]
lcd.message('IP %s' % (ip))
lcd.message('%s' % (title))
print(title)
sleep(3)

while 1:
    sleep(0.5)
    
    if GPIO.input(18) == 0:
        if current == int(length):
            current = 1
        else:
            current += 1
        os.system('mpc play %s 2>&1 &' % (current))
        
    titleNew = run_cmd('mpc current')[6:]
    if not titleNew == title:
        print(titleNew)
        title = titleNew
        lcd.clear()
        lcd.message('%s\n' % (title[0:16]))
        lcd.message('%s' % (title[16:32]))
