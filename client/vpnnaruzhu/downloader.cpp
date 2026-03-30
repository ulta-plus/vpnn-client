#include "downloader.h"

#include <QFile>
#include <QEventLoop>
#include <QNetworkReply>
#include <QThread>

void VpnNaruzhuDownloader::download(const QString &url, const QString &savePath)
{
    in_progress = true;
    QFile file(savePath);
    if (!file.open(QIODevice::WriteOnly)) {
        qDebug() << "Cannot open file for writing " << file.fileName();
        return;
    }

    QNetworkRequest request;
    request.setTransferTimeout(TIMEOUT);
    request.setUrl(url);

    QNetworkReply *reply = m_manager->get(request);

    connect(reply, &QNetworkReply::readyRead, this, [&]() {
        file.write(reply->readAll());
    });

    connect(reply, &QNetworkReply::downloadProgress,
            this, [this](qint64 received, qint64 total) {

        if (total > 0) {
            m_progress = qreal(received) / total;
            emit progressChanged(m_progress);
        }
    });

    connect(reply, &QNetworkReply::finished, this, [&]() {
        file.close();

        if (reply->error() != QNetworkReply::NoError) {
            QString error = reply->errorString();
            qDebug() << "download(): " << error;
            emit errorOccurred();
        } else {
            emit finished();
        }

        reply->deleteLater();
        in_progress = false;
        m_progress = 0.0;
    });

    QEventLoop wait;
    QObject::connect(reply, &QNetworkReply::finished, &wait, &QEventLoop::quit);
    wait.exec();
}