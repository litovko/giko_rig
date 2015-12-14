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
    property int network_caching: 250
    property int keyboard_count: 3
    property string filepath: ""
    property string cam1title:"cam1"
    property string cam2title:"cam2"
    property string cam3title:"cam3"
    property int cam1index: 1
    property int cam2index: 0
    property int cam3index: 0
    property list<VlcPlayer> players:[
        VlcPlayer {
            id: vlcPlayer1;
            Component.onCompleted: {
                if (cam1.index===0) return
                stop();
                playlist.clear();
                playlist.addWithOptions(cam1.url1,getrecordoption(1));
                if(cams[0].index)play();

            }
        },
        VlcPlayer {
            id: vlcPlayer2;
            Component.onCompleted: {
                if (cam2.index===0) return
                stop();
                playlist.clear();
                playlist.addWithOptions(cam2.url1,getrecordoption(2));
                if(cams[1].index)play();

            }
        },
        VlcPlayer {
            id: vlcPlayer3;
            Component.onCompleted: {
                if (cam3.index===0) return
                stop();
                playlist.clear();
                playlist.addWithOptions(cam3.url1,getrecordoption(3));
                if(cams[2].index)play();

            }
        }

    ]
    property list<RigCamera> cams: [
        RigCamera {
            id: cam1
            title: cam1title
            index: cam1index
        },
        RigCamera {
            id: cam2
            title: cam2title
            index: cam2index
        },
        RigCamera {
            id: cam3
            title: cam3title
            index: cam3index
        }
    ]

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
    function player_play(player_number){
        players[player_number].stop();
        players[player_number].playlist.clear();
        players[player_number].playlist.addWithOptions(cam1.url1,getrecordoption(player_number));
        players[player_number].play();
    }

    function statename(camstate) {
        if (camstate===0) return "---";
        if (camstate===1) return "Открытие";
        if (camstate===2) return "Буферизация";
        if (camstate===3) return "Трансляция";
        if (camstate===4) return "На паузе";
        if (camstate===5) return "Остановлено";
        if (camstate===6) return "Завершено";
        if (camstate===7) return "Ошибка";
        return "";
    }
    function getrecordoption(camindex){
        var dt=new Date();
        if (camindex===undefined) console.assert("getrecordoption camindex undefined!!!")
        var sopt=[":network-caching="+network_caching.toString(), ":sout-all", ":sout-keep" ];
        console.log("Options without record:"+sopt);
        if (recording===0) return sopt;
        console.log("Camindex="+camindex);
        console.log("Camindex="+camindex+"cam:" +cams[camindex].title+"text:"+cams[camindex].overlaytext);
        console.log("FN Time:"+ dt + "FilePath:"+filepath );
        var popt=[":network-caching="+network_caching.toString(),":sout=#stream_out_duplicate{dst=display,dst=std{access=file,mux=mp4,dst="+filepath+"hyco-"
                  +"cam"+(camindex+1)+"-"
                  +cams[camindex].overlaytext + "-"
                  + dt.toLocaleString(Qt.locale(),"dd-MM-yyyy_HH-mm-ss")
                  +".mpg}}"]
        console.log("Options with record:"+popt);
        return popt
    }
    RigModel {
        id: rig
        joystick_y1: j.yaxis
    }
    function changestate(){
                    console.log("STATE: "+mainRect.state + " ind:" +cams[0].index+cams[1].index+cams[2].index);
                    console.log((cams[1].index+cams[2].index)===2);
                    if ((cams[1].index+cams[2].index)===0) // только одна камера
                        if (mainRect.state==="1-KAM-bol") mainRect.state="1-KAM-mal"
                        else mainRect.state="1-KAM-bol"
                    if ((cams[1].index+cams[2].index)===2) // две камеры
                        if (mainRect.state==="2-KAM-mal") mainRect.state="2-KAM-bol1"
                        else if (mainRect.state==="2-KAM-bol1") mainRect.state="2-KAM-bol2"
                             else mainRect.state="2-KAM-mal"

                    if ((cams[1].index+cams[2].index)===5) //три камеры
                    if (mainRect.state==="3-KAM-mal") mainRect.state="3-KAM-bol1"
                    else if (mainRect.state==="3-KAM-bol1") mainRect.state="3-KAM-bol2"
                         else if (mainRect.state==="3-KAM-bol2") mainRect.state="3-KAM-bol3"
                              else if (mainRect.state==="3-KAM-bol3") mainRect.state="3-KAM-mal"
                                   else mainRect.state="3-KAM-mal"

                }
    Rectangle {
        id: mainRect
        color: 'black';
        anchors.fill: parent
        border.color: "yellow"
        radius:20
        border.width: 3
        focus:true
        state: "1-KAM-bol"
//        property list<VlcVideoSurface> surfs: [suface1, surface2, surface3]
            VlcVideoSurface {
                id: surface1
                source: win.players[0];
                anchors.top: mainRect.top;
                anchors.topMargin: 10;
                anchors.left: mainRect.left;
                anchors.leftMargin: anchors.topMargin;
                width: mainRect.width / 1 - anchors.leftMargin * 2;
                height: mainRect.height / 1 - anchors.topMargin * 2;
                opacity: 1;
                visible: true
                Behavior on opacity {

                            NumberAnimation {
                                duration: 600
                                easing.type: Easing.InOutQuad
                            }
                        }
                Behavior on width{

                            NumberAnimation {
                                duration: 600
                                easing.type: Easing.InOutQuad
                            }
                        }
                Behavior on height {

                            NumberAnimation {
                                duration: 600
                                easing.type: Easing.InOutQuad
                            }
                        }
            }
            VlcVideoSurface {
                id: surface2
                source: win.players[1];
                anchors.top: mainRect.top;
                anchors.topMargin: 10;
                anchors.left: mainRect.left;
                anchors.leftMargin: anchors.topMargin;
                width: mainRect.width / 1 - anchors.leftMargin * 2;
                height: mainRect.height / 1 - anchors.topMargin * 2;
                opacity: 1;
                visible: false
                Behavior on opacity {

                            NumberAnimation {
                                duration: 600
                                easing.type: Easing.InOutQuad
                            }
                        }
                Behavior on width{

                            NumberAnimation {
                                duration: 600
                                easing.type: Easing.InOutQuad
                            }
                        }
                Behavior on height {

                            NumberAnimation {
                                duration: 600
                                easing.type: Easing.InOutQuad
                            }
                        }
            }
            VlcVideoSurface {
                id: surface3
                source: win.players[2];
                anchors.top: mainRect.top;
                anchors.topMargin: 10;
                anchors.left: mainRect.left;
                anchors.leftMargin: anchors.topMargin;
                width: mainRect.width / 1 - anchors.leftMargin * 2;
                height: mainRect.height / 1 - anchors.topMargin * 2;
                opacity: 1;
                visible: false
                Behavior on opacity {

                            NumberAnimation {
                                duration: 600
                                easing.type: Easing.InOutQuad
                            }
                        }
                Behavior on width{

                            NumberAnimation {
                                duration: 600
                                easing.type: Easing.InOutQuad
                            }
                        }
                Behavior on height {

                            NumberAnimation {
                                duration: 600
                                easing.type: Easing.InOutQuad
                            }
                        }
            }
        Keys.onReleased: {
            console.log("Released:"+j.yaxis)

        }
        Keys.onNoPressed: {
            if (!j.ispresent)j.yaxis= j.yaxis-Math.sign(j.yaxis)
            console.log("NoPressed:"+j.yaxis)
        }

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
                if(cams[0].index>0) player_play(0);
                if(cams[1].index>0) player_play(1);
                if(cams[2].index>0) player_play(2);
            }
            if (event.key === Qt.Key_F6) {
                players[0].stop();
                players[1].stop();
                players[2].stop();
            }
            if (event.key === Qt.Key_Down) {
                j.ispresent=false
                if(j.yaxis>-127) j.yaxis=j.yaxis-1;
            }
            if (event.key === Qt.Key_Up) {
                j.ispresent=false
                if(j.yaxis<127) j.yaxis=j.yaxis+1;
                console.log("j.yaxis:"+j.yaxis)
            }
            if (event.key === Qt.Key_F12) win.visibility= win.visibility===Window.FullScreen?Window.Windowed:Window.FullScreen;
        }




        //        VlcMmPlayer {
        //            id: vlcMmPlayer;
        //            //mrl: "http://download.blender.org/peach/bigbuckbunny_movies/big_buck_bunny_480p_stereo.avi";
        //            //mrl: "rtsp://stream.tn.com.ar/live/tnhd1";
        //            //mrl: "rtsp://192.168.1.168:8553/PSIA/Streaming/channels/1?videoCodecType=MPEG4"
        //            mrl: "rtsp://192.168.1.168:8557/PSIA/Streaming/channels/2?videoCodecType=H.264"
        //        }
        Rectangle {
            id: statePannel
            x: 10
            y: 660
            z: 3
            border.color: "yellow"
            radius: 10
            GradientStop {
                position: 0.00;
                color: "#000000";
            }
            GradientStop {
                position: 1.00;
                color: "transparent";
            }
            opacity: 0.8
            color: "black"
            //width:parent.width
            height: 40
            width: mainRect.width-height
            anchors {
                horizontalCenter: parent.horizontalCenter
                bottom: parent.bottom
                //right: parent.right
                margins: 10
            }
            Row {
                spacing: 10
                anchors {
                    horizontalCenter: parent.horizontalCenter
                    bottom: parent.bottom
                    //right: parent.right
                    margins: 10
                }
                Text {
                    text: "Тип аппарата:" + rig.rigtype
                    color: "lightblue"
                    font.pointSize: 12
                }
                Text {
                    text: "Вид:"+mainRect.state.toString()
                    color: "lightblue"
                    font.pointSize: 12
                }

                Text {
                    id: t1
                    color: "yellow"
                    font.pointSize: 12
                    //anchors.centerIn: parent
                    text: "Статус видео 1: "+statename(vlcPlayer1.state)
                }
                Text {
                    id: t2
                    color: "yellow"
                    font.pointSize: 12
                    visible: cams[1].index
                    //anchors.centerIn: parent
                    text: "Статус видео 2: "+statename(vlcPlayer2.state)
                }
                Text {
                    id: t3
                    color: "yellow"
                    font.pointSize: 12
                    visible: cams[2].index
                    //anchors.centerIn: parent
                    text: "Статус видео 3: "+statename(vlcPlayer3.state)
                }
            }
        }



        MouseArea {
            anchors.fill: parent
            acceptedButtons: Qt.AllButtons

            onDoubleClicked: changestate()
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
                    onKey_1Changed: if (key_1) changestate()
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
            id: dashboard
            width: 180
            source: rig
            anchors { margins: 10; bottomMargin: 100; top: parent.top; bottom: parent.bottom; right: parent.right}
        }

        //###################################################################################################
        states: [
            State { // первая камера
                name: "3-KAM-bol1"
                PropertyChanges { target: surface1; z: 0;opacity: 1; visible: true;
                    height: mainRect.height / 1 - anchors.topMargin * 2;
                    width: mainRect.width / 1 - anchors.leftMargin * 2;
                    anchors.left: mainRect.left; anchors.top: mainRect.top}
                PropertyChanges { target: surface2; z: 1; opacity: 0.6; visible: true; height:mainRect.height/4; width: mainRect.width / 4; anchors.left: mainRect.left; anchors.top: mainRect.top}
                PropertyChanges { target: surface3; z: 1; opacity: 0.6; visible: true; height:mainRect.height/4; width: mainRect.width / 4; anchors.left: mainRect.left; anchors.top: surface2.bottom}

            },
            State { // три камеры рядом
                name: "3-KAM-mal"
                PropertyChanges { target: surface3; z: 0; opacity: 1; visible: true;
                    height:mainRect.height/3;
                    width: mainRect.width / 3 - anchors.leftMargin * 2;
                    anchors.top: mainRect.top; anchors.left: mainRect.left}
                PropertyChanges { target: surface2; z: 0; opacity: 1; visible: true;
                    height:mainRect.height/3;
                    width: mainRect.width / 3 - anchors.leftMargin * 2;
                    anchors.top: mainRect.top; anchors.left: surface3.right}
                PropertyChanges { target: surface1; z: 0; opacity: 1; visible: true;
                    height:mainRect.height/3;
                    width: mainRect.width / 3 - anchors.leftMargin * 2;
                    anchors.top: surface2.bottom; anchors.left: surface3.right}
            },
            State { //
                name: "3-KAM-bol2"
                PropertyChanges { target: surface2; z: 0; opacity: 1; visible: true;
                    height: mainRect.height / 1 - anchors.topMargin * 2;
                    width: mainRect.width / 1 - anchors.leftMargin * 2; anchors.left: mainRect.left; anchors.top: mainRect.top}
                PropertyChanges { target: surface1; z: 1; opacity: 0.6; visible: true; height:mainRect.height/4; width: mainRect.width / 4; anchors.left: mainRect.left; anchors.top: mainRect.top}
                PropertyChanges { target: surface3; z: 1; opacity: 0.6; visible: true; height:mainRect.height/4; width: mainRect.width / 4; anchors.left: mainRect.left; anchors.top: surface1.bottom}
            },
            State { //
                name: "3-KAM-bol3"
                PropertyChanges { target: surface3; z: 0; opacity: 1; visible: true;
                    height: mainRect.height / 1 - anchors.topMargin * 2;
                    width: mainRect.width / 1 - anchors.leftMargin * 2; anchors.left: mainRect.left; anchors.top: mainRect.top}
                PropertyChanges { target: surface2; z: 1; opacity: 0.6; visible: true; height:mainRect.height/4; width: mainRect.width / 4; anchors.left: mainRect.left; anchors.top: mainRect.top}
                PropertyChanges { target: surface1; z: 1; opacity: 0.6; visible: true; height:mainRect.height/4; width: mainRect.width / 4; anchors.left: mainRect.left; anchors.top: surface2.bottom}
            },
            State { // одна камера во весь экран
                name: "1-KAM-bol"
                PropertyChanges { target: surface1; z: 0; opacity: 1; visible: true;
                    height: mainRect.height / 1 - anchors.topMargin * 2;
                    width: mainRect.width / 1 - anchors.leftMargin * 2;
                    anchors.left: mainRect.left; anchors.top: mainRect.top}
                PropertyChanges { target: surface2; visible:cams[1].index;}
                PropertyChanges { target: surface3; visible:cams[2].index;}
            },
            State { // одна камера часть экрана
                name: "1-KAM-mal"
                PropertyChanges { target: surface1; z: 0; opacity: 1; visible: true;
                    height: mainRect.height-dashboard.width;
                    width: mainRect.width - dashboard.width;
                    anchors.left: mainRect.left; anchors.top: mainRect.top}
                PropertyChanges { target: surface2; visible:cams[1].index;}
                PropertyChanges { target: surface3; visible:cams[2].index;}
            },
            State { // две камеры, одинаковые
                name: "2-KAM-mal"
                PropertyChanges { target: surface1; z: 0; opacity: 1; visible: true;
                    height: mainRect.height / 2 - anchors.topMargin * 2;
                    width: mainRect.width / 2 - anchors.leftMargin * 2;
                    anchors.left: mainRect.left; anchors.top: mainRect.top
                }
                PropertyChanges { target: surface2; visible:cams[1].index; opacity: 1
                    height: mainRect.height / 2 - anchors.topMargin * 2;
                    width: mainRect.width / 2 - anchors.leftMargin * 2;
                    anchors.left: mainRect.left; anchors.top: surface1.bottom
                }
                PropertyChanges { target: surface3; visible:cams[2].index;}
            },
            State { // две камеры, первая большая
                name: "2-KAM-bol1"
                PropertyChanges { target: surface1; z: 0; opacity: 1; visible: true;
                    height: mainRect.height / 1 - anchors.topMargin * 2;
                    width: mainRect.width / 1 - anchors.leftMargin * 2;
                    anchors.left: mainRect.left; anchors.top: mainRect.top
                }
                PropertyChanges { target: surface2; visible:cams[1].index; opacity: 0.8;
                    height: mainRect.height / 4 - anchors.topMargin * 2;
                    width: mainRect.width / 4 - anchors.leftMargin * 2;
                    anchors.left: mainRect.left; anchors.top: mainRect.top
                }
                PropertyChanges { target: surface3; visible:cams[2].index; opacity: 0.8;
                    height: mainRect.height / 4 - anchors.topMargin * 2;
                    width: mainRect.width / 4 - anchors.leftMargin * 2;
                    anchors.left: mainRect.left; anchors.top: mainRect.top
                }
            },
            State { // две камеры, первая большая
                name: "2-KAM-bol2"
                PropertyChanges { target: surface2; z: 0; opacity: 1; visible:cams[1].index;
                    height: mainRect.height / 1 - anchors.topMargin * 2;
                    width: mainRect.width / 1 - anchors.leftMargin * 2;
                    anchors.left: mainRect.left; anchors.top: mainRect.top
                }
                PropertyChanges { target: surface3; z: 0; opacity: 1; visible:cams[2].index;
                    height: mainRect.height / 1 - anchors.topMargin * 2;
                    width: mainRect.width / 1 - anchors.leftMargin * 2;
                    anchors.left: mainRect.left; anchors.top: mainRect.top
                }
                PropertyChanges { target: surface1; visible: true; opacity: 0.8;
                    height: mainRect.height / 4 - anchors.topMargin * 2;
                    width: mainRect.width / 4 - anchors.leftMargin * 2;
                    anchors.left: mainRect.left; anchors.top: mainRect.top
                }
            }
        ]
        //###################################################################################################
    }
    ControlPanel {
        source: rig
        cam: win.cams
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
        cam: win.cams
        players: win.players
    }
    SetupSettings{
        id: settings
        width: 600
        height: 500
        anchors.centerIn: parent
        cam: win.cams
        rig: rig
        visible: false
    }
    MyHourglass {
        x: 300
        y: 300
        z:10
        anchors.centerIn: parent
        visible: cam1.timeout|cam2.timeout|cam3.timeout
    }
}

