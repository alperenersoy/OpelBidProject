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

    property double airTemp: -100
    property bool isCanOnline: false
    property bool isEngineRunning: false
    property bool isIgnitionOn: false
    property bool isCruiseControlActive: false
    property bool isHeadLightsOn: false

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
                        color: "#ffffff"
                        text: qsTr("00:39")
                        anchors.verticalCenter: parent.verticalCenter
                        anchors.left: parent.left
                        font.pixelSize: 36
                        anchors.leftMargin: 20
                    }

                    Rectangle {
                        id: topbar_container
                        width: 260
                        height: 50
                        color: "#00000000"
                        border.width: 0
                        anchors.horizontalCenter: parent.horizontalCenter
                        z: 1

                        Button {
                            id: home_button
                            y: 5
                            width: 40
                            height: 40
                            text: qsTr("Gauges")
                            anchors.left: parent.left
                            hoverEnabled: true
                            enabled: true
                            highlighted: false
                            wheelEnabled: false
                            checked: false
                            checkable: false
                            flat: true
                            display: AbstractButton.IconOnly
                            z: 1
                            anchors.leftMargin: 10
                            onClicked: {swipeView.setCurrentIndex(0);}
                            Image {
                                anchors.fill: parent
                                source: "qml/images/home.png"
                                z: 1
                                fillMode: Image.Pad
                            }

                            Rectangle {
                                id: bg_0
                                color: "#d9a600"
                                radius: 0
                                border.color: "#00000000"
                                anchors.fill: parent
                            }

                        }

                        Button {
                            id: gauges_button
                            x: 60
                            y: 5
                            width: 40
                            height: 40
                            text: qsTr("Gauges")
                            anchors.left: parent.left
                            checkable: false
                            anchors.leftMargin: 60
                            display: AbstractButton.IconOnly
                            flat: true
                            onClicked: {swipeView.setCurrentIndex(1);}
                            Image {
                                anchors.fill: parent
                                source: "qml/images/car.png"
                                z: 1
                                fillMode: Image.Pad
                            }

                            Rectangle {
                                id: bg_1
                                color: "#00000000"
                                radius: 0
                                border.color: "#00000000"
                                anchors.fill: parent
                            }
                        }

                        Button {
                            id: fuel_button
                            x: 110
                            y: 5
                            width: 40
                            height: 40
                            text: qsTr("Button")
                            anchors.left: parent.left
                            anchors.leftMargin: 110
                            flat: true
                            display: AbstractButton.IconOnly
                            onClicked: swipeView.setCurrentIndex(2)
                            Image {
                                anchors.fill: parent
                                source: "qml/images/fuel.png"
                                z: 1
                                fillMode: Image.Pad
                            }

                            Rectangle {
                                id: bg_2
                                color: "#00000000"
                                radius: 0
                                border.color: "#00000000"
                                anchors.fill: parent
                            }
                        }

                        Button {
                            id: info_button
                            x: 160
                            y: 5
                            width: 40
                            height: 40
                            text: qsTr("Button")
                            anchors.left: parent.left
                            anchors.leftMargin: 160
                            display: AbstractButton.IconOnly
                            flat: true
                            onClicked: swipeView.setCurrentIndex(3)
                            Image {
                                anchors.fill: parent
                                source: "qml/images/info.png"
                                z: 1
                                fillMode: Image.Pad
                            }

                            Rectangle {
                                id: bg_3
                                color: "#00000000"
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
                            anchors.leftMargin: 210
                            display: AbstractButton.IconOnly
                            flat: true
                            onClicked: swipeView.setCurrentIndex(4)
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
                        color: "#ffffff"
                        text: airTemp == -100 ? '--' : airTemp
                        visible: airTemp != -100
                        anchors.verticalCenter: parent.verticalCenter
                        anchors.right: parent.right
                        font.pixelSize: 36
                        anchors.rightMargin: 45

                        Text {
                            id: degree
                            x: 0
                            y: 0
                            color: "#ffffff"
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
                        color: "#ffffff"
                        text: qsTr("00:39")
                        anchors.verticalCenter: parent.verticalCenter
                        anchors.left: parent.left
                        font.pixelSize: 36
                        anchors.leftMargin: 20
                    }

                    Text {
                        id: temp1
                        y: 13
                        visible: airTemp != -100
                        color: "#ffffff"
                        text: airTemp == -100 ? '--' : airTemp
                        anchors.verticalCenter: parent.verticalCenter
                        anchors.right: parent.right
                        font.pixelSize: 36
                        Text {
                            id: degree1
                            x: 0
                            y: 0
                            color: "#ffffff"
                            text: qsTr("°C")
                            anchors.verticalCenter: parent.verticalCenter
                            anchors.right: parent.right
                            font.pixelSize: 36
                            anchors.rightMargin: -25
                            visible: airTemp != -100
                        }
                        anchors.rightMargin: 45
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
        z: 5
        currentIndex: 0
        /* interactive: false*/
        Item {
            id: item1
            z: 0
            StackView {
                id: stackViewHome
                anchors.left: parent.left
                anchors.right: parent.right
                anchors.top: parent.top
                anchors.bottom: parent.bottom
                anchors.bottomMargin: 480
                z: 0
                initialItem: "qml/pages/homePage.qml"
            }
        }

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
                id: stackViewFuel
                anchors.fill: parent
                enabled: true
                initialItem: "qml/pages/fuelPage.qml"
            }
        }

        Item {
            //info
            StackView {
                id: stackViewTrips
                anchors.fill: parent
                enabled: true
                initialItem: "qml/pages/tripsPage.qml"
            }
        }

        Item {
        }

        onCurrentIndexChanged: {
            if(currentIndex==0){
                bg_0.color = '#d9a600';
                bg_1.color='#00000000';
                bg_2.color='#00000000';
                bg_3.color='#00000000';
                bg_5.color='#00000000';
                swipeView.z = 5;
            }
            else if(currentIndex==1){
                bg_1.color = '#d9a600';
                bg_0.color='#00000000';
                bg_2.color='#00000000';
                bg_3.color='#00000000';
                bg_5.color='#00000000';
                swipeView.z = 0;
            }
            else if(currentIndex==2){
                bg_2.color = '#d9a600';
                bg_0.color='#00000000';
                bg_1.color='#00000000';
                bg_3.color='#00000000';
                bg_5.color='#00000000';
                swipeView.z = 0;
            }
            else if(currentIndex==3){
                bg_3.color = '#d9a600';
                bg_0.color='#00000000';
                bg_1.color='#00000000';
                bg_2.color='#00000000';
                bg_5.color='#00000000';
                swipeView.z = 0;
            }
            else if(currentIndex==4){
                bg_5.color = '#d9a600';
                bg_0.color='#00000000';
                bg_1.color='#00000000';
                bg_2.color='#00000000';
                bg_3.color='#00000000';
                
                swipeView.z = 0;
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
            var nowDate =  Qt.formatDateTime(new Date(), "dd.MM.yyyy");
            var nowTime = Qt.formatTime(new Date(),"hh:mm");
            
            clock.text = nowTime;
            stackViewHome.currentItem.clock = nowTime;
            stackViewHome.currentItem.date = nowDate;
            var currentTripData = JSON.parse(backend.getCurrentTripData())

            if(currentTripData.elapsedTime)
                stackViewTrips.currentItem.currentElapsedTime = currentTripData.elapsedTime

            if(currentTripData.fuelConsumption)
                stackViewTrips.currentItem.currentFuelConsumption = currentTripData.fuelConsumption

            if(currentTripData.distanceTraveled)
                stackViewTrips.currentItem.currentDistanceTraveled = currentTripData.distanceTraveled

            if(currentTripData.averageSpeed)
                stackViewTrips.currentItem.currentAverageSpeed = currentTripData.averageSpeed

            //if(backend.getSetting("autoHeadLights"))
            if(false)
            {
                var locale = Qt.locale();
                var autoHeadLightsStartTime = Date.fromLocaleTimeString(locale, backend.getSetting("autoHeadLightsTimeStart"), Locale.ShortFormat)
                var autoHeadLightsEndTime = Date.fromLocaleTimeString(locale, backend.getSetting("autoHeadLightsTimeEnd"), Locale.ShortFormat)
                if(new Date() > autoHeadLightsStartTime || new Date() < autoHeadLightsEndTime)
                {
                    if(!isHeadLightsOn)
                    {
                        backend.setHeadLights(1);
                        isHeadLightsOn = true;
                    }
                }
                else
                {
                    if(isHeadLightsOn)
                    {
                        backend.setHeadLights(0);
                    }
                }
            }

            var currentInstantConsumption = backend.getCurrentInstantConsumption();
            if(currentInstantConsumption)
            {
                stackViewFuel.currentItem.instantConsumption = currentInstantConsumption;
            }

            var ignitionStatus = backend.getCurrentIgnitionStatus();
            if(ignitionStatus)
            {
                if(ignitionStatus == "ON" || ignitionStatus == "START"){
                    isIgnitionOn = true;
                    stackViewGauges.currentItem.isIgnitionOn = true;
                }
                else{
                    isIgnitionOn = false;
                    stackViewGauges.currentItem.isIgnitionOn = false;
                }
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
                stackViewHome.currentItem.temp = temp
                airTemp = temp
            }
        }

        onFuelPercentage:
        {
            var fuelPercentage = backend.getCurrentFuelPercentage()
            if(fuelPercentage != null)
                stackViewFuel.currentItem.fuelPercentage = fuelPercentage
        }

        

        onTriggeredControl:
        {
            var triggeredControl = backend.getTriggeredControl()
            if(triggeredControl == 'LEFT_KNOB_UP'){
                swipeView.setCurrentIndex(swipeView.currentIndex+1)}
            else if(triggeredControl == 'LEFT_KNOB_DOWN')
                swipeView.setCurrentIndex(swipeView.currentIndex-1)
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

        /*function onInstantConsumption(instantConsumption)
        {
            stackViewFuel.currentItem.instantConsumption = instantConsumption
        }

        function onEstRange(estRange)
        {
            stackViewFuel.currentItem.estRange = estRange
        }*/

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
        anchors.bottomMargin: 0

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

}




