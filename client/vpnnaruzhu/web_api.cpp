#include "web_api.h"
#include "amnezia_application.h"

#include <QByteArray>
#include <QNetworkReply>
#include <QJsonDocument>
#include <QNetworkRequest>

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

QJsonDocument VpnNaruzhuWebApi::downloadJsonFile(const QString &url) const
{
    QNetworkRequest request;
    request.setTransferTimeout(10000);
    request.setHeader(QNetworkRequest::ContentTypeHeader, "application/json");
    request.setUrl(url);

    QNetworkReply *reply = replyGetRequest(request);
    return getJsonFromReply(reply, "downloadJsonFile");
}

void VpnNaruzhuWebApi::updateExternalSettings(void) const
{
    QJsonDocument config = downloadJsonFile(amnezia_config_url);
    if (config.isEmpty()) {
        qDebug() << "Cannot download amnezia config: " << amnezia_config_url;
    } else {
        QString apiBaseUrl = config["apiBaseUrl"].toString();
        m_settings->setApiBaseUrl(apiBaseUrl);

        QString dns1 = config["dns1"].toString();
        if (dns1 != "") {
            m_settings->setPrimaryDns(dns1);
        }

        QString dns2 = config["dns2"].toString();
        if (dns2 != "") {
            m_settings->setSecondaryDns(dns2);
        }

        QString support_link = config["supportLink"].toString();
        if (support_link != "") {
            m_settings->setSupportLink(support_link);
        }

        QJsonDocument connections_config = QJsonDocument(
            config["connections"].toArray());
        connectionMode->updateConfig(connections_config);
        uint64_t numbeOfModes = connectionMode->getNumberOfModes();
        if (numbeOfModes == 1) {
            // if new config contains only 1 Mode, needs to update settings
            VPNNRouteMode mode = connectionMode->getActiveRouteMode();
            connectionMode->setRouteMode(mode);
        }
    }
}

void VpnNaruzhuWebApi::updateSmartRouting(void) const
{
    QJsonDocument json_doc = downloadJsonFile(smart_routs_url);
    if (json_doc.isEmpty()) {
        qDebug() << "Cannot download smart routs: " << smart_routs_url;
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
