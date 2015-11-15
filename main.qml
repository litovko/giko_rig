import QtQuick 2.5
import QtQuick.Window 2.2
import QtQuick.Controls 1.4
import Gyco 1.0

import QmlVlc 0.1

Window {
    id: win
//    visibility: Window.FullScreen
    title: "HYCO RIG CONSOLE ПУЛЬТ УПРАВЛЕНИЯ ПОДВОДНЫМ КОМПЛЕКСОМ"
    visible: true
    height: 720
    width: 1280
    color: "transparent"


    Rectangle {
        id: mainRect
        color: 'black';
        anchors.fill: parent
        border.color: "yellow"
        radius:20
        border.width: 3
        focus:true

        Keys.onPressed: {
           console.log("key pressed my bottom");
           if (event.key === Qt.Key_F2) rig.lamp=rig.lamp?false:true;
           if (event.key === Qt.Key_F3) rig.camera=rig.camera?false:true;;
           if (event.key === Qt.Key_F4) rig.engine=rig.engine?false:true;
           if (event.key === Qt.Key_F5) rig.lamp=rig.lamp?false:true;
        }
        RigCamera {
            id: cam1
        }

        VlcPlayer {
            id: vlcPlayer;
            mrl: cam1.url1;
            //mrl: "rtsp://192.168.1.168:8557/PSIA/Streaming/channels/2?videoCodecType=H.264"
            // mrl: "rtsp://192.168.1.168:8553/PSIA/Streaming/channels/1?videoCodecType=MPEG4"
            //mrl: "rtsp://pionerskaya.glavpunkt.ru:554/user=admin&password=0508&channel=1&stream=0.sdp?real_stream--rtp-caching=100";
            //mrl: "rtsp://stream.tn.com.ar/live/tnhd1";
            //rtsp://192.168.1.168:8557/PSIA/Streaming/channels/2?videoCodecType=H.264
        }
//        VlcMmPlayer {
//            id: vlcMmPlayer;
//            //mrl: "http://download.blender.org/peach/bigbuckbunny_movies/big_buck_bunny_480p_stereo.avi";
//            //mrl: "rtsp://stream.tn.com.ar/live/tnhd1";
//            //mrl: "rtsp://192.168.1.168:8553/PSIA/Streaming/channels/1?videoCodecType=MPEG4"
//            mrl: "rtsp://192.168.1.168:8557/PSIA/Streaming/channels/2?videoCodecType=H.264"
//        }
        VlcVideoSurface {
            id: surface

            source: vlcPlayer;
            anchors.top: parent.top;
            anchors.topMargin: 10;
            anchors.left: parent.left;
            anchors.leftMargin: anchors.topMargin;
            width: parent.width / 1 - anchors.leftMargin * 2;
            height: parent.height / 1 - anchors.topMargin * 2;
            opacity: 1;


            Rectangle {
            id: statePannel
            border.color: "yellow"
            radius: 10
            color: "transparent"
            //width:parent.width
            height: 40
            width: surface.width
            anchors {
                horizontalCenter: parent.horizontalCenter
                bottom: parent.bottom
                //right: parent.right
                margins: 10
            }
            Text {
                id: t
                color: "yellow"
                font.pointSize: 12
                anchors {left: parent.center; bottom: parent.bottom; margins: 1}

                text: "Статус видео:"+vlcPlayer.state.toString()//+" w:" + vlcPlayer.video.width.toString()+" ww:"+surface.width.toString();
                onTextChanged:  console.log("New status: " + vlcPlayer.state.toString() )
            }
            }
        }

    RigModel {
        id: rig

        address:  "localhost"
//        port: 1212
//        pressure:   100
//        oiltemp:    20

    }

    MouseArea {
        anchors.fill: parent
        acceptedButtons: Qt.AllButtons
        onClicked: {
            if (mouse.button == Qt.RightButton){
                   console.log(rig.server_connected?"black":"white");
                   console.log(rig.lamp?"on":"off");
                   rig.pressure=111;
                   rig.lamp=rig.lamp?false:true;
                   rig.start_client();
            }
            else
                   Qt.quit();
        }
    }
    Column {
        spacing: 20
        anchors.top: parent.top
        anchors.left: parent.left
        anchors.margins: 20
        Rectangle{
            width: 200
            height: 20
            color: "transparent"
            border.color: "black"

            Slider {
                id: s1
                value:15
                anchors.fill: parent
                maximumValue: 100
                stepSize: 1
                onValueChanged: rig.ampere=value
            }
        }
        Rectangle{
            width: 200
            height: 20
            color: "transparent"
            border.color: "black"

            Slider {
                id: s2
                value:24
                anchors.fill: parent
                maximumValue: 50
                stepSize: 1
                onValueChanged: rig.voltage=value
            }
        }
        Rectangle{
            width: 200
            height: 20
            color: "transparent"
            border.color: "black"

            Slider {
                id: s3
                value:24
                anchors.fill: parent
                maximumValue: 200
                stepSize: 1
                onValueChanged: rig.temperature=value
            }
        }
        Rectangle{
            width: 200
            height: 20
            color: "transparent"
            border.color: "black"

            Slider {
                id: s4
                value:24
                anchors.fill: parent
                maximumValue: 200
                stepSize: 1
                onValueChanged: rig.pressure=value
            }
        }
        Rectangle{
            width: 200
            height: 20
            color: "transparent"
            border.color: "black"

            Slider {
                id: s5
                value:90
                anchors.fill: parent
                maximumValue: 100
                stepSize: 1
                onValueChanged: rig.joystick=value
            }
        }

    }
    MyDashboard {
                //height: 600
                width: 180
                source: rig
                anchors { margins: 10; bottomMargin: 100; top: parent.top; bottom: parent.bottom; right: parent.right}
            }

   }
    ControlPanel {
        source: rig
        width: 700
        height: 100
        anchors { margins: 10; bottomMargin: 100; bottom: parent.bottom; left: parent.left}
    }

}

