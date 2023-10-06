import QtQuick 2.15
import QtQuick.Window 2.15
import QtQuick.Controls 2.15

Window {
    width: 640
    height: 480
    visible: true
    minimumHeight: 480
    minimumWidth: 640
    title: qsTr("GaugeApp")

    property real minValue: 0
    property real maxValue: 25
    property int numOfTickmarks: 9
    property real value: 0
    property bool isGaugeFull: value >= maxValue
    property bool isGaugeEmpty: value <= minValue
    property bool isPlusButtonClickable: !isGaugeFull
    property bool isMinusButtonClickable: !isGaugeEmpty

    Rectangle {
        width: parent.width
        height: parent.height

        Rectangle {
            id: rectGaugeWrapper
            width: height * 0.2
            height: parent.height * 0.8
            color: "#DFDFDE"
            radius: 16
            anchors.centerIn: parent

            Rectangle {
                id: gauageB
                width: rectGaugeWrapper.width * 0.8
                height: rectGaugeWrapper.height * 0.8
                color:"#F7F7F7"
                radius: 16
                anchors.centerIn: rectGaugeWrapper
                anchors.bottomMargin: rectGaugeWrapper.height * 0.05
                anchors.topMargin: rectGaugeWrapper.height * 0.05

                Rectangle {
                    id: gauge
                    width: parent.width * 0.2
                    height: parent.height * 0.9
                    color: "#DFDFDE"
                    anchors.centerIn: parent
                    radius:6

                    Repeater {
                        model: numOfTickmarks + 1 // +1 to include the maxValue tick mark
                        delegate: Rectangle {
                            width: 5
                            height: 2
                            color: "#52504B"
                            radius: 1
                            anchors {
                                top: gauge.top
                                left: gauge.left
                                topMargin: (index / numOfTickmarks) * (gauge.height - height)
                            }
                        }
                    }
                    Rectangle {
                        id: gaugeA
                        width: 6
                        height: Math.min(gauge.height, (value - minValue) / (maxValue - minValue) * gauge.height)
                        color: isGaugeFull ? "red" : "#6495ED"
                        radius: 20

                        anchors {
                            bottom: gauge.bottom
                            horizontalCenter: gauge.horizontalCenter
                        }
                        z: 1
                    }

                    // Yuvarlak termometre üstündeki nesne
                    Item {
                        width: 20
                        height: 20
                        anchors {
                            bottom: gauge.bottom
                            horizontalCenter: gauge.horizontalCenter
                            bottomMargin: -3
                        }

                        Rectangle {
                            width: 20
                            height: 20
                            color: "#DFDFDE"
                            radius:9
                        }
                    }
                }
            }
        }

        Row {
            spacing: 10
            anchors.horizontalCenter: rectGaugeWrapper.horizontalCenter
            anchors.top: rectGaugeWrapper.bottom
            anchors.topMargin: 3

            Button {
                id: plusButton
                text: "+"
                width: 40
                height: 40
                background: Rectangle {
                    color: isPlusButtonClickable ? "#ff82ab" : "red"
                }

                onClicked: {
                    if (isPlusButtonClickable && value < maxValue) {
                        value += 1;
                        isPlusButtonClickable = !isGaugeFull;
                        isMinusButtonClickable = true;
                    }
                }

                Timer {
                    id: plusButtonTimer
                    interval: 100
                    repeat: true
                    running: false
                    onTriggered: {
                        if (isPlusButtonClickable && value < maxValue) {
                            value += 1;
                            isPlusButtonClickable = !isGaugeFull;
                            isMinusButtonClickable = true;
                        }
                    }
                }

                onPressed: {
                    plusButtonTimer.start();
                }

                onReleased: {
                    plusButtonTimer.stop();
                }
            }

            Button {
                id: minusButton
                text: "-"
                width: 40
                height: 40
                background: Rectangle {
                    color: isMinusButtonClickable ? "#ff82ab" : "red"
                }

                onClicked: {
                    if (isMinusButtonClickable && value > minValue) {
                        value -= 1;
                        isMinusButtonClickable = !isGaugeEmpty;
                        isPlusButtonClickable = true;
                    }
                }

                Timer {
                    id: minusButtonTimer
                    interval: 100
                    repeat: true
                    running: false
                    onTriggered: {
                        if (isMinusButtonClickable && value > minValue) {
                            value -= 1;
                            isMinusButtonClickable = !isGaugeEmpty;
                            isPlusButtonClickable = true;
                        }
                    }
                }

                onPressed: {
                    minusButtonTimer.start();
                }

                onReleased: {
                    minusButtonTimer.stop();
                }
            }
        }
    }
}
