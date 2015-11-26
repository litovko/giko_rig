import QtQuick 2.5
import QtQuick.Window 2.2
import QtQuick.Controls 1.4
import Gyco 1.0

import QmlVlc 0.1
import QtMultimedia 5.5

Window {
    id: win
//    visibility: Window.FullScreen
    title: "HYCO RIG CONSOLE ПУЛЬТ УПРАВЛЕНИЯ ПОДВОДНЫМ КОМПЛЕКСОМ"
    visible: true
    height: 720
    width: 1280
    color: "transparent"
    function statename(camstate) {
        if (camstate===0) return "NothingSpecial";
        if (camstate===1) return "Opening";
        if (camstate===2) return "Buffering";
        if (camstate===3) return "Playing";
        if (camstate===4) return "Paused";
        if (camstate===5) return "Stopped";
        if (camstate===6) return "Ended";
        if (camstate===7) return "Error";
        return "";
    }

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
        //   if (event.key === Qt.Key_F5) rig.lamp=rig.lamp?false:true;
           if (event.key === Qt.Key_F10) menu.visible=menu.visible?false:true;
           if (event.key === Qt.Key_F5) vlcPlayer.play(cam1.url1);
           if (event.key === Qt.Key_F6) vlcPlayer.stop();
           if (event.key === Qt.Key_F12) win.visibility= win.visibility===Window.FullScreen?Window.Windowed:Window.FullScreen;
        }
        RigCamera {
            id: cam1
            videopage: true
            address: "192.168.1.168"
        }

        VlcPlayer {
            id: vlcPlayer;
            mrl: cam1.url1;
            //mrl: "rtsp://192.168.1.168:8557/PSIA/Streaming/channels/2?videoCodecType=H.264"
            // mrl: "rtsp://192.168.1.168:8553/PSIA/Streaming/channels/1?videoCodecType=MPEG4"
            //mrl: "rtsp://pionerskaya.glavpunkt.ru:554/user=admin&password=0508&channel=1&stream=0.sdp?real_stream--rtp-caching=100";
            //mrl: "rtsp://stream.tn.com.ar/live/tnhd1";
            //rtsp://192.168.1.168:8557/PSIA/Streaming/channels/2?videoCodecType=H.264

            onStateChanged: {
                if (vlcPlayer.state===6) {

                    console.log("Try to start playing againe")
                    //play(cam1.url1);
                }
            }
        }
//        VlcMmPlayer {
//            id: vlcMmPlayer;
//            //mrl: "http://download.blender.org/peach/bigbuckbunny_movies/big_buck_bunny_480p_stereo.avi";
//            //mrl: "rtsp://stream.tn.com.ar/live/tnhd1";
//            //mrl: "rtsp://192.168.1.168:8553/PSIA/Streaming/channels/1?videoCodecType=MPEG4"
//            mrl: "rtsp://192.168.1.168:8557/PSIA/Streaming/channels/2?videoCodecType=H.264"
//        }
        VlcVideoSurface {
//        VideoOutput {
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

                text: "Статус видео:"+statename(vlcPlayer.state) +" playing:"+vlcPlayer.playing;
                onTextChanged:  console.log("New status: " + vlcPlayer.state.toString())
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
//                   Qt.quit();
            console.log("Mouse: left botton pressed");
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
            RigJoystick {
                id: j
            }

            Slider {
                id: s5
                value:j.yaxis
                anchors.fill: parent
                maximumValue: 127
                minimumValue: -127
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
        cam: cam1
        width: 900
        height: 100
        anchors { margins: 10; bottomMargin: 100; bottom: parent.bottom; left: parent.left}
    }
    SetupCamera {
        id: menu
        width: 600
        height: 500
        anchors.centerIn: parent
        cam: cam1
        player: vlcPlayer
    }


}

