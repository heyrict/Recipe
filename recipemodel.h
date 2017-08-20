#ifndef RECIPEMODEL_H
#define RECIPEMODEL_H

#include <QObject>
#include <QAbstractListModel>
#include "recipeelement.h"

class RecipeModel : public QAbstractListModel
{
    Q_OBJECT
public:
    enum RecipeRoles {
        NameRole = Qt::UserRole + 1,
        QuantityRole,
        CalcMtdRole
    };

    QHash<int, QByteArray> roleNames() const;
    RecipeModel(QObject* parent=nullptr);
    int rowCount(const QModelIndex &parent) const;
    QVariant data(const QModelIndex &index, int role) const;
    int addElement(RecipeElement* element);

private:
    QList<RecipeElement*> m_elements;
    double m_rate;
};

#endif // RECIPEMODEL_H
