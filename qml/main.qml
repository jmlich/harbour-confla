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

    property var conferenceListPage: ConferenceListPage {
        onSelectConference: {
//            name, url, checksum, feedback_url
            dataSource.init_conference(conf_data);
            if (replace) {
                app.pages.replace(conferenceDetailPage);
            } else {
                app.pages.push(conferenceDetailPage);

            }
        }
    }

    property var conferenceDetailPage: ConferenceDetailPage {
    }

    property var aboutPage: AboutPage {
    }

    property var schedulePage: SchedulePage {
        onSaveFavorites: {
            dataSource.setFavorites(conferenceDetailPage.url_id, favoritesModel);
        }

    }

    property var eventDetailPage: EventDetailPage {
        onAddToFavorites: {
            schedulePage.addToFavorites(session_id);
        }
        onRemoveFromFavorites: {
            schedulePage.removeFromFavorites(session_id);
        }
    }

    property var mapPage: MapPage {
        onShowDetail: {
            placesDetailPage.name = name;
            placesDetailPage.description = description;
            placesDetailPage.image = icon;
            placesDetailPage.lat = lat;
            placesDetailPage.lon = lon;
            app.pages.push(placesDetailPage)
        }
    }

    property var placesDetailPage: PlaceDetailPage {
        onShowOnMap: {
            mapPage.mapWidget.setZoomLevel(15)
            mapPage.mapWidget.setCenterLatLon(lat, lon);
            mapPage.map_visible = true;
            app.pages.pop();

        }
    }

    property var photoDetailPage: PhotoDetailPage {
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

    function tr(message) {
        return message
    }
}
