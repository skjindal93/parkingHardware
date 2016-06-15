#!/bin/bash

crontab -l > mycron
echo "*/1 * * * * python /home/pi/ultrasonic.py $1 $2 >> /home/pi/pi.log 2>&1" >> mycron
echo "*/1 * * * * sleep 10; python /home/pi/ultrasonic.py $1 $2 >> /home/pi/pi.log 2>&1" >> mycron
echo "*/1 * * * * sleep 20; python /home/pi/ultrasonic.py $1 $2 >> /home/pi/pi.log 2>&1" >> mycron
echo "*/1 * * * * sleep 30; python /home/pi/ultrasonic.py $1 $2 >> /home/pi/pi.log 2>&1" >> mycron
echo "*/1 * * * * sleep 40; python /home/pi/ultrasonic.py $1 $2 >> /home/pi/pi.log 2>&1" >> mycron
echo "*/1 * * * * sleep 50; python /home/pi/ultrasonic.py $1 $2 >> /home/pi/pi.log 2>&1" >> mycron
crontab mycron
rm mycron
