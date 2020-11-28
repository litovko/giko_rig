import QtQuick 2.12
import HYCO 1.0
import QtMultimedia 5.12
import Qt.labs.settings 1.0

Item {
    id: mycam
    property string name: "cam"
    property bool cameraenabled: false
    property alias media: cam.media
    property alias address: cam.address
    property alias port: cam.port
    property alias status: cam.is_playing
    property alias video_height: cam.video_height
    property alias video_width: cam.video_width
    property string video_path: "video/record_"
    property string video_file_extension: ".avi"
    property IPCamera cam: cam

    Settings {
        category: "cams/"+name
        property alias address: cam.address
        property alias port   : cam.port
        property alias height: cam.video_height
        property alias width: cam.video_width
        property alias media: cam.media
        property alias cameraenabled: mycam.cameraenabled
    }

    VideoOutput {
        id: vo1
        anchors.fill: parent;
        source: cam;
    }
    IPCamera {
        id: cam
        address: "192.168.1.168"
        port: 8557
        video_height:  1080 //288 1080
        video_width:   1920 //352 1920
        media: "/PSIA/Streaming/channels/2?videoCodecType=H.264"
        filename: "output.avi"
    }
}
