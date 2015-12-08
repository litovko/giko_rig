import QtQuick 2.5
import QtQuick.Window 2.2
import QtQuick.Controls 1.4
import Gyco 1.0

import QmlVlc 0.1
import QtMultimedia 5.5
import Qt.labs.settings 1.0

Window {
    id: win
//    visibility: Window.FullScreen
    title: "HYCO RIG CONSOLE ПУЛЬТ УПРАВЛЕНИЯ ПОДВОДНЫМ АППАРАТОМ"
    visible: true
    height: 720
    width: 1280
    color: "transparent"
    property int recording: 0
    property int network_caching: 333
    property string filepath: ""
    property string cam1title:"cam1"
    property string cam2title:"cam2"
    property string cam3title:"cam3"
    property int cam1index: 1
    property int cam2index: 0
    property int cam3index: 0
    Settings {
        property alias x: win.x
        property alias y: win.y
        property alias width: win.width
        property alias height: win.height
        property alias recording: win.recording
        property alias network_caching: win.network_caching
        property alias filepath: win.filepath
        property alias cam1title:win.cam1title
        property alias cam2title:win.cam2title
        property alias cam3title:win.cam3title
        property alias cam1index:win.cam1index
        property alias cam2index:win.cam2index
        property alias cam3index:win.cam3index
    }

    function statename(camstate) {
        if (camstate===0) return "---";
        if (camstate===1) return "Открытие";
        if (camstate===2) return "Буферизация";
        if (camstate===3) return "Проигрывание";
        if (camstate===4) return "На паузе";
        if (camstate===5) return "Остановлено";
        if (camstate===6) return "Завершено";
        if (camstate===7) return "Ошибка";
        return "";
    }
    function getrecordoption(){
       var dt=new Date();
       var sopt=[":network-caching="+network_caching.toString(), ":sout-all", ":sout-keep" ];
       console.log("Options without record:"+sopt);
       if (recording===0) return sopt;
       console.log("Current time for filename");
       console.log(dt);
       console.log("FilePath:"+filepath);
       var popt=[":network-caching="+network_caching.toString(),":sout=#stream_out_duplicate{dst=display,dst=std{access=file,mux=mp4,dst="+filepath+"hyco-"
                 + dt.toLocaleString(Qt.locale(),"dd-MM-yyyy_HH-mm-ss")
                 +".mpg}}"]
       console.log("Options with record:"+popt);
       return popt
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
           console.log("key pressed"+event.key);
           if (event.key === Qt.Key_F2) rig.lamp=rig.lamp?false:true;
           if (event.key === Qt.Key_F3) rig.camera=rig.camera?false:true;;
           if (event.key === Qt.Key_F4) rig.engine=rig.engine?false:true;
           if (event.key === Qt.Key_F10) {
               menu.visible=menu.visible?false:true;
               settings.visible=false;
           }
           if (event.key === Qt.Key_F11) {
               settings.visible=settings.visible?false:true;
               menu.visible=false;
           }
           if (event.key === Qt.Key_F5) {
               vlcPlayer.stop();
               console.log("Play:" +  cam1.url1 +" options:"+ getrecordoption() )
               vlcPlayer.playlist.clear();
               vlcPlayer.playlist.addWithOptions(cam1.url1,getrecordoption());
               vlcPlayer.play();
           }
           if (event.key === Qt.Key_F6) vlcPlayer.stop();
           if (event.key === Qt.Key_F12) win.visibility= win.visibility===Window.FullScreen?Window.Windowed:Window.FullScreen;
        }

        RigCamera {
            id: cam1
            title: cam1title
            index: cam1index
        }
        RigCamera {
            id: cam2
            title: cam2title
            index: cam2index
        }
        RigCamera {
            id: cam3
            title: cam3title
            index: cam3index
        }

        VlcPlayer {
            id: vlcPlayer;
            //mrl: "rtsp://192.168.1.168:8557/PSIA/Streaming/channels/2?videoCodecType=H.264"
            // mrl: "rtsp://192.168.1.168:8553/PSIA/Streaming/channels/1?videoCodecType=MPEG4"
            //mrl: "rtsp://pionerskaya.glavpunkt.ru:554/user=admin&password=0508&channel=1&stream=0.sdp?real_stream--rtp-caching=100";
            //mrl: "rtsp://stream.tn.com.ar/live/tnhd1";
            //rtsp://192.168.1.168:8557/PSIA/Streaming/channels/2?videoCodecType=H.264
            Component.onCompleted: {
            // остановим плеер
                stop();
                vlcPlayer.playlist.clear();
                vlcPlayer.playlist.addWithOptions(cam1.url1,getrecordoption());
                play();
            // добавим в плейлист
            }

            onStateChanged: {
                if (vlcPlayer.state===6) {
                    //
                    //console.log("Try to start playing againe")
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
                anchors.centerIn: parent
                text: "Статус видео: "+statename(vlcPlayer.state)// +" playing :"+vlcPlayer.playing;
                //onTextChanged:  console.log("New status: " + vlcPlayer.state.toString())
            }
            }
        }

    RigModel {
        id: rig

//        address:  "localhost"
//        port: 1212
//        pressure:   100
//        oiltemp:    20
        joystick: j.yaxis

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
        cam: [cam1, cam2, cam3]
        width: 1000
        height: 100
        lampSize: 90
        fontSize: 14
        anchors { margins: 10; bottomMargin: 100; bottom: parent.bottom; left: parent.left}
    }
    SetupCamera {
        id: menu
        width: 600
        height: 500
        visible: false
        anchors.centerIn: parent
        cam: cam1
        player: vlcPlayer
    }
    SetupSettings{
        id: settings
        width: 600
        height: 500
        anchors.centerIn: parent
        cam1: cam1
        cam2: cam2
        cam3: cam3
        player: vlcPlayer
        rig: rig
        visible: false
    }
}

