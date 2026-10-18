import QtQuick 2.0
import "functions.js" as F


BackgroundItem {
    id: scheduleGridDelegate

    property int startTime;
    property int endTime;
//    property alias roomShort: roomLabel.text;
    property alias roomColor: roomColorLabel.color;
    property string speakers_str;
    property string title;
    property int currentTimestamp;
    property bool inFavorites: false;

    clip: true;
    border.color: styler.themeSecondaryColor;
    color: roomColor
//    border.color: inFavorites ? Qt.lighter(styler.themeHighlightColor) : Theme.background_color_pressed;


    Text {
        id: roomColorLabel
        anchors.left: parent.left;
        anchors.top: parent.top;
        anchors.margins: styler.themePaddingMedium
        font.pixelSize: styler.themeFontSizeExtraSmall;
        color: styler.themePrimaryColor
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
        color: (currentTimestamp > endTime)
               ? (scheduleGridDelegate.highlighted ? styler.themeHighlightColor : styler.themeSecondaryColor)
               : (scheduleGridDelegate.highlighted ? styler.themeHighlightColor : styler.themePrimaryColor)
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


}
