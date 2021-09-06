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
    property alias dtc_button: dtc_button
    title: qsTr("Opel BID")
    //visibility: 'FullScreen'
    
    property double airTemp: -100
    property bool isCanOnline: false
    property bool isCarStarted: false

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
                        font.pixelSize: 24
                        anchors.leftMargin: 20
                    }

                    Rectangle {
                        id: topbar_container
                        width: 310
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
                            id: dtc_button
                            x: 260
                            y: 5
                            width: 40
                            height: 40
                            text: qsTr("Button")
                            anchors.left: parent.left
                            display: AbstractButton.IconOnly
                            flat: true
                            onClicked: swipeView.setCurrentIndex(4)
                            Image {
                                anchors.fill: parent
                                source: "qml/images/dtc.png"
                                fillMode: Image.Pad
                                z: 1
                            }

                            Rectangle {
                                id: bg_4
                                color: "#00000000"
                                radius: 0
                                border.color: "#00000000"
                                anchors.fill: parent
                            }
                            anchors.leftMargin: 210
                        }

                        Button {
                            id: settings_button
                            x: 2160
                            y: 5
                            width: 40
                            height: 40
                            text: qsTr("Button")
                            anchors.left: parent.left
                            anchors.leftMargin: 260
                            display: AbstractButton.IconOnly
                            flat: true
                            onClicked: swipeView.setCurrentIndex(5)
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
                        font.pixelSize: 24
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
                        font.pixelSize: 24
                        anchors.leftMargin: 20
                    }

                    Text {
                        id: temp1
                        y: 13
                        visible: true
                        color: "#ffffff"
                        text: airTemp
                        anchors.verticalCenter: parent.verticalCenter
                        anchors.right: parent.right
                        font.pixelSize: 24
                        Text {
                            id: degree1
                            x: 0
                            y: 0
                            color: "#ffffff"
                            text: qsTr("°C")
                            anchors.verticalCenter: parent.verticalCenter
                            anchors.right: parent.right
                            font.pixelSize: 24
                            anchors.rightMargin: -25
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
        anchors.verticalCenter: parent.verticalCenter
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
                initialItem: "qml/pages/gaugesPage.qml"
            }

        }


        Item {
            StackView {
                id: stackViewFuel
                anchors.fill: parent
                initialItem: "qml/pages/fuelPage.qml"
            }
        }

        Item {
            //info
        }

        Item {
            //dtc
            StackView {
                id: stackViewDtc
                anchors.fill: parent
                initialItem: "qml/pages/dtcPage.qml"
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
                bg_4.color='#00000000';
                bg_5.color='#00000000';
                swipeView.z = 5;
            }
            else if(currentIndex==1){
                bg_1.color = '#d9a600';
                bg_0.color='#00000000';
                bg_2.color='#00000000';
                bg_3.color='#00000000';
                bg_4.color='#00000000';
                bg_5.color='#00000000';
                swipeView.z = 0;
            }
            else if(currentIndex==2){
                bg_2.color = '#d9a600';
                bg_0.color='#00000000';
                bg_1.color='#00000000';
                bg_3.color='#00000000';
                bg_4.color='#00000000';
                bg_5.color='#00000000';
                swipeView.z = 0;
            }
            else if(currentIndex==3){
                bg_3.color = '#d9a600';
                bg_0.color='#00000000';
                bg_1.color='#00000000';
                bg_2.color='#00000000';
                bg_4.color='#00000000';
                bg_5.color='#00000000';
                swipeView.z = 0;
            }
            else if(currentIndex==4){
                bg_4.color = '#d9a600';
                bg_0.color='#00000000';
                bg_1.color='#00000000';
                bg_2.color='#00000000';
                bg_3.color='#00000000';
                bg_5.color='#00000000';
                swipeView.z = 0;
            }
            else if(currentIndex==5){
                bg_5.color = '#d9a600';
                bg_0.color='#00000000';
                bg_1.color='#00000000';
                bg_2.color='#00000000';
                bg_3.color='#00000000';
                bg_4.color='#00000000';
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

            if(backend.getSetting("autoHeadLights"))
            {
                var locale = Qt.locale();
                var autoHeadLightsStartTime = Date.fromLocaleTimeString(locale, backend.getSetting("autoHeadLightsTimeStart"), Locale.ShortFormat)
                var autoHeadLightsEndTime = Date.fromLocaleTimeString(locale, backend.getSetting("autoHeadLightsTimeEnd"), Locale.ShortFormat)
                if(new Date() > autoHeadLightsStartTime || new Date() < autoHeadLightsEndTime)
                    backend.runHeadLights()
            }

            /*stackViewGauges.currentItem.rpm = Math.floor(Math.random() * 60) + 1;
            stackViewGauges.currentItem.speed = Math.floor(Math.random() * 150) + 1;
            stackViewGauges.currentItem.engineTemp = Math.floor(Math.random() * 130) + 1;*/
        }
    }

    Connections
    {
        target: backend

        function onSpeed(speed)
        {
            if(speed)
                stackViewGauges.currentItem.speed = speed
        }

        function onRpm(rpm)
        {
            if(rpm)
                stackViewGauges.currentItem.rpm = rpm
        }

        function onEngineTemp(engineTemp)
        {
            if(engineTemp)
                stackViewGauges.currentItem.engineTemp = engineTemp
        }

        function onAirTemp(temp)
        {
            stackViewHome.currentItem.temp = temp
            airTemp = temp
        }

        function onFuelPercentage(fuelPercentage)
        {
            stackViewFuel.currentItem.fuelPercentage = fuelPercentage
        }

        function onInstantConsumption(instantConsumption)
        {
            stackViewFuel.currentItem.instantConsumption = instantConsumption
        }

        function onEstRange(estRange)
        {
            stackViewFuel.currentItem.estRange = estRange
        }

        function onTriggeredControl(triggeredControl)
        {
            if(triggeredControl == 'LEFT_KNOB_UP')
                swipeView.setCurrentIndex(swipeView.currentIndex+1)
            else if(triggeredControl == 'LEFT_KNOB_DOWN')
                swipeView.setCurrentIndex(swipeView.currentIndex-1)
        }

        function onIsEngineRunning(isEngineRunning)
        {
        }

        function onIsCanOnline(isCanOnline)
        {
        }

    }

}




