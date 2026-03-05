#include "countriesModel.h"

void
VPNNCountriesModel::refresh(void)
{
    QJsonDocument json_doc = webApi->getListOfCounties();
    if (json_doc.isEmpty() && !countriesList.isEmpty()) {
        qDebug() << "Cannot download new country list, keep old.";
        return;
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

    QString cachedVPNCountry = settings->getVPNCountry();
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
        const std::shared_ptr<Settings> &s)
    : QAbstractListModel(parent), webApi(web_api), settings(s)
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
    settings->setVPNCountry(iso_name);
    emit currentIndexChanged(currentIndex);
}
