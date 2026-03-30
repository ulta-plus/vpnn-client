#include "vpnnApp.h"

VpnNaruzhuApp::VpnNaruzhuApp(const std::shared_ptr<Settings> &s,
    const QSharedPointer<ServersModel> &sm,
    const QSharedPointer<VpnConnection> &vpnc,
    QQmlApplicationEngine* e,
    QSharedPointer<LanguageModel> &lm)
        : amnezia_settings(s), amnezia_serversModel(sm),
            amnezia_vpnConnection(vpnc), amnezia_engine(e),
            amnezia_languageModel(lm)
{
    vpnn_downloader.reset(new VpnNaruzhuDownloader());
    vpnn_downloadController.reset(new VpnnDownloadController(vpnn_downloader));
    amnezia_engine->rootContext()->setContextProperty("VPNNDownloadController",
        vpnn_downloadController.get());

    vpnn_web_api.reset(new VpnNaruzhuWebApi( amnezia_settings
                                           , amnezia_serversModel
                                           , amnezia_vpnConnection
                                           , amnezia_engine
                                           , amnezia_languageModel
                                           , vpnn_downloadController
                                           )
                      );
    amnezia_engine->rootContext()->setContextProperty("VPNNWebApi",
        vpnn_web_api.get());
    connect(vpnn_web_api.get(), &VpnNaruzhuWebApi::defaultAccountStatusUpdated,
        this, &VpnNaruzhuApp::updateAccountStatus);

    vpnn_countries_model.reset(new VPNNCountriesModel(this, vpnn_web_api,
        amnezia_settings));
    amnezia_engine->rootContext()->setContextProperty("VPNNCountriesModel",
        vpnn_countries_model.get());
}

void VpnNaruzhuApp::updateAccountStatus(void)
{
    vpnn_account_blocked = !amnezia_serversModel->isDefaultAccountActive();
    emit accoundStatusChanged();
}

bool VpnNaruzhuApp::isAccountBlocked(void) const
{
    return vpnn_account_blocked;
}