import QtQuick 2.0
import "components/platform"
import "functions.js" as F

PageListPL {
    id: page
    //% "Confla"
    title: qsTrId("application-title")

    signal selectConference(variant conf_data, bool replace );

    ListModel {
        id: conferencesListModel;
    }

    model: conferencesListModel
    placeholderEnabled: (conferencesListModel.count == 0)
    //% "List of conferences is empty"
    placeholderText: qsTrId("conference-list-page-list-is-empty")

    delegate: BackgroundItem {
        id: delegate
        height: Math.max(delegateText.paintedHeight, icon.height) + 2*styler.themePaddingMedium;

        Image {
            id: icon;
            anchors.top: parent.top;
            anchors.left: parent.left
            anchors.topMargin: styler.themePaddingMedium;
            anchors.leftMargin: styler.themePaddingMedium;
            width: styler.themeIconSizeLarge
            fillMode: Image.PreserveAspectFit

            source: (model.icon !== undefined) ? model.icon : "";
        }


        Text {
            id: delegateText
            anchors.left: icon.right
            anchors.margins: styler.themePaddingMedium
            anchors.right: parent.right
            text: model.title
            anchors.verticalCenter: parent.verticalCenter

            color: delegate.highlighted ? styler.themeHighlightColor : styler.themePrimaryColor;

            wrapMode: Text.Wrap;
            textFormat: Text.RichText;
            font.pixelSize: styler.themeFontSizeMedium

        }
        onClicked: {
            var selectedObj = {
                "url": model.url,
                "icon": model.icon,
                "title": model.title,
                "version": model.version,
                "rooms": JSON.parse(model.rooms),
            }
            console.log(JSON.stringify(selectedObj, null, 2))

            selectConference(selectedObj, false);
        }

    }



    // Giggity keeps room locations in metadata.rooms, some menu entries have them at the top level
    function conferenceRooms(conf) {
        if (conf.metadata !== undefined && conf.metadata.rooms !== undefined) {
            return conf.metadata.rooms
        }
        if (conf.rooms !== undefined) {
            return conf.rooms
        }
        return []
    }

    function reload(d) {
        conferencesListModel.clear();

        if (d.schedules !== undefined) {
            var confs = d.schedules;
            var conf;
            for (var i = 0; i < confs.length; i++) {
                conf = confs[i];

                var endDate = new Date(conf.end);
                endDate.setDate(endDate.getDate() + 1); // make sure not to hide event on its last day, because it is 00:00 not 23:59

                var now = new Date();

                if (endDate < now) {
                    // console.log("SKIP " + conf.title + " (in past " + endDate + ")")
                    continue;
                }

                if (/\.ics/.test(conf.url)) {
                    console.log("SKIP cannot parse ics " + conf.title)
                    continue
                }

                var selectObj = {
                    "url": conf.url,
                    "icon": (conf.metadata !== undefined && conf.metadata.icon !== undefined) ? conf.metadata.icon: "",
                    "title": conf.title,
                    "version": conf.version,
                    // ListModel would turn an array into a nested model, keep it as JSON
                    "rooms": JSON.stringify(conferenceRooms(conf)),
                }

                conferencesListModel.append(selectObj)
                // console.error(JSON.stringify(conf, null, 2));
            }
            if (confs.length === 1) {
                conf = confs[0];
                var selectObj = {
                    "url": conf.url,
                    "icon": (conf.metadata !== undefined && conf.metadata.icon !== undefined) ? conf.metadata.icon: "",
                    "title": conf.title,
                    "version": conf.version,
                    "rooms": conferenceRooms(conf),
                }

                console.log("select conference: " + JSON.stringify(selectObj, null, 2))
                selectConference(selectObj, true);
            }
        }

        // selectConference(
        //     {
        //         "url":"https://talks.openalt.cz/openalt-2025/schedule/export/schedule.xml",
        //         "icon":"https://gitlab.com/uploads/-/system/project/avatar/45099900/logo_konference-150.png",
        //         "title":"OpenALT 2025",
        //         "version":2025102700
        //     }
        //     , true)

        //        console.error("here " + JSON.stringify(d) )
    }
}
