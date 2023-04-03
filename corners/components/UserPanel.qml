import QtQuick 2.12
import QtQuick.Controls 2.12
import QtGraphicalEffects 1.12
import QtQml.Models 2.12

Column {
    property var username: usernameField.text

    spacing: 30

    DelegateModel {
        id: userWrapper

        model: userModel
        delegate: ItemDelegate {
            id: userEntry
                
            height: inputHeight
            width: parent.width
            highlighted: userList.currentIndex == index

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
                id: userEntryBg

                color: highlighted ? config.PopupHighlightColor : config.PopupBgColor
                radius: config.CornerRadius
            }

            states: [
                State {
                    name: "hovered"
                    when: userEntry.hovered
                    PropertyChanges {
                        target: userEntryBg
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
                    userList.currentIndex = index
                    usernameField.text = userWrapper.items.get(index).model.name
                    userPicture.source = userWrapper.items.get(index).model.icon
                    userPopup.close()
                }
            }
        }
    }

    Popup {
        id: userPopup

        width: inputWidth
        y: (inputWidth / 3) - padding - (userList.implicitHeight / 2)
        padding: 15

        background: Rectangle {
            radius: config.CornerRadius * 1.8
            color: config.PopupBgColor
        }

        contentItem: ListView {
            id: userList

            implicitHeight: contentHeight
            spacing: 8
            model: userWrapper
            currentIndex: userModel.lastIndex
            clip: true
        }

        enter: Transition {
            NumberAnimation {
                properties: "opacity"
                from: 0
                to: 1
                duration: 200
                easing.type: Easing.InOutQuad
            }
        }

        exit: Transition {
            NumberAnimation {
                properties: "opacity"
                from: 1
                to: 0
                duration: 200
                easing.type: Easing.InOutQuad
            }
        }
    }

    Item {
        width: inputWidth
        implicitHeight: pictureBorder.height

        Rectangle {
            id: pictureBorder

            anchors.centerIn: userPicture
            height: inputWidth / 1.5 + (border.width * 2)
            width: inputWidth / 1.5 + (border.width * 2)
            radius: height / 2
            border.width: config.UserPictureBorderWidth
            border.color: config.UserPictureBorderColor
            color: config.UserPictureColor

            MouseArea {
                id: roundMouseArea

                anchors.fill: parent
                hoverEnabled: true

                onClicked: userPopup.open()
                onHoveredChanged: {
                    if (containsMouse) {
                        pictureBorder.state = "hovered"
                    } else {
                        pictureBorder.state = "unhovered"
                    }
                }
                onPressedChanged: {
                    if (containsPress) {
                        pictureBorder.state = "pressed"
                    } else if (containsMouse) {
                        pictureBorder.state = "hovered"
                    } else {
                        pictureBorder.state = "unhovered"
                    }
                }
            }

            states: [
                State {
                    name: "pressed"
                    PropertyChanges {
                        target: pictureBorder
                        border.color: Qt.darker(config.UserPictureBorderColor, 1.2)
                        color: Qt.darker(config.UserPictureColor, 1.2)
                    }
                },
                State {
                    name: "hovered"
                    PropertyChanges {
                        target: pictureBorder
                        border.color: Qt.darker(config.UserPictureBorderColor, 1.4)
                        color: Qt.darker(config.UserPictureColor, 1.4)
                    }
                },
                State {
                    name: "unhovered"
                    PropertyChanges {
                        target: pictureBorder
                        border.color: config.UserPictureBorderColor
                        color: config.UserPictureColor
                    }
                }
            ]

            transitions: Transition {
                PropertyAnimation {
                    properties: "border.color, color"
                    duration: 150
                }
            }
        }

        Image {
            id: userPicture
            source: ""

            height: inputWidth / 1.5
            width: inputWidth / 1.5
            anchors.horizontalCenter: parent.horizontalCenter

            fillMode: Image.PreserveAspectCrop
            layer.enabled: true
            layer.effect: OpacityMask {
                maskSource: mask
            }

            Rectangle {
                id: mask

                anchors.fill: parent
                radius: inputWidth / 3
                visible: false
            }
        }
    }

    UserFieldPanel {
        id: usernameField

        height: inputHeight
        width: inputWidth
    }

    Component.onCompleted: userPicture.source = userWrapper.items.get(userList.currentIndex).model.icon
}
