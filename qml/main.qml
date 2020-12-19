import QtQuick 2.12
import QtQuick.Window 2.12
import Gyco 1.0
import HYCO 1.0
import Qt.labs.settings 1.0
import QtQuick.Extras 1.4

//DONE Сделать управление камерой (Зум и фокус)
Window {
    id: win
    title: "HYCO ПУЛЬТ УПРАВЛЕНИЯ МАНИПУЛЯТОРОМ"
    visible: true
    height: 720
    width: 1280
    color: "transparent"
    property int recording: 0
    property int play_on_start: 0
    property string filepath: ""
    property int filesize: 700 //Mbyte
    property alias rig: networker
    property list<MyCamera> cams
    property int demo_mode: 0

    Settings {
        property alias x: win.x
        property alias y: win.y
        property alias width: win.width
        property alias height: win.height
        property alias recording: win.recording
        property alias state: mainRect.state
        property alias play_on_start: win.play_on_start
        property alias filepath: win.filepath
        property alias filesize: win.filesize
        property alias joy_devider: j2.devider
    }
    function f_demo_mode(ana, mod ) {
        console.log(ana +"__"+mod)
        if (mod === 0)
        {
            if (ana===1) {
                return 0
            }
            if (ana===2) {
                return 0
            }
            if (ana===3) {
                return 0
            }
        }
        if (mod === 1)
        {
            rig1.gmod="grup1"
//            console.log(ana +"qqqq__"+mod)
            if (ana===1) {
                return 127
            }
            if (ana===2) {
                return 127
            }
            if (ana===3) {
                return 0
            }
        }
        if (mod === 2)
        {
            rig1.gmod="grup1"
            if (ana===1) {
                return -127
            }
            if (ana===2) {
                return -127
            }
            if (ana===3) {
                return 0
            }
        }
        if (mod === 3)
        {
            rig1.gmod="grup2"
            if (ana===1) {
                return 127
            }
            if (ana===2) {
                return 127
            }
            if (ana===3) {
                return 127
            }
        }
        if (mod === 4)
        {
            rig1.gmod="grup2"
            if (ana===1) {
                return -127
            }
            if (ana===2) {
                return -127
            }
            if (ana===3) {
                return -127
            }
        }

    }

    function register_camera(c) {
        cams.push(c)
    }

//    function statename(camstate) {
//        if (camstate === 0)
//            return "---"
//        if (camstate === 1)
//            return "Открытие"
//        if (camstate === 2)
//            return "Буферизация"
//        if (camstate === 3)
//            return "Трансляция"
//        if (camstate === 4)
//            return "Пауза"
//        if (camstate === 5)
//            return "Остановлено"
//        if (camstate === 6)
//            return "Завершено"
//        if (camstate === 7)
//            return "Ошибка"
//        return "UNKNOWN"
//    }


    Board {
        id: rig0
        board: 0
        light1: 0
        light2: 0
        light3: 0
        light4: 0
//        camera1: camSettings.cam1
//        camera2: camSettings.cam2
//        camera3: camSettings.cam3
//        camera4: camSettings.cam4
        onFree_engine1Changed: pins[1] = free_engine1 // клапан разгрузки
        Component.onCompleted: networker.reg(this)
        pin2: j2.keys[2]*(j2.x1axis>40); // поворот кисти влево 2Г
        pin3: j2.keys[2]*(j2.x1axis<-40);// поворот кисти вправо 2Г
        pin4: j2.keys[3]*(j2.y1axis>40);// направл локтя Подъем 4Г
        pin5: j2.keys[3]*(j2.y1axis<-40);// направл локть Спуск 4Г
        pin6: j2.keys[0]*(j2.y1axis>40); // направл плеча Подъем 5Г
        pin7: j2.keys[0]*(j2.y1axis<-40);// направл плеча Спуск 5Г

    }
    function power(v){ //регулировка мощности - зависит от движка на джойстике
        return v*Math.round(100*(j2.y2axis+127)/254)/100;
    }

    Board {
        id: rig1
        board: 1
        //j1.keys[0] = курок
//        joystick_x1: (win.f_demo_mode(1,win.demo_mode))+power((j2.y1axis>30||j2.y1axis<-30)*j2.y1axis*j2.keys[1])  //ana1 Схват

//        joystick_y1: (win.f_demo_mode(2,win.demo_mode))+power((j2.x2axis>30||j2.x2axis<-30)*j2.x2axis*j2.keys[0])   //ana2 поворот Схвата

//        joystick_x2: (win.f_demo_mode(3,win.demo_mode))+power((j2.x1axis>30||j2.x1axis<-30)*j2.x1axis*j2.keys[0])   //ana3 поворот руки

        joystick_x1: power(win.f_demo_mode(1,win.demo_mode))+power((j2.y1axis>30||j2.y1axis<-30)*j2.y1axis*j2.keys[1])  //ana1 Схват

        joystick_y1: power(win.f_demo_mode(2,win.demo_mode))+power((j2.x2axis>30||j2.x2axis<-30)*j2.x2axis*j2.keys[0])   //ana2 поворот Схвата

        joystick_x2: power(win.f_demo_mode(3,win.demo_mode))+power((j2.x1axis>30||j2.x1axis<-30)*j2.x1axis*j2.keys[0])   //ana3 поворот руки
        property bool lamp_switch: false
        light1: lampsSettings.lamp1 * lamp_switch
        light2: lampsSettings.lamp2 * lamp_switch
        light3: lampsSettings.lamp3 * lamp_switch
        light4: lampsSettings.lamp4 * lamp_switch
        Component.onCompleted: networker.reg(this)

        pin2: j2.keys[2]*(j2.y1axis>40);// направ кисти Подъем
        pin3: j2.keys[2]*(j2.y1axis<-40);// направ кисти Спуск
        pin6: controlPanel.cameras_power*camSettings.cam1; // Инжектор камеры

    }
//    Board {
//        id: rig2
//        board: 2
//        joystick_x1: (j1.hats[0]===1||j1.hats[0]===4)?power(j1.y1axis*!j1.keys[0]):0 // передний лифт ana1
//        joystick_y1: (j1.hats[0]===1||j1.hats[0]===4)?power(j1.y1axis*!j1.keys[0]):0 // задний лифт ana2
//        //joystick_x2: j2.x2axis*j2.keys[0]*!j2.keys[3] //поворот камеры ana3
//        joystick_x2: 127*(j2.keys[4]-j2.keys[5]) //поворот камеры ana3
//        light1: 0
//        light2: 0
//        light3: 0
//        light4: 0
//        pin1: j2.keys[2]*(j2.x1axis>100);
//        pin0: j2.keys[2]*(j2.x1axis<-100);
//        pin3: j2.keys[0]*(j2.y1axis>100);
//        pin2: j2.keys[0]*(j2.y1axis<-100);
//        pin5: j2.keys[0]*(j2.x1axis>100);
//        pin4: j2.keys[0]*(j2.x1axis<-100);
//        pin6: j2.keys[0]*j2.keys[3]*(j2.x2axis<-100);
//        pin7: j2.keys[0]*j2.keys[3]*(j2.x2axis>100);
//        Component.onCompleted: networker.reg(this)
//    }
    Networker {
        id: networker
    }

    function changestate() {

        console.log("STATE: " + mainRect.state + " ind:" )
    }

    function fcommand(cmd) {
        console.log("COMMAND=" + cmd)
        switch (cmd) {
        case "SET DEFAULT":
            win.height=1000
            win.width=1800
            win.x=50
            win.y=50
            dashboard.resetposition()
            controlPanel.x=100
            controlPanel.y=100
            menu.visible = false
            break
        case "FOCUS+START":
            cam_control.focus_minus()
            break
        case "FOCUS+STOP":
            cam_control.focus_minus_stop()
            break
        case "G+":
            if(rig1.gmod==="grup1")
                rig1.gmod="grup2"
            else if(rig1.gmod==="grup2")
                rig1.gmod="grup3"
             else if(rig1.gmod==="grup3")
                rig1.gmod="grup4"
              else if(rig1.gmod==="grup4")
                rig1.gmod="grup1"
            break
        case "G-":
            if(rig1.gmod==="grup4")
                rig1.gmod="grup3"
            else if(rig1.gmod==="grup3")
                rig1.gmod="grup2"
             else if(rig1.gmod==="grup2")
                rig1.gmod="grup1"
              else if(rig1.gmod==="grup1")
                rig1.gmod="grup4"
            break
        case "STOP":
            menu.visible = false
            camsettings.visible = false
            joystick_setup.visible = false
            settings.visible = false
            help.visible = false
            cm.cam.stop()
            break
        case "PLAY":
            menu.visible = false
            camsettings.visible = false
            settings.visible = false
            help.visible = false
            cm.cam.play()
            cm.cam.record(win.filepath, cm.video_file_extension)
            break
        case "PLAY2":
//            if (cams[1].cameraenabled)
//                player_play(1)
            menu.visible = false
            camsettings.visible = false
            settings.visible = false
            help.visible = false
            break
        case "PLAY3":
//            if (cams[2].cameraenabled)
//                player_play(2)
            menu.visible = false
            camsettings.visible = false
            settings.visible = false
            help.visible = false
            break
        case "PLAY4":
//            if (cams[3].cameraenabled)
//                player_play(3)
            menu.visible = false
            camsettings.visible = false
            settings.visible = false
            help.visible = false
            break
        case "STOP1":
//            players[0].stop()
            menu.visible = false
            camsettings.visible = false
            settings.visible = false
            help.visible = false
            break
        case "STOP2":
//            players[1].stop()
            menu.visible = false
            camsettings.visible = false
            settings.visible = false
            help.visible = false
            break
        case "STOP3":
//            players[2].stop()
            menu.visible = false
            camsettings.visible = false
            settings.visible = false
            help.visible = false
            break
        case "STOP4":
//            players[3].stop()
            menu.visible = false
            camsettings.visible = false
            settings.visible = false
            help.visible = false
            break
        case "JOYSTICK SETTINGS":
            joystick_setup.visible = !joystick_setup.visible
            settings.visible = false
            menu.visible = false
            //joystick_setup.visible = true
            camsettings.visible = false
            help.visible = false
            break
        case "PROGRAM SETTINGS":
            settings.visible = !settings.visible
            menu.visible = false
            camsettings.visible = false
            joystick_setup.visible = false
            help.visible = false
            break
        case "CAMERA SETTINGS":
//            camsettings.currentcam = 0
            camsettings.visible = !camsettings.visible
            menu.visible = false
            settings.visible = false
            joystick_setup.visible = false
            help.visible = false
            break
        case "HELP":
            help.visible = !help.visible
            camsettings.visible = false
            menu.visible = false
            joystick_setup.visible = false
            break
        case "MENU":
            menu.visible = menu.visible ? false : true
            camsettings.visible = false
            settings.visible = false
            joystick_setup.visible = false
            help.visible = false
            break
        case "FULLSCREEN":
            win.visibility = win.visibility
                    === Window.FullScreen ? Window.Maximized : Window.FullScreen
            break
        case "PICTURE":
            //picture.visible = !picture.visible;
            break
        case "LAYOUT":
            changestate()
            break
        case "LAYOUT_CAM1":
            mainRect.state = cmd
            break
        case "LAYOUT_CAM2":
            mainRect.state = cmd
            break
        case "LAYOUT_CAM3":
            mainRect.state = cmd
            break
        case "LAYOUT_CAM4":
            mainRect.state = cmd
            break
        case "LAMP":
            //rig0.lamp = !rig0.lamp
            rig1.lamp_switch = !rig1.lamp_switch
            break
        case "LAMPS":
            lampsSettings.visible = !lampsSettings.visible
            lampsSettings.height = lampsSettings.visible ? 160 : 0
            break
        case "CAMERA ON":
            controlPanel.cameras_power=!controlPanel.cameras_power
            break
        case "CAMSET":
            //окно с выбором включенных камер - не передаются параметры в rig
            camSettings.visible = !camSettings.visible
            camSettings.height = camSettings.visible ? 160 : 0
            break
        case "COOLSET":
            //окно управления охлаждением
            coolSettings.visible = !coolSettings.visible
            coolSettings.height = coolSettings.visible ? 160 : 0
            break
        case "ENGINE1":
            rig0.pins[0] = !rig0.pins[0]
            rig0.engine = rig0.pins[0]
            if (!rig0.engine) rig0.free_engine1 = false;
            break
        case "ENGINE2":
            //rig0.engine2 = rig0.engine2 ? false : true
            break
        case "COOLING":
            rig0.engine2 = !rig0.engine2
            break
        case "RECONNECT":
            networker.reconnect()
            break
        case "MODBUS RECONNECT":
            mbus.modbus_disconnect()
            break
        case "PUMP":
            rig0.pump = rig0.pump ? false : true
            break
        case "MANIP":
            rig0.pump=!rig0.pump
            rig0.pins[2] = rig0.pump
            break
        case "SCREENSHOT":
            var dt = new Date()
            var s = filepath + "MGM-screenshot" + dt.toLocaleString(
                        Qt.locale(), "dd-MM-yyyy_HH-mm-ss") + ".png"
            win.contentItem.grabToImage(function (result) {
                result.saveToFile(s)
            })

            break
        case "DEMO":
            recording = 0
            break
        }
    }

    Rectangle {
        id: mainRect
        color: 'black'
        anchors.fill: parent
        border.color: "yellow"
        //radius:20
        border.width: 3
        focus: true
        state: "1-KAM-bol"

        Keys.onPressed: {
            console.log("KeY:" + event.key)
            if (event.key === Qt.Key_F1 || event.key === Qt.Key_1)
                win.fcommand("HELP")
            if (event.key === Qt.Key_F2 || event.key === Qt.Key_2)
                win.fcommand("LAMP")
            if (event.key === Qt.Key_F3 || event.key === Qt.Key_3)
                win.fcommand("CAMERA ON")
            if (event.key === Qt.Key_F4 || event.key === Qt.Key_4)
                win.fcommand("ENGINE1")
            if (event.key === Qt.Key_F7 || event.key === Qt.Key_7)
                win.fcommand("COOLING")
            if (event.key === Qt.Key_G || event.key === 1055)
                win.fcommand("MANIP")
            if (event.key === Qt.Key_F8 || event.key === Qt.Key_8)
                win.fcommand("SET DEFAULT")
            if (event.key === Qt.Key_F9 || event.key === Qt.Key_9)
                win.fcommand("JOYSTICK SETTINGS")
            if (event.key === Qt.Key_F10 || event.key === Qt.Key_0)
                win.fcommand("CAMERA SETTINGS")
            if (event.key === Qt.Key_F11 || event.key === Qt.Key_Minus)
                win.fcommand("PROGRAM SETTINGS")
            if (event.key === Qt.Key_F5 || event.key === Qt.Key_5)
                win.fcommand("PLAY")
            if (event.key === Qt.Key_F6 || event.key === Qt.Key_6)
                win.fcommand("STOP")
            if (event.key === Qt.Key_F12 || event.key === Qt.Key_Equal)
                win.fcommand("FULLSCREEN")
            if ((event.modifiers & Qt.ControlModifier)
                    && (event.key === Qt.Key_P))
                win.fcommand("PICTURE")
            if ((event.modifiers & Qt.ControlModifier)
                    && (event.key === Qt.Key_D))
                win.fcommand("DEMO")
            if ((event.modifiers & Qt.ControlModifier)
                    && (event.key === Qt.Key_S))
                win.fcommand("SCREENSHOT")
            if ((event.key === Qt.Key_Y))
                rig0.gmod=rig1.gmod = "grup1"
            if ((event.key === Qt.Key_U))
                rig0.gmod=rig1.gmod = "grup2"
            if ((event.key === Qt.Key_I))
                rig0.gmod=rig1.gmod = "grup3"
            if ((event.key === Qt.Key_O))
                rig0.gmod=rig1.gmod = "grup4"

            if ((event.key === Qt.Key_Q)) {

                win.demo_mode=1
                rig1.joystick_x1= power(win.f_demo_mode(1,win.demo_mode))
                console.log(power(127)+ "  = "+ power(win.f_demo_mode(1,1))+" _  "+ win.f_demo_mode(1,1));
            }
            if ((event.key === Qt.Key_W))
                win.demo_mode=2
            if ((event.key === Qt.Key_E))
                win.demo_mode=3
            if ((event.key === Qt.Key_R))
                win.demo_mode=4
            if ((event.key === Qt.Key_T))
                win.demo_mode=0

            if ((event.modifiers & Qt.ControlModifier)
                    && (event.key === Qt.Key_Z))
                vlcPlayer1.mrl = "file:///" + win.filepath + "/demo/01.mpg"
            if ((event.modifiers & Qt.ControlModifier)
                    && (event.key === Qt.Key_X))
                vlcPlayer2.mrl = "file:///" + win.filepath + "/demo/02.mpg"
            if ((event.modifiers & Qt.ControlModifier)
                    && (event.key === Qt.Key_C))
                vlcPlayer3.mrl = "file:///" + win.filepath + "/demo/03.mpg"
            if ((event.modifiers & Qt.ControlModifier)
                    && (event.key === Qt.Key_V))
                vlcPlayer4.mrl = "file:///" + win.filepath + "/demo/04.mpg"
            //if ((event.key === Qt.Key_D)) win.fcommand("DEMO") vlcPlayer1.mrl = "file:///"+win.filepath+"/demo/01.mpg"
//            if (event.key === Qt.Key_Down) {
//                j1.ispresent = false
//                console.log("JFire:" + j1.key_0)
//                if (j1.y1axis > -127)
//                    j1.y1axis = j1.y1axis - 1
//            }
//            if (event.key === Qt.Key_Up) {
//                j1.ispresent = false
//                console.log("JFire:" + j1.key_0)
//                if (j1.y1axis < 127)
//                    j1.y1axis = j1.y1axis + 1
//            }
//            if (event.key === Qt.Key_PageDown || event.key === Qt.Key_Left) {
//                j1.ispresent = false
//                if (j1.y2axis > -127)
//                    j1.y2axis = j1.y2axis - 1
//            }
//            if (event.key === Qt.Key_PageUp || event.key === Qt.Key_Right) {
//                j1.ispresent = false
//                if (j1.y2axis < 127)
//                    j1.y2axis = j1.y2axis + 1
//            }
        }
        MyCamera{
            id: cm
            anchors.centerIn: parent
            anchors.fill: parent
            anchors.margins: 10
            name: "cam1"
            video_path: win.filepath
            Component.onCompleted: register_camera(cm)
        }
        StatePannel {
            id: statePannel
        }

        MouseArea {
            anchors.fill: parent
            acceptedButtons: Qt.RightButton | Qt.LeftButton
            onClicked: if (mouse.button === Qt.RightButton)
                           win.fcommand("MENU")
            onDoubleClicked: win.changestate()
        }

        MyMenu {
            id: menu
            width: 440
            height: 260
            z: 1
            anchors.centerIn: parent
            onCommandChanged: win.fcommand(command)
        }

        RigJoystick {
            id: j2
            current: 0
            devider: 1
//            onKeysChanged: print(keys)
            onKeyChanged: {
                console.log(key)
                if (key === 2 & !keys[2]) fcommand("G-")
                if (key === 3 & !keys[3]) fcommand("G+")

                if (key === 11 & keys[11]) fcommand("FOCUS+START")
                if (key === 11 & !keys[11]) fcommand("FOCUS+STOP")
                if (key === 10 & keys[10]) fcommand("FOCUS-START")
                if (key === 10 & !keys[10]) fcommand("FOCUS-STOP")

                if (key === 7 & keys[7]) fcommand("ZOOM+START")
                if (key === 7 & !keys[7]) fcommand("ZOOM+STOP")
                if (key === 6 & keys[6]) fcommand("ZOOM-START")
                if (key === 6 & !keys[6]) fcommand("ZOOM-STOP")
            }
        }

//        RigJoystick {
//            id: j2
//            current: 1
//            //onX1axisChanged: console.log(j2.x1axis)
//        }
        MyDashboard {
            visible: true
            height: 600
            id: dashboard
            width: 180
            z: 10
            rig: rig0
            state: "NPA"
            containerheight: parent.height
            anchors {
                margins: 10
                top: parent.top
                right: parent.right
            }
        }

        //###################################################################################################
        states: [
            State {
                // первая камера
                name: "LAYOUT_CAM1"
            },
            State {
                // вторая камера
                name: "LAYOUT_CAM2"
            }
        ]
    }
    ControlPanel {
        id: controlPanel
        source: rig0
        net: networker
//        cam: win.cams
        //width: 1000
        height: 100
        lampSize: 90
        fontSize: 14
        //anchors { margins: 10; bottomMargin: 100; bottom: parent.bottom; left: parent.left}
        onLampClicked: fcommand(cp_command)
        j1: j1
        j2: j2
    }
    LampsSettings {
        id: lampsSettings
        width: 250
        height: 0
        visible: false
        anchors {
            margins: 10
            leftMargin: 0
            bottom: controlPanel.top
            left: controlPanel.left
        }
    }
    CAMSettings {
        id: camSettings
        width: 150
        height: 0
        visible: false
//        cam: win.carms
        anchors {
            margins: 10
            leftMargin: 160
            bottom: controlPanel.top
            left: controlPanel.left
        }
    }
    COOLSettings {
        id: coolSettings
        width: 150
        height: 0
        visible: false
        anchors {
            margins: 10
            leftMargin: 300
            bottom: controlPanel.top
            left: controlPanel.left
        }
    }
    SetupCamera {
        id: camsettings
        width: 600
        height: 300
        visible: false
        anchors.centerIn: parent
        cam: win.cams
    }
    SetupSettings {
        id: settings
        width: 600
        height: 300
        anchors.centerIn: parent
        rig: networker
        rig_model: rig0
        visible: false
    }
    Joystick_setup {
        id: joystick_setup
    }
    Help {
        id: help
        visible: false
        width: 800
        height: 600
        anchors.centerIn: parent
    }
    CheckTCP {
        id: checke_tcp
        address:  cm.address //"192.168.1.168"
        port: 80
        interval: 5000
        timeout: 1000
        onOkChanged: console.log("camera " + (checke_tcp.ok ? "availavle": "unavailable"))
    }
    CamControl {
        id: cam_control
        address: cm.address
    }
    Component.onDestruction: {
        console.log("Good bye!")
    }

}


