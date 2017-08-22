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

    QList<RecipeElement*> m_elements;

public slots:
    int addElement(RecipeElement* element = new RecipeElement("Component",1,"x1"));
    void updateElement(int row, QString compName, double quantity, QString calcMtd = tr("x1"));
    void removeElement(int row);
    void updateModel(double rate);
    void setTitle(QString title);
    QString title();

signals:
    void titleChanged();

private:
    QString m_title;
    double m_rate;
};

#endif // RECIPEMODEL_H
