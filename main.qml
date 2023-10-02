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
    property int numOfTickmarks: 5
    property real value: 0
    property bool isGaugeFull: value >= maxValue
    property bool isGaugeEmpty: value <= minValue
    property bool isPlusButtonClickable: !isGaugeFull
    property bool isMinusButtonClickable: !isGaugeEmpty

    Rectangle {
        width: parent.width
        height: parent.height

        Item {
            id: wrapper
            width: parent.width
            height: parent.height

            Rectangle {
                id: rectGaugeWrapper
                width: height * 0.2
                height: parent.height * 0.7
                color: "deeppink"
                radius: 5
                anchors.centerIn: parent

                Rectangle {
                    id: gauge
                    width: parent.width * 0.3
                    height: parent.height * 0.6
                    color: "lightblue"
                    anchors.centerIn: parent
                    radius:5


                    Repeater {
                        model: numOfTickmarks + 1 // +1 to include the maxValue tick mark
                        delegate: Rectangle {
                            width: 2
                            height: 5
                            color: "white"
                            radius: 1

                            transform: Rotation {
                                        origin.x: width / 2
                                        origin.y: height / 2
                                        angle: 90
                                    }
                                    anchors {
                                        top: gauge.top
                                        horizontalCenter: gauge.horizontalCenter + gauge.width / 2
                                        topMargin: (index / numOfTickmarks) * (gauge.height - height)

                                    }
                                }
                            }
                    Text {
                        text: String(Math.round(value))
                        font.pixelSize: 10
                        anchors.centerIn: parent
                        color: "black"
                    }

                    Rectangle {
                        id: gaugeA
                        width: 6
                        height: Math.min(gauge.height, (value - minValue) / (maxValue - minValue) * gauge.height)
                        color: isGaugeFull ? "red" : "limegreen"
                        radius: 10
                        anchors {
                            bottom: gauge.bottom
                            horizontalCenter: gauge.horizontalCenter
                        }
                        z: 1
                    }
                }

                Row {
                    spacing: 20
                    anchors.horizontalCenter: rectGaugeWrapper.horizontalCenter
                    anchors.top: gauge.bottom
                    anchors.topMargin: 90

                    Button {
                        text: "+"
                        width: 40
                        height: 40
                        background: Rectangle {
                            color: isPlusButtonClickable ? "#ff82ab" : "red"
                        }
                        onClicked: {
                            if (isPlusButtonClickable && value < maxValue) {
                                value += 1
                                isPlusButtonClickable = !isGaugeFull;
                                isMinusButtonClickable = true;
                            }
                        }
                    }

                    Button {
                        text: "-"
                        width: 40
                        height: 40
                        background: Rectangle {
                            color: isMinusButtonClickable ? "#ff82ab" : "red"
                        }
                        onClicked: {
                            if (isMinusButtonClickable && value > minValue) {
                                value -= 1
                                isMinusButtonClickable = !isGaugeEmpty;
                                isPlusButtonClickable = true;
                            }
                        }
                    }
                }
            }
        }
    }
}
