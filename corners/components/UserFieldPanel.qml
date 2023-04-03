import QtQuick 2.12
import QtQuick.Controls 2.12
import QtGraphicalEffects 1.12

TextField {
    id: usernameField

    height: inputHeight
    width: inputWidth
    selectByMouse: true
    echoMode: TextInput.Normal
    selectionColor: config.TextFieldTextColor

    renderType: Text.NativeRendering
    font.family: config.Font
    font.pointSize: config.GeneralFontSize
    font.bold: true
    color: config.TextFieldTextColor
    horizontalAlignment: Text.AlignHCenter

    placeholderText: "User"
    text: userModel.lastUser

    background: Rectangle {
        id: userFieldBackground

        color: config.TextFieldColor
        border.color: config.TextFieldTextColor
        border.width: 0
        radius: config.CornerRadius
    }

    states: [
        State {
            name: "focused"
            when: usernameField.activeFocus
            PropertyChanges {
                target: userFieldBackground
                color: Qt.darker(config.TextFieldColor, 1.2)
                border.width: 3
            }
        },
        State {
            name: "hovered"
            when: usernameField.hovered
            PropertyChanges {
                target: userFieldBackground
                color: Qt.darker(config.TextFieldColor, 1.2)
            }
        }
    ]

    transitions: Transition {
        PropertyAnimation {
            properties: "color, border.width"
            duration: 150
        }
    }
}

