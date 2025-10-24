import QtQuick
import QtQuick.Controls

import MuseScore 3.0
import Muse.Ui
import Muse.UiComponents


MuseScore {
    title:    "Get Lyrics"
    version:     "1.0.0"
    thumbnailName: "gl.png"
    description: qsTr("Get lyrics from the current score")
    categoryCode: "lyrics"
    pluginType: "dialog"
    id: root
    width: 600
    height: 400

    property string scoreTitle: ""
    property string lyricsText: ""

    Rectangle {
        id: background
        width: parent.width
        height: parent.height
        color: "gray"
        border.color: "#888"
        border.width: 1

        TextArea {
            id: textArea
            anchors.fill: parent
            anchors.leftMargin:10
            anchors.rightMargin:10
            anchors.topMargin:10
            anchors.bottomMargin:10
            width:parent.width - 20
            height:parent.height - 20
            font.pointSize: 12
            wrapMode: TextEdit.WordWrap
            text: root.lyricsText !== "" ? root.lyricsText : "not find lyrics"
        }
    }

    onRun: {
        if (!curScore) {
            root.scoreTitle = "No score is open."
            return
        }
        var lyrics = "";
        var lyric_array = [];
        var title = curScore.metaTag("workTitle")
        if (!title || title === "") {
            lyrics += "No socore title \n\n";
        }else{
            lyric_array.push(title + "\n\n");
        }
        var measure = curScore.firstMeasure;
        while (measure) {
            var segment = measure.firstSegment;
            while (segment) {
                var i = 0; 
                var element = segment.elementAt(i);
                if (element != null && element.type == Element.CHORD) {
                    var lyrics = element.lyrics;
                    for (var ii = 0; ii < lyrics.length; ii++) {
                        var ly = lyrics[ii];
                        var w = lyrics[ii].text;
                        //console.log(w)
                        lyric_array.push(w)
                    }
                }
                segment = segment.next;
            }
            measure = measure.next;
        }
        lyrics = lyric_array.join(" ");
        root.lyricsText = lyrics;
        console.log(lyrics);

        //Qt.quit(); // Optional: Remove this line if you want the window to stay visible
    }
}