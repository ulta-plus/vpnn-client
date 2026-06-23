#include "connectionMode.h"

#include <QJsonArray>
#include <QJsonObject>

uint64_t VPNNConnectionMode::getNumberOfModes(void) const
{
    return config.array().size();
}

VPNNRouteMode VPNNConnectionMode::getActiveRouteMode(void) const
{
    switch (getNumberOfModes()) {
    case 0: return VPNNRouteMode::NONE;
    case 1:
        if (config.array()[0].toObject()["keyType"].toString() == "smart") {
            return VPNNRouteMode::SMART;
        } else {
            return VPNNRouteMode::DIRECT;
        }
    default:
        return static_cast<VPNNRouteMode>(m_appSettingsRepository->getVPNNRouteMode());
    }
}

QString VPNNConnectionMode::getActiveRouteModeRelativePath(void) const
{
    switch (static_cast<VPNNRouteMode>(m_appSettingsRepository->getVPNNRouteMode())) {
    case VPNNRouteMode::SMART:
        return getSmartModeRelativePath();
    case VPNNRouteMode::DIRECT:
        return getDirectModeRelativePath();
    default:
        return "/client-api/v1/download-awg-key";
    }
}

static QJsonObject getConnectionDescriptor(const QJsonDocument &json_doc,
    const QString &type)
{
    QJsonArray json_array = json_doc.array();
    for (const auto &elem: json_array) {
        QJsonObject json_obj = elem.toObject();
        QString keyType = json_obj["keyType"].toString();
        if (keyType == type) {
            return json_obj;
        }
    }

    return QJsonObject();
}

QString VPNNConnectionMode::getSmartModeTitle(void) const
{
    QJsonObject desc = getConnectionDescriptor(config, "smart");
    if (desc.isEmpty()) {
        return "";
    }

    QString title = desc["localizedTitle"][locale.left(2)].toString();
    if (title.isEmpty()) {
        title = desc["title"].toString();
        if (title.isEmpty()) {
            title = tr("Smart Mode");
        }
    }
    return title;
}

QString VPNNConnectionMode::getSmartModeRelativePath(void) const
{
    QJsonObject desc = getConnectionDescriptor(config, "smart");
    return desc["relativePath"].toString();
}

QString VPNNConnectionMode::getDirectModeTitle(void) const
{
    QJsonObject desc = getConnectionDescriptor(config, "direct");
    if (desc.isEmpty()) {
        return "";
    }

    QString title = desc["localizedTitle"][locale.left(2)].toString();
    if (title.isEmpty()) {
        title = desc["title"].toString();
        if (title.isEmpty()) {
            title = tr("Direct Mode");
        }
    }
    return title;
}

QString VPNNConnectionMode::getDirectModeRelativePath(void) const
{
    QJsonObject desc = getConnectionDescriptor(config, "direct");
    return desc["relativePath"].toString();
}
