import QtQuick 2.0

Rectangle {
    property alias text: sectionHeaderText.text
    color: "transparent"
    width: parent.width;
    height: sectionHeaderText.paintedHeight

    Text {
        id: sectionHeaderText
        anchors.fill: parent;
        verticalAlignment: Text.AlignVCenter
        anchors.margins: styler.themeHorizontalPageMargin
        horizontalAlignment: Text.AlignRight;
        color: styler.themeHighlightColor;
        font.pixelSize: styler.themeFontSizeExtraSmall;
    }

}
