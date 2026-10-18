import QtQuick 2.0

Rectangle {
    id: backgroundItem;
    property bool highlighted: highlight_enabled && mouse.pressed;
    property bool highlight_enabled: true;
    width: (parent !== null) ? parent.width : 100;
    color: highlighted ? Qt.rgba(styler.themePrimaryColor.r, styler.themePrimaryColor.g, styler.themePrimaryColor.b, 0.2) : "transparent"
    signal clicked();

    MouseArea {
        id: mouse
        anchors.fill: parent;
        onClicked: {
            backgroundItem.clicked();
        }
    }
}
