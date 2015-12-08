import QtQuick 2.5
import QtQuick.Controls.Styles 1.4
import QtQuick.Controls 1.4
import QtQuick.Extras 1.4
Item {
    id: g
    property int minimumValue: 0
    property int maximumValue: 127
    property int val: 0;
    property color color:"yellow"
    //onValChanged: pb.value=val
    Rectangle {
        id: r
        width: g.width
        height: (val>0)?g.height*val/(g.maximumValue-g.minimumValue):-g.height*val/(g.maximumValue-g.minimumValue)
        //y: g.height
        rotation: 0
        y:g.height-height
        color: g.color
        opacity: 0.8



        }
    Rectangle {
        id: p
        color: "blue"
        width:r.width+2
        height:r.width+2
        y: r.y-r.width
        x:-1
        radius: 2
        border.color: "white"
        Behavior on y {

                    NumberAnimation {
                        easing.overshoot: 2
                        easing.type: Easing.OutExpo
                        //This specifies how long the animation takes
                        duration: 100
                        //This selects an easing curve to interpolate with, the default is Easing.Linear
                        //easing.type: Easing.OutBounce

                    }
                }

    }

}



