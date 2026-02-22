#ifndef _VPNNARUZHU_APP_H
#define _VPNNARUZHU_APP_H

#include <QObject>

#include "web_api.h"
#include "downloader.h"
#include "countriesModel.h"

class VpnNaruzhuApp: public QObject
{
    Q_OBJECT

public:
    VpnNaruzhuApp(const std::shared_ptr<Settings> &s,
        const QSharedPointer<ServersModel> &sm,
        const QSharedPointer<VpnConnection> &vpnc,
        QQmlApplicationEngine* engine,
        QSharedPointer<LanguageModel> &lm);

    QSharedPointer<VpnNaruzhuWebApi> getWebApi(void) const
        { return vpnn_web_api; };

public slots:

private:
    VpnNaruzhuApp();

    // AmneziaApp properties
    std::shared_ptr<Settings> amnezia_settings;
    QSharedPointer<ServersModel> amnezia_serversModel;
    QSharedPointer<VpnConnection> amnezia_vpnConnection;
    QQmlApplicationEngine* amnezia_engine;
    QSharedPointer<LanguageModel> amnezia_languageModel;

    // VPNNaruzhu properties
    QSharedPointer<VpnNaruzhuWebApi> vpnn_web_api;
    QSharedPointer<VPNNCountriesModel> vpnn_countries_model;
    QSharedPointer<VpnNaruzhuDownloader> vpnn_downloader;
};

#endif /* _VPNNARUZHU_APP_H */
