import QtQuick 2.0
import "../common"

Rectangle {
    id: root
    property double quantity
    property string compName
    property string calcMtd
    property int generalLength: height / 10

    signal returned
    signal confirmed(var elementObj)

    Rectangle {
        id: renameRecipeDialogTopbar
        anchors {
            top: parent.top
            left: parent.left
            right: parent.right
        }
        height: root.generalLength
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
            height: root.generalLength
            fontsize: root.generalLength / 2
            name: "配料"
            value: root.compName
            KeyNavigation.tab: quantityInput
        }
        LabeledTextInput {
            id: quantityInput
            anchors.left: parent.left
            anchors.right: parent.right
            height: root.generalLength
            fontsize: root.generalLength / 2
            name: "数量"
            value: root.quantity
            KeyNavigation.tab: calcMtdInput
        }
        LabeledTextInput {
            id: calcMtdInput
            anchors.left: parent.left
            anchors.right: parent.right
            height: root.generalLength
            fontsize: root.generalLength / 2
            name: "计数"
            value: root.calcMtd
        }
    }
}
