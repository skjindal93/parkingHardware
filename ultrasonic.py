http_proxy  = "http://proxy62.iitd.ernet.in:3128"
proxyDict = { "http"  : http_proxy}
import RPi.GPIO as GPIO
import time, requests, sys
GPIO.setmode(GPIO.BCM)
piId = open("/home/pi/id.txt",'r').read()
print "Distance Measurement in Progress..."
TRIG = int(sys.argv[1]) #Pi Port
ECHO = int(sys.argv[2]) #Echo port
GPIO.setup(TRIG, GPIO.OUT)
GPIO.setup(ECHO, GPIO.IN)
GPIO.output(TRIG,False)
print "Waiting for sensor to settle..."
time.sleep(2)
url = "http://api.greenboard.in/parking/parkCarFromSensor/"+str(piId)+"/"+str(TRIG)+"/"
query_args={'occupied': False}


GPIO.output(TRIG, True)
time.sleep(0.00001)
GPIO.output(TRIG, False)
while GPIO.input(ECHO) == 0:
	pulse_start = time.time()
while GPIO.input(ECHO) == 1:
	pulse_end = time.time()
pulse_duration = pulse_end - pulse_start
distance = pulse_duration * 17150
distance = round(distance, 2)
print "Distance:",distance,"cm"
if (distance<20):
	query_args['occupied'] = 1
else:
	query_args['occupied'] = 0

try:
	response = requests.patch(url,data=query_args,proxies=proxyDict)
except requests.exceptions.RequestException as e:
	pass

GPIO.cleanup()
