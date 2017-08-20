#ifndef RECIPETITLEMODEL_H
#define RECIPETITLEMODEL_H

#include <QObject>
#include <QAbstractListModel>

class RecipeTitleModel : public QAbstractListModel
{
    Q_OBJECT
public:
    enum RecipeTitleRoles {
        TitleRole = Qt::UserRole + 1
    };

    RecipeTitleModel();
    QHash<int, QByteArray> roleNames() const;
};

#endif // RECIPETITLEMODEL_H
