#include "recipetitlemodel.h"
#define STARTRECIPE (quint32)0x33641E91
#define ENDRECIPE (quint32)0x128E841B
#define STARTMODEL (quint32)0x1384A99E
#define ENDMODEL (quint32)0x5B88C5B8
#define STARTELEMENT (quint32)0xAA8A4064
#define ENDELEMENT (quint32)0xE2515C60

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

void RecipeTitleModel::newRecipeModel(QString title)
{
    RecipeModel* recipeModel = new RecipeModel("New Recipe");

    m_recipeModels.append(recipeModel);
    emit layoutChanged();
}

void RecipeTitleModel::refresh()
{
    emit layoutChanged();
}

void RecipeTitleModel::deleteRecipeModel(int index)
{
    if (index < 0 || index > m_recipeModels.length())
        return;

    emit layoutAboutToBeChanged();
    m_recipeModels.removeAt(index);
    emit layoutChanged();
}

void RecipeTitleModel::save()
{
    QFile file("Recipies.dat");
    file.open(QIODevice::WriteOnly);
    QDataStream out(&file);
    out << STARTMODEL;
    for (RecipeModel* i : m_recipeModels)
    {
        out << STARTRECIPE;
        out << i->title();
        out << STARTELEMENT;
        for (RecipeElement *j : i->m_elements)
            out << j->compName() << j->quantity() << j->calcMtd();
        out << ENDELEMENT;
    }
    out << ENDMODEL;
}

bool RecipeTitleModel::load()
{
    QFile file("Recipies.dat");
    if (!file.exists()) return false;
    file.open(QIODevice::ReadOnly);
    QDataStream in(&file);

    quint32 serial, recipeSerial, elementSerial;
    QString title, compName, calcMtd;
    double quantity;

    in >> serial;
    while (serial != ENDMODEL)
    {
        in >> recipeSerial;
        while (recipeSerial != ENDRECIPE)
        {
            in >> title;
            in >> elementSerial;
            while (elementSerial != ENDELEMENT)
            {
                in >> compName >> quantity >> calcMtd;
                this->newRecipeModel();
            }
        }
    }
}
