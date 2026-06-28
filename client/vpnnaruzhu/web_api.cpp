#include "web_api.h"
#include "vpnnApp.h"

#include <QByteArray>
#include <QApplication>
#include <QNetworkReply>
#include <QJsonDocument>
#include <QNetworkRequest>
#include <QtEnvironmentVariables>

#include <filesystem>

VpnNaruzhuWebApi::VpnNaruzhuWebApi(
    SecureAppSettingsRepository *settings_repository,
    SecureServersRepository *servers_repository,
    QSharedPointer<VpnConnection> vpnc,
    QQmlApplicationEngine* engine,
    LanguageUiController *lc,
    ImportController *ic,
    QSharedPointer<VpnnDownloadController> &d,
    NotificationHandler *tray)
        : m_settingsRepository(settings_repository),
            m_serversRepository(servers_repository), m_vpnConnection(vpnc),
            m_engine(engine), m_languageController(lc), m_importController(ic),
            vpnn_downloadController(d)
{
    m_tray = qobject_cast<SystemTrayNotificationHandler*>(tray);
    m_manager.reset(new QNetworkAccessManager());
    //m_importController = (ImportController*)
    //    m_engine->rootContext()->objectForName("ImportController");

    if (default_app_config.open(QIODevice::ReadOnly)) {
        external_app_config = QJsonDocument::fromJson(
            default_app_config.readAll());
        default_app_config.close();
    } else {
        qDebug() << "Cannot open " << default_app_config.fileName();
    }

    connectionMode.reset(new VPNNConnectionMode(m_settingsRepository,
        m_settingsRepository->getAppLanguage()));
    m_engine->rootContext()->setContextProperty("VPNNConnectionMode",
        connectionMode.get());
    connect(m_languageController, &LanguageUiController::updateTranslations,
        connectionMode.get(), &VPNNConnectionMode::setLocale);

    initSettings();
}

static QJsonDocument getJsonFromReply(QNetworkReply* reply,
    const QString &comment)
{
    if (reply->error() == QNetworkReply::NoError) {
        QByteArray r = reply->readAll();
        reply->deleteLater();

        QJsonParseError json_error;
        QJsonDocument json_doc = QJsonDocument::fromJson(r, &json_error);
        if (json_error.error == QJsonParseError::NoError) {
            return json_doc;
        } else {
            qDebug() << "Cannot parse json error: " << json_error.error;
            qDebug() << "Json: " << r;
        }
    } else {
        qDebug() << "Reply failed: " << comment;
        qDebug() << reply->readAll();
        reply->deleteLater();
    }

    return QJsonDocument();
}

static QString getStringFromReply(QNetworkReply* reply, const QString &comment)
{
    if (reply->error() == QNetworkReply::NoError) {
        QString str = QString::fromUtf8(reply->readAll());
        reply->deleteLater();
        return str;
    } else {
        qDebug() << "Reply failed: " << comment;
        qDebug() << reply->readAll();
        reply->deleteLater();
    }

    return QString();
}

void VpnNaruzhuWebApi::initSimpleRequest(QNetworkRequest &request,
    const QString &url) const
{
    request.setTransferTimeout(TIMEOUT);
    request.setHeader(QNetworkRequest::UserAgentHeader, user_agent);
    request.setUrl(url);
}

void VpnNaruzhuWebApi::initRequest(QNetworkRequest &request,
    const QString &url, bool is_json) const
{
    request.setTransferTimeout(TIMEOUT);
    if (is_json) {
        request.setHeader(QNetworkRequest::ContentTypeHeader,
            "application/json");
    }
    request.setHeader(QNetworkRequest::UserAgentHeader, user_agent);
    request.setRawHeader("X-Device-Id",
        m_settingsRepository->getInstallationUuid(true).toUtf8());
    //qDebug() << "X-Device-Id: " << m_settings->getInstallationUuid(true).toUtf8();
    request.setRawHeader("X-Supported-Awg-Version", awg_version.toUtf8());
    //qDebug() << "X-Supported-Awg-Version: " << awg_version.toUtf8();
    request.setUrl(url);
}

QNetworkReply* VpnNaruzhuWebApi::replyGetRequest(
    const QNetworkRequest &request) const
{
    QNetworkReply *reply;
    reply = m_manager->get(request);

    QEventLoop wait;
    QObject::connect(reply, &QNetworkReply::finished, &wait, &QEventLoop::quit);
    wait.exec();

    return reply;
}

QNetworkReply* VpnNaruzhuWebApi::replyPostRequest(
    const QNetworkRequest &request, const QString &data) const
{
    QNetworkReply *reply;
    reply = m_manager->post(request, data.toUtf8());

    QEventLoop wait;
    QObject::connect(reply, &QNetworkReply::finished, &wait, &QEventLoop::quit);
    wait.exec();

    return reply;
}

QJsonDocument VpnNaruzhuWebApi::getDefaultAccountStatus(void) const
{
    QString url = getApiBaseUrl()
                + "/client-api/v1/get-request?public_request_id="
                + getPublicRequestId();
    qDebug() << "getDefaultAccountStatus: " << url;

    QNetworkRequest request;
    initRequest(request, url, false);

    QNetworkReply* reply = replyGetRequest(request);
    return getJsonFromReply(reply, "getDefaultAccountStatus");
}

void VpnNaruzhuWebApi::updateDefaultAccountStatus(void) const
{
    if (!m_serversRepository->naruzhuIsThereDefaultAccount()) {
        return;
    }

    QJsonDocument json_doc = getDefaultAccountStatus();
    if (json_doc.isEmpty()) {
        qDebug() << "Cannot get default account status";
    } else {
        m_serversRepository->naruzhuUpdateDefaultAccountStatus(json_doc);
    }

    emit defaultAccountStatusUpdated();
}

QString VpnNaruzhuWebApi::getDefaultAccountConfig(
    QString public_request_id) const
{
    QString url = getApiBaseUrl()
            + "/"
            + connectionMode->getActiveRouteModeRelativePath();
    if (url.contains('?')) {
        url += "&";
    } else {
        url += "?";
    }
    url += "public_request_id=";
    if (public_request_id.isEmpty()) {
        url += getPublicRequestId();
    } else {
        url += public_request_id;
    }

    QString iso = m_settingsRepository->naruzhuGetVPNCountry();
    if (iso != "ANY") {
        url += "&iso_country_code=" + iso;
    }
    qDebug() << "getDefaultAccountConfig: " << url;

    QNetworkRequest request;
    initRequest(request, url, false);

    QNetworkReply* reply = replyGetRequest(request);
    return getStringFromReply(reply, "getDefaultAccountConfig");
}

void VpnNaruzhuWebApi::updateDefaultAccountConfig(void) const
{
    if (!m_serversRepository->naruzhuIsThereDefaultAccount()) {
        return;
    }

    QString key = getDefaultAccountConfig();
    if (key.isEmpty()) {
        qDebug() << "Cannot get default account config";
    } else {
        m_importController->naruzhuUpdateDefaultAccountConfig(key);
    }
}

void VpnNaruzhuWebApi::downloadFile(const QString &url, QFile &file) const
{
    QNetworkRequest request;
    request.setTransferTimeout(TIMEOUT);
    request.setUrl(url);

    QNetworkReply *reply = replyGetRequest(request);
    file.open(QFile::WriteOnly);
    file.write(reply->readAll());
    file.flush();
    file.close();
    reply->deleteLater();
}

QJsonDocument VpnNaruzhuWebApi::downloadJsonFile(const QString &url) const
{
    QNetworkRequest request;
    request.setTransferTimeout(TIMEOUT);
    request.setHeader(QNetworkRequest::ContentTypeHeader, "application/json");
    request.setUrl(url);

    QNetworkReply *reply = replyGetRequest(request);
    return getJsonFromReply(reply, "downloadJsonFile");
}

QString VpnNaruzhuWebApi::getSmartRoutesListUrl(void) const
{
    if (vpnn_is_test_run()) {
        return smart_routs_test_url;
    } else {
        return smart_routs_url;
    }
}

QJsonDocument VpnNaruzhuWebApi::getAppTestConfig(void) const
{
    QJsonDocument config;
    QString local_test_config_path = vpnn_get_path_to_test_config();
    QFileInfo check_local_config(local_test_config_path);
    if (check_local_config.exists() && check_local_config.isFile()) {
        QFile local_test_config = QFile(local_test_config_path);
        if (local_test_config.open(QIODevice::ReadOnly)) {
            config = QJsonDocument::fromJson(local_test_config.readAll());
            local_test_config.close();
        } else {
            qDebug() << "Cannot open " << local_test_config.fileName();
        }
    } else {
        config = downloadJsonFile(external_app_config_test_url);
        if (config.isEmpty()) {
            qDebug() << "Cannot download test external config"
                    << external_app_config_test_url;
        }
    }

    return config;
}

QJsonDocument VpnNaruzhuWebApi::getAppExternalConfig(void) const
{
    for (const auto &url: external_app_config_urls) {
        QJsonDocument config = downloadJsonFile(url);
        if (!config.isEmpty()) {
            return config;
        } else {
            qDebug() << "Cannot download external config" << url;
        }
    }

    return QJsonDocument();
}

QJsonDocument VpnNaruzhuWebApi::getAppConfig(void) const
{
    if (vpnn_is_test_run()) {
        return getAppTestConfig();
    } else {
        return getAppExternalConfig();
    }

    return QJsonDocument();
}

void VpnNaruzhuWebApi::initSettings(void)
{
    QString dns1 = external_app_config["dns1"].toString();
    if (dns1 != "") {
        m_settingsRepository->setPrimaryDns(dns1);
    }

    QString dns2 = external_app_config["dns2"].toString();
    if (dns2 != "") {
        m_settingsRepository->setSecondaryDns(dns2);
    }

    QJsonDocument connections_config = QJsonDocument(
        external_app_config["connections"].toArray());
    if (!connections_config.isEmpty()) {
        connectionMode->updateConfig(connections_config);
        uint64_t numbeOfModes = connectionMode->getNumberOfModes();
        if (numbeOfModes == 1) {
            // if new config contains only 1 Mode, needs to update settings
            VPNNRouteMode mode = connectionMode->getActiveRouteMode();
            connectionMode->setRouteMode(mode);
        }
    }

    QString webSite = external_app_config["websiteLink"].toString();
    m_tray->updateWebsiteUrl(webSite);
}

void VpnNaruzhuWebApi::updateExternalSettings(void)
{
    QJsonDocument new_app_config = getAppConfig();
    if (!new_app_config.isEmpty()) {
        external_app_config = new_app_config;
        initSettings();
    }
}

void VpnNaruzhuWebApi::updateSmartRouting(void) const
{
    QString url = getSmartRoutesListUrl();
    QJsonDocument json_doc = downloadJsonFile(url);
    if (json_doc.isEmpty()) {
        qDebug() << "Cannot download smart routs: " << url;
    } else {
        m_vpnConnection->clearExcludeRouteList();
        QJsonArray json_array = json_doc.array();
        for (const auto &elem: json_array) {
            switch (elem.type()) {
                case QJsonValue::Object:
                {
                    QJsonObject json_obj = elem.toObject();
                    QString host = json_obj["hostname"].toString();
                    m_vpnConnection->excludeRoute(host);
                }
                    break;
                default:
                    qDebug() << "json_array elem unknown type: " << elem;
                    break;
            }
        }
    }
}

QJsonDocument VpnNaruzhuWebApi::getListOfCounties(void) const
{
    QString url = getApiBaseUrl()
            + "/client-api/v1/countries";

    QNetworkRequest request;
    initSimpleRequest(request, url);

    QNetworkReply* reply = replyGetRequest(request);
    return getJsonFromReply(reply, "getListOfCounties");
}

bool VpnNaruzhuWebApi::isNewVersionAvailable(void) const
{
    QString external_version = external_app_config["updateInfo"]["availableVersion"].toString();
    QVersionNumber new_version = QVersionNumber::fromString(external_version);
    QVersionNumber cur_version = QVersionNumber::fromString(APP_VERSION);
    if (new_version > cur_version) {
        return true;
    }

    return false;
}

bool VpnNaruzhuWebApi::shouldForceUpdateApp(void) const
{
    QString required_version = external_app_config["updateInfo"]["requiredVersion"].toString();
    QVersionNumber new_version = QVersionNumber::fromString(required_version);
    QVersionNumber cur_version = QVersionNumber::fromString(APP_VERSION);
    if (new_version > cur_version) {
        return true;
    }

    return false;
}

QString VpnNaruzhuWebApi::downloadNewApp(void) const
{
    std::filesystem::path new_path;
    QTemporaryFile temp_file;
    temp_file.setAutoRemove(false);
    if (temp_file.open()) {
        new_path = std::filesystem::path(temp_file.fileName().toStdString());
        new_path.replace_filename(new_path.filename().string() + ".exe");
        temp_file.rename(new_path.string().c_str());
    }

    QString link = external_app_config["updateInfo"]["downloadUrl"].toString();

    QEventLoop wait;
    QObject::connect(vpnn_downloadController.get(), &VpnnDownloadController::finished, &wait, &QEventLoop::quit);
    vpnn_downloadController->download(link, new_path.string().c_str());
    wait.exec();

    temp_file.flush();
    temp_file.close();

    return new_path.string().c_str();
}

void VpnNaruzhuWebApi::downloadAndInstallNewApp(void) const
{
    QString path = downloadNewApp();
    installNewApp(path);
}

void VpnNaruzhuWebApi::installNewApp(QString &path) const
{
    QProcess::startDetached(path);
}

QString VpnNaruzhuWebApi::getUUIDLastSymbols(void) const
{
    QString uuid = m_settingsRepository->getInstallationUuid(true);
    return uuid.right(4);
}

bool VpnNaruzhuWebApi::isChangeServerPossible(void) const
{
    QString url = getApiBaseUrl()
            + "/client-api/v1/check-change-server?public_request_id="
            + getPublicRequestId();

    switch (connectionMode->getActiveRouteMode()) {
    case VPNNRouteMode::SMART:
        url += "&key_type=smart";
        break;
    case VPNNRouteMode::DIRECT:
        url += "&key_type=direct";
        break;
    default:
        break;
    }

    QString iso = m_settingsRepository->naruzhuGetVPNCountry();
    if (iso != "ANY") {
        url += "&iso_country_code=" + iso;
    }

    qDebug() << "isChangeServerPossible: " << url;

    QNetworkRequest request;
    initRequest(request, url, false);

    QNetworkReply* reply = replyGetRequest(request);
    QJsonDocument json = getJsonFromReply(reply, "isChangeServerPossible");
    return json["data"]["is_change_server_available"].toBool();
}

bool VpnNaruzhuWebApi::changeServer(void) const
{
    QEventLoop wait;
    QObject::connect(m_vpnConnection.get(), &VpnConnection::connectionEnded, &wait,
        &QEventLoop::quit);
    QMetaObject::invokeMethod(m_vpnConnection.get(), "disconnectFromVpn",
        Qt::QueuedConnection);
    wait.exec();

    QString url = getApiBaseUrl() + "/client-api/v1/change-server";

    QString data = "{\n\"public_request_id\": \"" + getPublicRequestId() + "\",";

    switch (connectionMode->getActiveRouteMode()) {
    case VPNNRouteMode::SMART:
        data += "\n\"key_type\": \"smart\"";
        break;
    case VPNNRouteMode::DIRECT:
        data += "\n\"key_type\": \"direct\"";
        break;
    default:
        break;
    }

    QString iso = m_settingsRepository->naruzhuGetVPNCountry();
    if (iso != "ANY") {
        data += ",\n\"iso_country_code\": \"" + iso + "\"";
    }

    data += "\n}";
    qDebug() << "changeServer: " << url << ", with data:";
    qDebug() << data;

    QNetworkRequest request;
    initRequest(request, url);

    QNetworkReply* reply = replyPostRequest(request, data);
    QJsonDocument json = getJsonFromReply(reply, "changeServer");
    qDebug() << json;
    return json["data"]["success"].toBool();
}
