#include "web_api.h"
#include "amnezia_application.h"

#include <QByteArray>
#include <QNetworkReply>
#include <QJsonDocument>
#include <QNetworkRequest>

static QJsonDocument getJsonFromReply(QNetworkReply* reply, const QString &comment)
{
    QByteArray r = reply->readAll();
    reply->deleteLater();

    QJsonParseError json_error;
    QJsonDocument json_doc = QJsonDocument::fromJson(r, &json_error);
    if (reply->error() == QNetworkReply::NoError) {
        if (json_error.error == QJsonParseError::NoError) {
            return json_doc;
        } else {
            qDebug() << "Cannot parse json error: " << json_error.error;
            qDebug() << "Json: " << r;
        }
    } else {
        qDebug() << "Reply failed: " << comment;
        qDebug() << r;
        if (json_error.error == QJsonParseError::NoError) {
            return json_doc;
        }
    }

    return QJsonDocument();
}

static QString getStringFromReply(QNetworkReply* reply, const QString &comment)
{
    QString str = QString::fromUtf8(reply->readAll());
    reply->deleteLater();
    if (reply->error() == QNetworkReply::NoError) {
        return str;
    } else {
        qDebug() << "Reply failed: " << comment;
        if (!str.isEmpty()) {
            qDebug() << "Reply string: " << str;
            return str;
        }
    }

    return QString();
}

void SotkaWebApi::initRequest(QNetworkRequest &request,
    const QString &url) const
{
    request.setTransferTimeout(10000);
    // For some reason Sotka server fails because of this line
    //request.setHeader(QNetworkRequest::ContentTypeHeader, "application/json");
    request.setRawHeader("X-Device-Id",
        m_settings->getInstallationUuid(true).toUtf8());
    request.setHeader(QNetworkRequest::UserAgentHeader, user_agent);
    request.setRawHeader("X-Supported-Awg-Version", awg_version.toUtf8());
    request.setUrl(url);
}

QNetworkReply* SotkaWebApi::replyGetRequest(const QNetworkRequest &request) const
{
    QNetworkReply *reply;
    reply = amnApp->networkManager()->get(request);

    QEventLoop wait;
    QObject::connect(reply, &QNetworkReply::finished, &wait, &QEventLoop::quit);
    wait.exec();

    return reply;
}

QJsonDocument SotkaWebApi::getAccountStatus(QString public_request_id) const
{
    QString url = getApiBaseUrl()
                + "/client-api/v1/get-request?public_request_id="
                + public_request_id;

    QNetworkRequest request;
    initRequest(request, url);

    QNetworkReply* reply = replyGetRequest(request);
    return getJsonFromReply(reply, "getAccountStatus");
}

QString SotkaWebApi::getAccountStatusStr(QString public_request_id) const
{
    if (!m_serversModel->isThereDefaultAccount()) {
        return QString();
    }

    QJsonDocument json_doc = getDefaultAccountStatus();
    if (json_doc.isEmpty()) {
        return QString();
    } else {
        return QString::fromUtf8(json_doc.toJson());
    }
}

QJsonDocument SotkaWebApi::getDefaultAccountStatus(void) const
{
    return getAccountStatus(getDefaultPublicRequestId());
}

bool SotkaWebApi::updateDefaultAccountStatus(void) const
{
    if (!m_serversModel->isThereDefaultAccount()) {
        return true;
    }

    QJsonDocument json_doc = getDefaultAccountStatus();
    if (json_doc.isEmpty()) {
        qDebug() << "Cannot get default account status";
        return false;
    } if (json_doc[config_key::error][config_key::localized_message].toString() == "Key limit exceeded") {
        emit keyLimitExceeded();
        return false;
    }

    m_serversModel->updateDefaultAccountStatus(json_doc);
    emit defaultAccountStatusUpdated();
    return true;
}

QString SotkaWebApi::getDefaultAccountConfig(bool force_update_device) const
{
    QString url = getApiBaseUrl()
            + "/client-api/v1/download-awg-key?public_request_id="
            + getDefaultPublicRequestId();

    QNetworkRequest request;
    if (force_update_device) {
        url += "&force_update_device=true";
    }
    initRequest(request, url);

    QNetworkReply* reply = replyGetRequest(request);
    return getStringFromReply(reply, "getDefaultAccountConfig");
}

bool SotkaWebApi::updateDefaultAccountConfig(bool force_update_device) const
{
    if (!m_serversModel->isThereDefaultAccount()) {
        return true;
    }

    QString key = getDefaultAccountConfig(force_update_device);
    if (key.isEmpty()) {
        qDebug() << "Cannot get default account config";
        return false;
    }

    if (force_update_device) {
        if (!updateDefaultAccountStatus()) {
            return false;
        }
    }

    m_importController->extractConfigFromData(key);
    m_importController->updateDefaultAccountConfig();
    return true;
}

QJsonDocument SotkaWebApi::downloadJsonFile(const QString &url) const
{
    QNetworkRequest request;
    request.setTransferTimeout(10000);
    request.setHeader(QNetworkRequest::ContentTypeHeader, "application/json");
    request.setUrl(url);

    QNetworkReply *reply = replyGetRequest(request);
    return getJsonFromReply(reply, "downloadJsonFile");
}

/*  Currently Sotka doesn't support dynamic ApiBase URL
void SotkaWebApi::updateApiBaseUrl(void) const
{
    QJsonDocument config = downloadJsonFile(amnezia_config_url);
    if (config.isEmpty()) {
        qDebug() << "Cannot download amnezia config: " << amnezia_config_url;
    } else {
        QString apiBaseUrl = config["apiBaseUrl"].toString();
        m_settings->setApiBaseUrl(apiBaseUrl);
    }
}
*/

/* Currently Sotka doesn't support smart routing
void SotkaWebApi::updateSmartRouting(void) const
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
*/
