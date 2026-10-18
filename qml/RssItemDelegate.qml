import QtQuick 2.0
import "components/platform"

ListItemPL {

    id: delegate

    property string title: ""
    property string description: ""
    property int date;
    property url link;
    property alias img: avatarImage.source;

    contentHeight: Math.max(rssDateLabel.paintedHeight + rssDescriptionLabel.paintedHeight + 2 * styler.themePaddingLarge, 2 * styler.themePaddingLarge + avatarImage.height)

    Image {
        id: dummyImage;
        z: avatarImage.z -1;
        anchors.fill: avatarImage;
        source: "qrc:/images/blank_boy.png"
        visible: avatarImage.status !== Image.Ready;
    }

    Image {

        id: avatarImage;
        z: delegate.z+2
        anchors.left: parent.left
        anchors.top: parent.top;
        width: 0.8 * dpix;
        height: 0.8 * dpiy;
        anchors.margins: styler.themePaddingMedium;
        fillMode: Image.PreserveAspectCrop;

    }

    Text {
        id: rssDescriptionLabel
        anchors.top: parent.top;
        anchors.left: avatarImage.right;
        anchors.right: parent.right;
        anchors.margins: styler.themePaddingLarge;


        color: delegate.highlighted ? styler.themeHighlightColor : styler.themeSecondaryColor;
        wrapMode: Text.Wrap;
        font.pixelSize: styler.themeFontSizeSmall
        textFormat: Text.RichText;

        text: "<b>" + delegate.title + "</b> " + delegate.description

    }

    Text {
        id: rssDateLabel
        anchors.top: rssDescriptionLabel.bottom;
        anchors.left: avatarImage.right;
        anchors.right: parent.right;
        anchors.topMargin: styler.themePaddingLarge
        anchors.leftMargin: styler.themePaddingLarge;
        anchors.rightMargin: styler.themePaddingLarge;
        horizontalAlignment: Text.AlignRight


        color: delegate.highlighted ? styler.themeHighlightColor : styler.themeSecondaryColor;
        wrapMode: Text.Wrap;
        font.pixelSize: styler.themeFontSizeExtraSmall
        //        text: Format.formatDate(new Date(date*1000), Formatter.TimepointRelative)
        text: new Date(date*1000).toLocaleDateString()
    }


    onClicked: {
        Qt.openUrlExternally(link)
    }

}
