# This Python file uses the following encoding: utf-8
import os
from pathlib import Path
import sys
import can
import cardata
from datetime import datetime

from PyQt5.QtGui import QGuiApplication
from PySide2.QtQml import QQmlApplicationEngine
from PySide2 import QtCore
from PySide2.QtCore import QObject, Signal, Slot


class MainWindow(QObject):
    def __init__(self):
        QObject.__init__(self)

    isCanOnline = Signal(bool)
    speed = Signal(float)
    rpm = Signal(int)
    engineTemp = Signal(int)
    airTemp = Signal(float)
    fuelPercentage = Signal(float)
    estRange = Signal(float)
    averageConsumption = Signal(str)
    instantConsumption = Signal(float)
    isEngineRunning = Signal(bool)
    isCruiseControlActive = Signal(bool)
    triggeredControl = Signal(dict)

    def emitDefaults(self):
        self.isEngineRunning.emit(False)
        self.isCanOnline.emit(False)
    bus = None

    # define can information for MCP2515 and GMLAN Single Wire Can (LSCAN)
    try:
        bus = can.interface.Bus(bustype='socketcan',
                                channel='can0', bitrate=33300)
    except:
        print("Can bus tanımlanamadı.")

    def canLoop(self):
        if self.bus is not None:
            self.isCanOnline.emit(True)
            for msg in self.bus:
                self.checkCanMessage(msg.arbitration_id,  msg.data)
        else:
            self.isCanOnline.emit(False)

    def checkCanMessage(self, id, data):
        if(cardata.canMessages[id] == 'MOTION'):
            self.updateMotionData(data)
        elif(cardata.canMessages[id] == 'ENGINE'):
            self.updateEngineData(data)
        elif(cardata.canMessages[id] == 'AIR_TEMP'):
            self.updateAirTemp(data)
        elif(cardata.canMessages[id] == 'FUEL_LEVEL'):
            self.updateFuelLevel(data)
        elif(cardata.canMessages[id] == 'SW_CONTROL'):
            self.triggerSWControl(data)

    def updateMotionData(self, data):
        motionData = cardata.humanizeMotionData(data)
        self.speed.emit(motionData["speed"])
        self.rpm.emit(motionData["rpm"]/100)

    def updateEngineData(self, data):
        engineData = cardata.humanizeEngineData(data)
        self.engineTemp.emit(engineData["engineTemp"])
        self.isEngineRunning.emit(engineData["isEngineRunning"])
        self.isCruiseControlActive.emit(engineData["isCruiseControlActive"])

    def updateAirTemp(self, data):
        airTemp = cardata.humanizeAirTemp(data)
        self.airTemp.emit(airTemp)

    def updateFuelLevel(self, data):
        fuelLevel = cardata.humanizeFuelLevel(data)
        self.fuelPercentage.emit((fuelLevel * 100) / cardata.fuelCapacity)

    def triggerSWControl(self, data):
        triggeredControls = cardata.humanizeSWControls(data)
        for triggeredControl in triggeredControls:
            timestamp = datetime.timestamp(datetime.now())
            triggeredControlObject = {
                "control": triggeredControl, "time": timestamp}
            self.triggeredControl.emit(triggeredControlObject)


if __name__ == "__main__":
    app = QGuiApplication(sys.argv)
    engine = QQmlApplicationEngine()
    main = MainWindow()
    engine.rootContext().setContextProperty("backend", main)
    engine.load(os.fspath(Path(__file__).resolve().parent / "main.qml"))
    main.emitDefaults()
    timer = QtCore.QTimer()
    timer.timeout.connect(main.canLoop)
    timer.start(40)
    if not engine.rootObjects():
        sys.exit(-1)
    sys.exit(app.exec())
