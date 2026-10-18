# Confla

Conference schedule app for Sailfish OS, Ubuntu Touch and Linux desktop (Kirigami).

It lists the conferences from the [Giggity](https://github.com/Wilm0r/giggity) menu
(https://ggt.gaa.st/menu.json) and shows their schedule, talks, speakers, favorites and a map of the
rooms. The schedule is read from the frab XML export. For pretalx events, speaker avatars and bios are
added from the public pretalx API. Schedules are cached, so the app also works offline.

## Build

Choose the platform with `FLAVOR`: `kirigami`, `uuitk` (Ubuntu Touch), `silica` (Sailfish OS) or
`qtcontrols`.

```
mkdir build && cd build
cmake -DFLAVOR=kirigami ..
make
```

For Ubuntu Touch, run `clickable build`.

The code must stay compatible with Qt 5.6 used by Sailfish OS, so QML JavaScript is limited to ES5.

## Translations

Texts use id-based translations (`qsTrId`). After changing texts, run `./update-translations.sh`.
