import QtQuick 2.0

Item {
    id: item1
    property bool frontLeftOpen: true
    property bool frontRightOpen: true
    property bool backLeftOpen: true
    property bool backRightOpen: true
    property bool trunkOpen: true
    width: 320
    height: 320

    Rectangle {
        id: rectangle
        color: "#000000"
        radius: 10
        border.color: "#ffffff"
        anchors.fill: parent


        Text {
            id: text1
            x: 410
            color: "#ffffff"
            text: qsTr("Sağ Ön")
            anchors.right: parent.right
            anchors.top: parent.top
            font.pixelSize: 20
            anchors.topMargin: 105
            anchors.rightMargin: -10
            rotation: 270
            visible: frontRightOpen
        }

        Text {
            id: text2
            x: 395
            y: 189
            text: qsTr("Sağ Arka")
            anchors.right: parent.right
            font.pixelSize: 20
            anchors.rightMargin: -20
            rotation: 270
            visible: backRightOpen
            color: "#ffffff"
        }

        Text {
            id: text3
            x: 8
            color: "#ffffff"
            text: qsTr("Sol Ön")
            anchors.right: parent.right
            anchors.top: parent.top
            font.pixelSize: 20
            anchors.topMargin: 108
            anchors.rightMargin: 271
            rotation: 270
            visible: frontLeftOpen
        }

        Text {
            id: text4
            x: 8
            y: 189
            color: "#ffffff"
            text: qsTr("Sol Arka")
            anchors.right: parent.right
            font.pixelSize: 20
            anchors.rightMargin: 264
            rotation: 270
            visible: backLeftOpen
        }

        Text {
            id: text5
            x: 215
            y: 404
            color: "#ffffff"
            text: qsTr("Bagaj")
            anchors.bottom: parent.bottom
            font.pixelSize: 20
            anchors.horizontalCenter: parent.horizontalCenter
            anchors.bottomMargin: 10
            visible: trunkOpen
        }

        Image {
            id: image
            x: 0
            y: 0
            width: 320
            height: 320
            source: "../images/door/car.png"
            anchors.horizontalCenter: parent.horizontalCenter
            sourceSize.height: 412
            sourceSize.width: 412
            fillMode: Image.PreserveAspectFit
        }

        Image {
            id: frontLeft
            x: 0
            y: 0
            width: 320
            height: 320
            source: "../images/door/front_left.png"
            anchors.horizontalCenterOffset: -2
            anchors.horizontalCenter: parent.horizontalCenter
            sourceSize.height: 412
            sourceSize.width: 412
            fillMode: Image.PreserveAspectFit
            visible: frontLeftOpen
        }

        Image {
            id: frontRight
            x: 0
            y: 0
            width: 320
            height: 320
            source: "../images/door/front_right.png"
            anchors.horizontalCenter: parent.horizontalCenter
            sourceSize.height: 412
            sourceSize.width: 412
            fillMode: Image.PreserveAspectFit
            visible: frontRightOpen
        }

        Image {
            id: backLeft
            x: 0
            y: 0
            width: 320
            height: 320
            source: "../images/door/back_left.png"
            anchors.horizontalCenterOffset: -2
            anchors.horizontalCenter: parent.horizontalCenter
            sourceSize.height: 412
            sourceSize.width: 412
            fillMode: Image.PreserveAspectFit
            visible: backLeftOpen
        }

        Image {
            id: backRight
            x: 0
            y: 0
            width: 320
            height: 320
            source: "../images/door/back_right.png"
            smooth: true
            anchors.horizontalCenterOffset: 1
            anchors.horizontalCenter: parent.horizontalCenter
            sourceSize.height: 412
            sourceSize.width: 412
            fillMode: Image.PreserveAspectFit
            visible: backRightOpen
        }

        Image {
            id: trunk
            x: 0
            y: 0
            width: 320
            height: 320
            source: "../images/door/trunk.png"
            anchors.horizontalCenterOffset: -2
            anchors.horizontalCenter: parent.horizontalCenter
            sourceSize.height: 412
            sourceSize.width: 412
            fillMode: Image.PreserveAspectFit
            visible: trunkOpen
        }
    }
}


