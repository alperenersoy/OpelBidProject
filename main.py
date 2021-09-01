# This Python file uses the following encoding: utf-8
import os
from pathlib import Path
import sys
import random
import obd
import time
from obd import OBDStatus

from PyQt5.QtGui import QGuiApplication
from PySide2.QtQml import QQmlApplicationEngine
from PySide2.QtCore import QObject, Signal, Slot


class MainWindow(QObject):
    def __init__(self):
        QObject.__init__(self)

    isOBDConnected = False
    connection = ''
    fuelCapacity = 58  # For Opel Zafira B
    currentSpeed = 0
    currentInstantConsumption = 0

    def startOBDWatch(self):
        def updateSpeed(speed):
            self.currentSpeed = speed.value.magnitude
            self.speed.emit(speed.value.magnitude)

        def updateRpm(rpm):
            self.rpm.emit(rpm.value.magnitude/100)

        def updateEngineTemp(engineTemp):
            self.engineTemp.emit(engineTemp.value.magnitude)

        def updateAirTemp(airTemp):
            self.airTemp.emit(airTemp.value.magnitude)

        def updateFuelPercentage(fuelPercentage):
            fuelPercentageData = ((fuelPercentage.value.magnitude * 100) / 255)
            self.fuelPercentage.emit(round(fuelPercentageData, 1))

        def updateInstantConsumption(maf):
            print(maf.value.magnitude)
            _instantConsumption = 0
            if(self.currentSpeed > 0):
                _instantConsumption = (
                    maf.value.magnitude*3600/100)/(14.7 * self.currentSpeed)
            else:
                _instantConsumption = 0
            print(_instantConsumption)
            self.currentInstantConsumption = _instantConsumption
            self.instantConsumption.emit(round(_instantConsumption, 1))
            #hourRange = 58/_instantConsumption
            #estRange = hourRange * self.currentSpeed
            #self.estRange.emit(estRange)

        self.connection.watch(obd.commands.SPEED, callback=updateSpeed)
        self.connection.watch(obd.commands.RPM, callback=updateRpm)
        self.connection.watch(obd.commands.COOLANT_TEMP,
                              callback=updateEngineTemp)
        self.connection.watch(
            obd.commands.AMBIANT_AIR_TEMP, callback=updateAirTemp)
        self.connection.watch(obd.commands.FUEL_LEVEL,
                              callback=updateFuelPercentage)
        self.connection.watch(
            obd.commands.MAF, callback=updateInstantConsumption)
        self.connection.start()

    speed = Signal(float)
    rpm = Signal(int)
    engineTemp = Signal(int)
    airTemp = Signal(float)
    fuelPercentage = Signal(float)
    estRange = Signal(float)
    averageConsumption = Signal(str)
    instantConsumption = Signal(float)

    @Slot(result=list)
    def getDtcErrors(self):
        if(self.connection != ''):
            self.connection.close()
            time.sleep(1)
            connection = obd.OBD()
            dtc = connection.query(obd.commands.GET_DTC)
            connection.close()
            time.sleep(1)
            self.connection = obd.Async()
            dtcErrors = []
            if not dtc.is_null():
                for dtcError in dtc.value:
                    dtcErrors.append(
                        {'errorCode': dtcError[0], 'details': dtcError[1]})
                return dtcErrors
            else:
                return [{'errorCode': "Bağlantı hatası", 'details': "Bilgi alınamadı."}]

        else:
            return [{'errorCode': "Bağlantı hatası", 'details': "Arabaya bağlanılamıyor."}]

    @Slot(result=bool)
    def clearDtcErrors(self):
        if(self.connection != ''):
            try:
                self.connection.close()
                time.sleep(1)
                connection = obd.OBD()
                connection.query(obd.commands.CLEAR_DTC)
                connection.close()
                time.sleep(1)
                self.connection = obd.Async()
                return True
            except:
                return False
        else:
            return False

    @Slot(result=bool)
    def checkOBDConnection(self):
        #print("checking")
        try:
            if(self.isOBDConnected == False):
                _connection = obd.Async()
                #print("connection async")
                if(_connection.is_connected()):
                    self.connection = _connection
                    self.isOBDConnected = True
                    self.startOBDWatch()
                    #print("connected")
                    return True
                return False
            else:
                if(self.connection.is_connected() == False):
                    self.connection.stop()
                    self.isOBDConnected = False
                    return False
        except:
            return False


if __name__ == "__main__":
    app = QGuiApplication(sys.argv)
    engine = QQmlApplicationEngine()
    main = MainWindow()
    engine.rootContext().setContextProperty("backend", main)
    engine.load(os.fspath(Path(__file__).resolve().parent / "main.qml"))
    if not engine.rootObjects():
        sys.exit(-1)
    sys.exit(app.exec())
