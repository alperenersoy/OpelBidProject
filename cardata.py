import can
from datetime import datetime, timedelta
from easysettings import EasySettings

settings = EasySettings("settings.conf")


fuelCapacity = 58  # For Opel Zafira B

canMessages = {
    0x108:  "MOTION",  # speed and rpm
    0x145:  "ENGINE",  # coolant, running state and cruise control
    0x235:  "BACKLIGHT",
    0x445:  "AIR_TEMP",
    0x375:  "FUEL_LEVEL",
    0x175:  "SW_CONTROL",  # any steering wheel control including turn signals and glass wash
    0x500:  "VOLTAGE",
    0x230:  "DOOR_OPEN",
    0x260:  "HAZARD_LIGHTS",
    0X305:  "HEAD_LIGHTS",
    0X350:  "GEAR_STATUS",  # reverse or not
    0X370:  "HANDBRAKE_STATUS",
    0x170:  "IGNITION_STATUS",
    0x160:  "KEY_BUTTONS",
    0x110:  "DISTANCE_TRAVELED",
    0x440:  "TIME"
}

# constants
HAZARD_LIGHTS_ON = can.Message(arbitration_id=0x260, data=[
                                0x1F, 0x43, 0x7F], is_extended_id=False)
HAZARD_LIGHTS_ON2 = can.Message(arbitration_id=0x305, data=[
                               0x00, 0x00, 0x00, 0x10, 0x00, 0x10, 0x80, 0x00], is_extended_id=False)
HAZARD_LIGHTS_OFF = can.Message(arbitration_id=0x260,
                                data=[0x00, 0x00, 0x00], is_extended_id=False)
HAZARD_LIGHTS_OFF2 = can.Message(arbitration_id=0x305, data=[
                                 0x00, 0x00, 0x00, 0x10, 0x00, 0x10, 0x80, 0x00], is_extended_id=False)
SIDE_LIGHTS_ON = can.Message(arbitration_id=0x305,
                             data=[0x00, 0x00, 0x40, 0x00, 0x10, 0x00, 0x00, 0x00], is_extended_id=False)  # must be send in a loop. automatic off
HEAD_LIGHTS_ON = can.Message(arbitration_id=0x305,
                             data=[0x00, 0x00, 0xC0, 0x00, 0x10, 0x00, 0x80, 0x00], is_extended_id=False)  # must be send in a loop. automatic off
HIGH_BEAM_LIGHTS_ON = can.Message(arbitration_id=175,
                                  data=[0x08, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00], is_extended_id=False)
HIGH_BEAM_LIGHTS_OFF = can.Message(arbitration_id=175,
                                   data=[0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00], is_extended_id=False)
KEY_BUTTONS_LOCK = can.Message(arbitration_id=0x160,
                               data=[0x02, 0x40, 0x05, 0x8F], is_extended_id=False)
KEY_BUTTONS_UNLOCK = can.Message(arbitration_id=0x160,
                                 data=[0x02, 0x10, 0x05, 0x8F], is_extended_id=False)
KEY_BUTTONS_LOCK_HOLD = can.Message(arbitration_id=0x160,
                                    data=[0x02, 0xC0, 0x05, 0x8F], is_extended_id=False)  # closing windows
KEY_BUTTONS_UNLOCK_HOLD = can.Message(arbitration_id=0x160,
                                      data=[0x02, 0x30, 0x05, 0x8F], is_extended_id=False)  # opening windows


def humanizeMotionData(data):
    data = convertByteArrayToList(data)
    isIgnitionOn = (False, True)[data[0] == "03"]  # before running engine
    isEngineRunning = (False, True)[data[0] == "13" or data[0] == "23"]
    speedHex = data[4] + data[5]
    speed = int(round(int(speedHex, 16) / 128))
    rpmHex = data[1] + data[2]
    rpm = int(rpmHex, 16) / 4
    return {"isIgnitionOn": isIgnitionOn, "isEngineRunning": isEngineRunning, "speed": speed, "rpm": rpm}


def humanizeEngineData(data):
    data = convertByteArrayToList(data)
    isCruiseControlActive = (False, True)[data[5] == "06"]
    engineTempHex = data[3]
    engineTemp = int(engineTempHex, 16) - 40
    return {"isCruiseControlActive": isCruiseControlActive, "engineTemp": engineTemp}


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

    if(data[5] == "01" and data[7] == "01"):
        triggeredControls.append('RIGHT_KNOB_UP')  # volume up
    elif(data[5] == "02" and data[7] == "1F"):
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


def humanizeDoorOpenData(data):
    data = convertByteArrayToList(data)
    openDoors = []
    if data[2] == "40":
        openDoors.append("FRONT_LEFT")
    elif data[2] == "04":
        openDoors.append("TRUNK")
    elif data[1] == "50" and data[2] == "10":
        openDoors.append("BACK_RIGHT")
    elif data[1] == "50" and data[2] == "50":
        openDoors.append("FRONT_LEFT")
        openDoors.append("BACK_RIGHT")
    elif data[1] == "50" and data[2] == "14":
        openDoors.append("TRUNK")
        openDoors.append("BACK_RIGHT")
    elif data[1] == "50" and data[2] == "54":
        openDoors.append("FRONT_LEFT")
        openDoors.append("BACK_RIGHT")
        openDoors.append("TRUNK")
    return openDoors


def humanizeGearData(data):
    data = convertByteArrayToList(data)
    if data[0] == "12" or data[0] == "16":
        return "REVERSE"
    elif data[0] == "02" or data[2] == "06":
        return "NOT_REVERSE"


def humanizeHandBrakeData(data):
    data = convertByteArrayToList(data)
    if data[0] == "01":
        return "PULLED"
    elif data[0] == "00":
        return "NOT_PULLED"


def humanizeIgnitionData(data):
    data = convertByteArrayToList(data)
    if data[0] == "70":
        return "LOCK"
    elif data[0] == "72":
        return "ACCESSORY"
    elif data[0] == "74":
        return "ON"
    elif data[0] == "76":
        return "START"


def humanizeDistanceData(data):
    data = convertByteArrayToList(data)
    frontLeftWheelDistanceHex = data[1] + data[2]
    frontRightWheelDistanceHex = data[3] + data[4]
    frontLeftWheelDistance = int(
        frontLeftWheelDistanceHex, 16) * 1.5748 / 1000   # as meters
    frontRightWheelDistance = int(
        frontRightWheelDistanceHex, 16) * 1.5748 / 1000  #as meters
    # mean of distances in case of getting different values
    meanDistance = (frontLeftWheelDistance + frontRightWheelDistance) / 2
    return meanDistance


def humanizeTimeData(data):
    data = convertByteArrayToList(data)
    hour = str(int(int(data[0], 16) / 8)).zfill(2)
    minute = str(int(int(data[1], 16) / 4)).zfill(2)
    second = str(int(int(data[2], 16) / 4)).zfill(2)
    fullDateTime = hour+':'+minute+':'+second
    format = '%H:%M:%S'
    time = datetime.strptime(fullDateTime, format)
    hourDifference = int(settings.get("hourDifference")) if settings.has_option("hourDifference") else 0
    minuteDifference = int(settings.get("minuteDifference")) if settings.has_option("minuteDifference") else 0
    # fix wrong date time
    fixedDate = time
    if(hourDifference >= 0):
        fixedDate = fixedDate + timedelta(hours=abs(hourDifference))
    elif(hourDifference < 0):
        fixedDate = fixedDate - timedelta(hours=abs(hourDifference))
    if(minuteDifference >= 0):
        fixedDate = fixedDate + timedelta(minutes=abs(minuteDifference))
    elif(hourDifference < 0):
        fixedDate = fixedDate - timedelta(minutes=abs(minuteDifference))

    finalTime = fixedDate.strftime("%H:%M")
    return {"time": finalTime}

def humanizeBacklightData(data):
    data = convertByteArrayToList(data)
    if(data[1] == "00"):
        return 0 #day mode
    else:
        return 1 #night mode


def convertByteArrayToList(bytearr):  # is this really required??
    hexList = list(bytearr.hex())
    resultList = []
    for i, value in enumerate(hexList):
        if i % 2 == 0:
            resultList.append(hexList[i] + hexList[i+1])
    resultList = [elem.upper() for elem in resultList]
    return resultList
