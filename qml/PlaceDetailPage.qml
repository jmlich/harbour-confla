import QtQuick 2.0
import "components/platform"

PagePL {
    id: page
    //% "Place"
    title: qsTrId("place-detail-header-place")
    property alias name: title_label.text
    property string description;
    property alias image: placesDelegate.source;
    property double lat
    property double lon

    signal showOnMap();


    Item {
        width: page.width
        implicitHeight: childrenRect.height
        height: implicitHeight
        //        PullDownMenu {
        //            MenuItem {
        //                //% "Show on map"
        //                text: qsTrId("place-detail-menu-show-on-map");
        //                onClicked: {
        //                    showOnMap();
        //                }
        //            }
        //            MenuItem {
        //                //% "Navigate to"
        //                text: qsTrId("place-detail-menu-navigate-to");
        //                onClicked: {
        //                    Qt.openUrlExternally("geo:"+lat+","+lon)
        //                }
        //            }
        //        }

        Image {
            id: placesDelegate
            anchors.left: parent.left;
            anchors.verticalCenter: title_label.verticalCenter;

            anchors.margins: styler.themePaddingSmall;
            smooth: true
            width: 0.5 * dpix;
            height: 0.5 * dpiy;
            fillMode: Image.PreserveAspectFit

        }
        Image {
            anchors.top: parent.top;
            anchors.left: parent.left;
            anchors.margins: styler.themePaddingMedium
            anchors.centerIn: placesDelegate;
            source: "./images/marker-icon.png"
            visible:( placesDelegate.status !== Image.Ready)
            width: placesDelegate.width;
            height: placesDelegate.height;
            fillMode: Image.PreserveAspectFit
        }


        Text {
            id: title_label
            anchors.margins: styler.themePaddingSmall;
            anchors.top: parent.top;
            anchors.left: placesDelegate.right;
            anchors.right: parent.right
            wrapMode: Text.Wrap;
            color: styler.themePrimaryColor
            verticalAlignment: Text.AlignVCenter;
            font.pixelSize: styler.themeFontSizeMedium;


        }

        Text {
            id: description_label;
            anchors.margins: styler.themePaddingMedium;
            anchors.left: parent.left
            anchors.right: parent.right
            anchors.top: title_label.bottom
            color: styler.themeSecondaryColor
            wrapMode: Text.Wrap;
            font.pixelSize: styler.themeFontSizeMedium;

            textFormat: Text.RichText;
            text: "<style type='text/css'>a:link{color:"+styler.themeHighlightColor+"; } a:visited{color:"+styler.themeHighlightColor+"}</style>  "+  description
            onLinkActivated: {
                Qt.openUrlExternally(link);
            }

        }

        ButtonPL {
            id: showOnMapButton
            anchors.topMargin: styler.themePaddingLarge
            anchors.top: description_label.bottom
            anchors.horizontalCenter: parent.horizontalCenter
            //% "Show on Map"
            text: qsTrId("show-on-map")

            onClicked: {
                showOnMap();
            }

        }

        ButtonPL {
            id: navigateToButton
            anchors.topMargin: styler.themePaddingLarge
            anchors.top: showOnMapButton.bottom
            anchors.horizontalCenter: parent.horizontalCenter
            //% "Navigate to"
            text: qsTrId("navigate-to")
            onClicked: {
                Qt.openUrlExternally("geo:"+lat+","+lon)
            }
        }


    }

}
