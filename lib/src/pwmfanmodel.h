/*
 * <one line to give the library's name and an idea of what it does.>
 * Copyright 2015  Malte Veerman maldela@halloarsch.de
 *
 * This program is free software; you can redistribute it and/or
 * modify it under the terms of the GNU General Public License as
 * published by the Free Software Foundation; either version 2 of
 * the License or (at your option) version 3 or any later version
 * accepted by the membership of KDE e.V. (or its successor approved
 * by the membership of KDE e.V.), which shall act as a proxy
 * defined in Section 14 of version 3 of the license.
 *
 * This program is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 * GNU General Public License for more details.
 *
 * You should have received a copy of the GNU General Public License
 * along with this program.  If not, see <http://www.gnu.org/licenses/>.
 *
 */


#ifndef PWMFANMODEL_H
#define PWMFANMODEL_H


#include <QtCore/QStringListModel>



namespace Fancontrol {


class PwmFan;

class PwmFanModel : public QStringListModel
{
    Q_OBJECT
    Q_PROPERTY(QList<QObject *> fans READ fans NOTIFY fansChanged)
    Q_PROPERTY(int count READ count NOTIFY fansChanged)

public:

    PwmFanModel(QObject *parent = Q_NULLPTR);
    void setPwmFans(const QList<PwmFan *> &fans);
    void addPwmFans(const QList<PwmFan *> &fans);
    QList<QObject *> fans() const;
    int count() const { return m_fans.size(); }


public slots:

    void updateFan(PwmFan *fan);


private slots:

    void updateFan();


signals:

    void fansChanged();


private:

    QList<PwmFan *> m_fans;
};

}


#endif //PWMFANMODEL_H