import QtQuick 2.0

Item {
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
                text: currentElapsedTime > 0 ? currentElapsedTime : qsTr("--")
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
            anchors.rightMargin: 0
            anchors.leftMargin: 0
            delegate: Item {
                x: 5
                width: 80
                height: 40
                Row {
                    id: row1
                    spacing: 10
                    Rectangle {
                        width: 40
                        height: 40
                        color: colorCode
                    }

                    Text {
                        text: name
                        anchors.verticalCenter: parent.verticalCenter
                        font.bold: true
                    }
                }
            }
            model: ListModel {
                ListElement {
                    name: "Grey"
                    colorCode: "grey"
                }

                ListElement {
                    name: "Red"
                    colorCode: "red"
                }

                ListElement {
                    name: "Blue"
                    colorCode: "blue"
                }

                ListElement {
                    name: "Green"
                    colorCode: "green"
                }
            }
        }


    }

}

/*##^##
Designer {
    D{i:0;autoSize:true;height:480;width:800}D{i:5}D{i:8}D{i:11}D{i:14}
}
##^##*/
