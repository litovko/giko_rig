#include "networker.h"
#include <QDebug>

networker::networker(QObject *parent) : QObject(parent)
{
    qDebug()<<"init networker";
}

void networker::reg(cRigmodel *rig)
{
    m_boards.append(rig);
    qDebug()<<rig->name();
}
