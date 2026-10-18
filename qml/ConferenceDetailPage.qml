import QtQuick 2.0
import "functions.js" as F

Page {
    id: page
    property alias name: page.title;
    property string url_id: ""
    property string feedback_url: ""

    Flickable {
        anchors.fill: parent

        contentHeight: column.height

        Component.onCompleted: {
            maximumFlickVelocity *= 2
        }

        Column {
            id: column

            width: page.width
            spacing: styler.themePaddingSmall

            SectionHeader {
                //% "About"
                text: qsTrId("section-header-about")
                visible: (aboutModel.count > 0)
            }


            Repeater {
                model: aboutModel
                delegate: BackgroundItem {
                    id: aboutDelegate
                    width: column.width;
                    height: aboutDelegateText.paintedHeight + styler.themePaddingLarge;
                    Text {
                        id: aboutDelegateText
                        x: styler.themePaddingLarge
                        text: model.title
                        anchors.verticalCenter: parent.verticalCenter

                        color: aboutDelegate.highlighted ? styler.themeHighlightColor : styler.themePrimaryColor;

                        wrapMode: Text.Wrap;
                        font.pixelSize: styler.themeFontSizeMedium

                    }
                    onClicked: {
                        aboutPage.title = model.title;
                        aboutPage.text = model.text;
                        app.pages.push(aboutPage);
                    }

                }
            }

            Repeater {
                model: venueMapModel
                delegate: BackgroundItem {
                    id: venueMapDelegate
                    width: column.width;
                    height: venueMapDelegateText.paintedHeight + styler.themePaddingLarge;
                    Text {
                        id: venueMapDelegateText
                        x: styler.themePaddingLarge
                        text: model.title
                        anchors.verticalCenter: parent.verticalCenter

                        color: venueMapDelegate.highlighted ? styler.themeHighlightColor : styler.themePrimaryColor;
                        wrapMode: Text.Wrap;
                        font.pixelSize: styler.themeFontSizeMedium

                    }
                    onClicked: {
                        var local_url = IMAGE_CACHE_FOLDER + "/" + filereader.getBasename(model.image)

                        photoDetailPage.addr = (filereader.file_exists(local_url)) ? local_url : model.image;

                        app.pages.push(photoDetailPage)
                    }

                }
            }


            BackgroundItem {
                id: mapDelegate
                width: column.width
                height: mapDelegateText.paintedHeight + styler.themePaddingLarge;
                visible: (mapPage.mapWidget.places.count > 0)

                Text {
                    id: mapDelegateText;
                    x: styler.themePaddingLarge
                    //% "Important Places"
                    text: qsTrId("section-about-places")
                    anchors.verticalCenter: parent.verticalCenter

                    color: mapDelegate.highlighted ? styler.themeHighlightColor : styler.themePrimaryColor
                    wrapMode: Text.Wrap;
                    //                    font.family: Theme.fontFamily
                    font.pixelSize: styler.themeFontSizeMedium;

                }
                onClicked: {
                    app.pages.push(mapPage)
                }

            }


            SectionHeader {
                //% "Schedule"
                text: qsTrId("section-header-schedule")
                visible: (daysModel.count > 0)
            }

            Repeater {
                model: daysModel
                delegate: BackgroundItem {
                    id: daysDelegate
                    height: daysDelegateText.paintedHeight + styler.themePaddingLarge;
                    Text {
                        id: daysDelegateText
                        x: styler.themePaddingLarge
                        text: name
                        anchors.verticalCenter: parent.verticalCenter

                        color: daysDelegate.highlighted ? styler.themeHighlightColor : styler.themePrimaryColor;
                        wrapMode: Text.Wrap;
                        font.pixelSize: styler.themeFontSizeMedium

                    }
                    onClicked: {
                        schedulePage.filter_favorites = false;
                        schedulePage.filter_start = parseInt(timestamp, 10)
                        schedulePage.filter_end = parseInt(timestamp, 10) + 24 * 3600
                        schedulePage.updateFilter();

                        app.pages.push(schedulePage)
                    }

                }
            }

            BackgroundItem {
                id: favoritesDelegate
                width: column.width
                height: favoritesDelegateText.paintedHeight + styler.themePaddingLarge;
                visible: (schedulePage.favoritesModel.length > 0)
                Text {
                    id: favoritesDelegateText
                    x: styler.themePaddingLarge
                    //% "Favorites"
                    text: qsTrId("section-favorites")
                    anchors.verticalCenter: parent.verticalCenter
                    color: favoritesDelegate.highlighted ? styler.themeHighlightColor : styler.themePrimaryColor;
                    wrapMode: Text.Wrap;
                    font.pixelSize: styler.themeFontSizeMedium


                }
                onClicked: {
                    schedulePage.filter_favorites = true;
                    schedulePage.updateFilter();
                    app.pages.push(schedulePage)
                }

            }

            SectionHeader {
                //% "Upcoming talks"
                text: qsTrId("section-header-upcoming-talks")
                visible: (currentEvents.count > 0)
            }

            Repeater {
                model: currentEvents;
                delegate: ScheduleDelegate {
                    startTime: parseInt(model.event_start, 10);
                    endTime: parseInt(model.event_end, 10);
                    roomShort: model.room_short;
                    roomColor:  model.room_color;
                    speakers_str: model.speakers_str;
                    title: model.title
                    inFavorites: schedulePage.isInFavorites(model.session_id);

                    onClicked: {
                        //                        eventDetailPage.title = model.type;
                        eventDetailPage.talkName = model.title
                        eventDetailPage.description = model.description
                        eventDetailPage.startTime = F.format_time(model.event_start);
                        eventDetailPage.endTime = F.format_time(model.event_end);
                        eventDetailPage.startDay = model.event_day;
                        eventDetailPage.room = model.room;
                        eventDetailPage.roomColor = model.room_color
                        eventDetailPage.um.clear()
                        var speakersArray = JSON.parse(model.speakers);
                        for (var i = 0; i < speakersArray.length; i++) {
                            var detail = dataSource.getSpeakerDetail(speakersArray[i])
                            if (detail !== undefined) {
                                eventDetailPage.um.append(detail)
                            }
                        }

                        eventDetailPage.tags = model.tags_str;
                        eventDetailPage.session_id = model.session_id;
                        eventDetailPage.inFavorites = schedulePage.isInFavorites(model.session_id);
                        app.pages.push(eventDetailPage);
                    }

                }
            }


            SectionHeader {
                //% "News"
                text: qsTrId("section-header-news")
                visible: (rssModel.count > 0)
            }

            Repeater {
                id: rssRepeater
                model: rssModel
                delegate: RssItemDelegate {
                    //                    img: (model.avatar !== undefined) ? model.avatar : ""
                    img: model.avatar;
                    title: model.title
                    description: model.description
                    link: model.link
                    date: model.time
                }

            }



        }
    }

    ListModel {
        id: aboutModel
    }

    ListModel {
        id: daysModel;
    }

    ListModel {
        id: rssModel;
    }

    ListModel {
        id: currentEvents
    }

    ListModel {
        id: venueMapModel;
    }



    function reload(d) {
        aboutModel.clear()
        if (d.about !== undefined) {
            var aboutArray = d.about;
            for (var i = 0; i < aboutArray.length; i++) {
                aboutModel.append(aboutArray[i])
            }
        }

        daysModel.clear();
        if (d.days !== undefined) {
            var daysArray = d.days;
            for (var i = 0; i < daysArray.length; i++) {
                var ts = parseInt(daysArray[i], 10);
                var date = new Date(ts* 1000);
                var dayName = F.dayOfWeek(date.getDay())
                daysModel.append({'timestamp': parseInt(ts, 10), 'name': dayName})
            }
        }

        rssModel.clear();
        if (d.rss !== undefined) {
            var rss = d.rss;
            for (var i = 0; i < rss.length; i++) {
                rssModel.append(rss[i])
            }
        }

        currentEvents.clear();
        if (d.sessions !== undefined) {

            var now = Math.floor(new Date().getTime()/1000);
            var sessions = d.sessions
            var j = 0;
            for (var i = 0; i < sessions.length; i++) {
                var item = sessions[i];
                if (item.event_start > now) {
                    var dayInt = new Date(parseInt(item.event_start, 10) * 1000).getDay();
                    item.event_day = F.dayOfWeek(dayInt)

                    var obj;
                    if ((typeof item.speakers) == (typeof "")) { // this is ugly workarround - this should be object (array of strings)
                        obj = eval(item.speakers);
                        item.speakers = JSON.stringify(obj);
                    } else {
                        obj = item.speakers;
                        item.speakers = JSON.stringify(item.speakers)
                    }
                    item.speakers_str = F.make_speakers_str(obj, d.users); // need to work with object

                    if ((typeof item.tags) == (typeof "")) { // this is ugly workarround - this should be object (array of strings)
                        obj = eval(item.tags);
                    } else {
                        obj = item.tags;
                    }

                    item.tags_str = F.make_tags_str(obj)

                    currentEvents.append(item)
                    j++;
                }
                if (j >= 8) {
                    break;
                }
            }
        } // endif (d.sessions !== undefined)


        venueMapModel.clear();
        if (d.venueMap !== undefined) {
            var venueMap = d.venueMap;

            for (var i = 0; i < venueMap.length; i++) {
                var item = venueMap[i]
                venueMapModel.append(item);

                var remote_url = item.image
                var local_url = IMAGE_CACHE_FOLDER + "/" + filereader.getBasename(remote_url)


                if (!filereader.file_exists(local_url)) {
                    downloader.append(remote_url, local_url)
                }


            }
        }


    }


}


