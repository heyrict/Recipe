import QtQuick 2.6
import QtQuick.Window 2.2

Window {
    visible: true
    width: 640
    height: 480
    title: "Recipe"

    Rectangle {
        id: root
        anchors.fill: parent
        property int transTime: 300
        state: "sidebarInvisible"

        states: [
            State {
                name: "sidebarOnly"
                PropertyChanges {
                    target: sidebar
                    width: root.width
                }
            },
            State {
                name: "sidebarToggled"
                PropertyChanges {
                    target: sidebar
                    width: root.width>600?root.width*0.382:root.width
                    opacity: 100
                }
                PropertyChanges {
                    target: closeMenu
                    visible: true
                }
            },
            State {
                name: "sidebarInvisible"
                PropertyChanges {
                    target: sidebar
                    width: 0
                }
                PropertyChanges {
                    target: closeMenu
                    visible: false
                }
            }
        ]

        Rectangle {
            id: contentsField
            anchors {
                left: sidebar.right
                top: parent.top
                bottom: parent.bottom
                right: parent.right
            }

            color: "lightgray"
            gradient: Gradient {
                GradientStop { position: 0; color: Qt.lighter(contentsField.color)}
                GradientStop { position: 1; color: contentsField.color}
            }

            Behavior on width { NumberAnimation { duration: root.transTime}}

            Rectangle {
                id: contentsBanner
                anchors {
                    top: parent.top
                    left: parent.left
                    right: parent.right
                }
                height: 40
                color: "#779077"
                gradient: Gradient {
                    GradientStop { position: 0; color: Qt.lighter(contentsBanner.color)}
                    GradientStop { position: 1; color: contentsBanner.color}
                }

                Image {
                    id: menuIcon
                    source: "components/icons/menu.svg"
                    anchors {
                        left: parent.left
                        top: parent.top
                        bottom: parent.bottom
                    }
                    width: height

                    MouseArea {
                        anchors.fill: parent
                        onClicked: { root.state = "sidebarToggled" }
                    }
                    Behavior on opacity { NumberAnimation { duration: root.transTime }}
                }
            }

            ListView {
                id: contentsList
                anchors {
                    left: parent.left
                    top: contentsBanner.bottom
                    bottom: parent.bottom
                    right: parent.right
                }

                topMargin: 30
                model: recipeModel
                delegate: recipeDelegate
            }

            Component {
                id: recipeDelegate
                Row {
                    property int fontsize: 18
                    property int rectWidth: contentsList.width / 2

                    topPadding: fontsize

                    Rectangle {
                        Text{
                            text: compName
                            anchors.centerIn: parent
                            font.pixelSize: fontsize
                        }
                        height: fontsize*2
                        width: rectWidth
                    }

                    Rectangle {
                        TextInput {
                            text: quantity
                            font.underline: true
                            anchors.centerIn: parent
                            font.pixelSize: fontsize
                            onAccepted: { recipeModel.updateModel(Number(text)/quantity,calcMtd)}
                        }
                        height: fontsize*2
                        width: rectWidth
                    }
                }
            }

        }

        Rectangle {
            id: closeMenu
            anchors {
                left: sidebar.right
                top: parent.top
                bottom: parent.bottom
                right: parent.right
            }

            visible: false
            opacity: 0
            MouseArea {
                anchors.fill: parent
                onClicked: { root.state = "sidebarInvisible"}
            }
        }

        Rectangle {
            id: sidebar
            color: "#3f6456"
            anchors {
                left: parent.left
                top: parent.top
                bottom: parent.bottom
            }

            gradient:  Gradient{
                GradientStop { position: 0; color: Qt.lighter(sidebar.color,2.0)}
                GradientStop { position: 1; color: sidebar.color}
            }

            Behavior on width { NumberAnimation { duration: root.transTime}}
        }

    }
}
