import QtQuick 2.0
import "functions.js" as F

BackgroundItem {

    id: scheduleDelegate
    height: Math.max(startTimeLabel.height + endTimeLabel.height + roomLabel.height + styler.themePaddingMedium, roomLabel.height, titleLabel.height) + 2 * styler.themePaddingMedium

    property int startTime;
    property int endTime;
    property alias roomShort: roomLabel.text;
    property color roomColor
    color: highlighted ? Qt.darker(roomColor): roomColor
    property string speakers_str;
    property string title;
    property int currentTimestamp;
    property bool inFavorites;

    Text {
        id: startTimeLabel
        text: F.format_time(startTime);
        font.pixelSize: styler.themeFontSizeExtraSmall;
        color: scheduleDelegate.highlighted ? styler.themeHighlightColor : styler.themeSecondaryColor
        anchors.left: parent.left;
        anchors.top: parent.top;
        anchors.margins: styler.themePaddingMedium
        textFormat: Text.RichText;
    }
    Text {
        id: endTimeLabel
        text: F.format_time(endTime);
        font.pixelSize: styler.themeFontSizeExtraSmall;
        color: scheduleDelegate.highlighted ? styler.themeHighlightColor : styler.themeSecondaryColor
        anchors.left: parent.left;
        anchors.top: startTimeLabel.bottom
        anchors.margins: styler.themePaddingMedium
        textFormat: Text.RichText;

    }

    Text {
        id: roomLabel;
        font.pixelSize: styler.themeFontSizeExtraSmall;

        color: scheduleDelegate.highlighted ? styler.themeHighlightColor : styler.themeSecondaryColor
        anchors.left: parent.left;
        anchors.top: endTimeLabel.bottom;
        anchors.margins: styler.themePaddingMedium
        textFormat: Text.RichText;

    }

    Text {
        id: titleLabel
        anchors.left: startTimeLabel.right
        anchors.right: parent.right
        anchors.top: parent.top;
        anchors.margins: styler.themePaddingMedium
        font.pixelSize: styler.themeFontSizeSmall

        text: (speakers_str !== "") ? (speakers_str + ": " + title) : title
        color: (currentTimestamp > endTime)
               ? (scheduleDelegate.highlighted ? styler.themeHighlightColor : styler.themeSecondaryColor)
                 : (scheduleDelegate.highlighted ? styler.themeHighlightColor : styler.themePrimaryColor)
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
