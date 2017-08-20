#include "recipetitlemodel.h"

RecipeTitleModel::RecipeTitleModel()
{

}

QHash<int, QByteArray> RecipeTitleModel::roleNames() const
{
    QHash<int, QByteArray>roles;
    roles[TitleRole] = "title";
    return roles;
}
