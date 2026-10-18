import QtQuick 2.0


Page {
    id: page

    property string text

    Flickable {
        anchors.fill: parent
        contentHeight: column.height

        Column {
            id: column

            width: page.width
            spacing: styler.themePaddingLarge
            Text {
                id: contentLabel
                wrapMode: Text.Wrap;
                font.pixelSize: styler.themeFontSizeSmall;
                anchors.left: parent.left
                anchors.right: parent.right
                anchors.margins: styler.themePaddingLarge;
                textFormat: Text.RichText
                color: styler.themePrimaryColor
                text: "<style type='text/css'>a:link{color:"+styler.themeHighlightColor+"; } a:visited{color:"+styler.themeHighlightColor+"}</style>  "+ page.text
                onLinkActivated:{
                    Qt.openUrlExternally(link)
                }

            }

        }
    }
}
