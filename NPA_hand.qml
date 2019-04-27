import QtQuick 2.5
import "./figure.js" as Fig

Item {
    id: hand
    property real a1: 20
    property real a2: -80
    property real a3: 120
    property real a4: -60
    property real a5: 20
    property real l1: 50
    property real l2: 80
    property real l3: 80
    property real l4: 80
    property real l5: 40
    readonly property point p0: "100,220"
    property point p1: "0,0"
    property point p2: "0,0"
    property point p3: "0,0"
    property point p4: "0,0"
    property point p5: "0,0"
    property string c1: "yellow" //обычный
    property string c2: "red"   // выбранный
    property string c3: "transparent" //каркас
    property string c4: "lightgray" //каркас выбранный
    readonly property real r: 5; //радиус точек
    readonly property real d: 3; //зазоры
    property int select: 14
    property bool pos_rask: true
    property bool pos_home: false
    property alias a6up: a6up.value
    property alias a6down: a6down.value
    property alias a2up: a2up.value
    property alias a2down: a2down.value
    property alias a5left: a5left.value
    property alias a5right: a5right.value
    property alias a3left: a3left.value
    property alias a3right: a3right.value
    property alias a7left: a7left.value
    property alias a7right: a7right.value
    property alias a4left: a4left.value
    property alias a4right: a4right.value
    property alias a1left: a1left.value
    property alias a1right: a1right.value

    onA1Changed:   canvas.requestPaint()
    onA2Changed:   canvas.requestPaint()
    onA3Changed:   canvas.requestPaint()
    onA4Changed:   canvas.requestPaint()
    onA5Changed:   canvas.requestPaint()
    onL1Changed:   canvas.requestPaint()
    onL2Changed:   canvas.requestPaint()
    onL3Changed:   canvas.requestPaint()
    onL4Changed:   canvas.requestPaint()
    onL5Changed:   canvas.requestPaint()
    onSelectChanged: canvas.requestPaint()

    function draw1(c, p, len, angle)
    {
        angle=angle-60;

        var s6=2*r // толщина скобы
        var s1=len/6; //длина петли
        var s2=d // выступ циллиндра
        var s3=(len)*Math.sqrt(3)/2// высота циллиндра

        var s4=(len)/2/2 // ширина циллиндра
        var s7=s4+s4/2 // ширина скобы
        var s5=d // зазор


        var s8=len/8 // выступ угла скобы
        var s9=(len)/2   // смещение центра отверстия по Х -  угол наклона оси 30 градусов
        var s10=len*Math.sqrt(3)/2   // смещение центра отверстия по Y
        c.save();
        c.strokeStyle = select&1?c2:c1
        c.lineWidth = 2
        c.beginPath()
        c.translate(p.x, p.y)
        c.rotate(angle*Math.PI/180);
        c.arc(0,0, r, 0.5*Math.PI, 1.5*Math.PI);

        c.moveTo(0,r)
        c.lineTo(s1,r);
        c.lineTo(s1,-r);
        c.lineTo(0,-r);
        c.strokeRect(s1,-r-s2,s4, s3);
        //вторая деталь - скоба
        c.moveTo(s1,-r-s2-s5);
        c.lineTo(s1+s4+s5,-r-s2-s5); //скоба - верх
        c.lineTo(s1+s4+s5,-r-s2+s5+s3)
        c.lineTo(s1,-r-s2+s5+s3)
        c.lineTo(s1,-r-s2+s5+s3+s6)
        c.lineTo(s1+s7,-r-s2+s5+s3+s6) // cкоба - низ
        c.lineTo(s1+s7+s8,(s3+2*s5+2*s6)/2-r-s2-s5-s6/2)
        c.lineTo(s1+s7,-r-s2-s5-s6)
        c.lineTo(s1,-r-s2-s5-s6)
        c.lineTo(s1,-r-s2-s5)

        c.stroke();
        c.restore();

    }
    function draw2(c, p, len, angle)
    {

        var s6=2*r // толщина скобы
        var s1=len/6; //длина петли
        var s2=d // выступ циллиндра
        var s3=(len)*Math.sqrt(3)/2// высота циллиндра

        var s4=(len)/2/2 // ширина циллиндра
        var s7=s4+s4/2 // ширина скобы
        var s5=d // зазор


        var s8=len/8 // выступ угла скобы
        var s9=(len)/2   // смещение центра отверстия по Х -  угол наклона оси 30 градусов
        var s10=len*Math.sqrt(3)/2   // смещение центра отверстия по Y
        c.save();
        c.strokeStyle = select&2?c2:c1
        c.lineWidth = 2
        c.beginPath()
        c.translate(p.x, p.y)
        c.rotate(angle*Math.PI/180);
        c.arc(0,0, r, 0.5*Math.PI, 1.5*Math.PI);

        c.moveTo(0,-r)
        c.lineTo(len,-r);
        c.arc(len,0, r, 1.5*Math.PI, 0.5*Math.PI);
        c.moveTo(len,r)
        c.lineTo(len/4*3,len/8);
        c.lineTo(len/3,len/8);
        c.lineTo(0,r);


        c.stroke();
        c.restore();

    }
    function draw3(c, p, len, angle)
    {
        var s1=len*15/95
        var s2=len*10/95
        var s3=len*20/95
        var s4=len*8/95
        var s5=len*23/95
        var s6=len*16/95
        c.save();
        c.strokeStyle = select&4?c2:c1
        c.lineWidth = 2
        c.beginPath()
        c.translate(p.x, p.y)
        c.rotate(angle*Math.PI/180);
        c.arc(-s1,-s2, r, 0.5*Math.PI, 1.5*Math.PI);
        c.lineTo(s3,-s4);
        c.lineTo(len,-r);
        c.arc(len,0, r, 1.5*Math.PI, 0.5*Math.PI);
        c.moveTo(len,r)
        c.lineTo(s5,s6);
        c.lineTo(-s1,-s2+r);


        c.stroke();
        c.restore();
    }
    function draw4(c, p, len, angle)
    {
        var dd=90
        var s1=len*10/dd
        var s2=len*5/dd //смещение оси детали вниз.
        var s3=len*15/dd
        var s4=len*15/dd

        var s5=len*20/dd  //длина циллиндра
        var s6=len*30/dd  //Высота циллиндра

        var ss=s6/2+s2 //ось вращения детали
        var s7=len*25/dd //Большая Высота конуса
        var s8=len*8/dd  //Ширина конуса
        var s9=len*25/dd //Меньшая Высота конуса и сторона квадрата

        c.save();
        c.strokeStyle = select&8?c2:c1
        c.lineWidth = 2
        c.beginPath()
        c.translate(p.x, p.y)
        c.rotate(angle*Math.PI/180);
        c.arc(0,0, r, 0.4*Math.PI, 1.5*Math.PI);
        c.moveTo(s1+r, s2)
        c.arc(s1, s2, r, 0*Math.PI, 0.5*Math.PI);
        c.lineTo(0,r);
        c.moveTo(0, -r)
        c.lineTo(r,-r);
        c.lineTo(r,-s3);
        c.lineTo(s4,-s3);
        c.strokeRect(s4, -s6+s2,s5, s6);
        c.strokeRect(s4+s5+r/2, -s6+s2,s5, s6);
        c.strokeRect(s4+s5+r/2+s8+s5, s2-s9-(s6-s9)/2, s9, s9);
        c.moveTo(s4+s5+r/2+s5, -s6+s2)
        c.lineTo(s4+s5+r/2+s8+s5,s2-s9-(s6-s9)/2);
        c.moveTo(s4+s5+r/2+s5, s2)
        c.lineTo(s4+s5+r/2+s8+s5,s2-(s6-s9)/2);


        c.stroke();
        c.restore();
    }
    function draw5(c, p, len, angle, angle0)
    {
        var s1=len/4
        var s2=len/5
        var s3=len/10 //толщина губки


        c.save();
        c.strokeStyle = select&16?c2:c1
        c.lineWidth = 1
        c.beginPath()
        c.translate(p.x, p.y)
        c.rotate(angle*Math.PI/180);
        c.arc(0,0, r, 0.5*Math.PI, 1.5*Math.PI);
        c.moveTo(len, -r)
        c.arc(len, 0, r, -0.5*Math.PI, 0.5*Math.PI);
        c.moveTo(len, -r)
        c.lineTo(0,-r)
        c.moveTo(0, r)
        c.lineTo(s1,s2)
        c.lineTo(s1+s1+s1,s2)
        c.lineTo(len,r)
        c.moveTo(s1,-r-s3)
        c.strokeRect(s1,-r-s3,len-s1+r,s3);
        c.stroke()
        c.restore()

        c.save();
        c.strokeStyle = select&16?c2:c1
        c.lineWidth = 1
        c.beginPath()

        c.translate(p.x,p.y)

        c.rotate(angle0*Math.PI/180);
        c.translate(0,-2*(r+s3))
        //c.rotate((angle0)*Math.PI/180);
        c.rotate((angle0-angle)*Math.PI/180);
        c.moveTo(0,r)
        c.arc(0,0, r, 0.5*Math.PI, 1.5*Math.PI);
        c.moveTo(len, -r)
        c.arc(len, 0, r, -0.5*Math.PI, 0.5*Math.PI);
        //c.rotate(-angle*Math.PI/180);
        c.moveTo(0,r)
        c.lineTo(len,r)

        c.moveTo(0,-r)
        c.lineTo(s1,-s2)
        c.lineTo(len-s1,-s2)
        c.lineTo(len,-r)


        c.moveTo(s1,r)
        c.strokeRect(s1,r,len-s1+r,s3);

        c.stroke();
        c.restore();
    }

    function el(c, p, len, angle, draw, index, angle0)
    {
        var  s9=len
        var s10=0
        var s=select&index?1:0
        //console.log("index="+index+" angle0="+angle0+" angle="+angle+ "res:"+select&index)
        c.save();
        c.strokeStyle = select&index?c4:c3
        c.lineWidth = 2
        c.beginPath()
        c.translate(p.x, p.y)
        angle=angle+tim.i*s*(angle>0?1:-1)
        //console.log("ind:"+index+" select:"+select+ "res:"+s)
        c.rotate(angle*Math.PI/180);
        c.moveTo(r/2,0);
        c.arc(0,0, r/2, 0, Math.PI*2)
        c.moveTo(s9+r/2,s10);
        c.arc(s9,s10, r/2, 0, Math.PI*2)
        c.moveTo(0,0);
        c.lineTo(s9,s10);
        c.stroke();
        c.restore();
        draw(c, p, len, angle, angle0);
        var xx=p.x+len*Math.cos((-angle)*Math.PI/180)
        var yy=p.y-len*Math.sin((-angle)*Math.PI/180)
        return xx.toString()+","+yy.toString();
    }
    Timer {
        id: tim
        property int i:0
        interval: 100
        running:false
        repeat: true
        onTriggered: {i+=1; i=i>2?-2:i; canvas.requestPaint()}
    }

    Rectangle {
        id: rask
        height: 20
        width: 30
        border.color: "white"
        border.width: 2
        radius: 10
        color: pos_rask?"green":"transparent"
        x: 20
        y: parent.height/2-80
        Text {
            anchors.left: parent.right
            anchors.leftMargin: 5
            anchors.horizontalCenter: parent.horizontalCenter
            text: "Раск."
            font.pointSize: 12
            color: "white"
        }

    }

    GArrow {
        id: a6up
        anchors.margins: 30
        anchors.left: parent.left
        angle: 180
        height: hand.height*7/90
        width: hand.height*7/90
        y: p0.y-height-3
        positive: true
    }
    GArrow {
        id: a6down
        anchors.margins: 30
        anchors.left: parent.left
        angle: 0
        height: hand.height*7/90
        width: hand.height*7/90
        y: p0.y+3
        positive: false
    }
    GArrow {
        id: a7left
        angle: 90
        height: hand.height*7/90
        width: hand.height*7/90
        y: p0.y+2*height
        x: p0.x-width-3
        positive: false
    }
    Rectangle {
        id: home
        height: 20
        width: 30
        border.color: "white"
        border.width: 2
        radius: 10
        color: pos_home?"green":"transparent"
        x: 20
        y: parent.height/2+40
        Text {
            anchors.left: parent.right
            anchors.leftMargin: 5
            anchors.horizontalCenter: parent.horizontalCenter
            text: "Фикс."
            font.pointSize: 12
            color: "white"
        }

    }

    GArrow {
        id: a7right
        angle: -90
        height: hand.height*7/90
        width: hand.height*7/90
        y: p0.y+2*height
        x: p0.x+3
        positive: true
    }
    GArrow {
        id: a5left
        angle: 90
        height: hand.height*7/90
        width: hand.height*7/90
        y: p1.y-4*height
        x: p1.x-width-3
        positive: false
    }
    GArrow {
        id: a5right
        angle: -90
        height: hand.height*7/90
        width: hand.height*7/90
        y: p1.y-4*height
        x: p1.x+3
        positive: true
    }
    GArrow {
        id: a4left
        angle: 90
        height: hand.height*7/90
        width: hand.height*7/90
        y: p2.y+3*height
        x: p2.x-width-3
        positive: false
    }
    GArrow {
        id: a4right
        angle: -90
        height: hand.height*7/90
        width: hand.height*7/90
        y: p2.y+3*height
        x: p2.x+3
        positive: true
    }
    GArrow {
        id: a3right
        angle: -90
        height: hand.height*7/90
        width: hand.height*7/90
        y: p3.y-4*height
        x: p3.x+3
        positive: true
    }
    GArrow {
        id: a3left
        angle: 90
        height: hand.height*7/90
        width: hand.height*7/90
        y: p3.y-4*height
        x: p3.x-width-3
        positive: false
    }
    GArrow {
        id: a2up
        angle: 180
        height: hand.height*7/90
        width: hand.height*7/90
        y: p4.y-height-3
        x: p4.x+width*2
        positive: true
    }
    GArrow {
        id: a2down
        angle: 0
        height: hand.height*7/90
        width: hand.height*7/90
        y: p4.y+3
        x: p4.x+width*2
        positive: false
    }
    GArrow {
        id: a1right
        angle: -90
        height: hand.height*7/90
        width: hand.height*7/90
        y: p4.y-l4*0.4-height
        x: p4.x-width/2
        positive: true
    }
    GArrow {
        id: a1left
        angle: 90
        height: hand.height*7/90
        width: hand.height*7/90
        y: p4.y+l4*0.4
        x: p4.x-width/2
        positive: false
    }

    Canvas {
        id: canvas

        width: parent.width
        height: parent.height

        onPaint: {
            var ctx = getContext('2d')
            ctx.save()
            ctx.clearRect(0, 0, width, height)
            ctx.strokeStyle = "white"

            ctx.beginPath()
            var th=20
            //p0="100,200"
            //p0.y=hy

            p1=el(ctx,p0, l1, a1, draw1, 1)
            //console.log(p1);
            p2=el(ctx, p1, l2, a1+a2, draw2, 2)
            p3=el(ctx, p2, l3, a1+a2+a3, draw3, 4 )
            p4=el(ctx, p3, l4, a1+a2+a3+a4, draw4, 8)
            p5=el(ctx, p4, l5, a1+a2+a3+a4+a5, draw5, 16,a1+a2+a3+a4)
            Fig.line(ctx,p0.x, p0.y,10,p0.y, 2);
            Fig.text_m(ctx,5,p0.y,th,"6", "left", "bottom", Qt.rgba(0.8, 0.8, 1.0, 0.5))
            Fig.line(ctx,p0.x, p0.y,p0.x,(p0.y+height)/2.1, 2);
            Fig.text_m(ctx,p0.x,(p0.y+height)/2.1,th,"7", "left", "top", Qt.rgba(0.8, 0.8, 1.0, 0.5))
            Fig.line(ctx,p1.x, p1.y,p1.x,(p1.y-height/3), 2);
            Fig.text_m(ctx,p1.x,(p1.y-height/3),th,"5", "left", "bottom", Qt.rgba(0.8, 0.8, 1.0, 0.5))
            Fig.line(ctx,p2.x, p2.y,p2.x,(p2.y+height/3), 2);
            Fig.text_m(ctx,p2.x,(p2.y+height/3),th,"4", "left", "top", Qt.rgba(0.8, 0.8, 1.0, 0.5))
            Fig.line(ctx,p3.x, p3.y,p3.x,(p3.y-height/3), 2);
            Fig.text_m(ctx,p3.x,(p3.y-height/3),th,"3", "left", "bottom", Qt.rgba(0.8, 0.8, 1.0, 0.5))
            Fig.line(ctx,p4.x, p4.y,p4.x+width/4,p4.y, 2);
            Fig.text_m(ctx,p4.x+width/4,p4.y,th,"2", "left", "bottom", Qt.rgba(0.8, 0.8, 1.0, 0.5))
            var rr=l4*0.8
            Fig.circle(ctx, p4.x,p4.y,rr,Qt.rgba(1, 1, 1.0, 0.0))
            Fig.line(ctx,p4.x, p4.y+rr,p4.x,p4.y+rr+l5, 2);
            Fig.text_m(ctx,p4.x,p4.y+rr+l5,th,"1", "left", "top", Qt.rgba(0.8, 0.8, 1.0, 0.5))
            ctx.restore()
            //ctx.closePath();
        }
    }
}
