using Toybox.Background;
using Toybox.System as Sys;
using Toybox.Communications as Comm;
using Toybox.Application as App;
using Toybox.Lang as Lang;
import Toybox.Application.Storage;

// The Service Delegate is the main entry point for background processes
// our onTemporalEvent() method will get run each time our periodic event
// is triggered by the system.
//
(:background)
class BackgroundServiceDelegate extends Sys.ServiceDelegate 
{
	 
	function initialize() 
	{
		Sys.ServiceDelegate.initialize();
	}
	
    function onTemporalEvent() 
    {
    	try
    	{
			// request update without condition, maybe i should check if bluetooth is enabled
			Utils.log("onTemporalEvent called (every 30min)");
			// update lat and lon in storage
			Utils.getPosition();
			getCityFromPosition();
			getWeather();
			Utils.weatherUpdateFlag(true);
		}
		catch(ex)
		{
			Utils.log("[onTemporalEvent] [TRY_CATCH] error: " + ex.getErrorMessage());
			Background.exit(null);
		}		 
    }
    

	function getCityFromPosition()
    {
		var lat = Utils.get_number_from_storage("lat");
		var lon = Utils.get_number_from_storage("lon");
		var url = "https://api.openweathermap.org/geo/1.0/reverse?lat="+lat+"&lon="+lon+"&limit=1&appid=77cd6940bcb81de2e9f2e58d7ae65c39";

        Utils.log("[getCityFromPosition] url "+url);
		var options = {
			:method => Comm.HTTP_REQUEST_METHOD_GET,
            :responseType => Communications.HTTP_RESPONSE_CONTENT_TYPE_JSON
        };

        Comm.makeWebRequest(
            url,
            {},
            options,
            method(:OnReceivePosition)
        );  	
    }

    function OnReceivePosition(responseCode as Lang.Number, data as Null or Lang.Dictionary or Lang.String) as Void
	{
		try
		{
			if (responseCode == 200)
			{
				//Utils.log("Position responseCode == 200");
				var city = data[0]["name"];
				Utils.persist("weatherLocation", city);

			}
			else
			{
				Utils.log("[OnReceivePosition] ERROR "+responseCode);
			}

			//Background.exit(_received);
		}
		catch(ex)
		{
			Sys.println("[OnReceivePosition] [TRY_CATCH] error : " + ex.getErrorMessage());
			Background.exit(null);
		}
	}


	function getWeather()
    {

		//var position = [38.855385, -94.799644];
		var lat = Utils.get_number_from_storage("lat");
		var lon = Utils.get_number_from_storage("lon");
		var url = "https://api.openweathermap.org/data/3.0/onecall?lat="+lat+"&lon="+lon+"&appid=[YOUR_ID]&units=metric&exclude=hourly,minutely,daily,alerts";
		Utils.log("[getWeather] url "+url);
        //Utils.log("url  = "+url);
		var options = {
			:method => Comm.HTTP_REQUEST_METHOD_GET,
            :responseType => Communications.HTTP_RESPONSE_CONTENT_TYPE_JSON
        };

        Comm.makeWebRequest(
            url,
            {},
            options,
            method(:OnReceiveUpdateWeather)
        );  	
    }

    function OnReceiveUpdateWeather(responseCode as Lang.Number, data as Null or Lang.Dictionary or Lang.String) as Void
	{
		try
		{
			if (responseCode == 200)
			{
				//Utils.log("Weather responseCode == 200");
				var feels_like = data["current"]["feels_like"];
				var wind_speed = data["current"]["wind_speed"];
				var wind_deg = data["current"]["wind_deg"];
				var rain = 0;
				if(data["current"].hasKey("rain")){
					rain = data["current"]["rain"]["1h"];
				}
				//var precipitation = data["minutely"][1]["precipitation"];
				//var daily_pop = data["daily"]["pop"];
				var description = data["current"]["weather"][0]["description"];

            	Utils.persist("feelsLikeTemperature", feels_like);
            	Utils.persist("rainInMmPerHour", rain);
            	Utils.persist("windSpeed", wind_speed*3.6);
            	Utils.persist("windBearing", wind_deg);
				Utils.persist("weatherCondition", description);
				Utils.persist("weatherLastUpdate", Utils.getTime());
				/*
				System.println("feels_like  "+feels_like);
				System.println("wind_speed  "+wind_speed);
				System.println("wind_deg  "+wind_deg);
				//System.println("precipitation  "+precipitation);
				System.println("description	"+description);

				System.println("rain	"+rain+" mm/h");
				//System.println("daily_pop	"+daily_pop);
				*/

			}
			else
			{
				Utils.log("[OnReceiveUpdateWeather] ERROR "+responseCode);
			}

			//Background.exit(_received);
		}
		catch(ex)
		{
			Sys.println("[OnReceiveUpdateWeather] [TRY_CATCH] error : " + ex.getErrorMessage());
			Background.exit(null);
		}
	}

}
