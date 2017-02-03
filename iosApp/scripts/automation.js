//UIALogger.logDebug("Now setting up the alert function");
UIATarget.onAlert = function onAlert(alert) 
{
    var title = alert.name();
    UIALogger.logWarning("Alert with title ’" + title + "’ encountered!");
    
    if (/Motion Activity/i.test(title) || /Send You Notifications/i.test(title))
    {
        UIALogger.logDebug("entered if with title " + title);
        alert.buttons()["OK"].tap();
        return true;
    }
    else if (/access your location/i.test(title))
    {
        UIALogger.logDebug("entered if with title " + title);
        alert.buttons()["Allow"].tap();
        return true;
    }
    else
    {
        UIALogger.logDebug("entered else with title " + title);
        // if (alert.cancelButton()) 
        // {
        //     alert.cancelButton().tap();
        //     return true;
        // }; 
        return false;
    }
}

var target = UIATarget.localTarget();

target.delay( 7 );

//var app = target.frontMostApp();
//var window = app.mainWindow();

//UIALogger.logDebug("Log Element Tree");
//app.logElementTree();

//target.delay( 3 );

UIALogger.logDebug("Starting script");
target.frontMostApp().mainWindow().scrollViews()[0].textFields()[0].textFields()[0].tap();
target.frontMostApp().keyboard().typeString("john@appleseed.com");
target.frontMostApp().mainWindow().scrollViews()[0].secureTextFields()[0].secureTextFields()[0].tap();
target.frontMostApp().keyboard().typeString("john\n");
target.frontMostApp().mainWindow().scrollViews()[0].buttons()["LOGIN"].tap();

target.delay( 5 );

target.frontMostApp().navigationBar().buttons()["ico menu threelines"].tap();
target.frontMostApp().mainWindow().tableViews()[0].tapWithOptions({tapOffset:{x:0.31, y:0.04}});
UIALogger.logDebug("Dashboard");

target.delay( 2 );

target.frontMostApp().navigationBar().buttons()["ico menu threelines"].tap();
target.frontMostApp().mainWindow().tableViews()[0].tapWithOptions({tapOffset:{x:0.38, y:0.17}});
UIALogger.logDebug("Challenges");

target.delay( 2 );

target.frontMostApp().navigationBar().buttons()["ico menu threelines"].tap();
target.frontMostApp().mainWindow().tableViews()[0].tapWithOptions({tapOffset:{x:0.35, y:0.23}});
UIALogger.logDebug("History");

target.delay( 2 );

target.frontMostApp().navigationBar().buttons()["ico menu threelines"].tap();
target.frontMostApp().mainWindow().tableViews()[0].tapWithOptions({tapOffset:{x:0.33, y:0.34}});
UIALogger.logDebug("Settings");

target.delay( 2 );

target.frontMostApp().navigationBar().buttons()["ico menu threelines"].tap();
target.frontMostApp().mainWindow().tableViews()[0].tapWithOptions({tapOffset:{x:0.40, y:0.43}});
UIALogger.logDebug("Assessment");

target.delay(1);
target.frontMostApp().mainWindow().tableViews()[1].cells()["Demographics"].tapWithOptions({tapOffset:{x:0.85, y:0.57}});
target.delay(1);
target.frontMostApp().navigationBar().leftButton().tap();
target.delay(2);
target.frontMostApp().mainWindow().tableViews()[1].tapWithOptions({tapOffset:{x:0.87, y:0.27}});
target.delay(1);
target.frontMostApp().navigationBar().leftButton().tap();
target.delay(2);
target.frontMostApp().mainWindow().tableViews()[1].tapWithOptions({tapOffset:{x:0.85, y:0.45}});
target.delay(1);
target.frontMostApp().navigationBar().leftButton().tap();
target.delay(2);
target.frontMostApp().mainWindow().tableViews()[1].tapWithOptions({tapOffset:{x:0.85, y:0.62}});
target.delay(1);
target.frontMostApp().navigationBar().leftButton().tap();
target.delay(2);
target.frontMostApp().mainWindow().tableViews()[1].tapWithOptions({tapOffset:{x:0.87, y:0.81}});
target.delay(1);
target.frontMostApp().navigationBar().buttons()[0].tap();
target.delay( 2 );

target.frontMostApp().navigationBar().buttons()["ico menu threelines"].tap();
target.frontMostApp().mainWindow().elements()["HEALTH ASSESSMENT"].buttons()["ico menu threelines"].tap();

target.delay( 2 );

UIALogger.logDebug("Test Passed");
