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

        QFile default_config(":/vpnnaruzhu/default_config.json");
        default_config.open(QIODevice::ReadOnly);
        external_config = QJsonDocument::fromJson(default_config.readAll());
        default_config.close();

        connectionMode.reset(new VPNNConnectionMode(s, s->getAppLanguage()));
        m_engine->rootContext()->setContextProperty("VPNNConnectionMode",
            connectionMode.get());
        connect(m_languageModel.get(), &LanguageModel::updateTranslations,
            connectionMode.get(), &VPNNConnectionMode::setLocale);

        initSettings();
    }

    QJsonDocument getDefaultAccountStatus(void) const;
    QJsonDocument downloadJsonFile(const QString &url) const;
    QJsonDocument getListOfCounties(void) const;

    void downloadFile(const QString &url, QFile &file) const;

signals:
    void defaultAccountStatusUpdated(void) const;

public slots:
    void updateExternalSettings(void);
    void updateSmartRouting(void) const;
    void updateDefaultAccountStatus(void) const;
    void updateDefaultAccountConfig(void) const;
    void downloadAndInstallNewApp(void) const;

    QString getUserAgent(void) const { return user_agent; }
    QString getAwgVersion(void) const { return awg_version; }
    QString getAppVersion(void) const { return APP_VERSION; }
    QString getDefaultAccountConfig(QString public_request_id = QString()) const;
    QString getApiBaseUrl(void) const { return external_config["apiBaseUrl"].toString(); }
    QString getSupportLink(void) const { return external_config["supportLink"].toString(); }
    QString getAboutLink(void) const { return external_config["aboutLink"].toString(); }
    QString getUUIDLastSymbols(void) const;

    bool isNewVersionAvailable(void) const;

private:
    VpnNaruzhuWebApi();

    QJsonDocument external_config;
    void initSettings(void);

    std::shared_ptr<Settings> m_settings;
    QSharedPointer<ServersModel> m_serversModel;
    QSharedPointer<VpnConnection> m_vpnConnection;
    QQmlApplicationEngine* m_engine;
    ImportController* m_importController;
    QSharedPointer<LanguageModel> m_languageModel;
    QSharedPointer<VPNNConnectionMode> connectionMode;

    const QString awg_version = "1.5";
    const QString user_agent = "naruzhu-desktop/" APP_VERSION;
    const QString external_config_urls[3] = {
        "https://raw.githubusercontent.com/ulta-plus/public/refs/heads/main/naruzhu/amnezia/config.json",
        "https://storage.googleapis.com/naruzhu/amnezia/config.json",
        "https://storage.yandexcloud.net/vpnn-web-configs/naruzhu/amnezia/config.json"
    };
    const QString external_config_test_url =
        "https://storage.googleapis.com/naruzhu/amnezia/test-config.json";
    const QString smart_routs_url =
        "https://storage.googleapis.com/naruzhu/amnezia/local.json";
    const QString smart_routs_test_url =
        "https://storage.googleapis.com/naruzhu/amnezia/test-local.json";

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

    QString getSmartRoutesListUrl(void) const;
    QJsonDocument getConfig(void) const;
    QJsonDocument getTestConfig(void) const;
    QJsonDocument getExternalConfig(void) const;
};

#endif /* _VPNNARUZHU_WEB_API_H */
