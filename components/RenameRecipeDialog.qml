import QtQuick 2.0
import "../common"

Rectangle {
    id: root
    property int quantity
    property string compName
    property string calcMtd

    signal returned
    signal confirmed(var elementObj)

    Rectangle {
        id: renameRecipeDialogTopbar
        anchors {
            top: parent.top
            left: parent.left
            right: parent.right
        }
        height: root.height / 10
        color: "#779077"
        gradient: Gradient {
            GradientStop { position: 0; color: Qt.lighter(contentsBanner.color)}
            GradientStop { position: 1; color: contentsBanner.color}
        }
        Image {
            anchors {
                left: parent.left
                top: parent.top
                bottom: parent.bottom
            }
            width: height
            source: "icons/return.png"
            MouseArea {
                anchors.fill: parent
                onClicked: {
                    console.log(root.quantity,root.compName,root.calcMtd)
                    returned()
                }
            }
        }
        Image {
            anchors {
                right: parent.right
                top: parent.top
                bottom: parent.bottom
            }
            width: height
            source: "icons/confirm.png"
            MouseArea {
                anchors.fill: parent
                onClicked: {
                    confirmed({"quantity": quantityInput.getValue(),
                                  "compName": compNameInput.getValue(),
                                  "calcMtd": calcMtdInput.getValue()})
                    returned()
                }
            }
        }
    }
    Column {
        spacing: 15
        anchors {
            topMargin: 20
            top: renameRecipeDialogTopbar.bottom
            left: parent.left
            right: parent.right
        }
        property int fontsize: 18
        LabeledTextInput {
            id: compNameInput
            anchors.left: parent.left
            anchors.right: parent.right
            name: "compName"
            value: root.compName
        }
        LabeledTextInput {
            id: quantityInput
            anchors.left: parent.left
            anchors.right: parent.right
            name: "quantity"
            value: root.quantity
        }
        LabeledTextInput {
            id: calcMtdInput
            anchors.left: parent.left
            anchors.right: parent.right
            name: "calcMtd"
            value: root.calcMtd
        }
    }
}
