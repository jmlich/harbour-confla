import QtQuick 2.0
import "components/platform"
import "functions.js" as F

PagePL {
    id: page
    //% "Talk"
    title: qsTrId("event-detail-title")

    property alias um: usersModel;
    //    property alias title: header.title
    property alias talkName: talkNameLabel.text
    property alias description: descriptionLabel.text

    property string startDay;
    property string startTime
    property string endTime
    property alias room: roomLabel.text
    property alias roomColor: tagsLabelBackground.color
    property alias tags: tagsLabel.text;

    property bool inFavorites: false;

    property string session_id;

    signal addToFavorites(string session_id);
    signal removeFromFavorites(string session_id);


    ListModel {
        id: usersModel;
    }


    Column {
        id: column

        width: page.width
        spacing: styler.themePaddingMedium


        //            PageHeader {
        //                id: header;
        //                title: "event"
        //            }

        Text {
            id: talkNameLabel
            anchors.left: parent.left
            anchors.right: parent.right
            anchors.margins: styler.themePaddingMedium;
            //                font.family: Theme.fontFamilyHeading
            font.pixelSize: styler.themeFontSizeLarge
            color: styler.themePrimaryColor
            wrapMode: Text.WordWrap

        }

        Text {
            id: timeLabel
            anchors.left: parent.left
            anchors.right: parent.right
            anchors.margins: styler.themePaddingMedium;
            color: styler.themeSecondaryColor
            font.pixelSize: styler.themeFontSizeSmall
            text: startTime + " - " + endTime

        }

        Text {
            id: roomLabel
            anchors.left: parent.left
            anchors.right: parent.right
            anchors.margins: styler.themePaddingMedium;
            color: styler.themeSecondaryColor
            font.pixelSize: styler.themeFontSizeSmall
        }




        Repeater {
            model: usersModel;
            delegate: BackgroundItem {
                id: usersDelegate
                highlight_enabled: false;

                height: Math.max(avatarImage.height, nameLabel.paintedHeight + companyLabel.paintedHeight + positionLabel.paintedHeight + 2*styler.themePaddingMedium) + bioLabel.paintedHeight + 3 * styler.themePaddingMedium

                Image {
                    id: dummyImage;
                    z: avatarImage.z -1;
                    anchors.fill: avatarImage;
                    source: "qrc:/qml/images/blank_boy.png"
                    visible: avatarImage.status !== Image.Ready;
                    width: avatarImage.width;
                    height: avatarImage.height
                }

                Image {
                    id: avatarImage;
                    z: usersDelegate.z+2
                    anchors.left: parent.left
                    anchors.top: parent.top;
                    source: model.avatar;
                    width: 1.5 * dpix;
                    height: 1.5 * dpiy;
                    sourceSize.width: width
                    sourceSize.height: height
                    fillMode: Image.PreserveAspectCrop
                    asynchronous: true
                    anchors.margins: styler.themePaddingMedium;

                }

                Text {
                    id: nameLabel
                    anchors.top: parent.top;
                    anchors.left: avatarImage.right
                    anchors.right: parent.right
                    anchors.margins: styler.themePaddingMedium;

                    text: model.name
                    color: styler.themePrimaryColor
                    font.pixelSize: styler.themeFontSizeMedium
                    wrapMode: Text.WordWrap

                }

                Text {
                    id: companyLabel
                    anchors.left: avatarImage.right
                    anchors.top: nameLabel.bottom
                    anchors.right: parent.right
                    anchors.margins: styler.themePaddingMedium;
                    text: model.company
                    color: styler.themeSecondaryColor
                    font.pixelSize: styler.themeFontSizeSmall
                    wrapMode: Text.WordWrap

                }
                Text {
                    id: positionLabel
                    anchors.right: parent.right
                    anchors.margins: styler.themePaddingMedium;
                    anchors.top: companyLabel.bottom
                    anchors.left: avatarImage.right
                    text: model.position
                    color: styler.themeSecondaryColor
                    font.pixelSize: styler.themeFontSizeSmall
                    wrapMode: Text.WordWrap

                }
                Text {
                    id: bioLabel
                    anchors.left: parent.left
                    anchors.right: parent.right
                    anchors.top: (avatarImage.height > nameLabel.paintedHeight + companyLabel.paintedHeight + positionLabel.paintedHeight)
                                 ? avatarImage.bottom : positionLabel.bottom
                    anchors.margins: styler.themePaddingMedium;
                    text: model.bio !== undefined ? model.bio : ""
                    color: styler.themeSecondaryColor
                    font.pixelSize: styler.themeFontSizeSmall
                    wrapMode: Text.WordWrap
                }
            }
        }

        Rectangle {
            id: tagsLabelBackground
            anchors.left: parent.left
            anchors.right: parent.right
            anchors.margins: styler.themePaddingMedium;
            height: tagsLabel.paintedHeight + tagsLabel.anchors.topMargin + tagsLabel.anchors.bottomMargin
            color: styler.themeHighlightColor
            z: tagsLabel.z -1;
            Text {
                id: tagsLabel;
                anchors.fill: tagsLabelBackground
                anchors.margins: styler.themePaddingSmall
                font.pixelSize: styler.themeFontSizeSmall
                color: "#ffffff";//styler.themeHighlightColor
                wrapMode: Text.WordWrap
                textFormat: Text.RichText;
            }
        }

        Text {
            id: descriptionLabel
            anchors.left: parent.left
            anchors.right: parent.right
            anchors.margins: styler.themePaddingMedium;
            font.pixelSize: styler.themeFontSizeSmall
            color: styler.themeSecondaryColor
            wrapMode: Text.WordWrap
            textFormat: Text.RichText;

        }
        ButtonPL {
            anchors.horizontalCenter: parent.horizontalCenter
            text: inFavorites ?
                      //% "Remove from favorites"
                      qsTrId("remove-from-favorites")
                    :
                      //% "Add to favorites"
                      qsTrId("add-to-favorites")
            onClicked: {
                if (inFavorites) {
                    removeFromFavorites(session_id);
                    inFavorites = false;
                } else {
                    addToFavorites(session_id);
                    inFavorites = true;
                }
            }
        }

        ButtonPL {
            anchors.horizontalCenter: parent.horizontalCenter
            visible: (conferenceDetailPage.feedback_url !== '')

            //% "Leave your feedback here"
            text: qsTrId("open-feedback-form")
            onClicked: {
                var link = conferenceDetailPage.feedback_url;
                link = link.replace(/\{url_id\}/, conferenceDetailPage.url_id)
                link = link.replace(/\{session_id\}/, session_id)
                Qt.openUrlExternally( link )
            }
        }

    }
}
