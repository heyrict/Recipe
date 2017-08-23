#include "recipemodel.h"

RecipeModel::RecipeModel(QString sTitle, QObject* parent) : QAbstractListModel(parent)
{
    m_title = sTitle;
    m_rate = 1;
}

void RecipeModel::setTitle(QString title)
{
    m_title = title;
    emit titleChanged();
}

QString RecipeModel::title()
{
    return m_title;
}

QHash<int, QByteArray> RecipeModel::roleNames() const
{
    QHash<int, QByteArray>roles;
    roles[NameRole] = "compName";
    roles[QuantityRole] = "quantity";
    roles[CalcMtdRole] = "calcMtd";
    roles[RateRole] = "rate";
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
    else if (role == QuantityRole) return QVariant(curElement->quantity());
    else if (role == RateRole) return QVariant(m_rate);
    else return QVariant();
}

int RecipeModel::addElement(QString sCompName, double sQuantity, QString sCalcMtd, bool changeLayout)
{
    if (changeLayout) emit layoutAboutToBeChanged();
    m_elements.append(new RecipeElement(sCompName,sQuantity,sCalcMtd));
    if (changeLayout) emit layoutChanged();
    return true;
}

void RecipeModel::updateModel(double rate)
{
    if (rate < 0 || rate > 1000)  return;

    m_rate = rate;
    emit layoutAboutToBeChanged();
    emit layoutChanged();
}

void RecipeModel::removeElement(int row)
{
    if (row < 0 || row > m_elements.length())
        return;

    emit layoutAboutToBeChanged();
    m_elements.removeAt(row);
    emit layoutChanged();
}

void RecipeModel::updateElement(int row, QString compName, double quantity, QString calcMtd)
{
    if (row < 0 || row > m_elements.length())
        return;

    emit layoutAboutToBeChanged();
    m_elements[row]->setCompName(compName);
    m_elements[row]->setQuantity(quantity);
    m_elements[row]->setCalcMtd(calcMtd);
    emit layoutChanged();
}
