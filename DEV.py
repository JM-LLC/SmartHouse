#!/usr/bin/python
# -*- coding: utf-8 -*-

# Modules for main
import os
import ConfigParser


# Modules - Services
import modules.services.Systemservices as Systemservices
import modules.services.Forecast as Forecast
import modules.services.Schedule as Schedule

# Modules - Hardware
import modules.hardware.Generic as Generic
import modules.hardware.RollerShutter as RollerShutter
import modules.hardware.Hygrometer_GPIO as Hygrometer_GPIO



print "[ Starte Systemservices ]"
SysSrv = dict()

print "-> Options..."
confFile = os.path.join(os.path.dirname(os.path.realpath('__file__')), 'conf', 'core.cfg'),
SysSrv['Opt'] = ConfigParser.ConfigParser()
SysSrv['Opt'].read(confFile)


print "-> Logging..."
SysSrv['Logger'] = Systemservices.Logger(SysSrv)


print "[- FINISH -]"


print 2*"\n","--- FOR DEV : ---"
#
print 'H = Hygrometer_GPIO.Sensor(1,"Fo", SysSrv)'
H = Hygrometer_GPIO.Sensor(1,"Fo", SysSrv)
H.getValue('Temperatur')
#print 'G = Generic.Actor(1,"Fo",SysSrv)'
#GA = Generic.Actor(1,"Foo",SysSrv)
#print 'RS = RollerShutter.Sensor(2, "Bar", SysSrv)'
#RS = RollerShutter.Sensor(2, "Bar", SysSrv)
#
#print "[ - FINISHED - ]"


if __name__ == '__main__':
	print 2*"\n"
	# from DEV import *
	print "Zum Testen und importieren in eine interaktive Python-Shell\n"
	print 'H = Hygrometer_GPIO.Sensor(1,"Fo", SysSrv)'
	H = Hygrometer_GPIO.Sensor(1,"Fo", SysSrv)
	#GA = Generic.Actor(1,"Foo",SysSrv)
	#RS = RollerShutter.Actor(2, "Bar", SysSrv)
	