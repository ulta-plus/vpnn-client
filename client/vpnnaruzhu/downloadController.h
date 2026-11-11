#ifndef _VPNNARUZHU_DOWNLOAD_CONTROLLER_H
#define _VPNNARUZHU_DOWNLOAD_CONTROLLER_H

#include <QObject>
#include <QThread>

#include "downloader.h"

class VpnnDownloadController: public QObject
{
    Q_OBJECT
    Q_PROPERTY(qreal progress READ getProgress NOTIFY progressChanged)
    Q_PROPERTY(bool inProgress READ isDownloadInProgress NOTIFY inProgressChanged)

public:
    explicit VpnnDownloadController(QObject* parent = nullptr)
            : QObject(parent), vpnn_downloader(new VpnNaruzhuDownloader)
    {
        connect(this, &VpnnDownloadController::startDownload,
            vpnn_downloader, &VpnNaruzhuDownloader::download);
        connect(vpnn_downloader, &VpnNaruzhuDownloader::progressChanged,
            this, &VpnnDownloadController::onProgressChanged);
        connect(vpnn_downloader, &VpnNaruzhuDownloader::fileErrorOccurred,
            this, &VpnnDownloadController::onFileErrorOccurred);
        connect(vpnn_downloader, &VpnNaruzhuDownloader::errorOccurred,
            this, &VpnnDownloadController::onErrorOccurred);
        connect(vpnn_downloader, &VpnNaruzhuDownloader::finished,
            this, &VpnnDownloadController::onFinished);
        connect(&vpnn_downloaderThread, &QThread::finished,
            vpnn_downloader, &QObject::deleteLater);

        vpnn_downloader->moveToThread(&vpnn_downloaderThread);
        vpnn_downloaderThread.start();
    }

    ~VpnnDownloadController()
    {
        if (vpnn_downloaderThread.isRunning()) {
            QMetaObject::invokeMethod(vpnn_downloader, "shutdown",
                Qt::BlockingQueuedConnection);
        }
        vpnn_downloaderThread.quit();
        vpnn_downloaderThread.wait();
        vpnn_downloader = nullptr;
    }

    Q_INVOKABLE void download(const QString &url, const QString &savePath)
    {
        in_progress = true;
        emit inProgressChanged();
        m_progress = 0.0;
        emit startDownload(url, savePath);
    }

    Q_INVOKABLE qreal getProgress() const { return m_progress; }

signals:
    void startDownload(const QString &url, const QString &savePath);
    void progressChanged(qreal p);
    void inProgressChanged(void);
    void fileErrorOccurred(void);
    void errorOccurred(void);
    void finished(void);

public slots:
    Q_INVOKABLE bool isDownloadInProgress() { return in_progress; }

    void reportError() { onErrorOccurred(); }

    void onProgressChanged(qreal p) {
        m_progress = p;
        emit progressChanged(p);
    }

    void onFileErrorOccurred()
    {
        emit fileErrorOccurred();
        onErrorOccurred();
    }

    void onErrorOccurred()
    {
        in_progress = false;
        emit inProgressChanged();
        m_progress = 0.0;
        emit errorOccurred();
    }

    void onFinished()
    {
        in_progress = false;
        emit inProgressChanged();
        m_progress = 0.0;
        emit finished();
    }

private:
    qreal m_progress = 0.0;
    bool in_progress = false;

    VpnNaruzhuDownloader *vpnn_downloader;
    QThread vpnn_downloaderThread;
};

#endif /* _VPNNARUZHU_DOWNLOAD_CONTROLLER_H */
