#include <QGuiApplication>
#include <QQmlApplicationEngine>
#include <QQmlContext>
#include "recipetitlemodel.h"

int main(int argc, char *argv[])
{
    QGuiApplication app(argc, argv);

    //RecipeModel recipeModel;
    //recipeModel.addElement(new RecipeElement("RATE",1));
    //recipeModel.addElement(new RecipeElement("size",8,"^2"));
    //recipeModel.addElement(new RecipeElement("powder",500));
    //recipeModel.addElement(new RecipeElement("butter",100));

    RecipeTitleModel recipes;
    recipes.newRecipeModel();

    QQmlApplicationEngine engine;
    QQmlContext* ctxt = engine.rootContext();
    ctxt->setContextProperty("recipeTitleModel",&recipes);
    engine.load(QUrl(QStringLiteral("qrc:/main.qml")));
    if (engine.rootObjects().isEmpty())
        return -1;

    return app.exec();
}
