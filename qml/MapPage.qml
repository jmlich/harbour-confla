import QtQuick 2.0
import "components/platform"
import QtPositioning 5.0

PageEmptyPL {
    id: page;
    //% "Places"
    title: qsTrId("map-title")

    property alias deviceLat: map.currentPositionLat
    property alias deviceLon: map.currentPositionLon
    property alias mapWidget: map;

    signal showDetail(string name, string description, url icon, double lat, double lon);

    PinchMap {
        id: map
        anchors.top: parent.top;
        anchors.left: parent.left;
        anchors.right: parent.right;
        height: parent.height / 2;
        clip: true;
        pageActive: page.visible;

        onMapItemClicked: {
            showDetail(name, description, icon, lat, lon);
        }
    }

    IconButtonPL {
        visible: map.currentPositionValid;
        iconName: styler.iconMyPosition
        anchors.right: map.right;
        anchors.bottom: map.bottom
        onClicked: {
            map.setCenterLatLon(map.currentPositionLat, map.currentPositionLon);
        }
    }

    ListView {
        anchors.top: map.bottom;
        anchors.left: parent.left;
        anchors.right: parent.right;
        anchors.bottom: parent.bottom;
        clip: true;
        model: map.places;
        delegate: ListItemPL {
            id: delegate;
            contentHeight: Math.max(placesDelegate.height, placesDelegateColumn.height) + 2 * styler.themePaddingSmall
            Image {
                id: placesDelegate
                anchors.left: parent.left;
                anchors.verticalCenter: parent.verticalCenter;
                anchors.margins: styler.themePaddingSmall;
                source: model.icon;
                smooth: true
                fillMode: Image.PreserveAspectFit
                width: 0.5 * dpix;
                height: 0.5 * dpiy;
            }
            Image {
                anchors.centerIn: placesDelegate;
                source: "./images/marker-icon.png"
                visible: (placesDelegate.status !== Image.Ready)
                fillMode: Image.PreserveAspectFit
            }

            Column {
                id: placesDelegateColumn
                anchors.left: placesDelegate.right
                anchors.right: parent.right;
                anchors.verticalCenter: parent.verticalCenter;
                anchors.leftMargin: styler.themePaddingSmall;

                Text {
                    width: parent.width
                    color: delegate.highlighted ? styler.themeHighlightColor : styler.themePrimaryColor
                    font.pixelSize: styler.themeFontSizeMedium
                    wrapMode: Text.Wrap;
                    text: model.name;
                }
                Text {
                    width: parent.width
                    visible: text !== ""
                    color: styler.themeSecondaryColor
                    font.pixelSize: styler.themeFontSizeSmall
                    wrapMode: Text.Wrap;
                    text: model.description;
                }
            }
            onClicked: {
                map.selectedIndex = index;
                map.setCenterLatLon(model.lat, model.lon)
            }
        }
    }

    PositionSource {
        id: positionSource
        updateInterval: 1000
        active: page.visible;
        onPositionChanged: {
            var coord = position.coordinate;
            map.currentPositionLat = coord.latitude;
            map.currentPositionLon = coord.longitude;
            map.currentPositionValid = position.latitudeValid
        }
    }

    function reload(d) {
        map.places.clear();
        map.selectedIndex = -1;
        if (d.places !== undefined) {
            var places = d.places;
            for (var i = 0; i < places.length; i++) {
                var item = places[i];
                map.places.append(item);
            }
        }

        if (d.rooms !== undefined) {
            for (var i = 0; i < d.rooms.length; i++) {
                var room = d.rooms[i];
                if (room.latlon === undefined) {
                    continue;
                }
                map.places.append({
                    "name": room.name.replace(/\.\*$/, ""),
                    "description": roomsMatching(room.name, d.sessions),
                    "icon": "",
                    "lat": room.latlon[0],
                    "lon": room.latlon[1],
                });
            }
        }

        if (map.places.count > 0) {
            var lat = 0;
            var lon = 0;
            for (var i = 0; i < map.places.count; i++) {
                lat += map.places.get(i).lat;
                lon += map.places.get(i).lon;
            }
            map.setZoomLevel(17);
            map.setCenterLatLon(lat / map.places.count, lon / map.places.count);
        }
    }

    // room names in menu.json are regular expressions, list the schedule rooms they cover
    function roomsMatching(pattern, sessions) {
        if (sessions === undefined) {
            return "";
        }
        var re = new RegExp("^(" + pattern + ")$");
        var names = [];
        for (var i = 0; i < sessions.length; i++) {
            var name = sessions[i].room;
            if (re.test(name) && names.indexOf(name) === -1) {
                names.push(name);
            }
        }
        names.sort();
        return names.join(", ");
    }


}
