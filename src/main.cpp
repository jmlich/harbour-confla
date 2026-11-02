
#ifdef MER_EDITION_SAILFISH
#include <sailfishapp.h>
#else
#include <QQmlApplicationEngine>
#include <QQuickWindow>
#endif
#include <QQuickView>
#include <QApplication>
#include <QtQml>
#include <QDesktopWidget>
#include "filereader.h"
#include "networkaccessmanagerfactory.h"
#include "downloader.h"

int main(int argc, char *argv[])
{
    QApplication app(argc, argv);
#ifdef UUITK_EDITION
    // a confined click may write only to the directories named after its id
    app.setOrganizationName("com.github.jmlich.harbour-confla");
    app.setApplicationName("com.github.jmlich.harbour-confla");
#else
    app.setOrganizationName("harbour-confla");
    app.setApplicationName("harbour-confla");
#endif
    app.setApplicationVersion(GIT_VERSION);
    qDebug() << "Starting build" << GIT_VERSION << "Qt" << qVersion();


    QString tr_path(TRANSLATION_FOLDER);
    if ( !tr_path.isEmpty() ) {
        QString locale = QLocale::system().name();
        QTranslator *translator = new QTranslator();
        // the build directory has the .qm files too, so the app also runs without installing
        QString build_path = QCoreApplication::applicationDirPath();

        if ( !translator->load(QLocale(), "harbour-confla", "-", tr_path) &&
             !translator->load(QLocale(), "harbour-confla", "-", build_path) ) {
            if ( !translator->load("en_US", "harbour-confla", "-", tr_path) ) {
                qWarning() << "Cannot load translations for " << locale << " " << tr_path;
            }
        }

        app.installTranslator(translator);
    }

    NetworkAccessManagerFactory namFactory;

    qmlRegisterType<FileReader>("cz.mlich", 1, 0, "FileReader");
    qmlRegisterType<Downloader>("cz.mlich", 1, 0, "Downloader");

#ifdef MER_EDITION_SAILFISH
    QQuickView *engine = SailfishApp::createView();
    engine->engine()->setNetworkAccessManagerFactory(&namFactory);
#else
    QQmlApplicationEngine *engine = new QQmlApplicationEngine();
    engine->setNetworkAccessManagerFactory(&namFactory);
#endif

    engine->rootContext()->setContextProperty("IMAGE_CACHE_FOLDER", "file://" +QStandardPaths::writableLocation(QStandardPaths::DataLocation) );

    engine->rootContext()->setContextProperty("dpix", app.desktop()->logicalDpiX());
    engine->rootContext()->setContextProperty("dpiy", app.desktop()->logicalDpiY());
#ifdef MER_EDITION_SAILFISH
    engine->setSource(QUrl("qrc:/qml/main.qml"));
    engine->show();
#else
    engine->load(QUrl("qrc:/qml/main.qml"));
#endif
    return app.exec();
}
