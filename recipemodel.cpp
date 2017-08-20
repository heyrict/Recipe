#include "recipemodel.h"

RecipeModel::RecipeModel(QObject* parent) : QAbstractListModel(parent)
{
}

QHash<int, QByteArray> RecipeModel::roleNames() const
{
    QHash<int, QByteArray>roles;
    roles[NameRole] = "compName";
    roles[QuantityRole] = "quantity";
    roles[CalcMtdRole] = "calcMtd";
    return roles;
}

int RecipeModel::rowCount(const QModelIndex &parent) const
{
    return m_elements.length();
}

QVariant RecipeModel::data(const QModelIndex &index, int role) const
{
    if (index.row() < 0 || index.row() > m_elements.length())
        return QVariant();

    RecipeElement* curElement = m_elements[index.row()];
    if (role == NameRole)  return QVariant(curElement->compName());
    else if (role == CalcMtdRole)  return QVariant(curElement->calcMtd());
    else if (role == QuantityRole)  return QVariant(curElement->quantity());
    else return QVariant();
}

int RecipeModel::addElement(RecipeElement* element)
{
    m_elements.append(element);
}
