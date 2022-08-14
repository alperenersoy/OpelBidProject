import QtQuick 2
import QtQuick.Controls 2.0

Item {
    id:settingsPage
    width:800

    Rectangle {
        id: rectangle1
        color: "#000000"
        anchors.fill: parent

        FontLoader{
            id: fontLoader
            source: "../fonts/Helvetica.ttf"
        }

        Rectangle {
            id: timeSetting
            height: 50
            visible: false
            color: "#ededed"
            radius: 10
            border.width: 0
            anchors.left: parent.left
            anchors.right: parent.right
            anchors.top: parent.top
            anchors.rightMargin: 20
            anchors.leftMargin: 20
            anchors.topMargin: 70

            Rectangle {
                id: hour
                width: 247
                color: "#ededed"
                radius: 10
                border.width: 0
                anchors.left: parent.left
                anchors.top: parent.top
                anchors.bottom: parent.bottom
                anchors.leftMargin: 0
                anchors.bottomMargin: 0
                anchors.topMargin: 0

                Text {
                    id: hourLabel
                    x: 20
                    y: 7
                    text: qsTr("Saat")
                    anchors.verticalCenter: parent.verticalCenter
                    anchors.left: parent.left
                    font.pixelSize: 30
                    verticalAlignment: Text.AlignVCenter
                    font.bold: true
                    anchors.leftMargin: 20
                }

                Button {
                    id: hourPlus
                    x: 228
                    y: 5
                    width: 40
                    height: 40
                    text: qsTr("+")
                    anchors.verticalCenter: parent.verticalCenter
                    display: AbstractButton.TextOnly
                    flat: false
                    anchors.verticalCenterOffset: 0
                    font.pointSize: 12
                    onClicked: {
                        var hourDifference = backend.getSetting("hourDifference") ? parseInt(backend.getSetting("hourDifference")) : 0;
                        backend.setSetting("hourDifference", hourDifference + 1);
                    }
                }

                Button {
                    id: hourMinus
                    x: 182
                    y: 5
                    width: 40
                    height: 40
                    text: qsTr("-")
                    anchors.verticalCenter: parent.verticalCenter
                    flat: false
                    display: AbstractButton.TextOnly
                    anchors.verticalCenterOffset: 0
                    font.pointSize: 12
                    onClicked: {
                        var hourDifference = backend.getSetting("hourDifference") ? parseInt(backend.getSetting("hourDifference")) : 0;
                        backend.setSetting("hourDifference", hourDifference - 1);
                    }
                }
            }

            Rectangle {
                id: minute
                width: 247
                color: "#ededed"
                anchors.left: parent.left
                anchors.top: parent.top
                anchors.bottom: parent.bottom
                anchors.leftMargin: 400
                anchors.bottomMargin: 0
                Text {
                    id: minuteLabel
                    x: 20
                    y: 7
                    text: qsTr("Dakika")
                    anchors.verticalCenter: parent.verticalCenter
                    anchors.left: parent.left
                    font.pixelSize: 30
                    verticalAlignment: Text.AlignVCenter
                    font.bold: true
                    anchors.leftMargin: 0
                }

                Button {
                    id: minutePlus
                    x: 228
                    y: 5
                    width: 40
                    height: 40
                    text: qsTr("+")
                    anchors.verticalCenter: parent.verticalCenter
                    flat: false
                    display: AbstractButton.TextOnly
                    anchors.verticalCenterOffset: 0
                    font.pointSize: 12
                    onClicked: {
                        var minuteDifference = backend.getSetting("minuteDifference") ? parseInt(backend.getSetting("minuteDifference")) : 0;
                        backend.setSetting("minuteDifference", minuteDifference + 1);
                    }
                }

                Button {
                    id: minuteMinus
                    x: 180
                    y: 5
                    width: 40
                    height: 40
                    text: qsTr("-")
                    anchors.verticalCenter: parent.verticalCenter
                    flat: false
                    display: AbstractButton.TextOnly
                    anchors.verticalCenterOffset: 0
                    font.pointSize: 12
                    onClicked: {
                        var minuteDifference = backend.getSetting("minuteDifference") ? parseInt(backend.getSetting("minuteDifference")) : 0;
                        backend.setSetting("minuteDifference", minuteDifference - 1);
                    }
                }
                anchors.topMargin: 0
            }
        }

        Rectangle {
            id: reverseSetting
            height: 50
            visible: false
            color: "#ededed"
            radius: 10
            border.width: 0
            anchors.left: parent.left
            anchors.right: parent.right
            anchors.top: parent.top
            anchors.rightMargin: 20
            anchors.leftMargin: 20

            Switch {
                id: reverseSwitch
                y: 5
                text: qsTr("Geri Viteste Dörtlü Yak")
                anchors.verticalCenter: parent.verticalCenter
                anchors.left: parent.left
                font.bold: true
                anchors.leftMargin: 20
                font.pointSize: 18
                checked: backend.getSetting("hazardLightsOnReverse") ? backend.getSetting("hazardLightsOnReverse") : false
                onCheckedChanged: {
                    backend.setSetting("hazardLightsOnReverse", reverseSwitch.checked.toString());
                }
            }
            anchors.topMargin: 310
        }

        Button {
            id: saveBtn
            x: 631
            y: 421
            text: qsTr("Kaydet")
            anchors.right: parent.right
            anchors.bottom: parent.bottom
            hoverEnabled: true
            highlighted: false
            layer.enabled: false
            flat: true
            anchors.rightMargin: 20
            anchors.bottomMargin: 70

            Rectangle {
                id: rectangle
                color: "#ffffff"
                radius: 10
                border.width: 0
                anchors.fill: parent
            }

            BusyIndicator {
                id: saveBusy
                anchors.left: parent.left
                anchors.top: parent.top
                anchors.bottom: parent.bottom
                anchors.leftMargin: -60
                anchors.bottomMargin: 0
                anchors.topMargin: 0
                enabled: true
                running: false
            }

            onClicked:{
                saveBusy.running = true
                if(Screen.height === 480)
                    backend.saveSettings();
                saveBusy.running = false
                
            }
        }

        Rectangle {
            id: closeWindowSetting
            x: 20
            y: 150
            height: 50
            visible: false
            color: "#ededed"
            radius: 10
            border.width: 0
            anchors.left: parent.left
            anchors.right: parent.right
            anchors.top: parent.top
            anchors.leftMargin: 20
            anchors.rightMargin: 20
            Switch {
                id: closeWindowSwitch
                y: 5
                text: qsTr("Camları Otomatik Kapat")
                anchors.verticalCenter: parent.verticalCenter
                anchors.left: parent.left
                font.bold: true
                anchors.leftMargin: 20
                checked: backend.getSetting("closeWindowOnLock") ? backend.getSetting("closeWindowOnLock") : false
                onCheckedChanged: {
                    backend.setSetting("closeWindowOnLock", closeWindowSwitch.checked.toString());
                }
                font.pointSize: 18
            }
            anchors.topMargin: 230
        }

        Rectangle {
            id: brightnessSetting
            x: 29
            y: 142
            height: 50
            color: "#ededed"
            radius: 10
            border.width: 0
            anchors.left: parent.left
            anchors.right: parent.right
            anchors.top: parent.top
            anchors.leftMargin: 20
            anchors.rightMargin: 20
            anchors.topMargin: 70

            Text {
                id: brightnessLabel
                text: qsTr("Parlaklık")
                anchors.verticalCenter: parent.verticalCenter
                anchors.left: parent.left
                font.pixelSize: 30
                verticalAlignment: Text.AlignVCenter
                font.bold: true
                anchors.leftMargin: 20
            }

            SpinBox {
                id: dayBrightness
                y: 7
                anchors.verticalCenter: parent.verticalCenter
                anchors.left: parent.left
                to: 100
                anchors.verticalCenterOffset: 0
                anchors.leftMargin: 312
                value: backend.getSetting("dayBrightness") ? parseInt(backend.getSetting("dayBrightness")) : 100;
                onValueChanged: {
                    backend.setSetting("dayBrightness", dayBrightness.value)
                    backend.refreshBacklight()
                }
            }

            Text {
                id: dayLabel
                text: qsTr("Gündüz")
                anchors.verticalCenter: parent.verticalCenter
                anchors.left: parent.left
                font.pixelSize: 30
                verticalAlignment: Text.AlignVCenter
                font.bold: false
                font.italic: false
                anchors.leftMargin: 180
            }

            Text {
                id: nightLabel
                text: qsTr("Gece")
                anchors.verticalCenter: parent.verticalCenter
                anchors.left: parent.left
                font.pixelSize: 30
                verticalAlignment: Text.AlignVCenter
                font.italic: false
                anchors.verticalCenterOffset: 0
                anchors.leftMargin: 483
            }

            SpinBox {
                id: nightBrightness
                y: 7
                anchors.verticalCenter: parent.verticalCenter
                anchors.left: parent.left
                to: 100
                anchors.leftMargin: 579
                anchors.verticalCenterOffset: 0
                value: backend.getSetting("nightBrightness") ? parseInt(backend.getSetting("nightBrightness")) : 50;
                onValueChanged: {
                    backend.setSetting("nightBrightness", nightBrightness.value)
                    backend.refreshBacklight()
                }
            }
        }



    }
}






