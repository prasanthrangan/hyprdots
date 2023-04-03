import QtQuick 2.12
import QtQuick.Controls 2.12
import QtQml.Models 2.12

Item {
    property var session: sessionList.currentIndex

    implicitHeight: sessionButton.height
    implicitWidth: sessionButton.width

    DelegateModel {
        id: sessionWrapper

        model: sessionModel
        delegate: ItemDelegate {
            id: sessionEntry

            height: inputHeight
            width: parent.width
            highlighted: sessionList.currentIndex == index

            contentItem: Text {
                renderType: Text.NativeRendering
                font.family: config.Font
                font.pointSize: config.GeneralFontSize
                font.bold: true
                horizontalAlignment: Text.AlignHCenter
                verticalAlignment: Text.AlignVCenter
                color: highlighted ? config.PopupBgColor : config.PopupHighlightColor
                text: name
            }

            background: Rectangle {
                id: sessionEntryBg

                color: highlighted ? config.PopupHighlightColor : config.PopupBgColor
                radius: config.CornerRadius
            }

            states: [
                State {
                    name: "hovered"
                    when: sessionEntry.hovered
                    PropertyChanges {
                        target: sessionEntryBg
                        color: highlighted ? Qt.darker(config.PopupHighlightColor, 1.2) : Qt.darker(config.PopupBgColor, 1.2)
                    }
                }
            ]

            transitions: Transition {
                PropertyAnimation {
                    property: "color"
                    duration: 150
                }
            }

            MouseArea {
                anchors.fill: parent
                onClicked: {
                    sessionList.currentIndex = index
                    sessionPopup.close()
                }
            }
        }
    }

    Button {
        id: sessionButton

        height: inputHeight
        width: inputHeight
        hoverEnabled: true

        icon.source: Qt.resolvedUrl("../icons/settings.svg")
        icon.height: height * 0.6
        icon.width: width * 0.6
        icon.color: config.SessionIconColor
        
        background: Rectangle {
            id: sessionButtonBg

            color: config.SessionButtonColor
            radius: config.CornerRadius
        }

        states: [
            State {
                name: "pressed"
                when: sessionButton.down
                PropertyChanges {
                    target: sessionButtonBg
                    color: Qt.darker(config.SessionButtonColor, 1.2)
                }
            },
            State {
                name: "hovered"
                when: sessionButton.hovered
                PropertyChanges {
                    target: sessionButtonBg
                    color: Qt.darker(config.SessionButtonColor, 1.2)
                }
            },
            State {
                name: "selection"
                when: sessionPopup.visible
                PropertyChanges {
                    target: sessionButtonBg
                    color: Qt.darker(config.SessionButtonColor, 1.2)
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
            sessionPopup.visible ? sessionPopup.close() : sessionPopup.open()
            sessionButton.state = "pressed"
        }
    }

    Popup {
        id: sessionPopup

        width: inputWidth + padding * 2
        x: sessionButton.width + sessionList.spacing
        y: -(contentHeight + padding * 2) + sessionButton.height
        padding: 15

        background: Rectangle {
            radius: config.CornerRadius * 1.8
            color: config.PopupBgColor
        }
        
        contentItem: ListView {
            id: sessionList

            implicitHeight: contentHeight
            spacing: 8
            model: sessionWrapper
            currentIndex: sessionModel.lastIndex
            clip: true
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
