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
#include "vpnconnection.h"
#include "connectionMode.h"
#include "ui/models/languageModel.h"
#include "ui/models/servers_model.h"
#include "ui/controllers/importController.h"

class VpnNaruzhuWebApi: public QObject
{
    Q_OBJECT

public:
    VpnNaruzhuWebApi(const std::shared_ptr<Settings> &s,
        const QSharedPointer<ServersModel> &sm,
        const QSharedPointer<VpnConnection> &vpnc,
        QQmlApplicationEngine* engine,
        QSharedPointer<LanguageModel> &lm)
            : m_settings(s), m_serversModel(sm), m_vpnConnection(vpnc),
                m_engine(engine), m_languageModel(lm)
    {
        m_importController = (ImportController*)
            m_engine->rootContext()->objectForName("ImportController");

        connectionMode.reset(new VPNNConnectionMode(s, s->getAppLanguage()));
        m_engine->rootContext()->setContextProperty("VPNNConnectionMode",
            connectionMode.get());
        connect(m_languageModel.get(), &LanguageModel::updateTranslations,
            connectionMode.get(), &VPNNConnectionMode::setLocale);
        updateExternalSettings();
    }

    QJsonDocument getDefaultAccountStatus(void) const;
    QJsonDocument downloadJsonFile(const QString &url) const;
    QJsonDocument getListOfCounties(void) const;

    void downloadFile(const QString &url, QFile &file) const;

public slots:
    void updateExternalSettings(void) const;
    void updateSmartRouting(void) const;
    void updateDefaultAccountStatus(void) const;
    void updateDefaultAccountConfig(void) const;
    void downloadAndInstallNewApp(void) const;

    QString getUserAgent(void) const { return user_agent; }
    QString getAwgVersion(void) const { return awg_version; }
    QString getAppVersion(void) const { return APP_VERSION; }
    QString getDefaultAccountConfig(QString public_request_id = QString()) const;
    QString getSupportLink(void) const { return m_settings->getSupportLink(); }

    bool isNewVersionAvailable(void) const;

private:
    VpnNaruzhuWebApi();

    std::shared_ptr<Settings> m_settings;
    QSharedPointer<ServersModel> m_serversModel;
    QSharedPointer<VpnConnection> m_vpnConnection;
    QQmlApplicationEngine* m_engine;
    ImportController* m_importController;
    QSharedPointer<LanguageModel> m_languageModel;
    QSharedPointer<VPNNConnectionMode> connectionMode;

    const QString awg_version = "1.5";
    const QString user_agent = "naruzhu-desktop/" APP_VERSION;
    const QString amnezia_config_url =
        "https://storage.googleapis.com/naruzhu/amnezia/config.json";
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

    void initSimpleRequest(QNetworkRequest &request, const QString &url) const;
    void initRequest(QNetworkRequest &request, const QString &url,
        bool is_json = true) const;
    QNetworkReply* replyGetRequest(const QNetworkRequest &request) const;

    QString downloadNewApp(void) const;
    void installNewApp(QString &path) const;
};

#endif /* _VPNNARUZHU_WEB_API_H */
