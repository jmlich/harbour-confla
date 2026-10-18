import QtQuick 2.0


BackgroundItem {
    id: lineButton
    height: Math.max(innerText.paintedHeight, innerImage.sourceSize.height) + styler.themePaddingLarge;
    width: parent.width;
    anchors.left: parent.left;
    anchors.right: parent.right;
    property alias text: innerText.text;
    property alias image: innerImage.source


    Image {
        id: innerImage;
        anchors.verticalCenter: parent.verticalCenter;
        anchors.left: parent.left;
        anchors.margins: styler.themePaddingLarge
        fillMode: Image.PreserveAspectFit
    }

    Text {
        id: innerText
        anchors.top: parent.top;
        anchors.left: innerImage.right
        anchors.right: parent.right

        anchors.margins: styler.themePaddingLarge
        color: lineButton.highlighted ? styler.themeHighlightColor : styler.themePrimaryColor;

        wrapMode: Text.Wrap;
//        font.family: Theme.fontFamily
        font.pixelSize: styler.themeFontSizeSmall;

    }
}



