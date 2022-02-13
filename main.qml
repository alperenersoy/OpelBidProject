import QtQuick 2
import QtQuick.Window 2.3
import QtQuick.Controls 2
import 'qml/pages' as Pages

Window {
    id: window
    width: 800
    height: 480
    visible: true
    color: "#000000"
    title: qsTr("Opel BID")
    visibility: Screen.height === 480 ? 'FullScreen' : 'Windowed'  //for 800x480 raspberry pi screen only

   Loader{
    asynchronous: true
   }

    property double airTemp: -100
    property bool isCanOnline: false
    property bool isEngineRunning: false
    property bool isIgnitionOn: false
    property bool isCruiseControlActive: false
    property string currentOpenDoors: ""
    property double currentFuelPercentage: 0
    property string currentElapsedTime: "" //as seconds
    property double currentDistanceTraveled:0
    property int currentAverageSpeed: 0

    Rectangle {
        id: topbar
        height: 50
        color: "#00000000"
        anchors.left: parent.left
        anchors.right: parent.right
        anchors.top: parent.top
        anchors.leftMargin: 0
        z: 4
        anchors.rightMargin: 0
        anchors.topMargin: 0

        SwipeView {
            id: toolbar_swipe
            anchors.fill: parent
            orientation: Qt.Horizontal

            Component.onCompleted: {
                var currentTopBarSetting = backend.getSetting("currentTopBar")
                if(currentTopBarSetting)
                    toolbar_swipe.setCurrentIndex(parseInt(currentTopBarSetting))
            }

            onCurrentIndexChanged:{
                backend.setSetting('currentTopBar', toolbar_swipe.currentIndex)
            }

            Item {
                Rectangle {
                    id: topbar1
                    height: 50
                    color: "#000000"
                    anchors.left: parent.left
                    anchors.right: parent.right
                    anchors.top: parent.top
                    z: 4
                    anchors.rightMargin: 0
                    anchors.leftMargin: 0
                    anchors.topMargin: 0
                    Text {
                        id: clock
                        y: 13
                        color: "#ededed"
                        text: qsTr("--:--")
                        anchors.verticalCenter: parent.verticalCenter
                        anchors.right: parent.right
                        font.pixelSize: 36
                        anchors.rightMargin: 20
                    }

                    Rectangle {
                        id: topbar_container
                        width: 110
                        height: 50
                        color: "#00000000"
                        border.width: 0
                        anchors.horizontalCenter: parent.horizontalCenter
                        z: 1

                        Button {
                            id: gauges_button
                            x: 10
                            y: 5
                            width: 40
                            height: 40
                            text: qsTr("Gauges")
                            anchors.left: parent.left
                            checkable: false
                            anchors.leftMargin: 10
                            display: AbstractButton.IconOnly
                            flat: true
                            onClicked: {swipeView.setCurrentIndex(0);}
                            Image {
                                anchors.fill: parent
                                source: "qml/images/car.png"
                                z: 1
                                fillMode: Image.Pad
                            }

                            Rectangle {
                                id: bg_1
                                color: "#d9a600"
                                radius: 0
                                border.color: "#00000000"
                                anchors.fill: parent
                            }
                        }

                        Button {
                            id: settings_button
                            x: 2160
                            y: 5
                            width: 40
                            height: 40
                            text: qsTr("Button")
                            anchors.left: parent.left
                            anchors.leftMargin: 60
                            display: AbstractButton.IconOnly
                            flat: true
                            onClicked: swipeView.setCurrentIndex(1)
                            Image {
                                anchors.fill: parent
                                source: "qml/images/settings.png"
                                z: 1
                                fillMode: Image.Pad
                            }

                            Rectangle {
                                id: bg_5
                                color: "#00000000"
                                radius: 0
                                border.color: "#00000000"
                                anchors.fill: parent
                            }
                        }


                    }

                    Text {
                        id: temp
                        y: 13
                        color: "#ededed"
                        text: airTemp == -100 ? '--' : airTemp
                        visible: airTemp != -100
                        anchors.verticalCenter: parent.verticalCenter
                        anchors.left: parent.left
                        font.pixelSize: 36
                        anchors.leftMargin: 20

                        Text {
                            id: degree
                            x: 0
                            y: 0
                            color: "#ededed"
                            text: qsTr("°C")
                            visible: airTemp != -100
                            anchors.verticalCenter: parent.verticalCenter
                            anchors.right: parent.right
                            font.pixelSize: 24
                            anchors.rightMargin: -25
                        }
                    }

                }
            }

            Item {
                Rectangle {
                    id: topbar2
                    color: "#00000000"
                    anchors.fill: parent
                    Text {
                        id: clock1
                        y: 13
                        color: "#ededed"
                        text: qsTr("00:39")
                        anchors.verticalCenter: parent.verticalCenter
                        anchors.right: parent.right
                        font.pixelSize: 36
                        anchors.rightMargin: 20
                    }

                    Text {
                        id: temp1
                        y: 13
                        visible: airTemp != -100
                        color: "#ededed"
                        text: airTemp == -100 ? '--' : airTemp
                        anchors.verticalCenter: parent.verticalCenter
                        anchors.left: parent.left
                        font.pixelSize: 36
                        anchors.leftMargin: 20
                        Text {
                            id: degree1
                            x: 0
                            y: 0
                            color: "#ededed"
                            text: qsTr("°C")
                            anchors.verticalCenter: parent.verticalCenter
                            anchors.right: parent.right
                            font.pixelSize: 36
                            anchors.rightMargin: -25
                            visible: airTemp != -100
                        }
                    }
                    z: 4
                }
            }

            Item {
            }
        }
    }

    SwipeView {
        id: swipeView
        anchors.left: parent.left
        anchors.top: parent.top
        anchors.bottom: parent.bottom
        anchors.horizontalCenter: parent.horizontalCenter
        orientation: Qt.Horizontal
        currentIndex: 0
        /* interactive: false*/

        Item {
            StackView {
                id: stackViewGauges
                anchors.fill: parent
                enabled: true
                initialItem: "qml/pages/gaugesPage.qml"
            }

        }


        Item {
            StackView {
                id: stackViewSettings
                anchors.fill: parent
                enabled: true
                initialItem: "qml/pages/settingsPage.qml"
            }
        }

        onCurrentIndexChanged: {
            if(currentIndex==0){
                bg_1.color = '#d9a600';
                bg_5.color='#00000000';
            }
            else if(currentIndex==1){
                bg_5.color = '#d9a600';
                bg_1.color='#00000000';
            }
        }
    }

    Timer {
        id: timer
        interval: 750
        repeat: true
        running: true

        onTriggered:
        {
            var nowTime = "--:--";
            
            var time = backend.getCurrentTime();

            if(time != "")
                nowTime = time

            clock.text = nowTime;

            var currentTripData = JSON.parse(backend.getCurrentTripData())

            if(currentTripData.elapsedTime)
                currentElapsedTime = currentTripData.elapsedTime

            if(currentTripData.distanceTraveled)
                currentDistanceTraveled = currentTripData.distanceTraveled

            if(currentTripData.averageSpeed)
                currentAverageSpeed = currentTripData.averageSpeed

            if(backend.getOpenDoors() != currentOpenDoors)
            {
                var openDoors = JSON.parse(backend.getOpenDoors());
                stackViewDoorOpen.currentItem.frontLeftOpen = false;
                stackViewDoorOpen.currentItem.frontRightOpen = false;
                stackViewDoorOpen.currentItem.backLeftOpen = false;
                stackViewDoorOpen.currentItem.backRightOpen = false;
                stackViewDoorOpen.currentItem.trunkOpen = false;

                if(openDoors.length>0)
                {
                    for(var i=0; i< openDoors.length; i++)
                    {
                        if(openDoors[i] == "FRONT_LEFT")
                            stackViewDoorOpen.currentItem.frontLeftOpen = true;
                        if(openDoors[i] == "FRONT_RIGHT")
                            stackViewDoorOpen.currentItem.frontRightOpen = true;
                        if(openDoors[i] == "BACK_LEFT")
                            stackViewDoorOpen.currentItem.backLeftOpen = true;
                        if(openDoors[i] == "BACK_RIGHT")
                            stackViewDoorOpen.currentItem.backRightOpen = true;
                        if(openDoors[i] == "TRUNK")
                            stackViewDoorOpen.currentItem.trunkOpen = true;
                    }
                    openDoorsMouseArea.visible = true;
                }
                else
                    openDoorsMouseArea.visible = false;
                
                currentOpenDoors = backend.getOpenDoors();
            }

            var ignitionOn = backend.getIsIgnitionOn();
            if(ignitionOn)
            {
                isIgnitionOn = true;
                stackViewGauges.currentItem.isIgnitionOn = true;
            }
            else{
                isIgnitionOn = false;
                stackViewGauges.currentItem.isIgnitionOn = false;
            }
            
        }
    }

    MouseArea {
        id: openDoorsMouseArea
        anchors.fill: parent
        z: 10
        visible: false
        onClicked: {
            if(openDoorsMouseArea.visible==true)
            {
                openDoorsMouseArea.visible=false;
            }
        }

        StackView {
            id: stackViewDoorOpen
            x: 240
            y: 80
            width: 320
            height: 320
            anchors.verticalCenter: parent.verticalCenter
            anchors.horizontalCenter: parent.horizontalCenter
            z: 10
            initialItem: "qml/pages/doorOpen.qml"
            visible: true

            Button {
                id: button
                width: 40
                text: qsTr("")
                anchors.right: parent.right
                z: 6
                display: AbstractButton.IconOnly
                autoRepeat: false
                flat: true
                anchors.rightMargin: 0
                onClicked: {
                    openDoorsMouseArea.visible = false;
                }

                Rectangle {
                    id: rectangle
                    color: "#00000000"
                    anchors.fill: parent
                }

                Text {
                    id: text1
                    color: "#ffffff"
                    text: qsTr("x")
                    anchors.fill: parent
                    font.pixelSize: 20
                    horizontalAlignment: Text.AlignHCenter
                    verticalAlignment: Text.AlignVCenter
                }

            }
        }
    }

    Rectangle {
        id: errorBar
        y: 232
        height: 50
        visible: false
        color: "#00000000"
        anchors.left: parent.left
        anchors.right: parent.right
        anchors.bottom: parent.bottom
        anchors.rightMargin: 0
        anchors.leftMargin: 0
        anchors.bottomMargin: 50

        Text {
            id: errorMessage
            x: 700
            y: 0
            color: "#ffffff"
            text: "<!DOCTYPE HTML PUBLIC \"-//W3C//DTD HTML 4.0//EN\" \"http://www.w3.org/TR/REC-html40/strict.dtd\">\n<html><head><meta name=\"qrichtext\" content=\"1\" /><style type=\"text/css\">\np, li { white-space: pre-wrap; }\n</style></head><body style=\" font-family:'MS Shell Dlg 2'; font-size:7.8pt; font-weight:400; font-style:normal;\">\n<p style=\" margin-top:0px; margin-bottom:0px; margin-left:0px; margin-right:0px; -qt-block-indent:0; text-indent:0px;\">Error Message</p></body></html>"
            anchors.verticalCenter: parent.verticalCenter
            font.pixelSize: 15
            horizontalAlignment: Text.AlignHCenter
            verticalAlignment: Text.AlignVCenter
            fontSizeMode: Text.FixedSize
            textFormat: Text.RichText
            anchors.horizontalCenter: parent.horizontalCenter

            Image {
                id: image
                width: 36
                height: 36
                anchors.verticalCenter: parent.verticalCenter
                anchors.left: parent.left
                anchors.top: parent.top
                source: "qml/images/warning.png"
                anchors.leftMargin: -50
                anchors.topMargin: -10
                fillMode: Image.PreserveAspectFit
            }
        }

    }

    MouseArea {
        id: mouseArea
        x: 700
        y: 0
        width: 100
        height: 50
        anchors.right: parent.right
        anchors.rightMargin: 0
        preventStealing: false
        acceptedButtons: Qt.LeftButton
        hoverEnabled: false
        z: 50
        onDoubleClicked: {
            if(window.visibility == 2)
                window.visibility = "FullScreen";
            else if(window.visibility == 5)
                window.visibility = "Windowed";
        }
    }

    Rectangle {
        id: bottombar
        y: 50
        height: 50
        color: "#00000000"
        anchors.left: parent.left
        anchors.right: parent.right
        anchors.bottom: parent.bottom
        anchors.bottomMargin: 0
        anchors.leftMargin: 0
        anchors.rightMargin: 0
        Rectangle {
            id: fuel_mask
            x: 0
            width: 40
            height: 20
            color: "#000000"
            radius: 0
            border.width: 0
            anchors.verticalCenter: parent.verticalCenter
            anchors.right: parent.right
            anchors.rightMargin: 642
            rotation: 0
            transformOrigin: Item.Center
            z: 2
            clip: false

            Text {
                id: fuelPercentage
                color: "#ededed"
                text: currentFuelPercentage > 0 ? "%" + currentFuelPercentage.toFixed(2) : "--"
                anchors.verticalCenter: parent.verticalCenter
                anchors.left: parent.left
                font.pixelSize: 18
                anchors.leftMargin: 10
               onTextChanged: PropertyAnimation {
                   target: fuel_mask; property: "width"; to: fuel_gradient.height - ((parseInt(currentFuelPercentage)/100)*fuel_gradient.height);
               }
            }
        }

        Rectangle {
            id: fuel_gradient
            y: 0
            width: 20
            height: 98
            radius: 10
            border.color: "#00000000"
            border.width: 0
            anchors.verticalCenter: parent.verticalCenter
            anchors.left: parent.left
            anchors.leftMargin: 99
            rotation: 270
            clip: false
            gradient: Gradient {
                GradientStop {
                    position: 0
                    color: "#ededed"
                }

                GradientStop {
                    position: 0.1
                    color: "#ededed"
                }

                GradientStop {
                    position: 0.665
                    color: "#ededed"
                }

                GradientStop {
                    position: 0.83
                    color: "#ededed"
                }


            }
        }

        Image {
            id: fuelImage
            y: 0
            width: 30
            height: 30
            anchors.verticalCenter: parent.verticalCenter
            anchors.left: parent.left
            source: "qml/images/fuel.png"
            anchors.leftMargin: 20
            fillMode: Image.PreserveAspectFit
        }

        Rectangle {
            id: trip_info
            width: 450
            height: 50
            color: "#00000000"
            anchors.right: parent.right
            anchors.rightMargin: 20

            Image {
                id: timerImage
                y: 0
                width: 30
                height: 30
                anchors.verticalCenter: parent.verticalCenter
                anchors.left: parent.left
                source: "qml/images/timer.png"
                anchors.leftMargin: 0
                fillMode: Image.PreserveAspectFit

                Text {
                    id: timerText
                    width: 100
                    color: "#ededed"
                    text: currentElapsedTime.length > 0 ? currentElapsedTime : qsTr("--")
                    anchors.left: parent.left
                    anchors.top: parent.top
                    anchors.bottom: parent.bottom
                    font.pixelSize: 20
                    horizontalAlignment: Text.AlignHCenter
                    verticalAlignment: Text.AlignVCenter
                    textFormat: Text.RichText
                    anchors.leftMargin: 40
                    anchors.bottomMargin: 0
                    anchors.topMargin: 0
                }
            }

            Image {
                id: distanceImage
                y: 0
                width: 30
                height: 30
                anchors.verticalCenter: parent.verticalCenter
                anchors.left: parent.left
                source: "qml/images/road.png"
                anchors.leftMargin: 150
                fillMode: Image.PreserveAspectFit

                Text {
                    id: distanceText
                    width: 100
                    color: "#ededed"
                    text: currentDistanceTraveled > 0 ? currentDistanceTraveled.toFixed(2) + " km" : qsTr("--")
                    anchors.left: parent.left
                    anchors.top: parent.top
                    anchors.bottom: parent.bottom
                    font.pixelSize: 20
                    horizontalAlignment: Text.AlignHCenter
                    verticalAlignment: Text.AlignVCenter
                    anchors.leftMargin: 40
                    anchors.topMargin: 0
                    anchors.bottomMargin: 0
                }
            }

            Image {
                id: speedImage
                y: 0
                width: 30
                height: 30
                anchors.verticalCenter: parent.verticalCenter
                anchors.left: parent.left
                source: "qml/images/speed.png"
                anchors.leftMargin: 300
                fillMode: Image.PreserveAspectFit

                Text {
                    id: speedText
                    width: 100
                    color: "#ededed"
                    text: currentAverageSpeed > 0 ? currentAverageSpeed.toFixed(0) + " km/s": qsTr("--")
                    anchors.left: parent.left
                    anchors.top: parent.top
                    anchors.bottom: parent.bottom
                    font.pixelSize: 20
                    horizontalAlignment: Text.AlignHCenter
                    verticalAlignment: Text.AlignVCenter
                    anchors.leftMargin: 40
                    anchors.topMargin: 0
                    anchors.bottomMargin: 0
                }
            }
        }

    }

    Connections
    {
        target: backend

        onSpeed: //new syntax didn't work on raspberry pi and i had to solve like this.
        {
            var speed = backend.getCurrentSpeed()
            if(speed != null)
                stackViewGauges.currentItem.speed = speed
        }

        onRpm:
        {
            var rpm  = backend.getCurrentRpm()
            if(rpm != null)
                stackViewGauges.currentItem.rpm = rpm
        }

        onEngineTemp:
        {
            var engineTemp = backend.getCurrentEngineTemp()
            if(engineTemp != null)
                stackViewGauges.currentItem.engineTemp = engineTemp
        }

        onAirTemp:
        {
            var temp = backend.getCurrentAirTemp()
            if(temp != null)
            {
                airTemp = temp
            }
        }

        onFuelPercentage:
        {
            var fuelPercentage = backend.getCurrentFuelPercentage()
            if(fuelPercentage != null)
                currentFuelPercentage = fuelPercentage
        }

        

        onTriggeredControl:
        {
            var triggeredControl = backend.getTriggeredControl()
            stackViewGauges.currentItem.triggeredControl = triggeredControl
        }

        onIsCanOnline:
        {
            var isCanOnline = backend.getCurrentIsCanOnline()
            if(!isCanOnline){
                //can bus can not be initialized. show error?
                errorMessage.text = "Can başlatılamadı!"
                errorBar.visible = true
            }
            else
            {
                errorMessage.text = ""
                errorBar.visible = false
            }
        }

        onIsCruiseControlActive:
        {
            var isCruiseControlActive = backend.getCurrentIsCruiseControlActive()
            stackViewGauges.currentItem.isCruiseControlActive = isCruiseControlActive
        }

    }







}





/*##^##
Designer {
    D{i:0;formeditorZoom:0.9}D{i:21;locked:true}D{i:26;locked:true}D{i:34;locked:true}
}
##^##*/
