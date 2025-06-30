#ifndef _SOTKA_WEB_API_H
#define _SOTKA_WEB_API_H

#include <QObject>
#include <QString>
#include <QQmlContext>
#include <QJsonObject>
#include <QNetworkReply>
#include <QQmlApplicationEngine>

#include "version.h"
#include "settings.h"
#include "vpnconnection.h"
#include "ui/models/servers_model.h"
#include "ui/controllers/importController.h"

class SotkaWebApi: public QObject
{
    Q_OBJECT

public:
    SotkaWebApi(const std::shared_ptr<Settings> &s,
        const QSharedPointer<ServersModel> &sm,
        const QSharedPointer<VpnConnection> &vpnc,
        QQmlApplicationEngine* engine)
            : m_settings(s), m_serversModel(sm), m_vpnConnection(vpnc),
                m_engine(engine)
    {
        m_importController = (ImportController*)
            m_engine->rootContext()->objectForName("ImportController");
    }

    QString getDefaultAccountConfig(void) const;
    QJsonDocument getDefaultAccountStatus(void) const;
    QJsonDocument downloadJsonFile(const QString &url) const;

public slots:
    void updateApiBaseUrl(void) const;
    void updateSmartRouting(void) const;
    void updateDefaultAccountStatus(void) const;
    void updateDefaultAccountConfig(void) const;

private:
    SotkaWebApi();

    std::shared_ptr<Settings> m_settings;
    QSharedPointer<ServersModel> m_serversModel;
    QSharedPointer<VpnConnection> m_vpnConnection;
    QQmlApplicationEngine* m_engine;
    ImportController* m_importController;

    const QString user_agent = "naruzhu-desktop/" APP_VERSION;
    const QString amnezia_config_url =
        "https://raw.githubusercontent.com/ulta-plus/public/refs/heads/main/naruzhu/amnezia/config.json";
    const QString smart_routs_url =
        "https://storage.googleapis.com/naruzhu/amnezia/local.json";

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

#endif /* _SOTKA_WEB_API_H */
