import Toybox.Application;
import Toybox.WatchUi;
import Toybox.Lang;
using Toybox.Time;
using Toybox.Background;


(:background)
class TriathlonWatchApp extends Application.AppBase {

    function initialize() {
        AppBase.initialize();
    }

    // onStart() is called on application start up
    function onStart(state as Dictionary?) as Void {
        //Utils.log("On START");
    }

    // onStop() is called when your application is exiting
    function onStop(state as Dictionary?) as Void {
    }

    // Return the initial view of your application here
    function getInitialView() as Array<Views or InputDelegates>? {
        InitBackgroundEvents();
        return [ new ironmanWatchView() ] as Array<Views or InputDelegates>;
    }

    // New app settings have been received so trigger a UI update
    function onSettingsChanged() as Void {
        WatchUi.requestUpdate();
    }

    
    function onBackgroundData(d) {
        WatchUi.requestUpdate();
    }    

    function getServiceDelegate()
    {
        return [new BackgroundServiceDelegate()];
    }
    
    function InitBackgroundEvents()
    {
        //Utils.log("InitBackgroundEvents");
        /*        
        var FIVE_MINUTES = new Time.Duration(20 * 60);
        var eventTime = Time.now().add(FIVE_MINUTES);
        Background.registerForTemporalEvent(eventTime);
        */
    	Background.registerForTemporalEvent(new Time.Duration(30 * 60));
    }

}

function getApp() as TriathlonWatchApp {
    return Application.getApp() as TriathlonWatchApp;
}