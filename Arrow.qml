import QtQuick 2.5

Item {
    id: a
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

    //Component.onCompleted: canvas.requestPaint()
    onStateChanged: canvas.requestPaint()

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


    function line(c, x1,y1,x2,y2)
    {
        c.save();
        c.strokeStyle = Qt.rgba(1.0, 1.0, 1.0, 0.5)
        c.lineWidth = 3
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
            var shift_y = 30
            var shift_x = 20
            line(ctx,width*0.8-shift_x, height/2-shift_y, width*0.8-shift_x, height-shift_y )
            if (a.state==="DOWN") {
              line(ctx,width*0.7-shift_x, height*0.8-shift_y, width*0.8-shift_x, height-shift_y )
              line(ctx,width*0.9-shift_x, height*0.8-shift_y, width*0.8-shift_x, height-shift_y )
            }
            if (a.state==="UP") {
              line(ctx,width*0.7-shift_x, height*0.7-shift_y, width*0.8-shift_x, height/2-shift_y )
              line(ctx,width*0.9-shift_x, height*0.7-shift_y, width*0.8-shift_x, height/2-shift_y )
            }
            //ctx.stroke()
            //ctx.closePath();
        }
    }
}
