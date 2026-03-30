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

    ~VpnNaruzhuDownloader()
    {
        delete m_manager;
    }

public slots:
    Q_INVOKABLE void download(const QString &url, const QString &savePath);
    Q_INVOKABLE bool inProgress() { return in_progress; }
    Q_INVOKABLE qreal getProgress() const { return m_progress; }

signals:
    void progressChanged(qreal p);
    void errorOccurred(void);
    void finished(void);

private:
    QNetworkAccessManager* m_manager = nullptr;
    qreal m_progress = 0.0;
    bool in_progress = false;

    const quint64 TIMEOUT = 10000; // milliseconds
};

#endif /* _VPNNARUZHU_DOWNLOADER_H */