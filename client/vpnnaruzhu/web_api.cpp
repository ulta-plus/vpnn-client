#include "web_api.h"
#include "amnezia_application.h"

#include <QByteArray>
#include <QNetworkReply>
#include <QJsonDocument>
#include <QNetworkRequest>
#include <QtEnvironmentVariables>

#include <filesystem>

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
    request.setTransferTimeout(10000);
    request.setHeader(QNetworkRequest::UserAgentHeader, user_agent);
    request.setUrl(url);
}

void VpnNaruzhuWebApi::initRequest(QNetworkRequest &request,
    const QString &url, bool is_json) const
{
    request.setTransferTimeout(10000);
    if (is_json) {
        request.setHeader(QNetworkRequest::ContentTypeHeader,
            "application/json");
    }
    request.setHeader(QNetworkRequest::UserAgentHeader, user_agent);
    request.setRawHeader("X-Device-Id",
        m_settings->getInstallationUuid(true).toUtf8());
    request.setRawHeader("X-Supported-Awg-Version", awg_version.toUtf8());
    request.setUrl(url);
}

QNetworkReply* VpnNaruzhuWebApi::replyGetRequest(
    const QNetworkRequest &request) const
{
    QNetworkReply *reply;
    reply = amnApp->networkManager()->get(request);

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

    QNetworkRequest request;
    initRequest(request, url, false);

    QNetworkReply* reply = replyGetRequest(request);
    return getJsonFromReply(reply, "getDefaultAccountStatus");
}

void VpnNaruzhuWebApi::updateDefaultAccountStatus(void) const
{
    if (!m_serversModel->isThereDefaultAccount()) {
        return;
    }

    QJsonDocument json_doc = getDefaultAccountStatus();
    if (json_doc.isEmpty()) {
        qDebug() << "Cannot get default account status";
    } else {
        m_serversModel->updateDefaultAccountStatus(json_doc);
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

    QString iso = m_settings->getVPNCountry();
    if (iso != "ANY") {
        url += "&iso_country_code=" + iso;
    }

    QNetworkRequest request;
    initRequest(request, url, false);

    QNetworkReply* reply = replyGetRequest(request);
    return getStringFromReply(reply, "getDefaultAccountConfig");
}

void VpnNaruzhuWebApi::updateDefaultAccountConfig(void) const
{
    if (!m_serversModel->isThereDefaultAccount()) {
        return;
    }

    QString key = getDefaultAccountConfig();
    if (key.isEmpty()) {
        qDebug() << "Cannot get default account config";
    } else {
        m_importController->extractConfigFromData(key);
        m_importController->updateDefaultAccountConfig();
    }
}

void VpnNaruzhuWebApi::downloadFile(const QString &url, QFile &file) const
{
    QNetworkRequest request;
    request.setTransferTimeout(10000);
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
    request.setTransferTimeout(10000);
    request.setHeader(QNetworkRequest::ContentTypeHeader, "application/json");
    request.setUrl(url);

    QNetworkReply *reply = replyGetRequest(request);
    return getJsonFromReply(reply, "downloadJsonFile");
}

static bool is_test_run(void)
{
    QString test_env = qgetenv("VPNNARUZHU_TEST");
    return !test_env.isEmpty();
}

QString VpnNaruzhuWebApi::getSmartRoutesListUrl(void) const
{
    if (is_test_run()) {
        return smart_routs_test_url;
    } else {
        return smart_routs_url;
    }
}

QJsonDocument VpnNaruzhuWebApi::getTestConfig(void) const
{
    QJsonDocument config = downloadJsonFile(external_config_test_url);
    if (config.isEmpty()) {
        qDebug() << "Cannot download test external config"
                 << external_config_test_url;
    }

    return config;
}

QJsonDocument VpnNaruzhuWebApi::getExternalConfig(void) const
{
    for (const auto &url: external_config_urls) {
        QJsonDocument config = downloadJsonFile(url);
        if (!config.isEmpty()) {
            return config;
        } else {
            qDebug() << "Cannot download test external config" << url;
        }
    }

    return QJsonDocument();
}

QJsonDocument VpnNaruzhuWebApi::getConfig(void) const
{
    if (is_test_run()) {
        return getTestConfig();
    } else {
        return getExternalConfig();
    }

    return QJsonDocument();
}

void VpnNaruzhuWebApi::initSettings(void)
{
    QString dns1 = external_config["dns1"].toString();
    if (dns1 != "") {
        m_settings->setPrimaryDns(dns1);
    }

    QString dns2 = external_config["dns2"].toString();
    if (dns2 != "") {
        m_settings->setSecondaryDns(dns2);
    }

    QJsonDocument connections_config = QJsonDocument(
        external_config["connections"].toArray());
    if (!connections_config.isEmpty()) {
        connectionMode->updateConfig(connections_config);
        uint64_t numbeOfModes = connectionMode->getNumberOfModes();
        if (numbeOfModes == 1) {
            // if new config contains only 1 Mode, needs to update settings
            VPNNRouteMode mode = connectionMode->getActiveRouteMode();
            connectionMode->setRouteMode(mode);
        }
    }
}

void VpnNaruzhuWebApi::updateExternalSettings(void)
{
    QJsonDocument new_config = getConfig();
    if (!new_config.isEmpty()) {
        external_config = new_config;
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
    QString external_version = external_config["updateInfo"]["availableVersion"].toString();
    QVersionNumber new_version = QVersionNumber::fromString(external_version);
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

    QString link = external_config["updateInfo"]["downloadUrl"].toString();
    downloadFile(link, temp_file);
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
    QString uuid = m_settings->getInstallationUuid(true);
    return uuid.right(4);
}
