import QtQuick 2.6
import QtQuick.Window 2.2
import QtQuick.Controls 2.2
import "common"

Window {
    visible: true
    width: 640
    height: 480
    title: "Recipe"

    StackView {
        id: stack
        anchors.fill: parent
        initialItem: Rectangle {
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
                        width: root.width>root.generalLength * 10?root.width*0.382:root.width
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
                                opacity: 0.0
                            }
                            PropertyChanges {
                                target: contentsEditToolbar
                                opacity: 1.0
                            }
                        },
                        State {
                            name: "normalContents"
                            PropertyChanges {
                                target: contentsToolbar
                                opacity: 1.0
                            }
                            PropertyChanges {
                                target: contentsEditToolbar
                                opacity: 0.0
                            }
                        }
                    ]
                    transitions: [Transition {
                            from: "editContents"
                            to: "normalContents"
                            SequentialAnimation {
                                NumberAnimation {target: contentsEditToolbar; property: "opacity"; duration: root.transTime}
                                NumberAnimation {target: contentsToolbar; property: "opacity"; duration: root.transTime}
                            }
                        },
                        Transition {
                            SequentialAnimation {
                                NumberAnimation {target: contentsToolbar; property: "opacity"; duration: root.transTime}
                                NumberAnimation {target: contentsEditToolbar; property: "opacity"; duration: root.transTime}
                            }
                        }
                    ]

                    Connections { target: root; onStateChanged: {contentsBanner.state = "normalContents"} }

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
                    }

                    Row {
                        id: contentsToolbar
                        layoutDirection: Qt.RightToLeft
                        visible: opacity != 0
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
                        visible: opacity != 0
                        anchors {
                            right: parent.right
                            top: parent.top
                            bottom: parent.bottom
                        }
                        padding: height * 0.1
                        spacing: height * 0.15
                        Image {
                            id: confirmEditRecipe
                            source: "components/icons/confirm.png"
                            height: parent.height * 0.8
                            width: height
                            MouseArea {
                                anchors.fill: parent
                                onClicked: {
                                    contentsBanner.state = "normalContents"
                                }
                            }
                        }
                        Image {
                            id: refreshEditRecipe
                            source:"components/icons/refresh.png"
                            height: parent.height * 0.8
                            width: height
                            MouseArea {
                                anchors.fill: parent
                                onClicked: { recipeList.model.updateModel(1) }
                            }
                        }

                        Image {
                            id: plusEditRecipe
                            source: "components/icons/plus.png"
                            height: parent.height * 0.8
                            width: height
                            MouseArea {
                                anchors.fill: parent
                                onClicked: {
                                    var addElementDialog = Qt.createComponent("components/RenameRecipeDialog.qml")
                                    var object = addElementDialog.createObject()
                                    object.returned.connect(stack.pop)
                                    object.confirmed.connect(newElement)
                                    object.compName = "配料"
                                    object.quantity = 1
                                    object.calcMtd = "x1"
                                    stack.push(object)
                                }
                                function newElement(obj) {
                                    console.log(obj.compName,obj.quantity,obj.calcMtd)
                                    recipeList.model.addElement(obj.compName,obj.quantity,obj.calcMtd)
                                }
                                //onClicked: {
                                //    recipeList.model.addElement()
                                //}
                            }
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

                    header: Item {
                        width: parent.width
                        height: contentsHeaderInput.font.pixelSize * 1.2
                        TextInput {
                            enabled: false
                            id: contentsHeaderInput
                            text: recipeList.model.title
                            font.pixelSize: calculateFontsize(text.length)
                            function calculateFontsize(stlen) {
                                var goodFontsize = Math.sqrt(parent.width / stlen) * 10
                                if (goodFontsize > parent.width / stlen * 2)
                                    return parent.width / stlen * 2
                                else return goodFontsize
                            }
                            onAccepted: {
                                recipeList.model.setTitle(text)
                                contentsHeaderInput.enabled = false
                                recipeTitleModel.refresh()
                            }
                        }
                        FlickableMouseArea {
                            anchors.fill: parent
                            onLongPressed: {
                                contentsHeaderInput.enabled = true
                                contentsHeaderInput.selectAll()
                                contentsHeaderInput.forceActiveFocus()
                            }
                        }
                    }

                    topMargin: 30
                    //! recipeDelegate start
                    delegate: SwipeDelegate {
                        id: recipeDelegate
                        width: parent.width
                        padding: 0
                        property int fontsize: root.height / 20
                        property int rectWidth: recipeList.width / 2
                        property var colorPalette: Gradient {
                            GradientStop { position: 0; color: "#eeee04"}
                            GradientStop { position: 1; color: "#ddcc00"}
                        }
                        Connections {
                            target: root
                            onStateChanged: swipe.close()
                        }

                        swipe.right: Rectangle {
                            height: fontsize * 2
                            width: height * 2 + 10
                            //width: parent.height
                            anchors.left: parent.contentItem.right
                            anchors.bottom: parent.contentItem.bottom
                            gradient: parent.colorPalette
                            Image {
                                anchors.right: parent.right
                                source: "components/icons/remove.png"
                                height: Math.min(parent.width, parent.height)
                                width: height
                                MouseArea {
                                    anchors.fill: parent
                                    onClicked: {
                                        recipeList.model.removeElement(index)
                                    }
                                }
                            }
                            Image {
                                anchors.left: parent.left
                                source: "components/icons/rename.png"
                                height: Math.min(parent.width, parent.height)
                                width: height
                                MouseArea {
                                    anchors.fill: parent
                                    onClicked: {
                                        var renameRecipeDialog = Qt.createComponent("components/RenameRecipeDialog.qml")
                                        var object = renameRecipeDialog.createObject()
                                        object.returned.connect(stack.pop)
                                        object.confirmed.connect(saveElement)
                                        object.compName = compName
                                        object.quantity = quantity
                                        object.calcMtd = calcMtd
                                        stack.push(object)
                                    }
                                    function saveElement(obj) {
                                        console.log(index,obj.compName,obj.quantity,obj.calcMtd)
                                        recipeList.model.updateElement(index,obj.compName,obj.quantity,obj.calcMtd)
                                        //compName = elementObj.compName
                                        //quantity = elementObj.quantity
                                        //calcMtd = elementObj.calcMtd
                                    }
                                }
                            }
                        }
                        background: Rectangle { color: "#00000000"}
                        contentItem: Row {
                            topPadding: 15
                            Rectangle {
                                height: recipeDelegate.fontsize*2
                                width: recipeDelegate.rectWidth
                                gradient: recipeDelegate.colorPalette
                                Text{
                                    text: compName
                                    anchors.centerIn: parent
                                    font.pixelSize: recipeDelegate.fontsize
                                }
                            }
                            Rectangle {
                                height: recipeDelegate.fontsize*2
                                width: recipeDelegate.rectWidth
                                gradient: recipeDelegate.colorPalette
                                TextInput {
                                    text: Math.round(quantity * (calcMtd=="x1"?rate:(calcMtd=="^2"?Math.sqrt(rate):1))
                                                     * 100) / 100
                                    font.underline: true
                                    anchors.centerIn: parent
                                    font.pixelSize: recipeDelegate.fontsize
                                    onEditingFinished: {
                                        var rate = Number(text)/quantity
                                        if (rate > 0 && rate < 100)
                                        {
                                            if (calcMtd == "x1")
                                                recipeList.model.updateModel(rate)
                                            else if (calcMtd == "^2")
                                                recipeList.model.updateModel(Math.pow(rate,2))
                                        }
                                    }
                                }
                            }
                        }
                    }
                    //! recipeDelegate end
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
                    height: root.generalLength
                    width: root.generalLength
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
                        anchors {
                            left: parent.left
                            top: parent.top
                            bottom: parent.bottom
                        }
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
                    Row {
                        anchors {
                            right: parent.right
                            top: parent.top
                            bottom: parent.bottom
                        }
                        spacing: height * 0.2
                        padding: height * 0.05
                        Image {
                            id: exit
                            source: "components/icons/exit.png"
                            height: Math.min(sideToolbar.height,sideToolbar.width) * 0.9
                            width: height
                            MouseArea { anchors.fill: parent; onClicked: {close()}}
                        }
                    }
                }
            }
        }

        Component {
            id: recipeTitleDelegate
            SwipeDelegate {
                id: recipeTitleSwipeDelegate
                property int fontsize: root.height / 20
                property int rectWidth: recipeTitleList.width
                Connections {
                    target: root
                    onStateChanged: swipe.close()
                }

                onClicked: {
                    recipeList.model = recipeModel
                    root.state = "sidebarInvisible"
                }
                background: Rectangle{color:"#00000000"}
                contentItem:Row {
                    leftPadding: recipeTitleSwipeDelegate.rectWidth * 0.05
                    Rectangle {
                        id: recipeTitleSwipeRect
                        width: recipeTitleSwipeDelegate.rectWidth * 0.9
                        height: fontsize * 2
                        color: "lightcyan"
                        gradient: Gradient {
                            GradientStop { position: 0; color: "#ccccee"}
                            GradientStop { position: 1; color: "#aaaaee"}
                        }
                        radius: fontsize
                        Text {
                            id: recipeTitleDelegateText
                            anchors.centerIn: parent
                            text: title
                            //font.pixelSize: fontsize
                            font.pixelSize: parent.width<fontsize/2*title.length?parent.width/title.length*2:recipeTitleSwipeDelegate.fontsize
                            visible: parent.width < 5 ? false : true
                        }
                    }
                }

                swipe.right: Image {
                    id: deleteEditRecipe
                    source: "components/icons/delete.png"
                    height: parent.height * 0.6
                    width: height
                    anchors.left: parent.contentItem.right
                    anchors.top: parent.contentItem.top
                    MouseArea {
                        anchors.fill: parent
                        onClicked: {
                            root.state = "sidebarOnly"
                            recipeTitleModel.deleteRecipeModel(index)
                        }
                    }
                }
            }
        }

    }
}
