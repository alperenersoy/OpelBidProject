# This Python file uses the following encoding: utf-8
import os
from pathlib import Path
import sys
import time
import datetime
import can
import cardata
import threading
import json
from easysettings import EasySettings
from rpi_backlight import Backlight

from PyQt5.QtGui import QGuiApplication
from PySide2.QtQml import QQmlApplicationEngine
from PySide2.QtCore import QObject, Signal, Slot


class MainWindow(QObject):
    def __init__(self):
        QObject.__init__(self)

    settings = EasySettings("settings.conf")
    backlight = None
    try:
        backlight = Backlight()
    except:
        print("backlight error")

    currentIgnitionStatus = ""
    hazardLightOn = False

    currentBacklightMode = 0
    currentFuelLevel = None
    insantConsumptionData = {"fuelLevel": None, "distanceTraveled": None}
    engineStartTime = 0
    distanceTraveled = 0
    distanceLoop = 0
    fuelLevelOnStart = None
    averageSpeed = [0, 0] #first element: count of samples, second element: current mean
    isShutDownSet = False
    openDoors = []

    currentTime = None

    isCanOnline = Signal(bool)
    currentIsCanOnline = False
    speed = Signal(float)
    currentSpeed = 0
    rpm = Signal(int)
    currentRpm = 0
    engineTemp = Signal(int)
    currentEngineTemp = 0
    airTemp = Signal(float)
    currentAirTemp = 0
    fuelPercentage = Signal(float)
    currentFuelPercentage = 0
    isIgnitionOn = Signal(bool)
    currentIsIgnitionOn = False
    isEngineRunning = Signal(bool)
    currentIsEngineRunning = False
    isCruiseControlActive = Signal(bool)
    currentIsCruiseControlActive = False
    triggeredControl = Signal(str)
    currentTriggeredControl = ""
    controlTriggeredTime = time.time()

    @Slot(result=float)
    def getCurrentSpeed(self):
        return self.currentSpeed

    @Slot(result=int)
    def getCurrentRpm(self):
        return self.currentRpm

    @Slot(result=int)
    def getCurrentEngineTemp(self):
        return self.currentEngineTemp

    @Slot(result=float)
    def getCurrentAirTemp(self):
        return self.currentAirTemp

    @Slot(result=bool)
    def getCurrentIsIgnitionOn(self):
        return self.currentIsIgnitionOn

    @Slot(result=bool)
    def getcurrentIsEngineRunning(self):
        return self.currentIsEngineRunning

    @Slot(result=bool)
    def getCurrentIsCruiseControlActive(self):
        return self.currentIsCruiseControlActive

    @Slot(result=str)
    def getCurrentTriggeredControl(self):
        return self.triggeredControl

    @Slot(result=bool)
    def getCurrentIsCanOnline(self):
        return self.currentIsCanOnline

    @Slot(result=float)
    def getCurrentFuelPercentage(self):
        return self.currentFuelPercentage

    @Slot(result=str)
    def getTriggeredControl(self):
        return self.currentTriggeredControl

    @Slot(result=str)
    def getCurrentTime(self):
        if(self.currentTime is not None):
            return self.currentTime

    @Slot(result=str)
    def getOpenDoors(self):
        return json.dumps(self.openDoors)

    @Slot(result=str)
    def getCurrentTripData(self):
        if(self.fuelLevelOnStart is None):
            self.fuelLevelOnStart = self.currentFuelLevel
        if(self.currentIsEngineRunning):
            currentTripData = {
                "elapsedTime": str(datetime.timedelta(seconds=time.time() - self.engineStartTime)),
                "fuelConsumption": round(self.fuelLevelOnStart - self.currentFuelLevel, 2),
                "distanceTraveled": round(((self.distanceLoop * 1032) + self.distanceTraveled)/1000, 2),
                "averageSpeed": self.averageSpeed[1]
            }
            return json.dumps(currentTripData)
        else:
            return json.dumps({})

    @Slot(result=bool)
    def getIsIgnitionOn(self):
        return self.isIgnitionOn

    @Slot(result=int)
    def refreshBacklight(self):
        if(self.currentBacklightMode == 0):
            if self.backlight is not None:
                self.backlight.brightness = self.settings.get(
                    "dayBrightness") if self.settings.has_option("dayBrightness") else 100
        elif(self.currentBacklightMode == 1):
            if self.backlight is not None:
                self.backlight.brightness = self.settings.get(
                    "nightBrightness") if self.settings.has_option("nightBrightness") else 100

    @Slot(result=bool)
    def saveSettings(self):
        try:
            os.system("sudo raspi-config --disable-overlayfs")
            os.system("sudo raspi-config --enable-overlayfs")
        except:
            return False
        return True

    @Slot(str, str)
    def setSetting(self, setting, value):
        self.settings.set(setting, value)
        self.settings.save()

    @Slot(str, result=str)
    def getSetting(self, setting):
        if self.settings.has_option(setting):
            return self.settings.get(setting)
        else:
            return None

    def emitDefaults(self):
        self.isEngineRunning.emit(False)
        self.isIgnitionOn.emit(False)
        self.isCanOnline.emit(False)

    bus = None

    # define can information for MCP2515 and GMLAN Single Wire Can (LSCAN)
    try:
        bus = can.interface.Bus(bustype='socketcan',
                                channel='can0', bitrate=33300)
    except:
        print("Can bus başlatılamıyor.")

    def canLoop(self):
        if self.bus is not None:
            self.currentIsCanOnline = True
            self.isCanOnline.emit(True)
            while True:
                msg = self.bus.recv()
                self.checkCanMessage(msg.arbitration_id,  msg.data)
        else:
            while True:
                #print("Can bağlantısı sağlanamadı. Yeniden deneniyor...")
                try:
                    self.bus = can.interface.Bus(bustype='socketcan',
                                                 channel='can0', bitrate=33300)
                except:
                    continue
                if self.bus is not None:
                    self.canLoop()
                    break
            self.currentIsCanOnline = False
            self.isCanOnline.emit(False)

    thread = None

    def startCanLoop(self):
        self.thread = threading.Thread(target=self.canLoop, daemon=True)
        self.thread.start()

    def checkCanMessage(self, id, data):
        if(id in cardata.canMessages and cardata.canMessages[id] == 'MOTION'):
            self.updateMotionData(data)
        elif(id in cardata.canMessages and cardata.canMessages[id] == 'TIME'):
            self.updateTime(data)
        elif(id in cardata.canMessages and cardata.canMessages[id] == 'ENGINE'):
            self.updateEngineData(data)
        elif(id in cardata.canMessages and cardata.canMessages[id] == 'AIR_TEMP'):
            self.updateAirTemp(data)
        elif(id in cardata.canMessages and cardata.canMessages[id] == 'FUEL_LEVEL'):
            self.updateFuelLevel(data)
        elif(id in cardata.canMessages and cardata.canMessages[id] == 'SW_CONTROL'):
            self.triggerSWControl(data)
        elif(id in cardata.canMessages and cardata.canMessages[id] == 'IGNITION_STATUS'):
            self.updateIgnitionStatus(data)
        elif(id in cardata.canMessages and cardata.canMessages[id] == 'GEAR_STATUS'):
            self.updateGearStatus(data)
        elif(id in cardata.canMessages and cardata.canMessages[id] == 'KEY_BUTTONS'):
            self.triggerKeyButtons(data)
        elif(id in cardata.canMessages and cardata.canMessages[id] == 'DISTANCE_TRAVELED'):
            self.updateDistanceTraveled(data)
        elif(id in cardata.canMessages and cardata.canMessages[id] == 'DOOR_OPEN'):
            self.updateOpenDoors(data)
        elif(id in cardata.canMessages and cardata.canMessages[id] == 'BACKLIGHT'):
            self.updateBacklight(data)

    def updateBacklight(self, data):
        backlightMode = cardata.humanizeBacklightData(data)
        if(backlightMode == 0):
            if self.backlight is not None:
                self.backlight.brightness = self.settings.get(
                    "dayBrightness") if self.settings.has_option("dayBrightness") else 100
            return ""
        elif(backlightMode == 1):
            if self.backlight is not None:
                self.backlight.brightness = self.settings.get("nightBrightness") if self.settings.has_option("nightBrightness")  else 100
            return ""
        self.currentBacklightMode = backlightMode

    def updateOpenDoors(self, data):
        openDoors = cardata.humanizeDoorOpenData(data)
        self.openDoors = openDoors

    def triggerKeyButtons(self, data):
        if(self.settings.has_option("closeWindowOnLock") and bool(self.settings.get("closeWindowOnLock")) == True):
            if data == cardata.KEY_BUTTONS_LOCK.data:
                try:
                    if(self.bus is not None):
                        #os.system("cansend can0 160#02C0058F")
                        time.sleep(5)
                        self.bus.send(cardata.KEY_BUTTONS_LOCK_HOLD)
                        print("Key button lock hold message sent.")
                except can.CanError:
                    print("Key button lock hold message NOT sent.")

    def updateTime(self, data):
        timeData = cardata.humanizeTimeData(data)
        self.currentTime = timeData["time"]

    def updateGearStatus(self, data):
        gearStatus = cardata.humanizeGearData(data)
        if(self.settings.has_option("hazardLightsOnReverse") and bool(self.settings.get("hazardLightsOnReverse")) == True):
            if(gearStatus == 'REVERSE'):
                try:
                    if(self.bus is not None and self.hazardLightOn == False):
                        self.bus.send(cardata.HAZARD_LIGHTS_ON)
                        self.bus.send(cardata.HAZARD_LIGHTS_ON2)
                        self.hazardLightOn = True
                        print("Hazard lights on message sent.")
                except can.CanError:
                    print("Hazard lights on message NOT sent.")
            elif(gearStatus == 'NOT_REVERSE'):
                try:
                    if(self.bus is not None and self.hazardLightOn == True):
                        self.bus.send(cardata.HAZARD_LIGHTS_OFF)
                        self.bus.send(cardata.HAZARD_LIGHTS_OFF2)
                        self.hazardLightOn = False
                        print("Hazard lights off message sent.")
                except can.CanError:
                    print("Hazard lights off message NOT sent.")

    def updateIgnitionStatus(self, data):
        ignitionStatus = cardata.humanizeIgnitionData(data)
        if((self.currentIgnitionStatus == "" or ignitionStatus != self.currentIgnitionStatus) and ignitionStatus is not None):
            self.currentIgnitionStatus = ignitionStatus

    def updateMotionData(self, data):
        motionData = cardata.humanizeMotionData(data)
        self.triggerEngineStatus(
            motionData["isEngineRunning"], self.currentIsEngineRunning)
        self.currentSpeed = float(motionData["speed"])
        self.currentRpm = int(motionData["rpm"]/100)
        self.currentIsEngineRunning = motionData["isEngineRunning"]
        self.currentIsIgnitionOn = motionData["isIgnitionOn"]
        self.speed.emit(self.currentSpeed)
        self.rpm.emit(self.currentRpm)
        self.isEngineRunning.emit(self.currentIsEngineRunning)
        self.isIgnitionOn.emit(self.currentIsIgnitionOn)
        if(self.currentSpeed > 0):
            newSampleCount = self.averageSpeed[0] + 1
            currentAverageSpeedTotal = self.averageSpeed[0] * \
                self.averageSpeed[1]
            newAverageSpeedTotal = currentAverageSpeedTotal + self.currentSpeed
            self.averageSpeed = [newSampleCount,
                                 newAverageSpeedTotal / newSampleCount]

        if(self.isShutDownSet == False and self.currentIsIgnitionOn == False and self.currentIsEngineRunning == False and (self.currentIgnitionStatus != "START" or self.currentIgnitionStatus != "ON")):
            self.shutDown()
        if(self.isShutDownSet and (self.currentIsIgnitionOn == True or self.currentIsEngineRunning == True or self.currentIgnitionStatus == "ON" or self.currentIgnitionStatus == "START")):
            self.cancelShutDown()

    def updateEngineData(self, data):
        engineData = cardata.humanizeEngineData(data)
        self.currentEngineTemp = int(engineData["engineTemp"])
        self.currentIsCruiseControlActive = engineData["isCruiseControlActive"]
        self.engineTemp.emit(self.currentEngineTemp)
        self.isCruiseControlActive.emit(self.currentIsCruiseControlActive)

    def updateAirTemp(self, data):
        airTemp = cardata.humanizeAirTemp(data)
        self.currentAirTemp = float(airTemp)
        self.airTemp.emit(self.currentAirTemp)

    def updateFuelLevel(self, data):
        fuelLevel = cardata.humanizeFuelLevel(data)
        self.currentFuelLevel = fuelLevel
        self.currentFuelPercentage = (
            float(fuelLevel) * 100) / cardata.fuelCapacity
        self.fuelPercentage.emit(self.currentFuelPercentage)

    def updateDistanceTraveled(self, data):
        distanceTraveled = cardata.humanizeDistanceData(data)
        if(distanceTraveled < self.distanceTraveled):
            # it means new distance loop started
            self.distanceLoop += 1
        self.distanceTraveled = distanceTraveled

    def triggerSWControl(self, data):
        triggeredControls = cardata.humanizeSWControls(data)
        for triggeredControl in triggeredControls:
            if(time.time() - self.controlTriggeredTime > 1):
                self.currentTriggeredControl = triggeredControl
                self.triggeredControl.emit(self.currentTriggeredControl)
                self.controlTriggeredTime = time.time()

    def triggerEngineStatus(self, newIsEngineRunning, currentIsEngineRunning):
        if(currentIsEngineRunning == False and newIsEngineRunning == True):
            # engine started
            self.engineStartTime = time.time()
            self.fuelLevelOnStart = self.currentFuelLevel
            self.distanceTraveled = 0
            self.averageSpeed = [0, 0]
        elif(currentIsEngineRunning == True and newIsEngineRunning == False):
            # engine stopped
            print()

    def shutDown(self):
        os.system("shutdown -h +4")
        print("shutdown is set")
        self.isShutDownSet = True

    def cancelShutDown(self):
        os.system("shutdown -c")
        print("shutdown is cancelled")
        self.isShutDownSet = False


if __name__ == "__main__":
    app = QGuiApplication(sys.argv)
    engine = QQmlApplicationEngine()
    main = MainWindow()
    engine.rootContext().setContextProperty("backend", main)
    engine.load(os.fspath(Path(__file__).resolve().parent / "main.qml"))
    main.emitDefaults()
    main.startCanLoop()
    if not engine.rootObjects():
        sys.exit(-1)
    sys.exit(app.exec_())
