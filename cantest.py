import can

bus = can.interface.Bus(bustype='socketcan',
                                channel='can0', bitrate=33300)

while True:
    msg = bus.recv()
    print(msg)
