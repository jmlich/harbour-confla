import QtQuick 2.0

Rectangle {
    id: button;
    width: dpix * 0.5;
    height: dpiy * 0.5;
    anchors.margins: styler.themePaddingMedium

    property alias image: icon.source;
    radius: 3;

    // floats over the map or the schedule and the icons are white
    color: mouse.pressed ? "#c0000000" : "#80000000";
    border.color: styler.themeSecondaryColor ;
    border.width: 1;
    signal clicked();
    Image {
        id: icon
        anchors.centerIn: parent;

        width: button.width * 0.8;
        height: button.height * 0.8;
        fillMode: Image.PreserveAspectFit
    }
    MouseArea {
        id: mouse;
        anchors.fill: parent;
        onClicked: {
            button.clicked();
        }
    }
}

