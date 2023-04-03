import QtQuick 2.12
import QtQuick.Controls 2.12
import QtGraphicalEffects 1.12

Item {
    implicitHeight: powerButton.height
    implicitWidth: powerButton.width

    ListModel {
        id: powerModel

        ListElement { name: "Sleep" }
        ListElement { name: "Restart" }
        ListElement { name: "Shut\nDown" }
    }

    Button {
        id: powerButton

        height: inputHeight
        width: inputHeight
        hoverEnabled: true

        icon.source: Qt.resolvedUrl("../icons/power.svg")
        icon.height: height
        icon.width: width
        icon.color: config.PowerIconColor

        background: Rectangle {
            id: powerButtonBg
            
            color: config.PowerButtonColor
            radius: config.CornerRadius
        }

        states: [
            State {
                name: "pressed"
                when: powerButton.down
                PropertyChanges {
                    target: powerButtonBg
                    color: Qt.darker(config.PowerButtonColor, 1.2)
                }
            },
            State {
                name: "hovered"
                when: powerButton.hovered
                PropertyChanges {
                    target: powerButtonBg
                    color: Qt.darker(config.PowerButtonColor, 1.2)
                }
            },
            State {
                name: "selection"
                when: powerPopup.visible
                PropertyChanges {
                    target: powerButtonBg
                    color: Qt.darker(config.PowerButtonColor, 1.2)
                }
            }
        ]

        transitions: Transition {
            PropertyAnimation {
                properties: "color"
                duration: 150
            }
        }

        onClicked: {
            powerPopup.visible ? powerPopup.close() : powerPopup.open()
            powerButton.state = "pressed"
        }
    }

    Popup {
        id: powerPopup

        height: inputHeight * 2.2 + padding * 2
        x: powerButton.width + powerList.spacing
        y: -height + powerButton.height
        padding: 15

        background: Rectangle {
            radius: config.CornerRadius * 1.8
            color: config.PopupBgColor
        }

        contentItem: ListView {
            id: powerList
            
            implicitWidth: contentWidth
            spacing: 8
            orientation: Qt.Horizontal
            clip: true

            model: powerModel
            delegate: ItemDelegate {
                id: powerEntry

                height: inputHeight * 2.2
                width: inputHeight * 2.2
                display: AbstractButton.TextUnderIcon
               
                contentItem: Item {
                    Image {
                        id: powerIcon
                    
                        anchors.centerIn: parent
                        source: index == 0 ? Qt.resolvedUrl("../icons/sleep.svg") : (index == 1 ? Qt.resolvedUrl("../icons/restart.svg") : Qt.resolvedUrl("../icons/power.svg"))
                        sourceSize: Qt.size(powerEntry.width * 0.5, powerEntry.height * 0.5)
                    }

                    ColorOverlay {
                        id: iconOverlay

                        anchors.fill: powerIcon
                        source: powerIcon
                        color: config.PopupBgColor
                    }

                    Text {
                        id: powerText

                        anchors.centerIn: parent
                        renderType: Text.NativeRendering
                        font.family: config.Font
                        font.pointSize: config.GeneralFontSize
                        font.bold: true
                        horizontalAlignment: Text.AlignHCenter
                        color: config.PopupBgColor
                        text: name
                        opacity: 0
                    }
                }
                
                background: Rectangle {
                    id: powerEntryBg

                    color: config.PopupHighlightColor
                    radius: config.CornerRadius
                }

                states: [
                    State {
                        name: "hovered"
                        when: powerEntry.hovered
                        PropertyChanges {
                            target: powerEntryBg
                            color: Qt.darker(config.PopupHighlightColor, 1.2)
                        }
                        PropertyChanges {
                            target: iconOverlay
                            color: Qt.darker(config.PopupHighlightColor, 1.2)
                        }
                        PropertyChanges {
                            target: powerText
                            opacity: 1
                        }
                    }
                ]

                transitions: Transition {
                    PropertyAnimation {
                        properties: "color, opacity"
                        duration: 150
                    }
                }

                MouseArea {
                    anchors.fill: parent
                    onClicked: {
                        powerPopup.close()
                        index == 0 ? sddm.suspend() : (index == 1 ? sddm.reboot() : sddm.powerOff())
                    }
                }
            }
        }

        enter: Transition {
            NumberAnimation {
                property: "opacity"
                from: 0
                to: 1
                duration: 200
                easing.type: Easing.InOutQuad
            }
        }

        exit: Transition {
            NumberAnimation {
                property: "opacity"
                from: 1
                to: 0
                duration: 200
                easing.type: Easing.InOutQuad
            }
        }
    }
}
