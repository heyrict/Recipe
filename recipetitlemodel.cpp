#include "recipetitlemodel.h"

RecipeTitleModel::RecipeTitleModel()
{

}

QHash<int, QByteArray> RecipeTitleModel::roleNames() const
{
    QHash<int, QByteArray>roles;
    roles[TitleRole] = "title";
    roles[ModelRole] = "recipeModel";
    return roles;
}

QVariant RecipeTitleModel::data(const QModelIndex &index, int role) const
{
    if (index.row() < 0 || index.row() > m_recipeModels.length())
        return QVariant();

    if (role == TitleRole)
        return (m_recipeModels[index.row()])->title();
    else if (role == ModelRole)
        return QVariant::fromValue(m_recipeModels[index.row()]);
    else
        return QVariant();
}

int RecipeTitleModel::rowCount(const QModelIndex &parent) const
{
    return m_recipeModels.length();
}

void RecipeTitleModel::newRecipeModel()
{
    RecipeModel* recipeModel = new RecipeModel("New Recipe");
    recipeModel->addElement(new RecipeElement("RATE",1));
    recipeModel->addElement(new RecipeElement("size",8,"^2"));
    recipeModel->addElement(new RecipeElement("powder",500));
    recipeModel->addElement(new RecipeElement("butter",100));

    m_recipeModels.append(recipeModel);
    emit layoutChanged();
}
