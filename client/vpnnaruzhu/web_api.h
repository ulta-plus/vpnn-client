#ifndef _VPNNARUZHU_WEB_API_H
#define _VPNNARUZHU_WEB_API_H

#include <QObject>
#include <QString>
#include <QQmlContext>
#include <QJsonObject>
#include <QNetworkReply>
#include <QQmlApplicationEngine>

#include "version.h"
#include "settings.h"
#include "ui/models/servers_model.h"
#include "ui/controllers/importController.h"

class VpnNaruzhuWebApi: public QObject
{
    Q_OBJECT

public:
    VpnNaruzhuWebApi(const std::shared_ptr<Settings> &s,
        const QSharedPointer<ServersModel> &sm,
        QQmlApplicationEngine* engine)
            : m_settings(s), m_serversModel(sm), m_engine(engine)
    {
        m_importController = (ImportController*)
            m_engine->rootContext()->objectForName("ImportController");
    }

    QJsonDocument getDefaultAccountStatus(void) const;
    QString getDefaultAccountConfig(void) const;

public slots:
    void updateDefaultAccountStatus(void) const;
    void updateDefaultAccountConfig(void) const;

private:
    VpnNaruzhuWebApi();

    std::shared_ptr<Settings> m_settings;
    QSharedPointer<ServersModel> m_serversModel;
    QQmlApplicationEngine* m_engine;
    ImportController* m_importController;

    const QString user_agent = "naruzhu-desktop/" APP_VERSION;

    QString getApiBaseUrl(void) const
    {
        return m_settings->apiBaseUrl();
    }

    QString getPublicRequestId(void) const
    {
        auto defAccount = m_serversModel->getDefaultAccount();
        return defAccount.value(config_key::public_request_id).toString();
    }

    void initRequest(QNetworkRequest &request, const QString &url) const;
    QNetworkReply* replyGetRequest(const QNetworkRequest &request) const;
};

#endif /* _VPNNARUZHU_WEB_API_H */
