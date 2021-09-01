import QtQuick 2
import QtQuick.Window 2
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

    property double airTemp: 0
    property bool isOBDOnline: false
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
                        text: airTemp
                        anchors.verticalCenter: parent.verticalCenter
                        anchors.right: parent.right
                        font.pixelSize: 24
                        anchors.rightMargin: 45
                        visible:isOBDOnline

                        Text {
                            id: degree
                            x: 0
                            y: 0
                            color: "#ffffff"
                            text: qsTr("°C")
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
                        visible: isOBDOnline
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
        anchors.fill: parent
        orientation: Qt.Horizontal
        z: 5
        currentIndex: 0
        anchors.topMargin: 0
        /* interactive: false*/
        Item {
            z: 0
            StackView {
                id: stackViewHome
                anchors.fill: parent
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
        interval: 1
        repeat: true
        running: true

        onTriggered:
        {
            clock.text = Qt.formatTime(new Date(),"hh:mm");
            stackViewHome.currentItem.date = Qt.formatDateTime(new Date(), "dd.MM.yyyy")
            stackViewHome.currentItem.clock = Qt.formatTime(new Date(),"hh:mm");

            /*if(backend.checkOBDConnection()){
                if(isOBDOnline==false)
                {
                    isOBDOnline = true;
                    swipeView.interactive = true;
                    stackViewHome.currentItem.isOBDOnline = true;
                    stackViewGauges.currentItem.isOBDOnline = true;
                    stackViewDtc.currentItem.isOBDOnline=true;
                }
            }
            else{
                    isOBDOnline = false;
                    stackViewHome.currentItem.isOBDOnline = false;
                    stackViewGauges.currentItem.isOBDOnline = false;
                    stackViewDtc.currentItem.isOBDOnline=false;
                    swipeView.setCurrentIndex(0);
                    swipeView.interactive = false;
            }*/
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

    }

}




