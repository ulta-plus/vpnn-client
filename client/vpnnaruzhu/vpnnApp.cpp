#include "vpnnApp.h"

VpnNaruzhuApp::VpnNaruzhuApp(SecureAppSettingsRepository *settings_repository,
    SecureServersRepository *servers_repository,
    QSharedPointer<VpnConnection> vpnc,
    QQmlApplicationEngine* e,
    LanguageUiController* lc,
    ImportController *ic,
    ServersUiController* sc)
        : amnezia_settingsRepository(settings_repository),
            amnezia_serversRepository(servers_repository),
            amnezia_vpnConnection(vpnc), amnezia_engine(e),
            amnezia_languageUiController(lc), amnezia_importController(ic),
            amnezia_serversUiController(sc)
{
    vpnn_downloader.reset(new VpnNaruzhuDownloader());
    vpnn_downloadController.reset(new VpnnDownloadController(vpnn_downloader));
    amnezia_engine->rootContext()->setContextProperty("VPNNDownloadController",
        vpnn_downloadController.get());

    vpnn_web_api.reset(new VpnNaruzhuWebApi( amnezia_settingsRepository
                                           , amnezia_serversRepository
                                           , amnezia_vpnConnection
                                           , amnezia_engine
                                           , amnezia_languageUiController
                                           , amnezia_importController
                                           , vpnn_downloadController
                                           )
                      );
    amnezia_engine->rootContext()->setContextProperty("VPNNWebApi",
        vpnn_web_api.get());
    connect(vpnn_web_api.get(), &VpnNaruzhuWebApi::defaultAccountStatusUpdated,
        this, &VpnNaruzhuApp::updateAccountStatus);

    vpnn_countries_model.reset(new VPNNCountriesModel(this, vpnn_web_api,
        amnezia_settingsRepository));
    amnezia_engine->rootContext()->setContextProperty("VPNNCountriesModel",
        vpnn_countries_model.get());
}

void VpnNaruzhuApp::updateAccountStatus(void)
{
    vpnn_account_blocked = !amnezia_serversUiController->naruzhuIsDefaultAccountActive();
    emit accoundStatusChanged();
}

bool VpnNaruzhuApp::isAccountBlocked(void) const
{
    return vpnn_account_blocked;
}