#ifndef SERVERSCONTROLLER_H
#define SERVERSCONTROLLER_H

#include <optional>

#include <QObject>
#include <QVector>
#include <QMap>

#include <QPair>

#include "core/utils/containerEnum.h"
#include "core/utils/containers/containerUtils.h"
#include "core/utils/protocolEnum.h"
#include "core/utils/errorCodes.h"
#include "core/utils/routeModes.h"
#include "core/utils/commonStructs.h"
#include "core/repositories/secureServersRepository.h"
#include "core/repositories/secureAppSettingsRepository.h"
#include "core/models/containerConfig.h"
#include "core/models/serverDescription.h"

class SshSession;
class InstallController;

using namespace amnezia;

class ServersController : public QObject
{
    Q_OBJECT

public:
    explicit ServersController(SecureServersRepository* serversRepository,
                              SecureAppSettingsRepository* appSettingsRepository = nullptr,
                              QObject *parent = nullptr);
    ~ServersController() = default;

    // Server management
    bool renameServer(const QString &serverId, const QString &name);
    void removeServer(const QString &serverId);
    void setDefaultServer(const QString &serverId);

    // Container management
    void setDefaultContainer(const QString &serverId, DockerContainer container);

    // Getters
    QVector<ServerDescription> buildServerDescriptions(bool isAmneziaDnsEnabled) const;
    int getDefaultServerIndex() const;
    QString getDefaultServerId() const;
    int getServersCount() const;
    QString getServerId(int serverIndex) const;
    int indexOfServerId(const QString &serverId) const;
    QString notificationDisplayName(const QString &serverId) const;
    std::optional<ApiV2ServerConfig> apiV2Config(const QString &serverId) const;
    std::optional<SelfHostedAdminServerConfig> selfHostedAdminConfig(const QString &serverId) const;
    ServerCredentials getServerCredentials(const QString &serverId) const;
    QMap<DockerContainer, ContainerConfig> getServerContainersMap(const QString &serverId) const;
    DockerContainer getDefaultContainer(const QString &serverId) const;
    ContainerConfig getContainerConfig(const QString &serverId, DockerContainer container) const;

    // Validation
    bool isServerFromApiAlreadyExists(const QString &userCountryCode, const QString &serviceType, const QString &serviceProtocol) const;
    bool hasInstalledContainers(const QString &serverId) const;
    bool isLegacyApiV1Server(const QString &serverId) const;

    QJsonObject getServerConfig(const int serverIndex) const;
    QPair<QString, QString> getDnsPair(const int serverIndex) const;
    const QString getCurrentServerDns1(void) const;
    const QString getCurrentServerDns2(void) const;

    QJsonObject getDefaultAccount(void) const;
    bool isThereDefaultAccount(void) const;
    bool isAccountDefault(int index) const;
    int getDefaultAccountIndex(void) const;
    void updateDefaultAccountStatus(const QJsonDocument &json_doc);
    void removeDefaultAccount(void);
    void updateDefaultAccountConfig(const QJsonObject &new_config);
    QString getPaidUntilDefaultAccountStr(void) const;
    qint64 getNumberOfActiveDays(void) const;
    bool isDefaultAccountActive(void) const;

    void updateCurrentKeyDnsConfig(const QString &dns1, const QString &dns2);

private:
    void ensureDefaultServerValid();

    SecureServersRepository* m_serversRepository;
    SecureAppSettingsRepository* m_appSettingsRepository;
};

#endif // SERVERSCONTROLLER_H

