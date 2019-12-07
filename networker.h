#ifndef NETWORKER_H
#define NETWORKER_H

#include <QObject>
#include <QList>
#include <rigmodel.h>

class networker : public QObject
{
    Q_OBJECT
public:
    explicit networker(QObject *parent = nullptr);

signals:

public slots:
     Q_INVOKABLE void reg(cRigmodel *rig);
private:
    QList<cRigmodel*> m_boards;
};

#endif // NETWORKER_H
