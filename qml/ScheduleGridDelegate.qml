import QtQuick 2.0
import "functions.js" as F


Rectangle {
    id: scheduleGridDelegate

    property bool highlighted: mouse.pressed
    signal clicked()

    property int startTime;
    property int endTime;
//    property alias roomShort: roomLabel.text;
    property color roomColor
    readonly property color textColor: F.textColorOn(color)
    property string speakers_str;
    property string title;
    property int currentTimestamp;
    property bool inFavorites: false;

    clip: true;
    border.color: styler.themeSecondaryColor;
    color: highlighted ? Qt.darker(roomColor) : roomColor
//    border.color: inFavorites ? Qt.lighter(styler.themeHighlightColor) : Theme.background_color_pressed;


    Text {
        id: roomColorLabel
        anchors.left: parent.left;
        anchors.top: parent.top;
        anchors.margins: styler.themePaddingMedium
        font.pixelSize: styler.themeFontSizeExtraSmall;
        color: scheduleGridDelegate.textColor
        //               font.family: Theme.fontFamilyHeading
        font.weight: Font.Bold
        text: "|"
    }

    Text {
        anchors.left: roomColorLabel.left;
        anchors.top: parent.top;
        anchors.right: parent.right;
        anchors.bottom: parent.bottom;
        anchors.margins: styler.themePaddingMedium
        font.pixelSize: styler.themeFontSizeExtraSmall;

        text: (speakers_str !== "") ? (speakers_str + ": " + title) : title
        color: scheduleGridDelegate.textColor
        opacity: (currentTimestamp > endTime) ? 0.6 : 1
        wrapMode: Text.Wrap;
        textFormat: Text.RichText;

    }

    Image {
        visible: inFavorites;
        source: "./images/ic_favorite_white_48dp.png"
        anchors.right: parent.right;
        anchors.bottom: parent.bottom;
        fillMode: Image.PreserveAspectFit;
        height: 24;
        anchors.margins: styler.themePaddingMedium;
        opacity: 0.5;
    }

    MouseArea {
        id: mouse
        anchors.fill: parent
        onClicked: scheduleGridDelegate.clicked()
    }


}
