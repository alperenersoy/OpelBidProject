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
    property bool isIgnitionOn: false

    FontLoader{
        id:analogFontBold
        source: '../../fonts/Interceptor Italic.otf'
    }

    FontLoader{
        id:analogFont
        source: '../../fonts/7segment.ttf'
    }

    Rectangle
    {
        id:rectangle
        color: '#000000'
        anchors.fill: parent
        anchors.topMargin: -30
        Label {
            id: kilometer
            y: 114
            height: 70
            color: isCruiseControlActive ? "#00ff00" : (speed >= 120 ? "#D10000" :  "#ededed")
            text: speed
            font.family: analogFontBold.name
            anchors.verticalCenter: parent.verticalCenter
            anchors.left: parent.left
            anchors.right: parent.right
            font.letterSpacing: 1.1
            horizontalAlignment: Text.AlignHCenter
            verticalAlignment: Text.AlignVCenter
            wrapMode: Text.NoWrap
            font.italic: true
            font.weight: Font.Normal
            font.wordSpacing: 0.6
            clip: false
            textFormat: Text.AutoText
            renderType: Text.QtRendering
            anchors.rightMargin: 210
            anchors.leftMargin: 210
            font.bold: false
            font.pointSize: 96

            Label {
                id: kms_text
                x: 384
                y: 158
                color: "#ededed"
                text: qsTr("km/s")
                anchors.bottom: parent.bottom
                anchors.bottomMargin: -75
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
        anchors.verticalCenterOffset: -10
        anchors.rightMargin: 0
        anchors.leftMargin: 0

        Rectangle {
            id: rpm_outer
            x: 150
            y: 39
            width: 98
            height: 20
            visible: isIgnitionOn
            color: "#ffffff"
            radius: 2
            border.color: "#7f353637"
            border.width: 1
            anchors.verticalCenter: parent.verticalCenter
            anchors.horizontalCenterOffset: -75
            anchors.verticalCenterOffset: 140
            anchors.horizontalCenter: parent.horizontalCenter
            transformOrigin: Item.Center
            rotation: 180

            Rectangle {
                id: rpm_mask
                x: 98
                width: 30
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

                Text {
                    id: rpm_text
                    y: 0
                    visible: true
                    color: "#ededed"
                    text: rpm
                    anchors.verticalCenter: parent.verticalCenter
                    anchors.left: parent.left
                    font.family: analogFontBold.name
                    font.pixelSize: 16
                    horizontalAlignment: Text.AlignHCenter
                    verticalAlignment: Text.AlignVCenter
                    anchors.leftMargin: 15
                    fontSizeMode: Text.FixedSize
                    rotation: 180
                    onTextChanged: PropertyAnimation {
                        target: rpm_mask; property: "width"; to: rpm_outer.width - ((parseInt(rpm_text.text)/60)*rpm_outer.width);
                    }
                }
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




        }

        Rectangle {
            id: engine_temp_outer
            x: 552
            y: 39
            width: 98
            height: 20
            visible: isIgnitionOn
            color: "#ffffff"
            radius: 2
            border.color: "#7f353637"
            border.width: 1
            anchors.verticalCenter: parent.verticalCenter
            anchors.horizontalCenterOffset: 75
            anchors.verticalCenterOffset: 140
            anchors.horizontalCenter: parent.horizontalCenter
            transformOrigin: Item.Center
            rotation: 0

            Rectangle {
                id: engine_temp_mask
                width: 40
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

                Text {
                    id: engine_temp_text
                    y: 0
                    width: 50
                    visible: true
                    color: "#ededed"
                    text: engineTemp
                    anchors.left: parent.left
                    font.pixelSize: 16
                    horizontalAlignment: Text.AlignHCenter
                    verticalAlignment: Text.AlignVCenter
                    anchors.leftMargin: 5
                    fontSizeMode: Text.FixedSize
                    rotation: 0
                    font.family: analogFontBold.name
                    onTextChanged: PropertyAnimation {
                        target: engine_temp_mask; property: "width"; to: engine_temp_outer.width - (((parseInt(engine_temp_text.text))/130)*engine_temp_outer.width);
                    }
                }
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
    D{i:0;formeditorZoom:1.1;height:480;width:800}D{i:26;locked:true}D{i:27;locked:true}
}
##^##*/
