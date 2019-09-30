import QtQuick 2.11
import QtQuick.Window 2.11
//import QtQuick.Controls 2.5
import Gyco 1.0
import QmlVlc 0.1
//import QtMultimedia 5.5
import Qt.labs.settings 1.0
import QtQuick.Extras 1.4

//import QtQml 2.2

Window {
    id: win
    //    visibility: Window.FullScreen
    title: "HYCO ПУЛЬТ УПРАВЛЕНИЯ НЕОБИТАЕМЫМ ПОДВОДНЫМ АППАРАТОМ"
    visible: true

    height: 720
    width: 1280
    color: "transparent"
    property int recording: 0
    property int play_on_start: 0
    property int network_caching: 250
    property string vlc_options: "--no-audio"
    property string filepath: ""
    property int filesize: 700 //Mbyte
    property variant curfilesize:[-1,-1,-1,-1]
    property bool onrecord: true; //true если меняется размер записываемого файла.
    property bool camera_umg: false //false - камеры ПМГРЭ true - камеры ЮМГ
    property string streaming: ":sout=#duplicate{dst=display,dst=std{access=file,mux=mp4,dst=" //параметры стриминга vlc при записи - дубликация потоков
    property bool  pause: false // если истина то показываются часики...
    // Поле в реестре vlc_options
    //:high-priority,:spu,:ods,:clock-synchro=0,:clock-jitter=10000  Убрана синхронизация времени и
    //                                джиттер задран как советует VLC для тяжелых условий сетевого доступа

    property list<VlcPlayer> players:[
        VlcPlayer {
            id: vlcPlayer1;

        },
        VlcPlayer {
            id: vlcPlayer2;

        },
        VlcPlayer {
            id: vlcPlayer3;

        },
        VlcPlayer {
            id: vlcPlayer4;

        }

    ]
    property list<RigCamera> cams: [
        RigCamera {
            id: cam1
            index: 1
            type: 1+win.camera_umg
        },
        RigCamera {
            id: cam2
            index: 2
            type: 1+win.camera_umg
        },
        RigCamera {
            id: cam3
            index: 3
            type: 1+win.camera_umg
        },
        RigCamera {
            id: cam4
            index: 4
            type: 1+win.camera_umg
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
        property alias camera_umg: win.camera_umg
        property alias streaming: win.streaming
        property alias subtitles: subtitle.interval
        property alias joy_devider: j.devider
    }
    function player_play(player_number){
        if (cams[0].timeout||cams[1].timeout||cams[2].timeout||cams[3].timeout) return;
        players[player_number].stop();
        players[player_number].playlist.clear();
        players[player_number].playlist.addWithOptions(cams[player_number].url1,getrecordoption(player_number));
        players[player_number].play();
        curfilesize[player_number]=-1;
        onrecord=true;

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
        return "UNKNOWN";
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
        var i;
        var vlc=vlc_options.split(',')
        console.log("registry vlc options - cam"+(camindex+1)+": ("+win.vlc_options+")");
        if (camindex===undefined) console.assert("getrecordoption camindex undefined!!!")
        var sopt=[":network-caching="+network_caching.toString()];//, ":sout-all", ":sout-keep" ];
        console.log("getrecordoption:("+sopt+")");
        if (recording===0) {
            console.log("Cam"+(camindex+1)+" Options without recording:"+sopt);
            for (i=0; i<vlc.length; i++) sopt.push(vlc[i]);
            return sopt;
        }

        var fn=file_name(camindex); cams[camindex].recordfile=fn; //The recorded file name stored in camera object
//        var popt=[":network-caching="+network_caching.toString()
//                  ,":sout=#stream_out_duplicate{dst=display,dst=std{access=file,mux=mp4,dst="
//                  + fn
//                  + "}}"
//                 ]
        var popt=[":network-caching="+network_caching.toString()
                  , streaming
                  + fn
                  + "}}"
                 ]

        for ( i=0; i<vlc.length; i++) popt.unshift(vlc[i]);
        console.log("Options with recording Cam"+(camindex+1)+":  "+popt);
        //:venc=ffmpeg,--no-audio,--high-priority,:threads=16
        return popt
    }
    function check_file_size(){
        if (recording===0) return;
        var flag=false;
        for (var i=0; i<4; i++) {
            if(players[i].state===3) {
                console.log ("file_name"+i+":"+cams[i].recordfile + "size:"+ cams[i].get_filesize())
                if (curfilesize[i]>=cams[i].get_filesize()) {
                    console.warn("NO RECORDINGS!!!"+"CAM:"+i);
                    onrecord=false;
                }
                curfilesize[i]=cams[i].get_filesize();
                if ((cams[i].get_filesize()>=filesize*1024*1024)&&!flag) {
                    flag=true;
                    console.warn("Reset recording file for CAM"+i);
                    player_play(i);
                }
            }
        } //for
    }

    Timer {
        id: t_filesize
        interval: 30000
        repeat: true
        onTriggered: check_file_size()
        running: true
    }
    Timer {
        id: subtitle
        interval:subtitle.interval
        repeat: subtitle.interval
        onTriggered: write_subtitle()
        running: recording

    }
    Timer {
        id: cooling
        interval: 10000
        repeat: true
        running: coolSettings.auto
        onTriggered: {
            if (rig.temperature>coolSettings.text_on*1) rig.engine2=true
            if (rig.temperature<coolSettings.text_off*1) rig.engine2=false

        }
    }

    function write_subtitle(){
        if(vlcPlayer1.state!==3) return;
        if(subtitle.interval===0) return;
        //console.log( "CAM1 POSITION: "+vlcPlayer1.time+ " = " + vlcPlayer1.input.length + " = " + vlcPlayer1.input.time)
        var s="A="+rig.ampere+":"+rig.ampere2+":"+rig.ampere3+" V="+rig.voltage+":"+rig.voltage2+":"+rig.voltage3+"\r\n";
        s=s+" P="+rig.pressure+":"+rig.pressure2+" t="+rig.temperature+":"+rig.temperature2+" h="+rig.altitude+" k="+rig.kren+" T="+rig.tangag+" R="+rig.turns;
        s=s+" J=" + rig.joystick_x1 + ":" + rig.joystick_x2 + ":" + rig.joystick_y1 + ":" + rig.joystick_y2
        cam1.write_subtitles(vlcPlayer1.time,s);
    }

    RigModel {
        id: rig
        joystick_y1: j.y1axis*(j.key_0||j.lock)
        joystick_y2: j.y2axis*(j.key_0||j.lock)
        joystick_x1: j.x1axis*(j.key_0||j.lock)
        joystick_x2: j.x2axis*(j.key_0||j.lock)
        light1: lampsSettings.lamp1*lamp_tag
        light2: lampsSettings.lamp2*lamp_tag
        light3: lampsSettings.lamp3*lamp_tag
        light4: lampsSettings.lamp4*lamp_tag
        camera1: camSettings.cam1
        camera2: camSettings.cam2
        camera3: camSettings.cam3
        camera4: camSettings.cam4
        property bool lamp_tag: false
        property var rig_types: ["grab6", "grab2", "gkgbu", "mgbu", "NPA"]

    }
    function changestate(){

                    console.log("STATE: "+mainRect.state + " ind:" +cams[0].index+cams[1].index+cams[2].index+cams[3].index);

        if (rig.rigtype==="mgbu") {
            console.log("CHANGE LAYOUT FOR MGBU")
            if(mainRect.state==="LAYOUT_CAM4") { mainRect.state="4-KAM-all"; return}
            if(mainRect.state==="LAYOUT_CAM3") { mainRect.state="LAYOUT_CAM4"; return}
            if(mainRect.state==="LAYOUT_CAM2") { mainRect.state="LAYOUT_CAM3"; return}
            if(mainRect.state==="LAYOUT_CAM1") { mainRect.state="LAYOUT_CAM2"; return}
            if(mainRect.state==="4-KAM-all") {   mainRect.state="LAYOUT_CAM1"; return}
            mainRect.state="4-KAM-all"; return;
        }
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
              players[3].stop();
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
              if(cams[3].cameraenabled) player_play(3);
              menu.visible=false;
              camsettings.visible=false
              settings.visible=false;
              help.visible=false

              break;
          case "PLAY1":
              if(cams[0].cameraenabled) player_play(0);
              menu.visible=false;
              camsettings.visible=false
              settings.visible=false;
              help.visible=false
              break;
          case "PLAY2":
              if(cams[1].cameraenabled) player_play(1);
              menu.visible=false;
              camsettings.visible=false
              settings.visible=false;
              help.visible=false
              break;
          case "PLAY3":
              if(cams[2].cameraenabled) player_play(2);
              menu.visible=false;
              camsettings.visible=false
              settings.visible=false;
              help.visible=false
              break;
          case "PLAY4":
              if(cams[3].cameraenabled) player_play(3);
              menu.visible=false;
              camsettings.visible=false
              settings.visible=false;
              help.visible=false
              break;
          case "STOP1":
              players[0].stop();
              menu.visible=false;
              camsettings.visible=false
              settings.visible=false;
              help.visible=false
              break;
          case "STOP2":
              players[1].stop();
              menu.visible=false;
              camsettings.visible=false
              settings.visible=false;
              help.visible=false
              break;
          case "STOP3":
              players[2].stop();
              menu.visible=false;
              camsettings.visible=false
              settings.visible=false;
              help.visible=false
              break;
          case "STOP4":
              players[3].stop();
              menu.visible=false;
              camsettings.visible=false
              settings.visible=false;
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
              var i=rig.rig_types.indexOf(dashboard.state)
              if (i===rig.rig_types.length-1) dashboard.state=rig.rig_types[0]
              else dashboard.state=rig.rig_types[i+1]
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
              //picture.visible = !picture.visible;
              break;
          case "LAYOUT":
              changestate();
              break;
          case "LAYOUT_CAM1":
              mainRect.state=cmd;
              break;
          case "LAYOUT_CAM2":
              mainRect.state=cmd;
              break;
          case "LAYOUT_CAM3":
              mainRect.state=cmd;
              break;
          case "LAYOUT_CAM4":
              mainRect.state=cmd;
              break;
          case "LAMP":
              rig.lamp=!rig.lamp
              break;
          case "LAMPS":
              lampsSettings.visible=!lampsSettings.visible
              lampsSettings.height=lampsSettings.visible?160:0
              break;
          case "CAMERA ON":
              rig.camera=rig.camera?false:true;
              break;
          case "CAMSET": //окно с выбором включенных камер - не передаются параметры в rig
              camSettings.visible=!camSettings.visible
              camSettings.height=camSettings.visible?160:0
              break;
          case "COOLSET": //окно управления охлаждением
              coolSettings.visible=!coolSettings.visible
              coolSettings.height=coolSettings.visible?160:0
              break;
          case "ENGINE1":
              rig.engine=rig.engine?false:true;
              break;
          case "ENGINE2":
              rig.engine2=rig.engine2?false:true;
              break;
          case "COOLING":
              rig.engine2=!rig.engine2;
              break;
          case "RECONNECT":
              rig.reconnect();
              break;
          case "PUMP":
              rig.pump=rig.pump?false:true;
              break;
          case "MANIP":
              rig.pump=!rig.pump;
              break;
          case "SCREENSHOT":
              var dt=new Date();
              var s=filepath+"NPA-screenshot"
                      + dt.toLocaleString(Qt.locale(),"dd-MM-yyyy_HH-mm-ss")
                      +".png"
              win.contentItem.grabToImage(function(result) {
                  result.saveToFile(s);
              })

              break;
          case "DEMO":
              recording=0
              //mainRect.state = "3-KAM-bol1" // "3-KAM-mal"
              vlcPlayer4.mrl = "file:///"+win.filepath+"/demo/04.mpg"
              //vlcPlayer1.play()
              vlcPlayer3.mrl = "file:///"+win.filepath+"/demo/02.mpg"
              //vlcPlayer2.play()
              vlcPlayer2.mrl = "file:///"+win.filepath+"/demo/03.mpg"
              //vlcPlayer3.play()
              //vlcPlayer1.mrl = "file:///"+win.filepath+"/demo/01.mpg"
              //vlcPlayer4.play()
//              rig.engine=true;
//              rig.lamp=true;
//              rig.camera=true;

              break;
        }
    }

    Rectangle {
        id: mainRect
        color: 'black';
        anchors.fill: parent
        border.color: "yellow"
        //radius:20
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
                Behavior on y {

                            NumberAnimation {
                                duration: 600
                                easing.type: Easing.InOutQuad
                            }
                        }
                Behavior on x {

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
                Behavior on y {

                            NumberAnimation {
                                duration: 600
                                easing.type: Easing.InOutQuad
                            }
                        }
                Behavior on x {

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
                Behavior on y {

                            NumberAnimation {
                                duration: 600
                                easing.type: Easing.InOutQuad
                            }
                        }
                Behavior on x {

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
                id: surface4
                source: win.players[3];
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
                Behavior on y {

                            NumberAnimation {
                                duration: 600
                                easing.type: Easing.InOutQuad
                            }
                        }
                Behavior on x {

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
            if (event.key === Qt.Key_F2||event.key ===  Qt.Key_2)  win.fcommand("LAMP");
            if (event.key === Qt.Key_F3||event.key ===  Qt.Key_3)  win.fcommand("CAMERA ON")
            if (event.key === Qt.Key_F4||event.key ===  Qt.Key_4)  win.fcommand("ENGINE1")
            if (event.key === Qt.Key_F7||event.key ===  Qt.Key_7)  win.fcommand("COOLING")
            if (event.key === Qt.Key_G||event.key ===  1055     )  win.fcommand("MANIP")
            if (event.key === Qt.Key_F8||event.key ===  Qt.Key_8)     win.fcommand("CHANGE RIG TYPE")
            if (event.key === Qt.Key_F9||event.key ===  Qt.Key_9)     win.fcommand("JOYSTICK SETTINGS")
            if (event.key === Qt.Key_F10||event.key === Qt.Key_0)     win.fcommand("CAMERA SETTINGS")
            if (event.key === Qt.Key_F11||event.key === Qt.Key_Minus) win.fcommand("PROGRAM SETTINGS")
            if (event.key === Qt.Key_F5||event.key ===  Qt.Key_5)     win.fcommand("PLAY")
            if (event.key === Qt.Key_F6||event.key ===  Qt.Key_6)     win.fcommand("STOP")
            if (event.key === Qt.Key_F12||event.key === Qt.Key_Equal) win.fcommand("FULLSCREEN")
            if ((event.modifiers & Qt.ControlModifier)&&(event.key === Qt.Key_P)) win.fcommand("PICTURE")
            if ((event.modifiers & Qt.ControlModifier)&&(event.key === Qt.Key_D)) win.fcommand("DEMO")
            if ((event.modifiers & Qt.ControlModifier)&&(event.key === Qt.Key_S)) win.fcommand("SCREENSHOT")
            if ((event.modifiers & Qt.ControlModifier)&&(event.key === Qt.Key_Z)) vlcPlayer1.mrl = "file:///"+win.filepath+"/demo/01.mpg"
            if ((event.modifiers & Qt.ControlModifier)&&(event.key === Qt.Key_X)) vlcPlayer2.mrl = "file:///"+win.filepath+"/demo/02.mpg"
            if ((event.modifiers & Qt.ControlModifier)&&(event.key === Qt.Key_C)) vlcPlayer3.mrl = "file:///"+win.filepath+"/demo/03.mpg"
            if ((event.modifiers & Qt.ControlModifier)&&(event.key === Qt.Key_V)) vlcPlayer4.mrl = "file:///"+win.filepath+"/demo/04.mpg"
            //if ((event.key === Qt.Key_D)) win.fcommand("DEMO") vlcPlayer1.mrl = "file:///"+win.filepath+"/demo/01.mpg"
            if (event.key === Qt.Key_Down) {
                j.ispresent=false
                console.log("JFire:"+j.key_0)
                if(j.y1axis>-127) j.y1axis=j.y1axis-1;
            }
            if (event.key === Qt.Key_Up) {
                j.ispresent=false
                console.log("JFire:"+j.key_0)
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


        StatePannel {
            id: statePannel
        }



        MouseArea {
            anchors.fill: parent
            acceptedButtons: Qt.RightButton|Qt.LeftButton
            onClicked: if (mouse.button===Qt.RightButton) win.fcommand("MENU")
            onDoubleClicked: win.changestate()


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
            onKey_1Changed: if (key_1) fcommand("JKEY1")
            onKey_0Changed: if (key_0&&j.ispresent) fcommand("JKEY0")
            devider: 1+key_5
        }
        MyDashboard {
            visible: true
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
                name: "LAYOUT_CAM1"
                PropertyChanges { target: surface1; z: 0;opacity: 1; visible: cams[0].cameraenabled;
                    height: mainRect.height / 1 - 10;
                    width: mainRect.width / 1 - 10;
                    anchors.centerIn: parent}
                PropertyChanges { target: surface2; z: 1; opacity: 0.6; visible: cams[1].cameraenabled; height:mainRect.height/4; width: mainRect.width / 4; anchors.left: mainRect.left; anchors.top: mainRect.top}
                PropertyChanges { target: surface3; z: 1; opacity: 0.6; visible: cams[2].cameraenabled; height:mainRect.height/4; width: mainRect.width / 4; anchors.left: mainRect.left; anchors.top: surface2.bottom}
                PropertyChanges { target: surface4; z: 1; opacity: 0.6; visible: cams[3].cameraenabled; height:mainRect.height/4; width: mainRect.width / 4; anchors.left: mainRect.left; anchors.top: surface3.bottom}

            },
            State { // вторая камера
                name: "LAYOUT_CAM2"
                PropertyChanges { target: surface2; z: 0;opacity: 1; visible: cams[1].cameraenabled;
                    height: mainRect.height / 1 - 10;
                    width: mainRect.width / 1 - 10;
                    anchors.centerIn: parent}
                PropertyChanges { target: surface1; z: 1; opacity: 0.6; visible: cams[0].cameraenabled; height:mainRect.height/4; width: mainRect.width / 4; anchors.left: mainRect.left; anchors.top: mainRect.top}
                PropertyChanges { target: surface3; z: 1; opacity: 0.6; visible: cams[2].cameraenabled; height:mainRect.height/4; width: mainRect.width / 4; anchors.left: mainRect.left; anchors.top: surface1.bottom}
                PropertyChanges { target: surface4; z: 1; opacity: 0.6; visible: cams[3].cameraenabled; height:mainRect.height/4; width: mainRect.width / 4; anchors.left: mainRect.left; anchors.top: surface3.bottom}

            },
            State { // третья камера
                name: "LAYOUT_CAM3"
                PropertyChanges { target: surface3; z: 0;opacity: 1; visible: cams[2].cameraenabled;
                    height: mainRect.height / 1 - 10;
                    width: mainRect.width / 1 - 10;
                    anchors.centerIn: parent}
                PropertyChanges { target: surface1; z: 1; opacity: 0.6; visible: cams[0].cameraenabled; height:mainRect.height/4; width: mainRect.width / 4; anchors.left: mainRect.left; anchors.top: mainRect.top}
                PropertyChanges { target: surface2; z: 1; opacity: 0.6; visible: cams[1].cameraenabled; height:mainRect.height/4; width: mainRect.width / 4; anchors.left: mainRect.left; anchors.top: surface1.bottom}
                PropertyChanges { target: surface4; z: 1; opacity: 0.6; visible: cams[3].cameraenabled; height:mainRect.height/4; width: mainRect.width / 4; anchors.left: mainRect.left; anchors.top: surface2.bottom}

            },
            State { // четвертая камера
                name: "LAYOUT_CAM4"
                PropertyChanges { target: surface4; z: 0;opacity: 1; visible: cams[3].cameraenabled;
                    height: mainRect.height / 1 - 10;
                    width: mainRect.width / 1 - 10;
                    anchors.centerIn: parent}
                PropertyChanges { target: surface1; z: 1; opacity: 0.6; visible: cams[0].cameraenabled; height:mainRect.height/4; width: mainRect.width / 4; anchors.left: mainRect.left; anchors.top: mainRect.top}
                PropertyChanges { target: surface2; z: 1; opacity: 0.6; visible: cams[1].cameraenabled; height:mainRect.height/4; width: mainRect.width / 4; anchors.left: mainRect.left; anchors.top: surface1.bottom}
                PropertyChanges { target: surface3; z: 1; opacity: 0.6; visible: cams[2].cameraenabled; height:mainRect.height/4; width: mainRect.width / 4; anchors.left: mainRect.left; anchors.top: surface2.bottom}

            },
            State { // бол 1 камера
                name: "3-KAM-bol1"
                PropertyChanges { target: surface1; z: 0;opacity: 1; visible: true;
                    height: mainRect.height / 1 - anchors.topMargin * 2;
                    width: mainRect.width / 1 - anchors.leftMargin * 2;
                    anchors.left: mainRect.left; anchors.top: mainRect.top}
                PropertyChanges { target: surface2; z: 1; opacity: 0.6; visible: true; height:mainRect.height/4; width: mainRect.width / 4; anchors.left: mainRect.left; anchors.top: mainRect.top}
                PropertyChanges { target: surface3; z: 1; opacity: 0.6; visible: true; height:mainRect.height/4; width: mainRect.width / 4; anchors.left: mainRect.left; anchors.top: surface2.bottom}

            },
            State { // четыре камеры по центру
                name: "4-KAM-all"
                PropertyChanges { target: surface1; z: 0; opacity: 1; visible: cams[0].cameraenabled; height:mainRect.height/4; width: mainRect.width / 4; anchors.left: mainRect.left; anchors.top: mainRect.top}
                PropertyChanges { target: surface2; z: 0; opacity: 1; visible: cams[1].cameraenabled; height:mainRect.height/4; width: mainRect.width / 4; anchors.left: surface1.right; anchors.top: mainRect.top}
                PropertyChanges { target: surface3; z: 0; opacity: 1; visible: cams[2].cameraenabled; height:mainRect.height/4; width: mainRect.width / 4; anchors.left: mainRect.left; anchors.top: surface1.bottom}
                PropertyChanges { target: surface4; z: 0; opacity: 1; visible: cams[3].cameraenabled; height:mainRect.height/4; width: mainRect.width / 4; anchors.left: surface1.right; anchors.top: surface2.bottom}


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

    }
    ControlPanel {
        id: controlPanel
        source: rig
        cam: win.cams
        //width: 1000
        height: 100
        lampSize: 90
        fontSize: 14
        //anchors { margins: 10; bottomMargin: 100; bottom: parent.bottom; left: parent.left}
        onLampClicked: fcommand(cp_command)
    }
    LampsSettings {
        id: lampsSettings
        width: 250
        height: 0
        visible: false
        anchors { margins: 10; leftMargin: 0; bottom: controlPanel.top; left: controlPanel.left}
    }
    CAMSettings {
        id: camSettings
        width: 150
        height: 0
        visible: false
        cam: win.cams
        anchors { margins: 10; leftMargin: 160; bottom: controlPanel.top; left: controlPanel.left}
        onCam1Changed: players[0].stop();
        onCam2Changed: players[1].stop();
        onCam3Changed: players[2].stop();
        onCam4Changed: players[3].stop();
    }
    COOLSettings {
        id: coolSettings
        width: 150
        height: 0
        visible: false
        anchors { margins: 10; leftMargin: 300; bottom: controlPanel.top; left: controlPanel.left}

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
        visible: cam1.timeout|cam2.timeout|cam3.timeout|cam4.timeout|win.pause
    }



    Component.onDestruction: {
        console.log("Good bye!")
        players[0].stop();
        players[1].stop();
        players[2].stop();
        players[3].stop();
        console.log("All players stopped")
    }
}

