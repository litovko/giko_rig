import QtQuick 2.5
import QtQuick.Controls.Styles 1.4
import QtQuick.Controls 1.4
Item {
    id: hg
    property bool run: false;
    property int size: 50
    Rectangle {
            id: tr
            width: hg.size
            height: hg.size
            color: "transparent"
            border.color: "transparent"
            radius:hg.size/4
            Rectangle {
                id: r
                width: hg.size/2
                height: hg.size/2
                //anchors {left: tr.left; top: tr.top}
                color: "yellow"
                border.color: "blue"
                state: "s1"
                opacity: 0.7
                radius:hg.size/2
                Timer {
                    interval:250;
                    running: hg.visible;
                    repeat: true;
                    onTriggered: r.change()
                }
                function change(){
                    if (r.state==="s4") r.state="s1"
                    else if (r.state==="s1") r.state="s2"
                         else if (r.state==="s2") r.state="s3"
                              else if (r.state==="s3") r.state="s4";
                }
                transitions:
                    Transition {
                      to: "*"
                      NumberAnimation {
                        target: r
                        property: "x"
                        duration: 250
                        easing.type: Easing.Linear
                      }
                      NumberAnimation {
                        target: r
                        property: "y"
                        duration: 250
                        easing.type: Easing.Linear
                      }
                      NumberAnimation {
                        target: r
                        property: "opacity"
                        duration: 250
                        easing.type: Easing.Linear
                      }
                    }

                states: [
                    State {
                        name: "s1"
                        PropertyChanges { target: r; x: 0; y:0; opacity: 1 }
                        //PropertyChanges { target: tr; border.width: 1}

                    },
                    State {
                        name: "s2"
                        PropertyChanges { target: r; x: tr.width-width; opacity: 0.8}
                        //PropertyChanges { target: tr; border.width: 3}
                    },
                    State {
                        name: "s3"
                        PropertyChanges { target: r; x: tr.width-width; y: tr.height-height;opacity: 0.6}
                        //PropertyChanges { target: tr; border.width: 9}
                    },
                    State {
                        name: "s4"
                        PropertyChanges { target: r; x: 0;y: tr.height-height; opacity: 0.8 }
                        //PropertyChanges { target: tr; border.width: 18}
                    }
                   ]
            }
    }
}

