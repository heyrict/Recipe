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
        state: "sidebarOnly"

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
                height: root.height / 10
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
                id: recipeList
                anchors {
                    left: parent.left
                    top: contentsBanner.bottom
                    bottom: parent.bottom
                    right: parent.right
                }

                topMargin: 30
                delegate: recipeDelegate
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
            color: "#5fb4a6"
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

            ListView {
                id: recipeTitleList
                width: root.width
                anchors.fill: parent
                model: recipeTitleModel
                delegate: recipeTitleDelegate
                topMargin: 50

            }
        }

    }

    Component {
        id: recipeTitleDelegate
        Row {
            property int fontsize: root.height / 20
            property int rectWidth: recipeTitleList.width
            property var colorPalette: Gradient {
                GradientStop { position: 0; color: "#ccccee"}
                GradientStop { position: 1; color: "#aaaaee"}
            }

            leftPadding: rectWidth * 0.05
            rightPadding: rectWidth * 0.05

            Rectangle {
                width: rectWidth * 0.9
                height: fontsize * 2
                color: "lightcyan"
                gradient: colorPalette
                radius: fontsize
                Text {
                    anchors.centerIn: parent
                    text: title
                    //font.pixelSize: fontsize
                    font.pixelSize: parent.width<fontsize*title.length?parent.width/title.length:fontsize
                    visible: parent.width < 5 ? false : true
                }
                MouseArea {
                    anchors.fill: parent
                    onClicked: {
                        recipeList.model = recipeModel
                        root.state = "sidebarInvisible"
                    }
                }
            }
        }
    }

    Component {
        id: recipeDelegate
        Row {
            property int fontsize: root.height / 20
            property int rectWidth: recipeList.width / 2
            property var colorPalette: Gradient {
                GradientStop { position: 0; color: "#eeee04"}
                GradientStop { position: 1; color: "#ddcc00"}
            }

            topPadding: fontsize

            Rectangle {
                gradient: colorPalette
                Text{
                    text: compName
                    anchors.centerIn: parent
                    font.pixelSize: fontsize
                }
                height: fontsize*2
                width: rectWidth
            }

            Rectangle {
                gradient: colorPalette
                TextInput {
                    text: quantity
                    font.underline: true
                    anchors.centerIn: parent
                    font.pixelSize: fontsize
                    onEditingFinished: {
                        var rate = Number(text)/quantity
                        if (rate > 0 && rate < 100)
                            recipeList.model.updateModel(rate,calcMtd)
                    }
                }
                height: fontsize*2
                width: rectWidth
            }
        }
    }

}
