.pragma library
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
function line(c, x1,y1,x2,y2, lw)
{
    c.save();
    c.strokeStyle = Qt.rgba(1.0, 1.0, 1.0, 0.5)
    c.lineWidth = typeof lw !== 'undefined' ? lw : 5;
    c.beginPath()
    c.lineCap="butt"
    c.moveTo(x1,y1);
    c.lineTo(x2,y2);
    c.stroke();
    c.restore();
}
function circle(c, x, y, r, s)
{
    c.save();
    c.fillStyle=s
    c.beginPath()
    c.arc(x, y, r, 0 ,Math.PI*2)
    c.closePath()
    c.fill()
    c.stroke()
    c.restore()
}

function draw1(c, p, len, angle)
{
    angle=angle-60;
    var r=1
    var d=10
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
    c.strokeStyle = Qt.rgba(0.5, 0.5, 1.0, 0.8)
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
function arrow(c, x, y, len, angle, fillstyle)
{


    var s8=len/8 // выступ угла скобы
    var s9=(len)/2   // смещение центра отверстия по Х -  угол наклона оси 30 градусов
    var s10=len*Math.sqrt(3)/2   // смещение центра отверстия по Y
    c.save()
    c.beginPath()
    c.fillStyle = fillstyle
    c.lineWidth = 1
    c.translate(x, y)
    c.rotate(angle*Math.PI/180);
    var lx=Math.sin(Math.PI/3)*len
    var ly=Math.cos(Math.PI/3)*len
    c.moveTo(0,-len)
    c.lineTo(lx,ly);
    c.lineTo(-lx,ly)
    c.lineTo(0,-len);
    c.closePath()
    c.fill()
    c.stroke();
    c.restore();

}

