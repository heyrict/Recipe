#include <QGuiApplication>
#include <QQmlApplicationEngine>
#include <QQmlContext>
#include "recipeelement.h"
#include "recipemodel.h"

int main(int argc, char *argv[])
{
    QGuiApplication app(argc, argv);

    RecipeModel recipeModel;
    recipeModel.addElement(new RecipeElement("RATE",1));
    recipeModel.addElement(new RecipeElement("size",8,"^2"));
    recipeModel.addElement(new RecipeElement("powder",500));
    recipeModel.addElement(new RecipeElement("butter",100));

    QQmlApplicationEngine engine;
    QQmlContext* ctxt = engine.rootContext();
    ctxt->setContextProperty("recipeModel",&recipeModel);
    engine.load(QUrl(QStringLiteral("qrc:/main.qml")));
    if (engine.rootObjects().isEmpty())
        return -1;

    return app.exec();
}
