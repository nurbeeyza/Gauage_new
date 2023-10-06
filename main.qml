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

        Rectangle {
            id: rectGaugeWrapper
            width: height * 0.2
            height: parent.height * 0.8
            color: "#DFDFDE"
            radius: 16
            anchors.centerIn: parent

            Rectangle {
                id: gauageB
                width: height * 0.2
                height: parent.height * 0.9
                color:"#F7F7F7"
                radius: 16
                anchors.centerIn: parent

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
                        radius: 15

                        anchors {
                            bottom: gauge.bottom
                            horizontalCenter: gauge.horizontalCenter
                        }
                        z: 1
                    }
                }
            }

            /* Text {
                width: rectGaugeWrapper.width * 0.5
                height: rectGaugeWrapper.height * 0.2
                anchors.horizontalCenter: rectGaugeWrapper.horizontalCenter
                anchors.bottom: rectGaugeWrapper.bottom
                anchors.bottomMargin: 3
                text: String(Math.round(value))
                color: "blue"
                font.pixelSize: height
                fontSizeMode: Text.HorizontalFit
                minimumPixelSize:8
                elide: Text.ElideRight
            } */
        }

        Row {
            spacing: 10
            anchors.horizontalCenter: rectGaugeWrapper.horizontalCenter
            anchors.top: rectGaugeWrapper.bottom
            anchors.topMargin: 3

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
