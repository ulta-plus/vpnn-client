#include "countriesModel.h"

void
VPNNCountriesModel::refresh(void)
{
    QJsonDocument json_doc = webApi->getListOfCounties();
    if (json_doc.isEmpty()) {
        qDebug() << "Cannot download new country list.";
        if (!countriesList.isEmpty()) {
            qDebug() << "Keep old country list.";
            return;
        }

        if (default_country_list.open(QIODevice::ReadOnly)) {
            qDebug() << "Use default country list.";
            json_doc = QJsonDocument::fromJson(default_country_list.readAll());
            default_country_list.close();
        } else {
            qDebug() << "Cannot open " << default_country_list.fileName();
        }
    }

    beginResetModel();
    QJsonArray countriesArray = json_doc["data"]["countries"].toArray();
    QVector<CountryEntry> newCountriesList;
    QVector<QVariantMap> newCountriesMap;

    CountryEntry entry;
    entry.name = tr("Любая страна");
    entry.iso = "ANY";
    entry.icon = "qrc:/countriesFlags/images/flagKit/" + entry.iso +".svg";
    newCountriesList.push_back(entry);
    QVariantMap map;
    map.insert("name", entry.name);
    map.insert("icon", entry.icon);
    currentIndex = 0;
    newCountriesMap.push_back(map);

    QString cachedVPNCountry = settingsRepository->naruzhuGetVPNCountry();
    for (const auto &elem: countriesArray) {
        QJsonObject country = elem.toObject();
        entry.name = country["country_label"].toString().split(" ")[1];
        entry.iso = country["iso_country_code"].toString();
        if (entry.iso == cachedVPNCountry) {
            currentIndex = newCountriesMap.size();
        }
        entry.icon = "qrc:/countriesFlags/images/flagKit/" + entry.iso +".svg";
        newCountriesList.push_back(entry);
        QVariantMap map;
        map.insert("name", entry.name);
        map.insert("icon", entry.icon);
        newCountriesMap.push_back(map);
    }

    countriesList = std::move(newCountriesList);
    countriesMap = std::move(newCountriesMap);
    endResetModel();
}

VPNNCountriesModel::VPNNCountriesModel(QObject *parent,
    const QSharedPointer<VpnNaruzhuWebApi> &web_api,
    SecureAppSettingsRepository *sr)
        : QAbstractListModel(parent), webApi(web_api), settingsRepository(sr)
{
    refresh();
}

int
VPNNCountriesModel::rowCount(const QModelIndex &parent) const
{
    Q_UNUSED(parent)
    return countriesMap.size();
}

QVariant
VPNNCountriesModel::data(const QModelIndex &i, int role) const
{
    if (!i.isValid() || i.row() < 0 || i.row() >= static_cast<int>(rowCount()))
        return QVariant();

    if (role == NameRole)
        return QVariant(countriesList[i.row()].name);
    else if (role == IconRole)
        return QVariant(countriesList[i.row()].icon);

     return QVariant();
}

QVariantMap
VPNNCountriesModel::get(int i) const
{
    if (i < 0 || i >= countriesMap.size())
        return QVariantMap();

    return countriesMap[i];
}

QHash<int, QByteArray>
VPNNCountriesModel::roleNames(void) const
{
    QHash<int, QByteArray> roles;
    roles[NameRole] = "name";
    roles[IconRole] = "icon";
    return roles;
}

void
VPNNCountriesModel::setCurrentIndex(int i)
{
    currentIndex = i;
    QString iso_name = countriesList[i].iso;
    settingsRepository->naruzhuSetVPNCountry(iso_name);
    emit currentIndexChanged(currentIndex);
}
