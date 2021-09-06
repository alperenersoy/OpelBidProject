import time
import can
import math

counter = 0
direction = 0 # 0: forward 1: backward
speedRmpRate = 3.25  # calculated for 8000 rpm and 260 km/s speed
start_time = time.time()
interval = 0.0020 # timer interval as seconds
tour = 0  # timer tour
while True:
    current_time = time.time()
    elapsed_time = current_time - start_time
    if math.floor(elapsed_time / interval) > tour:
        # time ticked
        if direction==0:
            if counter <= 260:
                speed1 = int(math.floor(counter/256))
                speed2 = int(counter % 256)
                rpm1 = int(math.floor(counter*100/speedRmpRate/256))
                rpm2 = int(math.ceil(counter*100/speedRmpRate)) % 256
                counter += 1
            else:
                direction = 1
        elif direction==1:
            if counter >= 0:
                speed1 = int(math.floor(counter/256))
                speed2 = int(counter % 256)
                rpm1 = int(math.floor(counter*100/speedRmpRate/256))
                rpm2 = int(math.ceil(counter*100/speedRmpRate)) % 256
                counter -= 1
            else:
                break

        msg = can.Message(arbitration_id=0x108,
                            data=[0, rpm1, rpm2, 0, speed1, speed2, 0, 0])

        print(msg)
       
        tour += 1