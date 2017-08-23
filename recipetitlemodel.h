#ifndef RECIPETITLEMODEL_H
#define RECIPETITLEMODEL_H

#include <QObject>
#include <QAbstractListModel>
#include <QFile>
#include <QDataStream>
#include <QIODevice>
#include "recipemodel.h"

class RecipeTitleModel : public QAbstractListModel
{
    Q_OBJECT
public:
    enum RecipeTitleRoles {
        TitleRole = Qt::UserRole + 1,
        ModelRole
    };

    RecipeTitleModel();
    QHash<int, QByteArray> roleNames() const;
    int rowCount(const QModelIndex &parent) const;
    QVariant data(const QModelIndex &index, int role) const;
    bool load();

public slots:
    int newRecipeModel(QString title = "New Recipe", bool changeLayout = true);
    void deleteRecipeModel(int index);
    void refresh();
    void save();

private:
    QList<RecipeModel*> m_recipeModels;

};

#endif // RECIPETITLEMODEL_H
