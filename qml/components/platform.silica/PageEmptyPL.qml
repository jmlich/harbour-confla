/* -*- coding: utf-8-unix -*-
 *
 * Copyright (C) 2018 Rinigus
 *
 * This program is free software: you can redistribute it and/or modify
 * it under the terms of the GNU General Public License as published by
 * the Free Software Foundation, either version 3 of the License, or
 * (at your option) any later version.
 *
 * This program is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 * GNU General Public License for more details.
 *
 * You should have received a copy of the GNU General Public License
 * along with this program.  If not, see <http://www.gnu.org/licenses/>.
 */

import QtQuick 2.0
import Sailfish.Silica 1.0

Page {
    id: page
    allowedOrientations: app.defaultAllowedOrientations

    default property alias content: itemCont.data
    readonly property bool empty: true
    property alias         pageMenu: menuLoader.sourceComponent
    property string        title

    signal pageStatusActivating
    signal pageStatusActive
    signal pageStatusInactive

    Item {
        id: itemCont
        anchors.fill: page
    }

    // A pull down menu works only inside a Silica flickable, so put it into the visible one
    Loader {
        id: menuLoader
        active: sourceComponent && parent !== page
        parent: {
            for (var i = 0; i < itemCont.children.length; i++) {
                var child = itemCont.children[i];
                if (child.visible && child.pullDownMenu !== undefined) return child;
            }
            return page;
        }
        width: parent.width
    }

    onStatusChanged: {
        if (page.status === PageStatus.Activating) pageStatusActivating();
        else if (page.status === PageStatus.Active) pageStatusActive();
        else if (page.status === PageStatus.Inactive) pageStatusInactive()
    }
}
