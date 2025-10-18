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

    // Return AWG Key
    QString getDefaultAccountConfig(bool force_update_device = false) const;
    // Return Account Status for the Account with public_request_id
    QJsonDocument getAccountStatus(QString public_request_id) const;
    // Return Account Status: blocked/active etc
    QJsonDocument getDefaultAccountStatus(void) const;
    // Download JSON file from URL
    QJsonDocument downloadJsonFile(const QString &url) const;

signals:
    void keyLimitExceeded(void) const;
    void defaultAccountStatusUpdated(void) const;

public slots:
    // Return Account Status for the Account with public_request_id
    QString getAccountStatusStr(QString public_request_id) const;
    /* Currently Sotka doesn't support smart routing and update ApiBase URL
    void updateApiBaseUrl(void) const;
    void updateSmartRouting(void) const;
    */
    bool updateDefaultAccountStatus(void) const;
    bool updateDefaultAccountConfig(bool force_update_device = false) const;

    QString getApiBaseUrl(void) const
    {
        return m_settings->getApiBaseUrl();
    }

    QString getUserAgent(void) const
    {
        return user_agent;
    }

    QString getUserAgent(void) const { return user_agent; }
    QString getAwgVersion(void) const { return awg_version; }

private:
    SotkaWebApi();

    std::shared_ptr<Settings> m_settings;
    QSharedPointer<ServersModel> m_serversModel;
    QSharedPointer<VpnConnection> m_vpnConnection;
    QQmlApplicationEngine* m_engine;
    ImportController* m_importController;

    const QString awg_version = "1.5";
    const QString user_agent = "sotka-desktop/" APP_VERSION;
    /* Currently Sotka doesn't support smart routing
    const QString amnezia_config_url =
        "https://raw.githubusercontent.com/ulta-plus/public/refs/heads/main/naruzhu/amnezia/config.json";
    const QString smart_routs_url =
        "https://storage.googleapis.com/naruzhu/amnezia/local.json";
    */

    QString getDefaultPublicRequestId(void) const
    {
        auto defAccount = m_serversModel->getDefaultAccount();
        return defAccount.value(config_key::public_request_id).toString();
    }

    void initRequest(QNetworkRequest &request, const QString &url) const;
    QNetworkReply* replyGetRequest(const QNetworkRequest &request) const;
};

#endif /* _SOTKA_WEB_API_H */
