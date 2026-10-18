#include "customnetworkaccessmanager.h"

CustomNetworkAccessManager::CustomNetworkAccessManager(QObject *parent) : QNetworkAccessManager(parent)
{
    m_userAgent = "harbour-confla/0.2 Qt/" QT_VERSION_STR;
}
