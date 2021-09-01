import QtQuick 2
import QtQuick.Controls 2

Item {
    id: gaugesPage
    property double speed: 0
    property double rpm: 0
    property double engineTemp: 0
    property bool isOBDOnline: false

    SwipeView {
        id: swipeView
        anchors.fill: parent
        currentIndex: 0
        orientation: Qt.Vertical

        Item {
            StackView {
                id: stackViewGauge1
                anchors.fill: parent
                initialItem: "gauges/gaugeOne.qml"
            }
        }

        Item {
            StackView {
                id: stackViewGauge2
                anchors.fill: parent
                initialItem: "gauges/gaugeTwo.qml"
            }
        }
        Item {
            StackView {
                id: stackViewGauge3
                anchors.fill: parent
                initialItem: "gauges/gaugeThree.qml"
            }
        }
    }
    Connections {
        target: gaugesPage
       function onSpeedChanged() {
            stackViewGauge1.currentItem.speed = speed
            stackViewGauge2.currentItem.speed = speed
            stackViewGauge3.currentItem.speed = speed
        }
        function onRpmChanged() {
            stackViewGauge1.currentItem.rpm = rpm
            stackViewGauge2.currentItem.rpm = rpm
            stackViewGauge3.currentItem.rpm = rpm
        }
        function onEngineTempChanged() {
            stackViewGauge1.currentItem.engineTemp = engineTemp
            stackViewGauge2.currentItem.engineTemp = engineTemp
            stackViewGauge3.currentItem.engineTemp = engineTemp
        }
        function onIsOBDOnlineChanged() {
            stackViewGauge1.currentItem.isOBDOnline = isOBDOnline
            stackViewGauge2.currentItem.isOBDOnline = isOBDOnline
            stackViewGauge3.currentItem.isOBDOnline = isOBDOnline
        }
    }



}

/*##^##
Designer {
    D{i:0;autoSize:true;height:480;width:800}
}
##^##*/
