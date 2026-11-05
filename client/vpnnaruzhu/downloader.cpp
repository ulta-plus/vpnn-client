#include "downloader.h"

#include <QByteArray>
#include <QDebug>
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
        in_progress = false;
        m_progress = 0.0;
        emit errorOccurred();
        return;
    }

    QNetworkRequest request;
    request.setTransferTimeout(TIMEOUT);
    request.setUrl(url);

    QNetworkReply *reply = m_manager->get(request);
    bool write_failed = false;

    connect(reply, &QNetworkReply::readyRead, this, [&]() {
        const QByteArray data = reply->readAll();
        if (file.write(data) != data.size()) {
            write_failed = true;
            reply->abort();
        }
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

        if (write_failed || reply->error() != QNetworkReply::NoError) {
            QString error = reply->errorString();
            qDebug() << "download(): " << error;
            in_progress = false;
            m_progress = 0.0;
            emit errorOccurred();
        } else {
            in_progress = false;
            m_progress = 0.0;
            emit finished();
        }

        reply->deleteLater();
    });

    QEventLoop wait;
    QObject::connect(reply, &QNetworkReply::finished, &wait, &QEventLoop::quit);
    wait.exec();
}
