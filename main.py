# This Python file uses the following encoding: utf-8
import os
from pathlib import Path
import sys
import time
import math
import can
import cardata
import threading
from easysettings import EasySettings
from random import randrange

from PyQt5.QtGui import QGuiApplication
from PySide2.QtQml import QQmlApplicationEngine
from PySide2 import QtCore
from PySide2.QtCore import QObject, Signal, Slot


class MainWindow(QObject):
    def __init__(self):
        QObject.__init__(self)

    settings = EasySettings("settings.conf")

    currentIgnitionStatus = ""
    currentSpeed = 0
    headLightLoop = None
    hazardLightOn = False

    isCanOnline = Signal(bool)
    speed = Signal(float)
    rpm = Signal(int)
    engineTemp = Signal(int)
    airTemp = Signal(float)
    fuelPercentage = Signal(float)
    estRange = Signal(float)
    averageConsumption = Signal(str)
    instantConsumption = Signal(float)
    isIgnitionOn = Signal(bool)
    isEngineRunning = Signal(bool)
    isCruiseControlActive = Signal(bool)
    triggeredControl = Signal(str)

    @Slot()
    def emitValues(self):
        self.speed.emit(self.currentSpeed)

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
        self.currentSpeed = randrange(150)
        if self.bus is not None:
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
                        self.hazardLightOn = True
                        print("Hazard lights on message sent.")
                except can.CanError:
                    print("Hazard lights on message NOT sent.")
            else:
                try:
                    if(self.bus is not None and self.hazardLightOn == True):
                        self.bus.send(cardata.HAZARD_LIGHTS_OFF)
                        self.hazardLightOn = False
                        print("Hazard lights off message sent.")
                except can.CanError:
                    print("Hazard lights off message NOT sent.")


    def updateIgnitionStatus(self, data):
        ignitionStatus = cardata.humanizeIgnitionData(data)
        if(self.currentIgnitionStatus == "ACCESSORY" and ignitionStatus == "ON"):
            if(self.settings.has_option("needleSweep") and bool(self.settings.get("needleSweep")) == True):
                print("needle")
                # self.needleSweep()
        if(self.currentIgnitionStatus == "" or ignitionStatus != self.currentIgnitionStatus):
            self.currentIgnitionStatus = ignitionStatus

    def updateMotionData(self, data):
        motionData = cardata.humanizeMotionData(data)
        self.speed.emit(float(motionData["speed"]))
        self.rpm.emit(int(motionData["rpm"]/100))
        self.isEngineRunning.emit(motionData["isEngineRunning"])
        self.isIgnitionOn.emit(motionData["isIgnitionOn"])

    def updateEngineData(self, data):
        engineData = cardata.humanizeEngineData(data)
        self.engineTemp.emit(int(engineData["engineTemp"]))
        self.isCruiseControlActive.emit(engineData["isCruiseControlActive"])

    def updateAirTemp(self, data):
        airTemp = cardata.humanizeAirTemp(data)
        self.airTemp.emit(float(airTemp))

    def updateFuelLevel(self, data):
        fuelLevel = cardata.humanizeFuelLevel(data)
        self.fuelPercentage.emit(
            (float(fuelLevel) * 100) / cardata.fuelCapacity)

    def triggerSWControl(self, data):
        triggeredControls = cardata.humanizeSWControls(data)
        for triggeredControl in triggeredControls:
            self.triggeredControl.emit(triggeredControl)
        print(triggeredControls)

    def needleSweep(self):
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
                if counter % 10 == 0: #reduce loops to empathize with buffer
                    if direction == 0:
                        if counter < 260:
                            speed1 = int(math.floor(counter/256))
                            speed2 = int(counter % 256)
                            rpm1 = int(math.floor(counter*100/speedRmpRate/256)) # multiply rpm by 100 to calculate exact 4 digit rpm
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

                    if self.bus is not None:
                        try:
                            if(self.bus is not None):
                                self.bus.send(msg)
                        except can.CanError:
                            if counter == 0:
                                print("Needle sweep message NOT sent.")
                tour += 1


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
