#include "legacyApiServerConfig.h"

#include "core/utils/constants/apiKeys.h"
#include "core/utils/constants/configKeys.h"

namespace amnezia
{

bool LegacyApiServerConfig::hasContainers() const
{
    return !containers.isEmpty();
}

ContainerConfig LegacyApiServerConfig::containerConfig(DockerContainer container) const
{
    if (!containers.contains(container)) {
        return ContainerConfig{};
    }
    return containers.value(container);
}

LegacyApiServerConfig LegacyApiServerConfig::fromJson(const QJsonObject &json)
{
    LegacyApiServerConfig config;

    config.description = json.value(configKey::description).toString();
    config.hostName = json.value(configKey::hostName).toString();

    config.isNaruzhuDefaultConfig = json.value(configKey::is_default).toBool();
    config.email = json.value(configKey::email).toString();
    config.dns1 = json.value(configKey::dns1).toString();
    config.dns2 = json.value(configKey::dns2).toString();
    config.paid_until = json.value(configKey::paid_until).toString();
    config.simplified_status = json.value(configKey::simplified_status).toString();

    config.crc = json.value(configKey::crc).toInt(0);

    config.configVersion = json.value(configKey::configVersion).toInt(1);
    config.apiEndpoint = json.value(apiDefs::key::apiEndpoint).toString();

    if (config.displayName.isEmpty()) {
        config.displayName = config.name.isEmpty() ? config.description : config.name;
    }

    return config;
}

} // namespace amnezia
