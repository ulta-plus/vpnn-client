#ifndef VPNNARUZHU_UPDATE_INFO_H
#define VPNNARUZHU_UPDATE_INFO_H

#include <QJsonDocument>
#include <QJsonObject>
#include <QRegularExpression>
#include <QUrl>
#include <QVersionNumber>

namespace VpnnUpdate {

inline bool validVersion(const QJsonValue &value)
{
    static const QRegularExpression pattern(QStringLiteral("^[0-9]+(?:\\.[0-9]+)*$"));
    return value.isString() && pattern.match(value.toString()).hasMatch();
}

inline bool validUrl(const QString &value)
{
    const QUrl url(value);
    return url.isValid() && !url.host().isEmpty()
        && (url.scheme() == QStringLiteral("https") || url.scheme() == QStringLiteral("http"));
}

inline QString migrationLandingUrl(const QJsonDocument &config)
{
    const QString url = config.object().value("migrationInfo").toObject()
                            .value("landingUrl").toString();
    return validUrl(url) ? url : QStringLiteral("https://usenaruzhu.space/landing/");
}

// Validate the config envelope before replacing the last known-good config.
// Hash errors are handled by the update attempt: they must not hide a hard-update screen.
inline bool validConfig(const QJsonDocument &document)
{
    if (!document.isObject())
        return false;
    const QJsonObject config = document.object();
    if (!validUrl(config.value("apiBaseUrl").toString()) || !config.value("updateInfo").isObject())
        return false;
    const QJsonObject update = config.value("updateInfo").toObject();
    bool hasVersion = false;
    for (const auto &key : {QStringLiteral("availableVersion"), QStringLiteral("requiredVersion")}) {
        const QJsonValue value = update.value(key);
        // An omitted or empty requiredVersion is the legacy soft-update format.
        if (value.isUndefined() || (value.isString() && value.toString().isEmpty()))
            continue;
        if (!validVersion(value))
            return false;
        hasVersion = true;
    }
    return hasVersion && validUrl(update.value("downloadUrl").toString());
}

struct Attempt {
    QString url;
    QString sha256;
    bool hashRequired = false;

    static Attempt fromConfig(const QJsonDocument &config, const QString &currentVersion)
    {
        const QJsonObject update = config.object().value("updateInfo").toObject();
        return {update.value("downloadUrl").toString(),
                update.value("sha256").toString().trimmed(),
                QVersionNumber::fromString(update.value("requiredVersion").toString())
                    > QVersionNumber::fromString(currentVersion)};
    }

    static Attempt fromMigrationConfig(const QJsonDocument &config)
    {
        const QJsonObject migration = config.object().value("migrationInfo").toObject();
        // The final legacy build must never download itself via updateInfo.
        // Migration is mandatory even when requiredVersion equals APP_VERSION.
        return {migration.value("downloadUrl").toString(),
                migration.value("sha256").toString().trimmed(), true};
    }

    bool validHash() const
    {
        if (sha256.isEmpty())
            return !hashRequired;
        static const QRegularExpression pattern(QStringLiteral("^[0-9a-fA-F]{64}$"));
        return pattern.match(sha256).hasMatch();
    }
};

} // namespace VpnnUpdate

#endif
