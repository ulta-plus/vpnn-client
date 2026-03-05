#ifndef _VPNN_COUNTRIES_MODEL_H
#define _VPNN_COUNTRIES_MODEL_H

#include <QAbstractListModel>
#include "web_api.h"

class VPNNCountriesModel : public QAbstractListModel
{
    Q_OBJECT

public:
    enum Roles {
        NameRole = Qt::UserRole + 1,
        IconRole,
    };

    explicit VPNNCountriesModel(QObject *parent = nullptr,
        const QSharedPointer<VpnNaruzhuWebApi> &web_api = nullptr,
        const std::shared_ptr<Settings> &s = nullptr);
    QVariant data(const QModelIndex &index, int role = Qt::DisplayRole) const override;
    int rowCount(const QModelIndex &parent = QModelIndex()) const override;
    Q_PROPERTY(int currentIndex READ getCurrentIndex WRITE setCurrentIndex NOTIFY currentIndexChanged)
    Q_INVOKABLE QVariantMap get(int i) const;

public slots:
    int getCurrentIndex(void) const { return currentIndex; }
    void setCurrentIndex(int i);
    void refresh(void);

signals:
    void currentIndexChanged(const int index);

protected:
    QHash<int, QByteArray> roleNames(void) const override;

private:
    struct CountryEntry {
        QString name;
        QString icon;
        QString iso;
    };

    int currentIndex;
    QVector<CountryEntry> countriesList;
    QVector<QVariantMap> countriesMap;
    QSharedPointer<VpnNaruzhuWebApi> webApi;
    std::shared_ptr<Settings> settings;
};

#endif /* _VPNN_COUNTRIES_MODEL_H */
