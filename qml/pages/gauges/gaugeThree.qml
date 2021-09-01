import QtQuick 2
import QtQuick.Controls 2

Item {
    id:gaugeThree
    width:800
    height: 430


    property double speed: 150
    property double rpm: 0
    property double engineTemp: 0
    property bool isOBDOnline: false

    FontLoader{
        id: fontLoader
        source: '../../fonts/Helvetica.ttf'
    }

    FontLoader{
        id: fontLoaderBold
        source: '../../fonts/default-font.otf'
    }


    Rectangle {
        id: main
        color: "#000000"
        anchors.fill: parent

        Rectangle {
            id: rectangle1
            color: "#00000000"
            anchors.fill: parent

            Rectangle {
                id: rpm_outer
                x: 150
                y: 39
                width: 200
                height: 200
                visible: isOBDOnline
                color: "#00000000"
                radius: 49
                border.color: "#7f353637"
                border.width: 0
                anchors.verticalCenter: parent.verticalCenter
                anchors.horizontalCenterOffset: -100
                anchors.horizontalCenter: parent.horizontalCenter
                transformOrigin: Item.Center
                rotation: 270

                Text {
                    id: rpm_text
                    width: 22
                    height: 23
                    color: "#ffffff"
                    text: rpm
                    anchors.left: parent.left
                    anchors.top: parent.top
                    font.family: fontLoader.name
                    font.pixelSize: 16
                    horizontalAlignment: Text.AlignLeft
                    verticalAlignment: Text.AlignVCenter
                    anchors.leftMargin: -4
                    z: 5
                    anchors.topMargin: -1
                    fontSizeMode: Text.FixedSize
                    rotation: 90
                    onTextChanged: PropertyAnimation {
                        target: rpm_mask; property: "width"; to: rpm_outer.width - ((parseInt(rpm_text.text)/60)*rpm_outer.width);
                    }
                }

                Rectangle {
                    id: rpm_mask
                    width: 0
                    height: 200
                    color: "#000000"
                    radius: 0
                    border.width: 0
                    anchors.verticalCenter: parent.verticalCenter
                    anchors.right: parent.right
                    anchors.rightMargin: 0
                    rotation: 0
                    transformOrigin: Item.Center
                    z: 2
                    clip: false
                }

                Rectangle {
                    id: rpm_gradient
                    width: 200
                    height: 200
                    radius: 150
                    border.color: "#00000000"
                    border.width: 0
                    anchors.verticalCenter: parent.verticalCenter
                    anchors.horizontalCenter: parent.horizontalCenter
                    rotation: 270
                    clip: false
                    gradient: Gradient {
                        GradientStop {
                            position: 0
                            color: "#faff66"
                        }

                        GradientStop {
                            position: 0.5
                            color: "#ccffaa"
                        }

                        GradientStop {
                            position: 0.665
                            color: "#ffae09"
                        }

                        GradientStop {
                            position: 0.83
                            color: "#d90000"
                        }


                    }
                }

                Rectangle {
                    id: rpm_inner_circle
                    x: 0
                    y: -26
                    width: 200
                    height: 200
                    color: "#000000"
                    radius: 100
                    border.color: "#00000000"
                    border.width: 0
                    anchors.bottom: parent.bottom
                    anchors.bottomMargin: -25
                    clip: false
                    rotation: 270
                }



            }

            Rectangle {
                id: engine_temp_outer
                x: 416
                y: 39
                width: 200
                height: 200
                visible: isOBDOnline
                color: "#00000000"
                radius: 100
                border.color: "#7f353637"
                border.width: 0
                anchors.verticalCenter: parent.verticalCenter
                anchors.horizontalCenterOffset: 100
                anchors.horizontalCenter: parent.horizontalCenter
                anchors.verticalCenterOffset: 0
                transformOrigin: Item.Center
                rotation: 270

                Text {
                    id: engine_temp_text
                    width: 22
                    color: "#ffffff"
                    text: engineTemp
                    anchors.left: parent.left
                    anchors.bottom: parent.bottom
                    font.family: fontLoader.name
                    font.pixelSize: 16
                    horizontalAlignment: Text.AlignRight
                    verticalAlignment: Text.AlignVCenter
                    anchors.bottomMargin: -1
                    anchors.leftMargin: -4
                    z: 5
                    fontSizeMode: Text.FixedSize
                    rotation: 90
                    onTextChanged: PropertyAnimation {
                        target: engine_temp_mask; property: "width"; to: engine_temp_outer.width - (((parseInt(engine_temp_text.text))/130)*engine_temp_outer.width);
                    }
                }

                Rectangle {
                    id: engine_temp_mask
                    width: 0
                    height: 200
                    color: "#000000"
                    radius: 0
                    border.width: 0
                    anchors.verticalCenter: parent.verticalCenter
                    anchors.right: parent.right
                    anchors.rightMargin: 0
                    rotation: 0
                    transformOrigin: Item.Center
                    z: 2
                    clip: false
                }
                Rectangle {
                    id: engine_temp_gradient
                    width: 200
                    height: 200
                    color: "#59ccff"
                    radius: 100
                    border.color: "#00000000"
                    border.width: 0
                    anchors.verticalCenter: parent.verticalCenter
                    anchors.horizontalCenter: parent.horizontalCenter
                    rotation: 270
                    clip: false
                    gradient: Gradient {
                        GradientStop {
                            position: 0
                            color: "#59ccff"
                        }

                        GradientStop {
                            position: 0.46
                            color: "#59ccff"
                        }

                        GradientStop {
                            position: 0.69
                            color: "#ccffaa"
                        }

                        GradientStop {
                            position: 0.85
                            color: "#ffae09"
                        }

                        GradientStop {
                            position: 1
                            color: "#d90000"
                        }


                    }
                }

                Rectangle {
                    id: engine_temp_inner_circle
                    x: 13
                    y: -552
                    width: 200
                    height: 200
                    color: "#000000"
                    radius: 100
                    border.color: "#00000000"
                    border.width: 0
                    anchors.verticalCenter: parent.verticalCenter
                    anchors.verticalCenterOffset: -25
                    anchors.horizontalCenterOffset: 0
                    anchors.horizontalCenter: parent.horizontalCenter
                    clip: false
                    rotation: 270
                }

            }
        }

        Rectangle
        {
            id:rectangle
            color: "#00000000"
            anchors.fill:parent
            Label {
                id: kilometer
                y: 114
                height: 160
                color: "#ffffff"
                text: speed
                font.family: fontLoaderBold.name
                anchors.verticalCenter: parent.verticalCenter
                anchors.left: parent.left
                anchors.right: parent.right
                horizontalAlignment: Text.AlignHCenter
                verticalAlignment: Text.AlignVCenter
                z: 100
                font.bold: false
                anchors.rightMargin: 210
                anchors.leftMargin: 210
                font.pointSize: 140

                Label {
                    id: kms_text
                    x: 384
                    y: 158
                    color: "#ffffff"
                    text: qsTr("km/s")
                    anchors.bottom: parent.bottom
                    anchors.bottomMargin: -50
                    anchors.horizontalCenter: parent.horizontalCenter
                    font.pointSize: 20
                }
            }
        }
    }

    MouseArea {
        id: rpm_mouseArea
        width: 300
        anchors.left: parent.left
        anchors.top: parent.top
        anchors.bottom: parent.bottom
        anchors.bottomMargin: 0
        anchors.topMargin: 0
        anchors.leftMargin: 0
        onDoubleClicked: {
            if(rpm_outer.visible == true)
                rpm_outer.visible = false
            else
                rpm_outer.visible = true
        }
    }

    MouseArea {
        id: engine_temp_mouseArea
        width: 300
        anchors.right: parent.right
        anchors.top: parent.top
        anchors.bottom: parent.bottom
        anchors.rightMargin: 0
        anchors.topMargin: 0
        anchors.bottomMargin: 0
        onDoubleClicked: {
            if(engine_temp_outer.visible == true)
                engine_temp_outer.visible = false
            else
                engine_temp_outer.visible = true
        }
    }






}



/*##^##
Designer {
    D{i:0;height:480;width:800}D{i:8;locked:true}D{i:14;locked:true}D{i:18;locked:true}
D{i:25;locked:true}D{i:4}D{i:3}
}
##^##*/
