#include "web_api.h"
#include "amnezia_application.h"

#include <QByteArray>
#include <QNetworkReply>
#include <QJsonDocument>
#include <QNetworkRequest>

static QJsonDocument getJsonFromReply(QNetworkReply* reply, const QString &comment)
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
    QJsonDocument json_doc = getAccountStatus(public_request_id);
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

void SotkaWebApi::updateDefaultAccountStatus(void) const
{
    if (!m_serversModel->isThereDefaultAccount()) {
        return;
    }

    QJsonDocument json_doc = getDefaultAccountStatus();
    //qDebug() << json_doc;
    if (json_doc.isEmpty()) {
        qDebug() << "Cannot get default account status";
    } else {
        m_serversModel->updateDefaultAccountStatus(json_doc);
    }

    if (json_doc[config_key::simplified_status].toString() == "Key limit exceeded") {
        emit keyLimitExceeded();
    }

    emit defaultAccountStatusUpdated();
}

QString SotkaWebApi::getDefaultAccountConfig(bool force_update_device) const
{
    QString url = getApiBaseUrl()
            + "/client-api/v1/download-awg-key?public_request_id="
            + getDefaultPublicRequestId();

    QNetworkRequest request;
    if (force_update_device) {
        request.setRawHeader("force_update_device", "true");
    }
    initRequest(request, url);

    QNetworkReply* reply = replyGetRequest(request);
    return getStringFromReply(reply, "getDefaultAccountConfig");
}

void SotkaWebApi::updateDefaultAccountConfig(bool force_update_device) const
{
    if (!m_serversModel->isThereDefaultAccount()) {
        return;
    }

    QString key = getDefaultAccountConfig(force_update_device);
    //qDebug() << key;
    if (key.isEmpty()) {
        qDebug() << "Cannot get default account config";
    } else {
        m_importController->extractConfigFromData(key);
        m_importController->updateDefaultAccountConfig();
    }
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
