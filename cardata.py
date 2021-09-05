fuelCapacity = 58  # For Opel Zafira B

canMessages = {
    0x108:   "MOTION",  # speed and rpm
    0x145:   "ENGINE",  # coolant, running state and cruise control
    0x445:   "AIR_TEMP",
    0x375:   "FUEL_LEVEL",
    0x175:   "SW_CONTROL", # any steering wheel control including turn signals and glass wash
    0x500:   "VOLTAGE"
}


def humanizeMotionData(data):
    data = convertByteArrayToList(data)
    speedHex = data[1] + data[2]
    speed = int(round(int(speedHex, 16) / 128))
    rpmHex = data[4] + data[5]
    rpm = int(rpmHex, 16)
    return {"speed": speed, "rpm": rpm}


def humanizeEngineData(data):
    data = convertByteArrayToList(data)
    isEngineRunning = (False, True)[data[4] == "A0"]
    isCruiseControlActive = (False, True)[data[5] == "06"]
    engineTempHex = data[3]
    engineTemp = int(engineTempHex, 16) - 40
    return {"isEngineRunning": isEngineRunning, "isCruiseControlActive": isCruiseControlActive, "engineTemp": engineTemp}


def humanizeAirTemp(data):
    data = convertByteArrayToList(data)
    airTempHex = data[1]
    airTemp = (int(airTempHex, 16) / 2) - 40
    return airTemp


def humanizeFuelLevel(data):
    data = convertByteArrayToList(data)
    fuelLevelHex = data[1]
    fuelLevel = 94 - (int(fuelLevelHex, 16) / 2)  # as liters
    return fuelLevel


def humanizeSWControls(data):
    data = convertByteArrayToList(data)
    triggeredControls = []

    if(data[4] == "01"):
        triggeredControls.append('LEFT_SIGNAL_HALF')
    elif(data[4] == "02"):
        triggeredControls.append('RIGHT_SIGNAL_HALF')
    elif(data[4] == "03"):
        triggeredControls.append('LEFT_SIGNAL_FULL')
    elif(data[4] == "04"):
        triggeredControls.append('RIGHT_SIGNAL_FULL')

    if(data[5] == "01" and data[7] == 0x01):
        triggeredControls.append('RIGHT_KNOB_UP')  # volume up
    elif(data[5] == "02" and data[7] == 0x1F):
        triggeredControls.append('RIGHT_KNOB_DOWN')  # volume down
    elif(data[5] == "04"):
        triggeredControls.append('RIGHT_BUTTON_UP')  # next track
    elif(data[5] == "05"):
        triggeredControls.append('RIGHT_BUTTON_DOWN')  # prev track
    elif(data[5] == "10" and data[6] == "1F"):
        triggeredControls.append('LEFT_KNOB_UP')
    elif(data[5] == "20" and data[6] == "01"):
        triggeredControls.append('LEFT_KNOB_DOWN')
    elif(data[5] == "30"):
        triggeredControls.append('LEFT_KNOB_PRESS')
    elif(data[5] == "40"):
        triggeredControls.append('LEFT_BUTTON_UP')
    elif(data[5] == "50"):
        triggeredControls.append('LEFT_BUTTON_DOWN')

    return triggeredControls


def humanizeVoltage(data):
    voltageHex = data[1]
    voltage = int(voltageHex, 16) / 8
    return voltage

def convertByteArrayToList(bytearr): #is this really required??
    hexList = list(bytearr.hex())
    resultList = []
    for i, value in enumerate(hexList):
        if i%2 == 0:
            resultList.append(hexList[i] + hexList[i+1])
    resultList = [elem.upper() for elem in resultList]
    return resultList