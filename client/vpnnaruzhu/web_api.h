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
#include "downloadController.h"
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
        QSharedPointer<LanguageModel> &lm,
        QSharedPointer<VpnnDownloadController> &d);

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
    QString getApiBaseUrl(void) const { return external_app_config["apiBaseUrl"].toString(); }
    QString getSupportLink(void) const { return external_app_config["supportLink"].toString(); }
    QString getTgChannelLink(void) const { return external_app_config["tgChannelLink"].toString(); }
    QString getAboutLink(void) const { return external_app_config["aboutLink"].toString(); }
    QString getUUIDLastSymbols(void) const;

    bool isNewVersionAvailable(void) const;

private:
    VpnNaruzhuWebApi();

    QJsonDocument external_app_config;
    void initSettings(void);

    std::shared_ptr<Settings> m_settings;
    QSharedPointer<ServersModel> m_serversModel;
    QSharedPointer<VpnConnection> m_vpnConnection;
    QQmlApplicationEngine* m_engine;
    ImportController* m_importController;
    QSharedPointer<LanguageModel> m_languageModel;

    // VPNN properties
    QSharedPointer<VPNNConnectionMode> connectionMode;
    QSharedPointer<VpnnDownloadController> vpnn_downloadController;

    QSharedPointer<QNetworkAccessManager> m_manager;
    const quint64 TIMEOUT = 10000; // milliseconds
    const QString awg_version = "1.5";
    const QString user_agent = "naruzhu-desktop/" APP_VERSION;

    QFile default_app_config = QFile(":/vpnnaruzhu/default_app_config.json");
    const QString external_app_config_urls[3] = {
        "https://raw.githubusercontent.com/ulta-plus/public/refs/heads/main/naruzhu/amnezia/config.json",
        "https://storage.googleapis.com/naruzhu/amnezia/config.json",
        "https://storage.yandexcloud.net/vpnn-web-configs/naruzhu/amnezia/config.json"
    };
    const QString external_app_config_test_url =
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
    QJsonDocument getAppConfig(void) const;
    QJsonDocument getAppTestConfig(void) const;
    QJsonDocument getAppExternalConfig(void) const;
};

#endif /* _VPNNARUZHU_WEB_API_H */
