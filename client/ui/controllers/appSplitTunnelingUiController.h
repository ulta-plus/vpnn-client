#ifndef APPSPLITTUNNELINGUICONTROLLER_H
#define APPSPLITTUNNELINGUICONTROLLER_H

#include <QObject>
#include <QVector>

#include "core/controllers/appSplitTunnelingController.h"
#include "core/utils/errorCodes.h"
#include "core/utils/routeModes.h"
#include "core/utils/commonStructs.h"
#include "ui/models/appSplitTunnelingModel.h"

class AppSplitTunnelingUiController : public QObject
{
    Q_OBJECT

    Q_PROPERTY(int routeMode READ getRouteMode WRITE setRouteMode NOTIFY routeModeChanged)
    /* issue_5
    Q_PROPERTY(bool isSplitTunnelingEnabled READ isSplitTunnelingEnabled NOTIFY isSplitTunnelingEnabledChanged)
    */

public:
    explicit AppSplitTunnelingUiController(AppSplitTunnelingController* appSplitTunnelingController,
                                          AppSplitTunnelingModel* appSplitTunnelingModel,
                                          QObject *parent = nullptr);

public slots:
    void addApp(const QString &appPath);
    void addApps(QVector<QPair<QString, QString>> apps);
    void removeApp(const int index);
    /* issue_5
    void toggleSplitTunneling(bool enabled);
    */
    void setRouteMode(int routeMode);

    int getRouteMode() const;
    /* issue_5
    bool isSplitTunnelingEnabled() const;
    */

    void updateModel();

signals:
    void routeModeChanged();
    /* issue_5
    void isSplitTunnelingEnabledChanged();
    */
    void errorOccurred(const QString &errorMessage);
    void finished(const QString &message);

private:
    AppSplitTunnelingController* m_appSplitTunnelingController;
    AppSplitTunnelingModel* m_appSplitTunnelingModel;
};

#endif // APPSPLITTUNNELINGUICONTROLLER_H
