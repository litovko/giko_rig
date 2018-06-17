import QtQuick 2.5

Item {
    property real roll: 20 //крен
    property real pitch: 0 //тангаж

//    Timer {
//            interval: 1000; running: true; repeat: true
//            onTriggered: { roll = roll+1;
//                if (roll>100) roll=-100
//                canvas.requestPaint()
//                pitch=pitch+0.5; if (pitch>90) pitch=-90
//            }
//    }
    onRollChanged: canvas.requestPaint()
    onPitchChanged: canvas.requestPaint()
    function rollline(c, angle)
    {
        var r=10
        c.save();
        c.strokeStyle = Qt.rgba(0.5, 0.5, 1.0, 0.8)
        c.lineWidth = 2
        c.beginPath()
        c.translate(width/2, height/2)
        c.rotate(angle*Math.PI/180);
        c.arc(0,0, r, 0, Math.PI)
        c.moveTo(r/2,0)
        c.arc(0,0, r/2, 0, Math.PI*2)
        c.moveTo(-width/2,0);
        c.lineTo(-r,0);
        c.moveTo(0+r,0)
        c.lineTo(width/2,0);
        //c.rotate(angle*Math.PI/180);
        c.stroke();
        c.restore();
    }
    function riski(c)
    {
        var r=25
        var step=30
        c.save();
        c.strokeStyle = Qt.rgba(0.5, 0.5, 1.0, 0.8)
        c.lineWidth = 1
        c.beginPath()
        c.translate(width/2, height/2)
        var b=true;
        for ( var a=step/2; a<180; a=a+step/2) {
            c.rotate(step/2*Math.PI/180);
            c.moveTo(r*2,0)
            c.lineTo(b?r*2.5:r*3,0);

            b=!b;
            c.stroke();
            if (b) text_a(c,r*3.5,0,15,270, ' '+(a>90?-a+180:a)+'\u00B0',"center", "middle",Qt.rgba(0.5, 0.5, 1.0, 0.8))
        }

        c.restore();
    }

    function hline(c,angle, rad)
    {
        c.save();
        c.strokeStyle = Qt.rgba(1.0, 1.0, 1.0, 0.5)
        c.beginPath()
        c.moveTo(0,height/2);
        c.lineTo(width/2-rad,height/2);
        c.moveTo(width/2+rad,height/2);
        c.lineTo(width,height/2);
        c.stroke();
        c.restore();
    }
    function horizont(c,angle, rad)
    {
        var m=angle*(height-15)/2/60;
        c.save();
        c.lineWidth = 5
        c.strokeStyle = Qt.rgba(0.0, 1.0, 0, 0.8)
        c.beginPath()
        c.translate(width/2, height/2)
        c.moveTo(-rad,m);
        c.lineTo(-width/2,m);
        c.moveTo(width/2,m);
        c.lineTo(rad,m);
        //c.closePath();

        c.stroke();
        c.restore();
    }
    function setka(c)
    {
        var otstup=20
        var tick_grad=20
        var height_grad=60
        var font_size=15
        var tick_size=(height-font_size)/2/height_grad
        var st=Qt.rgba(0.0, 1.0, 0.0, 0.8)
        c.save();
        c.strokeStyle = st
        c.beginPath()
        c.moveTo(otstup,0);
        for (var i=tick_grad; i<=height_grad; i=i+tick_grad)
          {
            var yy=height/2+i*tick_size
            c.moveTo(otstup,yy); c.lineTo(otstup*2,yy)
            c.moveTo(otstup*1.5,yy-tick_size/2*tick_grad); c.lineTo(otstup*2,yy-tick_size/2*tick_grad)
            c.moveTo(width-otstup*2,yy); c.lineTo(width-otstup,yy)
            c.moveTo(width-otstup*2,yy-tick_size/2*tick_grad); c.lineTo(width-otstup*1.5,yy-tick_size/2*tick_grad)
            c.stroke()
            text_m(c,otstup,yy,font_size,i,"right", "middle",st)
            text_m(c,width-otstup,yy,font_size,i,"left", "middle",st)
          }
        for (var i=tick_grad; i<=height_grad; i=i+tick_grad)
        {
          var yy=height/2-i*tick_size
          c.moveTo(otstup,yy); c.lineTo(otstup*2,yy)
          c.moveTo(otstup*1.5,yy+tick_size/2*tick_grad); c.lineTo(otstup*2,yy+tick_size/2*tick_grad)
          c.moveTo(width-otstup*2,yy); c.lineTo(width-otstup,yy)
            c.moveTo(width-otstup*2,yy+tick_size/2*tick_grad); c.lineTo(width-otstup*1.5,yy+tick_size/2*tick_grad)
          c.stroke()
          text_m(c,otstup,yy,font_size,i,"right", "middle",st)
          text_m(c,width-otstup,yy,font_size,i,"left", "middle",st)
        }
        //c.stroke();
        c.restore();
    }

    function line(c, x1,y1,x2,y2)
    {
        c.save();
        c.strokeStyle = Qt.rgba(1.0, 1.0, 1.0, 0.5)
        c.lineWidth = 1
        c.beginPath()
        c.lineCap="butt"
        c.moveTo(x1,y1);
        c.lineTo(x2,y2);
        c.stroke();
        c.restore();
    }
    function text_m(c,x,y,h,v, ta, bl, col){
        c.save();
        var f=h+"px Arial"
        c.fillStyle=col
        c.textAlign=ta; ; c.textBaseline=bl;
        c.lineWidth = 1
        c.font = f;
        c.beginPath()
        c.fillText(v, x, y)
        c.strokeText();
        c.restore();
    }
    function text_a(c,x,y,h,a,v, ta, bl, col){ //a=angle
        c.save();
        var f=h+"px Arial"
        c.fillStyle=col
        c.textAlign=ta; ; c.textBaseline=bl;
        c.lineWidth = 1
        c.translate(x,y)
        c.font = f;
        c.rotate(a*Math.PI/180);
        c.beginPath()
        c.fillText(v, 0, 0)

        c.strokeText();
        c.restore();
    }
    function text_f(c,x,y,h,v, ta, bl, col){ //framed text
        c.save();
        var f=h+"px Arial"
        c.fillStyle=col
        c.strokeStyle = col
        c.textAlign=ta; ; c.textBaseline=bl;
        c.lineWidth = 1
        c.font = f;
        var wt=2.0*h
        //console.log("wt:"+wt + metr.height)
        c.beginPath()
        c.fillText(v, x, y)
        c.moveTo(x-wt/2,y-h)
        c.strokeRect(x-wt/2,y-(h+6)/2,wt,h)
        c.stroke();
        c.restore();
    }

    Canvas {
        id: canvas

        width: parent.width
        height: parent.height

        onPaint: {
            var ctx = getContext('2d')
            ctx.clearRect(0, 0, width, height)
            //ctx.strokeStyle = "lightyellow"
            ctx.lineWidth =2
//            ctx.strokeStyle = "#cf0";
//            ctx.fillStyle="#cf0"
            ctx.beginPath()



            riski(ctx)
            hline(ctx,roll, width/6)
            rollline(ctx, roll)
            horizont(ctx, pitch, 100)
            text_f(ctx,width/2,height-30,30,Math.round(pitch),"center", "middle",Qt.rgba(0.0, 1.0, 0.0, 0.8))
            text_f(ctx,width/2,height/2-100,30,roll,"center", "middle",Qt.rgba(0.5, 0.5, 1.0, 0.8))

            setka(ctx)

            //ctx.stroke()
            //ctx.closePath();
        }
    }
}
