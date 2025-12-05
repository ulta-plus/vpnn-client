#ifndef _VPNNARUZHU_CONNECTION_MODE_H
#define _VPNNARUZHU_CONNECTION_MODE_H

#include "settings.h"

#include <QObject>
#include <QLocale>
#include <QJsonDocument>

enum VPNNRouteMode { SMART = 0, DIRECT = 1, NONE = -1 };

class VPNNConnectionMode: public QObject
{
    Q_OBJECT

public:
    VPNNConnectionMode(const std::shared_ptr<Settings> &s
        ,const QLocale &l) : m_settings(s), locale(l.name()) {}
    void updateConfig(const QJsonDocument &new_config) { config = new_config; }
    VPNNRouteMode getActiveRouteMode(void) const;

public slots:
    uint64_t getNumberOfModes(void) const;
    QString getSmartModeTitle(void) const;
    QString getSmartModeRelativePath(void) const;
    QString getDirectModeTitle(void) const;
    QString getDirectModeRelativePath(void) const;

    void setLocale(const QLocale &l) { locale = l.name(); }

    void setSmartRouteMode(void) const { m_settings->setVPNNRouteMode(VPNNRouteMode::SMART); }
    void setDirectRouteMode(void) const { m_settings->setVPNNRouteMode(VPNNRouteMode::DIRECT); }
    VPNNRouteMode getRouteMode(void) const { return static_cast<VPNNRouteMode>(m_settings->getVPNNRouteMode()); }
    void setRouteMode(VPNNRouteMode mode) const { m_settings->setVPNNRouteMode(mode); }
    bool isSmartRouteMode(void) const { return (getRouteMode() == VPNNRouteMode::SMART);};
    bool isDirectRouteMode(void) const { return (getRouteMode() == VPNNRouteMode::DIRECT);};
private:
    QJsonDocument config;

    std::shared_ptr<Settings> m_settings;
    QString locale;
};

#endif /* _VPNNARUZHU_CONNECTION_MODE_H */
