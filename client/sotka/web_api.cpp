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
    request.setHeader(QNetworkRequest::ContentTypeHeader, "application/json");
    request.setRawHeader("X-Device-Id",
        m_settings->getInstallationUuid(true).toUtf8());
    qDebug() << "UUID: " << m_settings->getInstallationUuid(true).toUtf8();
    request.setHeader(QNetworkRequest::UserAgentHeader, user_agent);
    qDebug() << "user_agent" << user_agent;
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

QJsonDocument SotkaWebApi::getDefaultAccountStatus(void) const
{
    QString url = getApiBaseUrl()
                + "/client-api/v1/get-request?public_request_id="
                + getPublicRequestId();
    qDebug() << url;

    QNetworkRequest request;
    initRequest(request, url);

    QNetworkReply* reply = replyGetRequest(request);
    return getJsonFromReply(reply, "getDefaultAccountStatus");
}

void SotkaWebApi::updateDefaultAccountStatus(void) const
{
    QJsonDocument json_doc = getDefaultAccountStatus();
    if (json_doc.isEmpty()) {
        qDebug() << "Cannot get default account status";
    } else {
        m_serversModel->updateDefaultAccountStatus(json_doc);
    }
}

QString SotkaWebApi::getDefaultAccountConfig(void) const
{
    QString url = getApiBaseUrl()
            + "/api/v1/wg_keys/download_mobile_request_key?public_request_id="
            + getPublicRequestId();

    QNetworkRequest request;
    initRequest(request, url);

    QNetworkReply* reply = replyGetRequest(request);
    return getStringFromReply(reply, "getDefaultAccountConfig");
}

void SotkaWebApi::updateDefaultAccountConfig(void) const
{
    QString key = getDefaultAccountConfig();
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

QJsonDocument SotkaWebApi::getAccountStatusWithPublicId(QString public_id)
{

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
