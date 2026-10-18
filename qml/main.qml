import QtQuick 2.0
import cz.mlich 1.0
import "components/platform"

ApplicationWindowPL {
    id: app
    //% "Confla"
    title: qsTrId("application-title")
    initialPage: conferenceListPage

    // used by the platform components
    property bool infoActive: false
    property var styler: StylerPL {}

    // Kirigami deletes a popped page that has no parent item, keep the pages here
    property Item pageParent: Item {
        visible: false

        ConferenceListPage {
            id: conferenceListPage
            onSelectConference: {
                dataSource.configSet("last_conference", conf_data['url']);
    //            name, url, checksum, feedback_url
                dataSource.init_conference(conf_data);
                if (replace) {
                    app.pages.replace(conferenceDetailPage);
                } else {
                    app.pages.push(conferenceDetailPage);

                }
            }
        }

        ConferenceDetailPage {
            id: conferenceDetailPage
        }

        AboutPage {
            id: aboutPage
        }

        SchedulePage {
            id: schedulePage
            onSaveFavorites: {
                dataSource.setFavorites(dataSource.data["url"], favoritesModel);
            }

        }

        EventDetailPage {
            id: eventDetailPage
            onAddToFavorites: {
                schedulePage.addToFavorites(session_id);
            }
            onRemoveFromFavorites: {
                schedulePage.removeFromFavorites(session_id);
            }
        }

        MapPage {
            id: mapPage
            onShowDetail: {
                placesDetailPage.name = name;
                placesDetailPage.description = description;
                placesDetailPage.image = icon;
                placesDetailPage.lat = lat;
                placesDetailPage.lon = lon;
                app.pages.push(placesDetailPage)
            }
        }

        PlaceDetailPage {
            id: placesDetailPage
            onShowOnMap: {
                mapPage.mapWidget.setZoomLevel(15)
                mapPage.mapWidget.setCenterLatLon(lat, lon);
                app.pages.pop();

            }
        }

        PhotoDetailPage {
            id: photoDetailPage
        }
    }

    property var dataSource: Data {
    }

    property var updateTimer: Timer {
        running: true;
        repeat: true;
        interval: 600000; // 10 minutes
        onTriggered: {
            dataSource.updateUI();
        }
    }

    property var filereader: FileReader {
    }

    property var downloader: Downloader {
    }

    Component.onCompleted: {
        dataSource.init_data()
    }

    // reopen the last conference once the page stack is ready, back goes to the conference list
    property var openLastTimer: Timer {
        interval: 0
        running: true
        onTriggered: {
            conferenceListPage.openConference(dataSource.configGet("last_conference", ""));
        }
    }

    function tr(message) {
        return message
    }
}
