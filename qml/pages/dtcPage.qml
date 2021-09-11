import QtQuick 2.0
import QtQuick.Controls 2.0

Item {
    id: item1

    property bool isCanOnline: false
    property var fcDelay

    Rectangle {
        id: loading
        x: 324
        y: 201
        width: 75
        opacity: 0
        height: 75
        color: "#ffffff"
        radius: 100
        anchors.verticalCenter: parent.verticalCenter
        anchors.horizontalCenter: parent.horizontalCenter

        BusyIndicator {
            id: busyIndicator
            anchors.fill: parent
        }
    }

    ListView {
        id: listView
        anchors.fill: parent
        anchors.topMargin: 110
        model : ListModel{
            ListElement{
                errorCode:"Her şey yolunda!"
                details:"Hata bulunamadı."
            }
        }

        delegate: Row {
            height: 80
            anchors.left: parent.left
            anchors.right: parent.right
            Rectangle{
                color: '#ffffff'
                anchors.fill: parent
                anchors.bottomMargin: 10
                anchors.leftMargin: 10
                anchors.rightMargin: 10
                radius: 10
                Text {
                    text: errorCode
                    x: 10
                    y:10
                    font.bold: true
                }
                Text {
                    text: details
                    x:10
                    y:30
                    height: 20
                    wrapMode: Text.Wrap
                    width: parent.width - 20
                }
            }
        }
    }

    Button {
        id: readBtn
        x: 550
        width: 80
        height: 40
        text: qsTr("Read")
        anchors.right: parent.right
        anchors.top: parent.top
        focusPolicy: Qt.ClickFocus
        highlighted: false
        anchors.rightMargin: 100
        anchors.topMargin: 60
        flat: true
        background: Rectangle{
            color: "#ffffff"
            radius: 10
        }
        onClicked: {
            backend.needleSweep()
            /*listView.model.clear();
            loading.opacity = 1
            delay(10, function() {
                var dtcErrors = backend.getDtcErrors();
                if(dtcErrors.length > 0)
                {
                    for(var i = 0 ; i < dtcErrors.length ; i++)
                    {
                        listView.model.append(dtcErrors[i]);
                    }
                }
                else
                    listView.model.append({errorCode:"Her şey yolunda!",details:"Hata bulunamadı."});
                loading.opacity = 0
            })*/


        }
    }

    function delay(delayTime, cb) {
           timer.interval = delayTime;
           timer.repeat = false;
           if(fcDelay)
                timer.triggered.disconnect(fcDelay)
           timer.triggered.connect(cb);
           fcDelay = cb
           timer.start();
     }

    Button {
        id: clearBtn
        x: 712
        width: 80
        height: 40
        text: qsTr("Clear")
        anchors.right: parent.right
        anchors.top: parent.top
        focusPolicy: Qt.ClickFocus
        checked: false
        checkable: false
        highlighted: false
        anchors.rightMargin: 10
        anchors.topMargin: 60
        flat: true
        background: Rectangle{
            color: "#ffffff"
            radius: 10
        }
        onPressAndHold:{
            loading.opacity = 1
            delay(10, function() {
                if(backend.clearDtcErrors())
                {
                     listView.model.clear();
                     clearBtn.background.color = 'green';
                }
                else
                    clearBtn.background.color = 'red';
                loading.opacity = 0
            })
        }
    }
}

/*##^##
Designer {
    D{i:0;autoSize:true;height:480;width:800}D{i:9}
}
##^##*/
