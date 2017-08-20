#ifndef RECIPEELEMENT_H
#define RECIPEELEMENT_H

#include <QObject>
#include <QVector>
#include <QDebug>

class RecipeElement : public QObject
{
    Q_OBJECT
    Q_PROPERTY(QString compName READ compName WRITE setCompName NOTIFY compNameChanged)
    Q_PROPERTY(double quantity READ quantity WRITE setQuantity NOTIFY quantityChanged)
    Q_PROPERTY(QString calcMtd READ calcMtd WRITE setCalcMtd NOTIFY calcMtdChanged)
public:
    explicit RecipeElement(QString sCompName, double sQuantity, QString sCalcMtd="x1", QObject *parent = nullptr);

signals:
    void compNameChanged(QString compName);
    void quantityChanged(double quantity);
    void calcMtdChanged(QString calcMtd);

public slots:
    QString compName();
    double quantity();
    QString calcMtd();

    int setCompName(QString compName);
    int setQuantity(double quantity);
    int setQuantity(QString quantity);
    int setCalcMtd(QString calcMtd);

private:
    QList<QString> m_acceptableCalcMtd;
    enum Exception{ValueError=1};

    QString m_compName;
    double m_quantity;
    QString m_calcMtd;
};

#endif // RECIPEELEMENT_H
