#include "recipetitlemodel.h"
#define STARTRECIPE (quint32)0x33641E91
#define ENDRECIPE (quint32)0x128E841B
#define STARTMODEL (quint32)0x1384A99E
#define ENDMODEL (quint32)0x5B88C5B8
#define STARTELEMENT (quint32)0xAA8A4064
#define ENDELEMENT (quint32)0xE2515C60

RecipeTitleModel::RecipeTitleModel()
{
    connect(this,SIGNAL(layoutChanged(QList<QPersistentModelIndex>,
                                      QAbstractItemModel::LayoutChangeHint)),this,SLOT(save()));
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

int RecipeTitleModel::newRecipeModel(QString title, bool changeLayout)
{
    RecipeModel* recipeModel = new RecipeModel(title);

    connect(recipeModel,SIGNAL(layoutChanged(QList<QPersistentModelIndex>,QAbstractItemModel::LayoutChangeHint)),this,SLOT(save()));

    m_recipeModels.append(recipeModel);
    if (changeLayout) emit layoutChanged();
    return m_recipeModels.length() - 1;
}

int RecipeTitleModel::replicateRecipeModel(int index)
{
    RecipeModel* recipeModel = m_recipeModels[index];

    emit layoutAboutToBeChanged();
    RecipeModel* rRecipeModel = new RecipeModel(recipeModel->title(), false);
    for (RecipeElement* ele : recipeModel->m_elements)
        rRecipeModel->addElement(ele->compName(),ele->quantity(),ele->calcMtd());
    m_recipeModels.append(rRecipeModel);
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
        if (m_recipeModels.length() == 0)
            out << ENDELEMENT;
        else for (RecipeElement *j : i->m_elements)
                out << STARTELEMENT << j->compName() << j->quantity() << j->calcMtd();
        out << ENDELEMENT;
    }
    out << ENDRECIPE;
}

bool RecipeTitleModel::load()
{
    QFile file("Recipies.dat");
    if (!file.exists()) return false;
    file.open(QIODevice::ReadOnly);
    QDataStream in(&file);

    quint32 serial, recipeSerial, elementSerial;
    QString title, compName, calcMtd;
    int indexCount = 0;
    double quantity;

    in >> serial;
    qDebug() << STARTMODEL << STARTRECIPE << STARTELEMENT;
    qDebug() << ENDMODEL << ENDRECIPE << ENDELEMENT;
    if (serial != STARTMODEL) return false;
    else {
        in >> recipeSerial;
        while (recipeSerial == STARTRECIPE)
        {
            in >> title;
            this->newRecipeModel(title, false);
            in >> elementSerial;
            while (elementSerial == STARTELEMENT)
            {
                in >> compName >> quantity >> calcMtd;
                this->m_recipeModels[indexCount]->addElement(compName, quantity, calcMtd, false);
                in >> elementSerial;
                if (elementSerial == ENDELEMENT) break;
            }
            indexCount++;
            in >> recipeSerial;
        }
    }
    return true;
}
