import QtQuick 2.5
import QtQuick.Window 2.2
import QtQuick.Controls 1.4
import Gyco 1.0
import QmlVlc 0.1
import QtMultimedia 5.5
import Qt.labs.settings 1.0
import QtQuick.Extras 1.4
import QtQml 2.2

Window {
    id: win
    //    visibility: Window.FullScreen
    title: "HYCO RIG CONSOLE ПУЛЬТ УПРАВЛЕНИЯ ПОДВОДНЫМ АППАРАТОМ"
    visible: true
    height: 720
    width: 1280
    color: "transparent"
    property int recording: 0
    property int play_on_start: 0
    property int network_caching: 250
    property string vlc_options: ",--nothing, --never ,:none=NAN"
    property string filepath: ""
    property int filesize: 700 //Mbyte
    property variant curfilesize:[-1,-1,-1]

    property list<VlcPlayer> players:[
        VlcPlayer {
            id: vlcPlayer1;
            Component.onCompleted: {
                if (cam1.index===0 || play_on_start===0) return
                stop();
                playlist.clear();
                playlist.addWithOptions(cam1.url1,getrecordoption(1));
                if(cams[0].index)play();
            }
        },
        VlcPlayer {
            id: vlcPlayer2;
            Component.onCompleted: {
                if (cam2.index===0|| play_on_start===0) return
                stop();
                playlist.clear();
                playlist.addWithOptions(cam2.url1,getrecordoption(2));
                if(cams[1].index)play();
            }
        },
        VlcPlayer {
            id: vlcPlayer3;
            Component.onCompleted: {
                if (cam3.index===0|| play_on_start===0) return
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
            index: 1
        },
        RigCamera {
            id: cam2
            index: 2
        },
        RigCamera {
            id: cam3
            index: 3
        }
    ]

    Settings {
        property alias x: win.x
        property alias y: win.y
        property alias width: win.width
        property alias height: win.height
        property alias recording: win.recording
        property alias state: mainRect.state
        property alias play_on_start: win.play_on_start
        property alias network_caching: win.network_caching
        property alias vlc_options: win.vlc_options
        property alias filepath: win.filepath
        property alias filesize: win.filesize
    }
    function player_play(player_number){
        if (cams[0].timeout||cams[1].timeout||cams[2].timeout) return;
        players[player_number].stop();
        players[player_number].playlist.clear();
        players[player_number].playlist.addWithOptions(cams[player_number].url1,getrecordoption(player_number));
        players[player_number].play();
        curfilesize[player_number]=-1;
    }

    function statename(camstate) {
        if (camstate===0) return "---";
        if (camstate===1) return "Открытие";
        if (camstate===2) return "Буферизация";
        if (camstate===3) return "Трансляция";
        if (camstate===4) return "Пауза";
        if (camstate===5) return "Остановлено";
        if (camstate===6) return "Завершено";
        if (camstate===7) return "Ошибка";
        return "";
    }
    function file_name(camindexx) {
        var dt=new Date();
        var s=filepath+"hyco-"
                +"cam"+(camindexx+1)+"-"
                +cams[camindexx].overlaytext + "-"
                + dt.toLocaleString(Qt.locale(),"dd-MM-yyyy_HH-mm-ss")
                +".mpg"
        //console.log("main: file_name->"+s)
        return s
    }

    function getrecordoption(camindex){
        //var dt=new Date();
        var vlc=vlc_options.split(',')
        console.log("registry vlc options - cam"+camindex+": ("+win.vlc_options+")");
        if (camindex===undefined) console.assert("getrecordoption camindex undefined!!!")
        var sopt=[":network-caching="+network_caching.toString()];//, ":sout-all", ":sout-keep" ];
        console.log("getrecordoption:("+sopt+")");
        if (recording===0) {
            console.log("Cam"+(camindex+1)+" Options without recording:"+sopt);
            for (var i=0; i<vlc.length; i++) sopt.push(vlc[i]);
            return sopt;
        }
//        console.log("Camindex="+camindex);
//        console.log("Camindex="+camindex+"cam:" +cams[camindex].title+"text:"+cams[camindex].overlaytext);
//        console.log("FN Time:"+ dt + "FilePath:"+filepath );
        var fn=file_name(camindex); cams[camindex].recordfile=fn;
        var popt=[":network-caching="+network_caching.toString()
                  ,":sout=#stream_out_duplicate{dst=display,dst=std{access=file,mux=mp4,dst="
                  + fn
                  + "}}"
                 ]
//        var popt=[":network-caching="+network_caching.toString()
//                  ,":sout=#stream_out_duplicate{dst=display,dst=std{access=file,mux=mp4,dst="+filepath+"hyco-"
//                  +"cam"+(camindex+1)+"-"
//                  +cams[camindex].overlaytext + "-"
//                  + dt.toLocaleString(Qt.locale(),"dd-MM-yyyy_HH-mm-ss")
//                  +".mpg}}"]
        for (var i=0; i<vlc.length; i++) popt.push(vlc[i]);
        console.log("Options with recording Cam"+(camindex+1)+":  "+popt);
        //:venc=ffmpeg,--no-audio,--high-priority,:threads=16
        return popt
    }
    function check_file_size(){
        if (recording===0) return;
        for (var i=0; i<3; i++) {
            if(players[i].state===3) {
                console.log ("file_name"+i+":"+cams[i].recordfile + "size:"+ cams[i].get_filesize())
                if (curfilesize[i]>=cams[i].get_filesize()) console.warn("NO RECORDINGS!!!")
                curfilesize[i]=cams[i].get_filesize();
                if (cams[i].get_filesize()>=filesize*1024*1024) player_play(i);
            }
        } //for
    }

    Timer {
        id: t_filesize
        interval: 10000
        repeat: true
        onTriggered: check_file_size()
        running: true
    }

    RigModel {
        id: rig
        joystick_y1: j.y1axis
        joystick_y2: j.y2axis
        joystick_x1: j.x1axis
    }
    function changestate(){
                    console.log("STATE: "+mainRect.state + " ind:" +cams[0].index+cams[1].index+cams[2].index);
                    console.log((cams[1].cameraenabled+"  "+cams[2].cameraenabled));
                    if ((!cams[1].cameraenabled&&!cams[2].cameraenabled)) // только одна камера
                        if (mainRect.state==="1-KAM-bol") mainRect.state="1-KAM-mal"
                        else mainRect.state="1-KAM-bol"
                    if (cams[1].cameraenabled&&!cams[2].cameraenabled) // две камеры
                        if (mainRect.state==="2-KAM-mal") mainRect.state="2-KAM-bol1"
                        else if (mainRect.state==="2-KAM-bol1") mainRect.state="2-KAM-bol2"
                             else mainRect.state="2-KAM-mal"

                    if (cams[1].cameraenabled&&cams[2].cameraenabled) //три камеры
                    if (mainRect.state==="3-KAM-mal") mainRect.state="3-KAM-bol1"
                    else if (mainRect.state==="3-KAM-bol1") mainRect.state="3-KAM-bol2"
                         else if (mainRect.state==="3-KAM-bol2") mainRect.state="3-KAM-bol3"
                              else if (mainRect.state==="3-KAM-bol3") mainRect.state="3-KAM-mal"
                                   else mainRect.state="3-KAM-mal"

    }
    function fcommand (cmd) {
        console.log ("COMMAND="+cmd)
        switch(cmd) {
          case "STOP":
              players[0].stop();
              players[1].stop();
              players[2].stop();
              menu.visible=false;
              camsettings.visible=false
              joysetup.visible=false;
              settings.visible=false;
              help.visible=false
              break;
          case "PLAY":
              if(cams[0].cameraenabled) player_play(0);
              if(cams[1].cameraenabled) player_play(1);
              if(cams[2].cameraenabled) player_play(2);
              menu.visible=false;
              camsettings.visible=false
              settings.visible=false;
              joysetup.visible=false
              help.visible=false
              break;
          case "JOYSTICK SETTINGS":
              joysetup.visible=!joysetup.visible;
              settings.visible=false;
              menu.visible=false;
              camsettings.visible=false
              help.visible=false
              break;
          case "PROGRAM SETTINGS":
              settings.visible=!settings.visible;
              menu.visible=false;
              camsettings.visible=false
              joysetup.visible=false;
              help.visible=false
              break;
          case "CAMERA SETTINGS":
              camsettings.visible=!camsettings.visible;
              menu.visible=false
              settings.visible=false;
              joysetup.visible=false;
              help.visible=false
              break;
          case "HELP":
              help.visible=!help.visible
              camsettings.visible=false;
              menu.visible=false
              settings.visible=false;
              joysetup.visible=false;
              break;
          case "CHANGE RIG TYPE":
              menu.visible=false
              camsettings.visible=false
              settings.visible=false;
              joysetup.visible=false
              help.visible=false
              if (dashboard.state==="grab2") dashboard.state="grab6"
              else if (dashboard.state==="grab6") dashboard.state="gkgbu"
                   else  dashboard.state="grab2"
              rig.rigtype=dashboard.state
              break;
          case "MENU":
              menu.visible=menu.visible?false:true
              camsettings.visible=false
              settings.visible=false;
              joysetup.visible=false
              help.visible=false
              break;
          case "FULLSCREEN":
              win.visibility = win.visibility===Window.FullScreen?Window.Maximized:Window.FullScreen;
              break;
          case "PICTURE":
              picture.visible = !picture.visible;
              break;
          case "LAYOUT":
              changestate();
              break;
          case "DEMO":
              mainRect.state = "3-KAM-bol1" // "3-KAM-mal"
              vlcPlayer1.mrl = "file:///"+win.filepath+"/01.3gp"
              vlcPlayer1.play()
              vlcPlayer2.mrl = "file:///"+win.filepath+"/02.3gp"
              vlcPlayer1.play()
              vlcPlayer3.mrl = "file:///"+win.filepath+"/03.3gp"
              vlcPlayer1.play()
              rig.engine=true;
              rig.lamp=true;
              rig.camera=true;
              rig.good_data=true;
              rig.client_connected=true;
              break;
        }
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


        Keys.onPressed: {
            console.log("KeY:"+event.key)
            if (event.key === Qt.Key_F1 || event.key === Qt.Key_1) win.fcommand("HELP")
            if (event.key === Qt.Key_F2||event.key ===  Qt.Key_2)  rig.lamp=rig.lamp?false:true;
            if (event.key === Qt.Key_F3||event.key ===  Qt.Key_3)  rig.camera=rig.camera?false:true;;
            if (event.key === Qt.Key_F4||event.key ===  Qt.Key_4)  rig.engine=rig.engine?false:true;
            if (event.key === Qt.Key_F8||event.key ===  Qt.Key_8)     win.fcommand("CHANGE RIG TYPE")
            if (event.key === Qt.Key_F9||event.key ===  Qt.Key_9)     win.fcommand("JOYSTICK SETTINGS")
            if (event.key === Qt.Key_F10||event.key === Qt.Key_0)     win.fcommand("CAMERA SETTINGS")
            if (event.key === Qt.Key_F11||event.key === Qt.Key_Minus) win.fcommand("PROGRAM SETTINGS")
            if (event.key === Qt.Key_F5||event.key ===  Qt.Key_5)     win.fcommand("PLAY")
            if (event.key === Qt.Key_F6||event.key ===  Qt.Key_6)     win.fcommand("STOP")
            if (event.key === Qt.Key_F12||event.key === Qt.Key_Equal) win.fcommand("FULLSCREEN")
            if ((event.modifiers & Qt.ControlModifier)&&(event.key === Qt.Key_P)) win.fcommand("PICTURE")
            if ((event.modifiers & Qt.ControlModifier)&&(event.key === Qt.Key_D)) win.fcommand("DEMO")
            //if ((event.key === Qt.Key_D)) win.fcommand("DEMO")
            if (event.key === Qt.Key_Down) {
                j.ispresent=false
                if(j.y1axis>-127) j.y1axis=j.y1axis-1;
            }
            if (event.key === Qt.Key_Up) {
                j.ispresent=false
                if(j.y1axis<127) j.y1axis=j.y1axis+1;
            }
            if (event.key === Qt.Key_PageDown||event.key === Qt.Key_Left) {
                j.ispresent=false
                if(j.y2axis>-127) j.y2axis=j.y2axis-1;
            }
            if (event.key === Qt.Key_PageUp||event.key === Qt.Key_Right) {
                j.ispresent=false
                if(j.y2axis<127) j.y2axis=j.y2axis+1;
            }

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
            acceptedButtons: Qt.RightButton
            onClicked: win.fcommand("MENU")

        }


        MyMenu {
            id: menu
            width: 440
            height: 260
            z:1
            anchors.centerIn: parent
            onCommandChanged: win.fcommand(command)

        }

        RigJoystick {
            id: j
            current: 0
            onKey_3Changed: if (key_3) fcommand("LAYOUT")
            onKey_2Changed: if (key_2) fcommand("PLAY")
//            {
//                                if(cams[0].cameraenabled) player_play(0);
//                                if(cams[1].cameraenabled) player_play(1);
//                                if(cams[2].cameraenabled) player_play(2);
//                            }
        }
        MyDashboard {
            height: 600
            id: dashboard
            width: 180
            z: 10
            source: rig
            state: rig.rigtype
            containerheight: parent.height
            anchors { margins: 10;
                      top: parent.top;
                      right: parent.right}           
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
            State { // две камеры, вторая большая
                name: "2-KAM-bol2"
                PropertyChanges { target: surface2; z: 0;  opacity: 1; visible:cams[1].index;
                    height: mainRect.height / 1 - anchors.topMargin * 2;
                    width: mainRect.width / 1 - anchors.leftMargin * 2;
                    anchors.left: mainRect.left; anchors.top: mainRect.top
                }
                PropertyChanges { target: surface3; z: 0; opacity: 1; visible:cams[2].index;
                    height: mainRect.height / 4 - anchors.topMargin * 2;
                    width: mainRect.width / 4 - anchors.leftMargin * 2;
                    anchors.left: mainRect.left; anchors.top: mainRect.top
                }
                PropertyChanges { target: surface1; z: 1; visible:cams[0].index; opacity: 0.8;
                    height: mainRect.height / 4 - anchors.topMargin * 2;
                    width: mainRect.width / 4 - anchors.leftMargin * 2;
                    anchors.left: mainRect.left; anchors.top: mainRect.top
                }
            }
        ]
        Image {
            id: picture
            visible: false
            fillMode: Image.PreserveAspectCrop
            source: "file:///c:/Users/1/Documents/qt/giko_rig/skin/q.png"
            anchors.fill: parent
            anchors.margins: 20
        }
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
        id: camsettings
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
    SetupJoystick{
        id: joysetup
        width: 600
        height: 500
        anchors.centerIn: parent
        joystick: j
        visible: false
    }
    Help {
        id: help
        visible: false
        width: 800
        height: 600
        anchors.centerIn: parent
    }

    MyHourglass {
        x: 300
        y: 300
        z:10
        anchors.centerIn: parent
        visible: cam1.timeout|cam2.timeout|cam3.timeout
    }

    Component.onDestruction: {
        console.log("Good bye!")
        players[0].stop();
        players[1].stop();
        players[2].stop();
        console.log("All players stopped")
    }
}

