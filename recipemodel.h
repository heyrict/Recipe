#ifndef RECIPEMODEL_H
#define RECIPEMODEL_H

#include <QObject>
#include <QAbstractListModel>
#include "recipeelement.h"

class RecipeModel : public QAbstractListModel
{
    Q_OBJECT
    Q_PROPERTY(QString title READ title WRITE setTitle NOTIFY titleChanged)
public:
    enum RecipeRoles {
        NameRole = Qt::UserRole + 1,
        QuantityRole,
        CalcMtdRole,
        RateRole
    };

    QHash<int, QByteArray> roleNames() const;
    RecipeModel(QString sTitle = "New Recipe", QObject* parent=nullptr);
    int rowCount(const QModelIndex &parent) const;
    QVariant data(const QModelIndex &index, int role) const;
    int addElement(RecipeElement* element);

public slots:
    void updateModel(double rate);
    void setTitle(QString title);
    QString title();

signals:
    void titleChanged();

private:
    QString m_title;
    QList<RecipeElement*> m_elements;
    double m_rate;
};

#endif // RECIPEMODEL_H
