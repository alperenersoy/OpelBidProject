# OpelBidProject

**This project is a work in progress. Interacting with a vehicle's CAN bus can be risky. Do note that you try this at your own risk.**

Simple Raspberry Pi based retrofit project for Opel Bid Display. It gets data from LS-CAN (also known as GMLAN) over the OBD II connector. It shows the clock, air temperature, speed, rpm, engine temperature, fuel percentage, elapsed time, driven distance, average speed and open doors. Also, it flashes hazard lights when the gear is in reverse and it should close windows when the car is locked but these functions are not working properly for now. I sniffed some CAN ids myself but most of them are from [this repo.](https://github.com/JJToB/Car-CAN-Message-DB/tree/master/Opel/Astra/H/LS-CAN) Some data such as fuelCapacity is hard coded for Opel Zafira check them if your car is different model.

## Python Dependencies
- PyQt5
- PySide2
- python-can
- easysettings
- rpi-backlight

## Hardware
- Raspberry Pi 3B+
- Waveshare 4.3-inch Capacitive Touch Display (DSI)
- MCP2515 CAN bus module (should be modified to work with Raspbery Pi. check [this repo](https://github.com/tolgakarakurt/CANBus-MCP2515-Raspi) to see how to modify and configure it.)
- DC-DC 24V/12V to 5V 5A Buck Converter ([one of these](https://www.aliexpress.com/item/33004338879.html?_randl_currency=TRY&_randl_shipto=TR&src=google&aff_fcid=a122133b4cb747229f2fd0538ca8186c-1648652823744-00204-UneMJZVf&aff_fsk=UneMJZVf&aff_platform=aaf&sk=UneMJZVf&aff_trace_key=a122133b4cb747229f2fd0538ca8186c-1648652823744-00204-UneMJZVf&terminal_id=0f17a9b78f284e9188746b9364744794&afSmartRedirect=y))
- XY-J02 12 V Time Delay Relay Module ([one of these](https://tr.aliexpress.com/item/32866640896.html?spm=a2g0o.seodetail.topbuy.1.156f2ed3Q4jdhU))
- Male OBDII Connector

## Diagram
![diagram](https://user-images.githubusercontent.com/83382417/160870396-82115a76-abf6-4911-a5ff-84959f6ca7e9.png)

## Assembling
Mounted Raspberry Pi directly to the display and added a metal back-cover which is cut in laser machine to attach cooler fan on then put it inside the box of original bid display. I didn't disconnect the bid display, removed all the parts except the board, secured it by wrapping it with something soft and heat resistant then put it somewhere inside the dashboard. We put the MCP2515 module somewhere more accessible to easily replace it when it fails, it's not in the place seen in the image below. The Buck converter and time delay relay are located in the glovebox in a box.

![assembling](https://user-images.githubusercontent.com/83382417/160884973-3893dad8-4c30-490a-8ad7-4b9155ea956d.jpg)
![assembling2](https://user-images.githubusercontent.com/83382417/160886850-f0537aa5-627f-40ed-b18d-1e678dfd9232.jpg)
![power](https://user-images.githubusercontent.com/83382417/160885530-fd9c0b45-b9d4-4dbd-a647-f3689e1de925.jpg)

## Could Be Improved
- A real-time clock module could be helpful because GMLAN gives time data but it has not any date data and I needed to format the given time data in an ugly way. ([see](https://github.com/alperenersoy/OpelBidProject/blob/main/cardata.py#L193))
- Boot time could be improved by building a custom Linux environment with buildroot. ([see](https://www.youtube.com/watch?v=yxj8ynXXgbk))
- Sometimes cranking the engine causes brownout I guess due to the current decrease. Ups can be added to solve this problem.
- I should quit dealing with electronics.

## Screenshots
![ss1](https://user-images.githubusercontent.com/83382417/160891335-53cfb453-012a-4665-8f0a-063cfd0921f3.jpg)
![ss2](https://user-images.githubusercontent.com/83382417/160891349-e5701113-ca83-4198-a7a4-7a9e7d4dcd2d.jpg)
![ss3](https://user-images.githubusercontent.com/83382417/160891351-e7ca0315-94ac-419e-9544-3d8233e11433.jpg)
![ss4](https://user-images.githubusercontent.com/83382417/160891353-e00a2b3a-045f-4cba-a2c2-d07e486684a6.jpg)
![ss5](https://user-images.githubusercontent.com/83382417/160891764-0939a3ad-e1ae-4d88-8b2f-e84bac51ebe2.jpg)

