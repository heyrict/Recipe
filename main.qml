import QtQuick 2.6
import QtQuick.Window 2.2
import "common"

Window {
    visible: true
    width: 640
    height: 480
    title: "Recipe"

    Rectangle {
        id: root
        anchors.fill: parent
        property int transTime: 300
        property int generalLength: height / 10
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
                state: "normalContents"
                states: [
                    State {
                        name: "editContents"
                        PropertyChanges {
                            target: contentsToolbar
                            visible: false
                        }
                        PropertyChanges {
                            target: contentsEditToolbar
                            visible: true
                        }
                    },
                    State {
                        name: "normalContents"
                        PropertyChanges {
                            target: contentsToolbar
                            visible: true
                        }
                        PropertyChanges {
                            target: contentsEditToolbar
                            visible: false
                        }
                    }
                ]

                Image {
                    id: menuIcon
                    source: "components/icons/menu.png"
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

                Row {
                    id: contentsToolbar
                    layoutDirection: Qt.RightToLeft
                    visible: true
                    anchors {
                        right: parent.right
                        top: parent.top
                        bottom: parent.bottom
                    }

                    Image {
                        id: editRecipe
                        source: "components/icons/edit.png"
                        height: parent.height
                        width: height
                        MouseArea {
                            anchors.fill: parent
                            onClicked: {
                                contentsBanner.state = "editContents"
                            }
                        }
                    }
                }

                Row {
                    id: contentsEditToolbar
                    layoutDirection: Qt.RightToLeft
                    visible: false
                    anchors {
                        right: parent.right
                        top: parent.top
                        bottom: parent.bottom
                    }
                    padding: height * 0.1
                    spacing: height * 0.15
                    Image {
                        id: deleteEditRecipe
                        source: "components/icons/delete.png"
                        height: parent.height * 0.8
                        width: height
                    }
                    Image {
                        id: cancelEditRecipe
                        source: "components/icons/cancel.png"
                        height: parent.height * 0.8
                        width: height
                    }
                    Image {
                        id: confirmEditRecipe
                        source: "components/icons/confirm.png"
                        height: parent.height * 0.8
                        width: height
                    }
                    Image {
                        id: plusEditRecipe
                        source: "components/icons/plus.png"
                        height: parent.height * 0.8
                        width: height
                    }
                }
            }

            ListView {
                id: recipeList
                clip: true
                anchors {
                    left: parent.left
                    top: contentsBanner.bottom
                    bottom: parent.bottom
                    right: parent.right
                }

                header: Rectangle {
                    anchors {
                        left: parent.left
                        right: parent.right
                    }
                    height: root.generalLength
                    color: "#00000000"
                    Text {
                        text: recipeList.model.title
                        font.pixelSize: root.generalLength * 0.9
                    }
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
                clip: true
                width: root.width
                anchors {
                    left: parent.left
                    right: parent.right
                    top: parent.top
                    bottom: sideToolbar.top
                }
                model: recipeTitleModel
                delegate: recipeTitleDelegate
                topMargin: 30
                spacing: 15
            }

            Rectangle {
                id: sideToolbar
                height: parent.height / 10
                width: parent.height / 10
                anchors {
                    left: parent.left
                    bottom: parent.bottom
                    right: parent.right
                }
                gradient: Gradient {
                    GradientStop { position: 0; color: Qt.lighter("#633314",2)}
                    GradientStop { position: 1; color: "#633314"}
                }

                Row {
                    anchors.fill: parent
                    spacing: height * 0.2
                    padding: height * 0.05
                    Image {
                        id: addRecipe
                        source: "components/icons/add.png"
                        height: Math.min(sideToolbar.height,sideToolbar.width) * 0.9
                        width: height
                        MouseArea {
                            anchors.fill: parent
                            onClicked: {
                                root.state = "sidebarOnly"
                                recipeTitleModel.newRecipeModel()
                            }
                        }
                    }
                }
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
                TextInput {
                    id: recipeTitleDelegateText
                    anchors.centerIn: parent
                    text: title
                    //font.pixelSize: fontsize
                    font.pixelSize: parent.width<fontsize*title.length?parent.width/title.length:fontsize
                    visible: parent.width < 5 ? false : true
                    onEditingFinished: {
                        focus = false
                        recipeModel.title = text
                    }
                }
                FlickableMouseArea {
                    anchors.fill: parent
                    onShortPressed: {
                        recipeList.model = recipeModel
                        root.state = "sidebarInvisible"
                    }
                    onLongPressed: {
                        recipeTitleDelegateText.selectAll()
                        recipeTitleDelegateText.forceActiveFocus()
                    }
                }
            }
        }
    }

    Component {
        id: recipeDelegate
        Row {
            id: recipeDelegateRow
            property int fontsize: root.height / 20
            property int rectWidth: recipeList.width / 2
            property var colorPalette: Gradient {
                GradientStop { position: 0; color: "#eeee04"}
                GradientStop { position: 1; color: "#ddcc00"}
            }
            Behavior on rectWidth { NumberAnimation { duration: root.transTime}}

            topPadding: fontsize

            Rectangle {
                height: fontsize * 2
                width: rectWidth * 2
                Rectangle {
                    gradient: colorPalette
                    anchors {
                        left: parent.left
                        top: parent.top
                        bottom: parent.bottom
                    }

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
                    anchors {
                        right: parent.right
                        top: parent.top
                        bottom: parent.bottom
                    }
                    TextInput {
                        text: quantity * rate
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
                FlickableMouseArea {
                    anchors.fill: parent
                    onLeftFlicked: {
                        recipeDelegateRow.rectWidth = recipeList.width / 2 - fontsize * 2
                    }
                    onRightFlicked: {
                        recipeDelegateRow.rectWidth = recipeList.width / 2
                    }
                }
            }

            Rectangle {
                height: fontsize * 2
                width: recipeList.width - rectWidth * 2
                gradient: colorPalette
                Behavior on width { NumberAnimation { duration: root.transTime}}
                Image {
                    source: "components/icons/remove.png"
                    height: Math.min(parent.width, parent.height)
                    width: height
                }
            }
        }
    }
}
