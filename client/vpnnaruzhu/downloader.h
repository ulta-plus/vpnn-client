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
    explicit VpnNaruzhuDownloader(QObject* parent = nullptr) : QObject(parent)
    {
        m_manager = new QNetworkAccessManager(this);
    }

public slots:
    Q_INVOKABLE void download(const QString &url, const QString &savePath);
    Q_INVOKABLE bool inProgress() { return in_progress; }
    Q_INVOKABLE qreal getProgress() const { return m_progress; }
    void shutdown();

signals:
    void progressChanged(qreal p);
    void fileErrorOccurred(void);
    void errorOccurred(void);
    void finished(void);

private:
    QNetworkAccessManager* m_manager = nullptr;
    QNetworkReply* m_reply = nullptr;
    qreal m_progress = 0.0;
    bool in_progress = false;
    bool shutting_down = false;

    const quint64 TIMEOUT = 10000; // milliseconds
};

#endif /* _VPNNARUZHU_DOWNLOADER_H */
