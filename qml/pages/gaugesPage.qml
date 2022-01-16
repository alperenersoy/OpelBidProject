import QtQuick 2
import QtQuick.Controls 2

Item {
    id: gaugesPage
    property double speed: 0
    property double rpm: 0
    property double engineTemp: 0
    property bool isCanOnline: false
    property bool isEngineRunning: false
    property bool isIgnitionOn: false
    property bool isCruiseControlActive: false
    property string triggeredControl: "";

    SwipeView {
        id: swipeView
        anchors.fill: parent
        currentIndex: 0
        orientation: Qt.Vertical

        Item {
            StackView {
                id: stackViewGauge1
                anchors.fill: parent
                initialItem: "gauges/gaugeThree.qml"
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
                initialItem: "gauges/gaugeOne.qml"
            }
        }

        Component.onCompleted: {
            var currentGaugeSetting = backend.getSetting("currentGauge")
            if(currentGaugeSetting)
                swipeView.setCurrentIndex(parseInt(currentGaugeSetting))
        }

        onCurrentIndexChanged:{ 
            backend.setSetting('currentGauge', swipeView.currentIndex)
        }
    }
    Connections {
        target: gaugesPage
        onSpeedChanged: {
            stackViewGauge1.currentItem.speed = speed
            stackViewGauge2.currentItem.speed = speed
            stackViewGauge3.currentItem.speed = speed
        }
        onRpmChanged: {
            stackViewGauge1.currentItem.rpm = rpm
            stackViewGauge2.currentItem.rpm = rpm
            stackViewGauge3.currentItem.rpm = rpm
        }
        onEngineTempChanged: {
            stackViewGauge1.currentItem.engineTemp = engineTemp
            stackViewGauge2.currentItem.engineTemp = engineTemp
            stackViewGauge3.currentItem.engineTemp = engineTemp
        }
        onIsIgnitionOnChanged: {
            stackViewGauge1.currentItem.isIgnitionOn = isIgnitionOn
            stackViewGauge2.currentItem.isIgnitionOn = isIgnitionOn
            stackViewGauge3.currentItem.isIgnitionOn = isIgnitionOn
        }
        onIsCruiseControlActiveChanged:
        {
            stackViewGauge1.currentItem.isCruiseControlActive = isCruiseControlActive
            stackViewGauge2.currentItem.isCruiseControlActive = isCruiseControlActive
            stackViewGauge3.currentItem.isCruiseControlActive = isCruiseControlActive
        }
        onTriggeredControlChanged:
        {
            if(triggeredControl == 'LEFT_KNOB_UP')
                swipeView.setCurrentIndex(swipeView.currentIndex+1)
            else if(triggeredControl == 'LEFT_KNOB_DOWN')
                swipeView.setCurrentIndex(swipeView.currentIndex-1)
            triggeredControl = ""
        }
    }
}

/*##^##
Designer {
    D{i:0;autoSize:true;height:480;width:800}
}
##^##*/
