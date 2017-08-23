#include "recipeelement.h"

RecipeElement::RecipeElement(QString sCompName, double sQuantity, QString sCalcMtd, QObject *parent) : QObject(parent)
{
    m_acceptableCalcMtd = {"x0","x1","^2"};
    setCompName(sCompName);
    setQuantity(sQuantity);
    if (setCalcMtd(sCalcMtd) != 0)
        qDebug() << "Failed to set CalcMtd to" << sCalcMtd;
}

QString RecipeElement::compName()
{
    return m_compName;
}

QString RecipeElement::calcMtd()
{
    return m_calcMtd;
}

double RecipeElement::quantity()
{
    return m_quantity;
}

int RecipeElement::setCompName(QString compName)
{
    m_compName = compName;
    emit compNameChanged(m_compName);
    return 0;
}

int RecipeElement::setCalcMtd(QString calcMtd)
{
    bool acceptable = false;
    for(QString i : m_acceptableCalcMtd)
        if (calcMtd == i)
        {
            acceptable = true;
            break;
        }
    if (!acceptable)  return ValueError;

    m_calcMtd = calcMtd;
    emit calcMtdChanged(m_calcMtd);
    return 0;
}

int RecipeElement::setQuantity(double quantity)
{
    m_quantity = quantity;
    emit quantityChanged(m_quantity);
    return 0;
}

int RecipeElement::setQuantity(QString quantity)
{
    return setQuantity(quantity.toDouble());
}
