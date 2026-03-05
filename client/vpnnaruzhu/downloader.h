#ifndef _VPNNARUZHU_DOWNLOADER_H
#define _VPNNARUZHU_DOWNLOADER_H

#include <QObject>
#include <QFile>
#include <QNetworkAccessManager>

class VpnNaruzhuDownloader: public QObject
{
    Q_OBJECT
    Q_PROPERTY(qreal progress READ getProgress NOTIFY progressChanged)

public:
    explicit VpnNaruzhuDownloader() {}
    Q_INVOKABLE void download(const QString &url, QFile &file);
    qreal getProgress() const { return m_progress; }

public slots:
    bool inProgress() { return in_progress; }
signals:
    void progressChanged();
    void errorOccurred(QString error);
    void finished();

private:
    QNetworkAccessManager m_manager;
    qreal m_progress = 0.0;
    bool in_progress = false;

    const quint64 TIMEOUT = 10000; // milliseconds
};

#endif /* _VPNNARUZHU_DOWNLOADER_H */