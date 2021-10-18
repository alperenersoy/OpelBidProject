# This Python file uses the following encoding: utf-8
import os
from pathlib import Path
import sys
import time
import datetime
import math
from PyQt5.QtCore import QVariant
import can
import cardata
import threading
import json
from easysettings import EasySettings

from PyQt5.QtGui import QGuiApplication
from PySide2.QtQml import QQmlApplicationEngine
from PySide2 import QtCore
from PySide2.QtCore import QObject, Signal, Slot


class MainWindow(QObject):
    def __init__(self):
        QObject.__init__(self)

    settings = EasySettings("settings.conf")

    currentIgnitionStatus = ""
    headLightLoop = None
    hazardLightOn = False

    currentFuelLevel = None
    insantConsumptionData = {"fuelLevel": None,"distanceTraveled": None}
    currentInstantConsumption = None
    engineStartTime = 0
    distanceTraveled = 0
    distanceLoop = 0
    fuelLevelOnStart = None
    # first element: count of samples, second element: current mean
    averageSpeed = [0, 0]

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
    controlTriggeredTime = None

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

    @Slot(result=float)
    def getCurrentInstantConsumption(self):
        if(self.insantConsumptionData["fuelLevel"] is not None and self.insantConsumptionData["distanceTraveled"] != 0):
            fuelConsumption = self.currentFuelLevel - self.insantConsumptionData["fuelLevel"]
            distanceTraveled =  ((self.distanceLoop * 1032) + self.distanceTraveled)/1000 - self.insantConsumptionData["distanceTraveled"]
            instantConsumption = fuelConsumption * 100 / distanceTraveled
            self.currentInstantConsumption = instantConsumption
        else:
            if(self.currentFuelLevel is not None):
                self.insantConsumptionData["fuelLevel"] = self.currentFuelLevel
            if(self.distanceTraveled is not None):
                self.insantConsumptionData["distanceTraveled"] = ((self.distanceLoop * 1032) + self.distanceTraveled)/1000
        return self.currentInstantConsumption if self.currentInstantConsumption is not None else 0

    @Slot(result=str)
    def getCurrentIgnitionStatus(self):
        return self.currentIgnitionStatus

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

    @Slot(int)
    def setHeadLights(self, status):
        if status == 1:
            try:
                if self.bus is not None:
                    #self.headLightLoop = self.bus.send_periodic(cardata.HEAD_LIGHTS_ON, 0.00001)
                    print("Head lights on loop started.")
            except can.CanError:
                print("Head lights on message NOT sent.")
        else:
            if self.headLightLoop is not None:
                print("head lights stopped")
                self.headLightLoop.stop()

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

    def triggerKeyButtons(self, data):
        if(self.settings.has_option("closeWindowOnLock") and bool(self.settings.get("closeWindowOnLock")) == True):
            if data == cardata.KEY_BUTTONS_LOCK.data:
                try:
                    if(self.bus is not None):
                        self.bus.send(cardata.KEY_BUTTONS_LOCK_HOLD)
                        print("Key button lock hold message sent.")
                except can.CanError:
                    print("Key button lock hold message NOT sent.")

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
            else:
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
            currentAverageSpeedTotal = self.averageSpeed[0] * self.averageSpeed[1]
            newAverageSpeedTotal = currentAverageSpeedTotal + self.currentSpeed
            self.averageSpeed = [newSampleCount,
                                newAverageSpeedTotal / newSampleCount]
        print(self.currentIsEngineRunning)
        print(self.currentIsIgnitionOn)


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

    @Slot()
    def needleSweep(self):
        print("on")
        counter = 0
        direction = 0  # 0: forward 1: backward
        speedRmpRate = 3.25  # calculated for 8000 rpm and 260 km/s speed
        start_time = time.time()
        interval = 0.0020  # timer interval as seconds
        tour = 0  # timer tour
        while True:
            current_time = time.time()
            elapsed_time = current_time - start_time
            if math.floor(elapsed_time / interval) > tour:
                # time ticked
                if direction == 0:
                    if counter < 260:
                        speed1 = int(math.floor(counter/256))
                        speed2 = int(counter % 256)
                        # multiply rpm by 100 to calculate exact 4 digit rpm
                        rpm1 = int(math.floor(counter*100/speedRmpRate/256))
                        rpm2 = int(math.ceil(counter*100/speedRmpRate)) % 256
                        counter += 1
                    else:
                        direction = 1
                elif direction == 1:
                    if counter >= 0:
                        speed1 = int(math.floor(counter/256))
                        speed2 = int(counter % 256)
                        rpm1 = int(math.floor(counter*100/speedRmpRate/256))
                        rpm2 = int(math.ceil(counter*100/speedRmpRate)) % 256
                        counter -= 1
                    else:
                        break

                msg = can.Message(arbitration_id=0x108,
                                  data=[0, rpm1, rpm2, 0, speed1, speed2, 0, 0], is_extended_id=False)

                if self.bus is not None and counter % 10 == 0:  # reduce loops to empathize with buffer
                    try:
                        if(self.bus is not None):
                            self.bus.send(msg)
                    except can.CanError:
                        if counter == 0:
                            print("Needle sweep message NOT sent.")
                tour += 1

    def shutDown(self):
        os.system("shutdown now -h")

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
