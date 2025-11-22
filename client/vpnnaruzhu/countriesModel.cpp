#include "countriesModel.h"

static QString
flagFromISO(QString &iso_code)
{
    QString code = iso_code.toUpper();
    if (code.length() != 2)
            return QString();

    const char16_t base = 0x1F1E6;
    const char16_t flag[2] = {
        base + (code[0].unicode() - 'A'),
        base + (code[1].unicode() - 'A')
    };

    return QString::fromRawData(flag, std::size(flag));
}

VPNNCountriesModel::VPNNCountriesModel(QObject *parent,
        const QSharedPointer<VpnNaruzhuWebApi> &web_api)
    : QAbstractListModel(parent), webApi(web_api)
{
    QJsonDocument json_doc = webApi->getListOfCounties();
    QJsonArray countriesArray = json_doc["data"]["countries"].toArray();
    for (const auto &elem: countriesArray) {
        QJsonObject country = elem.toObject();
        CountryEntry entry;
        entry.name = country["country_label"].toString();
        entry.icon = "qrc:/images/controls/question.svg";
        entry.iso = country["iso_country_code"].toString();
        entry.name = entry.iso + " " +  entry.name;
        countriesList.push_back(entry);
        QVariantMap map;
        map.insert("name", entry.name);
        map.insert("icon", entry.icon);
        countriesMap.push_back(map);
    }
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
VPNNCountriesModel::roleNames() const
{
    QHash<int, QByteArray> roles;
    roles[NameRole] = "name";
    roles[IconRole] = "icon";
    return roles;
}
