#ifndef _VPNNARUZHU_CONNECTION_MODE_H
#define _VPNNARUZHU_CONNECTION_MODE_H

#include "core/repositories/secureAppSettingsRepository.h"

#include <QObject>
#include <QLocale>
#include <QJsonDocument>

enum VPNNRouteMode { SMART = 0, DIRECT = 1, NONE = -1 };

class VPNNConnectionMode: public QObject
{
    Q_OBJECT

public:
    VPNNConnectionMode(SecureAppSettingsRepository *sr ,const QLocale &l)
        : m_appSettingsRepository(sr), locale(l.name()) {}
    void updateConfig(const QJsonDocument &new_config) {
        config = new_config;
        emit configUpdated();
    }
    VPNNRouteMode getActiveRouteMode(void) const;
    QString getActiveRouteModeRelativePath(void) const;

signals:
    void configUpdated(void) const;

public slots:
    uint64_t getNumberOfModes(void) const;
    QString getSmartModeTitle(void) const;
    QString getDirectModeTitle(void) const;

    void setLocale(const QLocale &l) { locale = l.name(); }

    void setSmartRouteMode(void) const { m_appSettingsRepository->setVPNNRouteMode(VPNNRouteMode::SMART); }
    void setDirectRouteMode(void) const { m_appSettingsRepository->setVPNNRouteMode(VPNNRouteMode::DIRECT); }
    VPNNRouteMode getRouteMode(void) const { return static_cast<VPNNRouteMode>(m_appSettingsRepository->getVPNNRouteMode()); }
    void setRouteMode(VPNNRouteMode mode) const { m_appSettingsRepository->setVPNNRouteMode(mode); }
    bool isSmartRouteMode(void) const { return (getRouteMode() == VPNNRouteMode::SMART);};
    bool isDirectRouteMode(void) const { return (getRouteMode() == VPNNRouteMode::DIRECT);};
private:
    QJsonDocument config;

    SecureAppSettingsRepository *m_appSettingsRepository;
    QString locale;

    QString getSmartModeRelativePath(void) const;
    QString getDirectModeRelativePath(void) const;
};

#endif /* _VPNNARUZHU_CONNECTION_MODE_H */
