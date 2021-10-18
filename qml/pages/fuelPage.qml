import QtQuick 2

Item {

    property double fuelPercentage: 0
    property double instantConsumption: 0
    property double estRange: 0

    Rectangle {
        id: rectangle
        color: "#000000"
        anchors.fill: parent

        Rectangle {
            id: rectangle1
            x: 184
            y: 53
            width: 432
            height: 360
            color: "#00000000"
            anchors.verticalCenter: parent.verticalCenter
            anchors.verticalCenterOffset: 25
            anchors.horizontalCenter: parent.horizontalCenter

            Rectangle {
                id: range
                x: 74
                width: 285
                height: 66
                color: "#00000000"
                radius: 15
                border.color: "#d9a600"
                border.width: 2
                anchors.top: parent.top
                anchors.topMargin: 97

                Text {
                    id: range_title
                    color: "#ffffff"
                    text: qsTr("Menzil")
                    anchors.fill: parent
                    font.pixelSize: 20
                    horizontalAlignment: Text.AlignHCenter
                    font.bold: true
                    anchors.topMargin: 8
                    anchors.bottomMargin: 8

                    Text {
                        id: range_text
                        x: 115
                        y: 43
                        color: "#ffffff"
                        text: estRange + " KM"
                        anchors.bottom: parent.bottom
                        font.pixelSize: 20
                        horizontalAlignment: Text.AlignHCenter
                        anchors.bottomMargin: 0
                        anchors.horizontalCenter: parent.horizontalCenter
                    }
                }
            }

            Rectangle {
                id: fuel_percentage
                x: 74
                width: 285
                height: 66
                color: "#00000000"
                radius: 15
                border.color: "#d9a600"
                border.width: 2
                anchors.top: parent.top
                anchors.topMargin: 0
                Text {
                    id: fuel_percentage_title
                    color: "#ffffff"
                    text: qsTr("Yakıt")
                    anchors.fill: parent
                    font.pixelSize: 20
                    horizontalAlignment: Text.AlignHCenter
                    font.bold: true
                    anchors.bottomMargin: 8
                    Text {
                        id: fuel_percentage_text
                        x: 115
                        y: 43
                        color: "#ffffff"
                        text: '%' + fuelPercentage
                        anchors.bottom: parent.bottom
                        font.pixelSize: 20
                        horizontalAlignment: Text.AlignHCenter
                        anchors.horizontalCenter: parent.horizontalCenter
                        anchors.bottomMargin: 0
                    }
                    anchors.topMargin: 8
                }
            }

            Rectangle {
                id: average_consumption
                x: 74
                y: 154
                width: 285
                height: 66
                color: "#00000000"
                radius: 15
                border.color: "#d9a600"
                border.width: 2
                anchors.bottom: parent.bottom
                anchors.bottomMargin: 97
                Text {
                    id: average_consumption_title
                    color: "#ffffff"
                    text: qsTr("Ort. Tüketim")
                    anchors.fill: parent
                    font.pixelSize: 20
                    horizontalAlignment: Text.AlignHCenter
                    font.bold: true
                    anchors.bottomMargin: 8
                    Text {
                        id: average_consumption_text
                        x: 115
                        y: 43
                        color: "#ffffff"
                        text: qsTr("8.6 L / 100 KM")
                        anchors.bottom: parent.bottom
                        font.pixelSize: 20
                        horizontalAlignment: Text.AlignHCenter
                        anchors.horizontalCenter: parent.horizontalCenter
                        anchors.bottomMargin: 0
                    }
                    anchors.topMargin: 8
                }
            }

            Rectangle {
                id: current_consumption
                x: 74
                y: 246
                width: 285
                height: 66
                color: "#00000000"
                radius: 15
                border.color: "#d9a600"
                border.width: 2
                anchors.bottom: parent.bottom
                anchors.bottomMargin: 0
                Text {
                    id: current_consumption_title
                    color: "#ffffff"
                    text: qsTr("Anlık Tüketim")
                    anchors.fill: parent
                    font.pixelSize: 20
                    horizontalAlignment: Text.AlignHCenter
                    font.bold: true
                    anchors.bottomMargin: 8
                    Text {
                        id: current_consumption_text
                        x: 115
                        y: 43
                        color: "#ffffff"
                        text: instantConsumption + " L / 100 KM"
                        anchors.bottom: parent.bottom
                        font.pixelSize: 20
                        horizontalAlignment: Text.AlignHCenter
                        anchors.horizontalCenter: parent.horizontalCenter
                        anchors.bottomMargin: 0
                    }
                    anchors.topMargin: 8
                }
            }
        }
    }

}

/*##^##
Designer {
    D{i:0;autoSize:true;height:480;width:800}D{i:5}D{i:4}D{i:3}D{i:6}D{i:9}D{i:12}D{i:1}
}
##^##*/
