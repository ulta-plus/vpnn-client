#ifndef _VPNNARUZHU_DOWNLOAD_CONTROLLER_H
#define _VPNNARUZHU_DOWNLOAD_CONTROLLER_H

#include <QObject>
#include <QThread>

#include "downloader.h"

class VpnnDownloadController: public QObject
{
    Q_OBJECT
    Q_PROPERTY(qreal progress READ getProgress NOTIFY progressChanged)
    Q_PROPERTY(qreal inProgress READ isDownloadInProgress NOTIFY inProgressChanged)

public:
    explicit VpnnDownloadController(QSharedPointer<VpnNaruzhuDownloader> &d,
        QObject* parent = nullptr)
            : QObject(parent), vpnn_downloader(d)
    {
        connect(this, &VpnnDownloadController::startDownload,
            vpnn_downloader.get(), &VpnNaruzhuDownloader::download);
        connect(vpnn_downloader.get(), &VpnNaruzhuDownloader::progressChanged,
            this, &VpnnDownloadController::onProgressChanged);
        connect(vpnn_downloader.get(), &VpnNaruzhuDownloader::errorOccurred,
            this, &VpnnDownloadController::onErrorOccurred);
        connect(vpnn_downloader.get(), &VpnNaruzhuDownloader::finished,
            this, &VpnnDownloadController::onFinished);

        vpnn_downloader->moveToThread(&vpnn_downloaderThread);
        vpnn_downloaderThread.start();
    }

    ~VpnnDownloadController()
    {
        vpnn_downloaderThread.quit();
        vpnn_downloaderThread.wait();
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
    void errorOccurred(void);
    void finished(void);

public slots:
    Q_INVOKABLE bool isDownloadInProgress() { return in_progress; }

    void onProgressChanged(qreal p) {
        m_progress = p;
        emit progressChanged(p);
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

    QSharedPointer<VpnNaruzhuDownloader> vpnn_downloader;
    QThread vpnn_downloaderThread;
};

#endif /* _VPNNARUZHU_DOWNLOAD_CONTROLLER_H */