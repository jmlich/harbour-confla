#!/bin/bash

# Update the .ts files after changing texts in QML or C++. Run from the project root, like update-qrc.sh.
lupdate -no-obsolete qml src -ts translations/*.ts
