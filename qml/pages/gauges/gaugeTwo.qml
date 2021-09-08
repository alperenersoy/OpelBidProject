import QtQuick 2
import QtQuick.Controls 2

Item {
    id:gaugeTwo
    width:800
    height: 430


    property double speed: 0
    property double rpm: 0
    property double engineTemp: 0
    property bool isCanOnline: false
    property bool isCruiseControlActive: false

    FontLoader{
        id:analogFontBold
        source: '../../fonts/DS-DIGIB.TTF'
    }

    FontLoader{
        id:analogFont
        source: '../../fonts/DS-DIGI.TTF'
    }

    Rectangle
    {
        id:rectangle
        color: '#000000'
        anchors.fill:parent
        Label {
            id: kilometer
            y: 114
            height: 70
            color: isCruiseControlActive ? "#00ff00" : "#ffffff"
            text: speed
            font.family: analogFontBold.name
            anchors.verticalCenter: parent.verticalCenter
            anchors.left: parent.left
            anchors.right: parent.right
            horizontalAlignment: Text.AlignHCenter
            verticalAlignment: Text.AlignVCenter
            anchors.rightMargin: 210
            anchors.leftMargin: 210
            font.bold: false
            font.pointSize: 160

            Label {
                id: kms_text
                x: 384
                y: 158
                color: "#ffffff"
                text: qsTr("km/s")
                anchors.bottom: parent.bottom
                anchors.bottomMargin: -100
                anchors.horizontalCenter: parent.horizontalCenter
                font.pointSize: 20
            }
        }
    }

    Rectangle {
        id: rectangle1
        y: 176
        height: 141
        color: "#00000000"
        anchors.verticalCenter: parent.verticalCenter
        anchors.left: parent.left
        anchors.right: parent.right
        anchors.verticalCenterOffset: 2
        anchors.rightMargin: 0
        anchors.leftMargin: 0

        Rectangle {
            id: rpm_outer
            x: 150
            y: 39
            width: 98
            height: 20
            visible: isCanOnline
            color: "#ffffff"
            radius: 2
            border.color: "#7f353637"
            border.width: 1
            anchors.verticalCenter: parent.verticalCenter
            anchors.verticalCenterOffset: -22
            transformOrigin: Item.Center
            rotation: 270

            Text {
                id: rpm_text
                color: "#ffffff"
                text: rpm
                font.family: analogFontBold.name
                anchors.fill: parent
                font.pixelSize: 20
                horizontalAlignment: Text.AlignHCenter
                verticalAlignment: Text.AlignVCenter
                anchors.leftMargin: -125
                anchors.bottomMargin: 0
                fontSizeMode: Text.FixedSize
                rotation: 90
                onTextChanged: PropertyAnimation {
                    target: rpm_mask; property: "width"; to: rpm_outer.width - ((parseInt(rpm_text.text)/60)*rpm_outer.width);
                }

                Text {
                    id: rpm_unit
                    x: 201
                    y: -22
                    color: "#ffffff"
                    text: "RPM"
                    font.family: analogFont.name
                    anchors.verticalCenter: parent.verticalCenter
                    font.pixelSize: 20
                    horizontalAlignment: Text.AlignHCenter
                    verticalAlignment: Text.AlignVCenter
                    textFormat: Text.RichText
                    anchors.horizontalCenter: parent.horizontalCenter
                    anchors.verticalCenterOffset: 21
                }
            }

            Rectangle {
                id: rpm_mask
                x: 98
                width: 0
                height: 20
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
                width: 20
                height: 98
                radius: 2
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

            Item {
                id: stripes
                width: 98
                height: 20

                Rectangle {
                    id: stripe
                    x: 14
                    y: 0
                    width: 7
                    height: 20
                    color: "#000000"
                }

                Rectangle {
                    id: stripe2
                    x: 28
                    y: 0
                    width: 7
                    height: 20
                    color: "#000000"
                }

                Rectangle {
                    id: stripe3
                    x: 42
                    y: 0
                    width: 7
                    height: 20
                    color: "#000000"
                }

                Rectangle {
                    id: stripe4
                    x: 56
                    y: 0
                    width: 7
                    height: 20
                    color: "#000000"
                }

                Rectangle {
                    id: stripe5
                    x: 70
                    y: 0
                    width: 7
                    height: 20
                    color: "#000000"
                }

                Rectangle {
                    id: stripe6
                    x: 84
                    y: 0
                    width: 7
                    height: 20
                    color: "#000000"
                }
            }




        }

        Rectangle {
            id: engine_temp_outer
            x: 552
            y: 39
            width: 98
            height: 20
            visible: isCanOnline
            color: "#ffffff"
            radius: 2
            border.color: "#7f353637"
            border.width: 1
            anchors.verticalCenter: parent.verticalCenter
            anchors.verticalCenterOffset: -22
            transformOrigin: Item.Center
            rotation: 270

            Text {
                id: engine_temp_text
                color: "#ffffff"
                text: engineTemp
                anchors.fill: parent
                font.pixelSize: 20
                horizontalAlignment: Text.AlignHCenter
                verticalAlignment: Text.AlignVCenter
                anchors.leftMargin: -125
                fontSizeMode: Text.FixedSize
                rotation: 90
                font.family: analogFontBold.name
                onTextChanged: PropertyAnimation {
                    target: engine_temp_mask; property: "width"; to: engine_temp_outer.width - (((parseInt(engine_temp_text.text))/130)*engine_temp_outer.width);
                }

                Text {
                    id: degree
                    x: 201
                    y: -22
                    color: "#ffffff"
                    text: qsTr("°C")
                    anchors.verticalCenter: parent.verticalCenter
                    font.pixelSize: 20
                    horizontalAlignment: Text.AlignHCenter
                    verticalAlignment: Text.AlignVCenter
                    anchors.horizontalCenter: parent.horizontalCenter
                    anchors.verticalCenterOffset: 21
                    font.family: analogFont.name
                }
            }

            Rectangle {
                id: engine_temp_mask
                width: 0
                height: 20
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
                width: 20
                height: 98
                color: "#59ccff"
                radius: 2
                border.color: "#00000000"
                border.width: 0
                anchors.verticalCenter: parent.verticalCenter
                rotation: 270
                anchors.horizontalCenter: parent.horizontalCenter
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

            Item {
                id: stripes1
                width: 98
                height: 20
                Rectangle {
                    id: stripe1
                    x: 14
                    y: 0
                    width: 7
                    height: 20
                    color: "#000000"
                }

                Rectangle {
                    id: stripe7
                    x: 28
                    y: 0
                    width: 7
                    height: 20
                    color: "#000000"
                }

                Rectangle {
                    id: stripe8
                    x: 42
                    y: 0
                    width: 7
                    height: 20
                    color: "#000000"
                }

                Rectangle {
                    id: stripe9
                    x: 56
                    y: 0
                    width: 7
                    height: 20
                    color: "#000000"
                }

                Rectangle {
                    id: stripe10
                    x: 70
                    y: 0
                    width: 7
                    height: 20
                    color: "#000000"
                }

                Rectangle {
                    id: stripe11
                    x: 84
                    y: 0
                    width: 7
                    height: 20
                    color: "#000000"
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
            {
                rpm_outer.visible = false
                backend.setSetting('gaugeTwoRpmHidden', "true")
            }
            else
            {
                rpm_outer.visible = true
                backend.setSetting('gaugeTwoRpmHidden', "false")
            }
        }
        Component.onCompleted: {
             var gaugeTwoRpmHiddenSetting = backend.getSetting("gaugeTwoRpmHidden")
             if(gaugeTwoRpmHiddenSetting !== null)
                rpm_outer.visible = !(gaugeTwoRpmHiddenSetting === 'true')
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
            if(engine_temp_outer.visible == true){
                engine_temp_outer.visible = false
                backend.setSetting('gaugeTwoEngineTempHidden', "true")
            }
            else{
                engine_temp_outer.visible = true
                backend.setSetting('gaugeTwoEngineTempHidden', "false")
            }
        }
        Component.onCompleted: {
             var gaugeTwoEngineTempHiddenSetting = backend.getSetting("gaugeTwoEngineTempHidden")
             if(gaugeTwoEngineTempHiddenSetting !== null)
                engine_temp_outer.visible = !(gaugeTwoEngineTempHiddenSetting === 'true')
        }
    }






}



/*##^##
Designer {
    D{i:0;height:480;width:800}
}
##^##*/
