#include "customnetworkaccessmanager.h"

CustomNetworkAccessManager::CustomNetworkAccessManager(QObject *parent) : QNetworkAccessManager(parent)
{
    m_userAgent = QString("harbour-confla/%1 Qt/%2").arg(GIT_VERSION).arg(qVersion());
}
