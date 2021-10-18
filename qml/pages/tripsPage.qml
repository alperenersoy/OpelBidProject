import QtQuick 2

Item {
    id:tripsPage
    width:800

    property string currentElapsedTime: "" //as seconds
    property double currentFuelConsumption: 0
    property double currentDistanceTraveled:0
    property int currentAverageSpeed: 0
    property int currentFuelConsumptionOnHunderedKm : currentDistanceTraveled > 0 ? (currentFuelConsumption * 100 / currentDistanceTraveled) : 0
    
    Rectangle {
        id: rectangle1
        color: "#000000"
        anchors.fill: parent

        FontLoader{
            id: fontLoader
            source: "../fonts/Helvetica.ttf"
        }

        Rectangle {
            id: timeRect
            width: 175
            height: 80
            color: "#ffffff"
            radius: 10
            anchors.left: parent.left
            anchors.top: parent.top
            anchors.leftMargin: 20
            anchors.topMargin: 70

            Text {
                id: timeHeader
                x: 40
                font.family: fontLoader.name
                text: qsTr("Süre")
                anchors.top: parent.top
                font.pixelSize: 24
                font.bold: true
                anchors.topMargin: 10
                anchors.horizontalCenter: parent.horizontalCenter
            }

            Text {
                id: timeText
                x: 40
                text: currentElapsedTime.length > 0 ? currentElapsedTime : qsTr("--")
                anchors.top: parent.top
                font.pixelSize: 24
                anchors.topMargin: 40
                anchors.horizontalCenter: parent.horizontalCenter
                font.family: fontLoader.name
            }
        }

        Rectangle {
            id: distanceRect
            width: 175
            height: 80
            color: "#ffffff"
            radius: 10
            anchors.left: parent.left
            anchors.top: parent.top
            anchors.topMargin: 70
            anchors.leftMargin: 215

            Text {
                id: distanceHeader
                x: 40
                font.family: fontLoader.name
                text: qsTr("Mesafe")
                anchors.top: parent.top
                font.pixelSize: 24
                font.bold: true
                anchors.topMargin: 10
                anchors.horizontalCenter: parent.horizontalCenter
            }

            Text {
                id: distanceText
                x: 40
                text: currentDistanceTraveled > 0 ? currentDistanceTraveled + " km" : qsTr("--")
                anchors.top: parent.top
                font.pixelSize: 24
                anchors.topMargin: 40
                anchors.horizontalCenter: parent.horizontalCenter
                font.family: fontLoader.name
            }
        }

        Rectangle {
            id: averageSpeedRect
            width: 175
            height: 80
            color: "#ffffff"
            radius: 10
            anchors.left: parent.left
            anchors.top: parent.top
            anchors.topMargin: 70
            anchors.leftMargin: 605

            Text {
                id: averageSpeedHeader
                x: 40
                font.family: fontLoader.name
                text: qsTr("Ortalama Hız")
                anchors.top: parent.top
                font.pixelSize: 24
                font.bold: true
                anchors.topMargin: 10
                anchors.horizontalCenter: parent.horizontalCenter
            }

            Text {
                id: averageSpeedText
                x: 40
                text: currentAverageSpeed > 0 ? currentAverageSpeed + " km/s": qsTr("--")
                anchors.top: parent.top
                font.pixelSize: 24
                anchors.topMargin: 40
                anchors.horizontalCenter: parent.horizontalCenter
                font.family: fontLoader.name
            }
        }

        Rectangle {
            id: fuelRect
            width: 175
            height: 80
            color: "#ffffff"
            radius: 10
            anchors.left: parent.left
            anchors.top: parent.top
            anchors.leftMargin: 410
            anchors.topMargin: 70

            Text {
                id: fuelHeader
                x: 40
                font.family: fontLoader.name
                text: qsTr("Yakıt Tüketimi")
                anchors.top: parent.top
                font.pixelSize: 24
                font.bold: true
                anchors.topMargin: 10
                anchors.horizontalCenter: parent.horizontalCenter
            }

            Text {
                id: fuelText
                x: 40
                text: currentFuelConsumption > 0 ? currentFuelConsumption + " L": qsTr("--")
                anchors.top: parent.top
                font.pixelSize: 24
                anchors.topMargin: 40
                anchors.horizontalCenter: parent.horizontalCenter
                font.family: fontLoader.name
            }
        }

        ListView {
            id: listView
            anchors.left: parent.left
            anchors.right: parent.right
            anchors.top: parent.top
            anchors.bottom: parent.bottom
            anchors.bottomMargin: 0
            anchors.topMargin: 170
            anchors.rightMargin: 8
            anchors.leftMargin: 8
            visible: false
            delegate: Row {
                height: 80
                anchors.left: parent.left
                anchors.right: parent.right
                Rectangle{
                    color: '#ffffff'
                    anchors.fill: parent
                    anchors.bottomMargin: 10
                    anchors.leftMargin: 10
                    anchors.rightMargin: 10
                    radius: 10
                    Text {
                        text: dates
                        anchors.horizontalCenter:  parent.horizontalCenter
                        x: 10
                        y:7.5
                        font.bold: true
                    }
                    Text {
                        id: text1
                        x: 0
                        width: 175
                        text: elapsedTime
                        anchors.top: parent.top
                        anchors.bottom: parent.bottom
                        font.pixelSize: 12
                        horizontalAlignment: Text.AlignHCenter
                        verticalAlignment: Text.AlignVCenter
                        anchors.bottomMargin: 0
                        anchors.topMargin: 0
                    }

                    Text {
                        id: text2
                        x: 195
                        width: 175
                        text: distanceTraveled
                        anchors.top: parent.top
                        anchors.bottom: parent.bottom
                        font.pixelSize: 12
                        horizontalAlignment: Text.AlignHCenter
                        verticalAlignment: Text.AlignVCenter
                        anchors.bottomMargin: 0
                        anchors.topMargin: 0
                    }

                    Text {
                        id: text3
                        x: 390
                        width: 175
                        text: fuelConsumption
                        anchors.top: parent.top
                        anchors.bottom: parent.bottom
                        font.pixelSize: 12
                        horizontalAlignment: Text.AlignHCenter
                        verticalAlignment: Text.AlignVCenter
                        anchors.bottomMargin: 0
                        anchors.topMargin: 0
                    }

                    Text {
                        id: text4
                        x: 585
                        width: 175
                        text: averageSpeed
                        anchors.top: parent.top
                        anchors.bottom: parent.bottom
                        font.pixelSize: 12
                        horizontalAlignment: Text.AlignHCenter
                        verticalAlignment: Text.AlignVCenter
                        anchors.bottomMargin: 0
                        anchors.topMargin: 0
                    }
                }
            }
            model: ListModel {
                ListElement {
                    dates: "02.10.2021 13:24 - 02.10.2021 13:34"
                    elapsedTime:"10s 10dk"
                    distanceTraveled:"1000 KM"
                    fuelConsumption: "58 L"
                    averageSpeed: "999 KM"
                }
                ListElement {
                    dates: "02.10.2021 13:24 - 02.10.2021 13:34"
                    elapsedTime:"10s 10dk"
                    distanceTraveled:"1000 KM"
                    fuelConsumption: "58 L"
                    averageSpeed: "999 KM"
                }
                ListElement {
                    dates: "02.10.2021 13:24 - 02.10.2021 13:34"
                    elapsedTime:"10s 10dk"
                    distanceTraveled:"1000 KM"
                    fuelConsumption: "58 L"
                    averageSpeed: "999 KM"
                }
                ListElement {
                    dates: "02.10.2021 13:24 - 02.10.2021 13:34"
                    elapsedTime:"10s 10dk"
                    distanceTraveled:"1000 KM"
                    fuelConsumption: "58 L"
                    averageSpeed: "999 KM"
                }
                ListElement {
                    dates: "02.10.2021 13:24 - 02.10.2021 13:34"
                    elapsedTime:"10s 10dk"
                    distanceTraveled:"1000 KM"
                    fuelConsumption: "58 L"
                    averageSpeed: "999 KM"
                }
            }
        }
    }

}



/*##^##
Designer {
    D{i:0;formeditorZoom:1.1}
}
##^##*/
