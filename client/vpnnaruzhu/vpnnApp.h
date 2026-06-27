#ifndef _VPNNARUZHU_APP_H
#define _VPNNARUZHU_APP_H

#include <QObject>

#include "web_api.h"
#include "downloader.h"
#include "countriesModel.h"
#include "downloadController.h"
#include "ui/controllers/serversUiController.h"

class VpnNaruzhuApp: public QObject
{
    Q_OBJECT

public:
    VpnNaruzhuApp(SecureAppSettingsRepository *settings_repository,
        SecureServersRepository *servers_repository,
        QSharedPointer<VpnConnection> vpnc,
        QQmlApplicationEngine* engine,
        LanguageUiController* lc,
        ImportController *amnezia_importController,
        ServersUiController* sc);

    QSharedPointer<VpnNaruzhuWebApi> getWebApi(void) const
        { return vpnn_web_api; };

    Q_PROPERTY(bool isAccountBlocked READ isAccountBlocked NOTIFY accoundStatusChanged)
    bool isAccountBlocked(void) const;

public slots:
    void updateAccountStatus(void);

signals:
    void accoundStatusChanged(void) const;

private:
    VpnNaruzhuApp();

    // AmneziaApp properties
    SecureAppSettingsRepository *amnezia_settingsRepository;
    SecureServersRepository *amnezia_serversRepository;
    QSharedPointer<VpnConnection> amnezia_vpnConnection;
    QQmlApplicationEngine* amnezia_engine;
    LanguageUiController* amnezia_languageUiController;
    ImportController *amnezia_importController;
    ServersUiController* amnezia_serversUiController;

    // VPNNaruzhu properties
    QSharedPointer<VpnNaruzhuWebApi> vpnn_web_api;
    QSharedPointer<VPNNCountriesModel> vpnn_countries_model;
    QSharedPointer<VpnNaruzhuDownloader> vpnn_downloader;
    QSharedPointer<VpnnDownloadController> vpnn_downloadController;

    bool vpnn_account_blocked = false;
};

static inline
bool vpnn_is_test_run(void)
{
    QString test_env = qgetenv("VPNNARUZHU_TEST_CONFIG");
    return !test_env.isEmpty();
}

static inline
QString vpnn_get_path_to_test_config(void)
{
    return  qgetenv("VPNNARUZHU_TEST_CONFIG");
}

#endif /* _VPNNARUZHU_APP_H */
