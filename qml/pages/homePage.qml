import QtQuick 2
import QtQuick.Controls 2

Item {
    id:homePage
    width:800
    height: 430

    property string date: Qt.formatDateTime(new Date(), "dd.MM.yyyy")
    property string clock: Qt.formatTime(new Date(),"hh:mm")
    property double temp: 0
    property bool isOBDOnline: false

    FontLoader{
        id: fontLoader
        source: '../fonts/default-font.otf'
    }

    Rectangle {
        id: rectangle
        color: "#000000"
        border.width: 0
        anchors.fill: parent
        anchors.rightMargin: 0
        anchors.topMargin: 0


        Rectangle {
            id: rectangle1
            x: 100
            y: 60
            width: 600
            height: 179
            color: "#00000000"
            border.width: 0
            anchors.verticalCenter: parent.verticalCenter
            anchors.horizontalCenter: parent.horizontalCenter

            Text {
                id: clock_text
                color: "#ffffff"
                text: clock
                font.family: fontLoader.name
                anchors.fill: parent
                font.pixelSize: 150
                horizontalAlignment: Text.AlignHCenter
                anchors.topMargin: -25
            }

            Text {
                id: date_text
                color: "#ffffff"
                text: date
                font.family: fontLoader.name
                anchors.verticalCenter: parent.verticalCenter
                anchors.left: parent.left
                anchors.right: parent.right
                anchors.top: parent.top
                font.pixelSize: 42
                horizontalAlignment: Text.AlignHCenter
                verticalAlignment: Text.AlignBottom
                lineHeight: 1
                lineHeightMode: Text.ProportionalHeight
                anchors.topMargin: -25
                textFormat: Text.AutoText
            }

            Text {
                id: temp_text
                x: 256
                y: 185
                width: 88
                height: 71
                color: "#ffffff"
                text: temp + " °C"
                font.family: fontLoader.name
                anchors.bottom: parent.bottom
                font.pixelSize: 30
                horizontalAlignment: Text.AlignHCenter
                verticalAlignment: Text.AlignVCenter
                anchors.bottomMargin: -100
                anchors.horizontalCenter: parent.horizontalCenter
                visible:isOBDOnline
            }
        }

    }

}

/*##^##
Designer {
    D{i:0;formeditorColor:"#c0c0c0"}
}
##^##*/
