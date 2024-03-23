using Toybox.Graphics as Gfx;
using Toybox.WatchUi as Ui;
import Toybox.Lang;
import Toybox.Weather;

module myWeather {


    var condition_font_icon = -1;
    var temp = -1;
    var windSpeed = -1;
    var windBearing = -1;
    var rainInMmPerHour = -1;
    var precipitationChance = -1;
    var desc = -1;
    var weatherLastUpdate_Location =-1;
    var highAndLowTemp = -1;


    function update(){
        var conditions = Weather.getCurrentConditions();    
        //Utils.log("conditions "+ conditions);
        if(conditions!=null){
            Utils.persist("condition", conditions.condition);
            Utils.persist("precipitationChance", conditions.precipitationChance);
            Utils.persist("highAndLowTemp", conditions.highTemperature+"/"+conditions.lowTemperature);
            //Utils.persist("weatherLastUpdateGarmin", Utils.getTime());
            //Utils.log("condition "+ conditions.condition);
            /*
            Utils.persist("feelsLikeTemperature", conditions.feelsLikeTemperature);
            Utils.persist("precipitationChance", conditions.precipitationChance);
            Utils.persist("windSpeed", (conditions.windSpeed*3.6).toNumber());
            Utils.persist("windBearing", conditions.windBearing);

            Utils.log("condition "+ conditions.condition);
            Utils.log("feelsLikeTemperature "+ conditions.feelsLikeTemperature);
            Utils.log("precipitationChance "+ conditions.precipitationChance);
            Utils.log("windSpeed "+ (conditions.windSpeed*3.6).toNumber());
            Utils.log("windBearing "+ conditions.windBearing);
            */
        }
    }


    function setWeatherIcon(weather) {
        if( condition_font_icon == -1 or Utils.weatherUpdated){  
            switch(Utils.get_from_storage("condition")){

            // CLEAR
            case Weather.CONDITION_CLEAR:
            case Weather.CONDITION_MOSTLY_CLEAR:
            case Weather.CONDITION_FAIR:
                condition_font_icon = "T";
                break;                     
            case Weather.CONDITION_PARTLY_CLEAR:
            case Weather.CONDITION_THIN_CLOUDS:
            	condition_font_icon = "S";
            	break;    
 

            // CLOUDS    
            case Weather.CONDITION_PARTLY_CLOUDY:
            case Weather.CONDITION_CLOUDY:
            	condition_font_icon = "d";
            	break;
            case Weather.CONDITION_MOSTLY_CLOUDY:
            	condition_font_icon = "c";
            	break;               

            // CLOUDS + RAIN
            case Weather.CONDITION_CLOUDY_CHANCE_OF_RAIN:
            case Weather.CONDITION_UNKNOWN_PRECIPITATION:
            	condition_font_icon = "Q";
            	break;

            // SHOWERS
            case Weather.CONDITION_LIGHT_SHOWERS:
            case Weather.CONDITION_SHOWERS:
            case Weather.CONDITION_HEAVY_SHOWERS:
            case Weather.CONDITION_CHANCE_OF_SHOWERS:
            case Weather.CONDITION_SCATTERED_SHOWERS:
            	condition_font_icon = "K";
            	break;
            

            // RAIN
            case Weather.CONDITION_RAIN:
            case Weather.CONDITION_LIGHT_RAIN:
            case Weather.CONDITION_HEAVY_RAIN:
            	condition_font_icon = "J";
            	break;              
            case Weather.CONDITION_FREEZING_RAIN:
            	condition_font_icon = "H";
            	break;   
            case Weather.CONDITION_HAIL:
            	condition_font_icon = "E";
            	break;
            case Weather.CONDITION_DRIZZLE:
            	condition_font_icon = "Q";
            	break;                 



            // RAIN + SNOW
            case Weather.CONDITION_CLOUDY_CHANCE_OF_RAIN_SNOW:       
            case Weather.CONDITION_LIGHT_RAIN_SNOW:
            case Weather.CONDITION_HEAVY_RAIN_SNOW:
            case Weather.CONDITION_RAIN_SNOW:             
            case Weather.CONDITION_CHANCE_OF_RAIN_SNOW:
            	condition_font_icon = "H";
            	break;                                       
                 

            // SNOW
            case Weather.CONDITION_CLOUDY_CHANCE_OF_SNOW:               
            case Weather.CONDITION_SNOW:
            case Weather.CONDITION_LIGHT_SNOW:
            case Weather.CONDITION_CHANCE_OF_SNOW:
            	condition_font_icon = "P";
            	break;
            case Weather.CONDITION_HEAVY_SNOW:
            	condition_font_icon = "O";
            	break;   
            case Weather.CONDITION_ICE_SNOW:
            case Weather.CONDITION_ICE:
            	condition_font_icon = "`";
            	break;      
            case Weather.CONDITION_SLEET:
            	condition_font_icon = "M";
            	break;   
                                                      


            // THUNDERSTORMS
            case Weather.CONDITION_SCATTERED_THUNDERSTORMS:
            case Weather.CONDITION_CHANCE_OF_THUNDERSTORMS:
            case Weather.CONDITION_THUNDERSTORMS:
            	condition_font_icon = "N";
            	break;  

            case Weather.CONDITION_TROPICAL_STORM:    
            	condition_font_icon = "R";
            	break;  

            // WIND + STORM
            case Weather.CONDITION_WINDY:
            	condition_font_icon = "C";
            	break;
            case Weather.CONDITION_WINTRY_MIX:
            	condition_font_icon = "A";
            	break;

            // FOG / HAZE    
            case Weather.CONDITION_FOG:
            case Weather.CONDITION_MIST:
            	condition_font_icon = "D";
            	break;
            case Weather.CONDITION_HAZY:
            case Weather.CONDITION_HAZE:
            	condition_font_icon = "F";
            	break;                


            
            case Weather.CONDITION_DUST:
            case Weather.CONDITION_SAND:
            	condition_font_icon = "X";
            	break;


            // SAND
            case Weather.CONDITION_TORNADO:
            case Weather.CONDITION_SANDSTORM:
            	condition_font_icon = "V";
            	break;                
     

            case Weather.CONDITION_SQUALL:
            	condition_font_icon = "V";
            	break;

            case Weather.CONDITION_VOLCANIC_ASH:
            case Weather.CONDITION_SMOKE:
            case Weather.CONDITION_HURRICANE:
            case Weather.CONDITION_UNKNOWN:
            	condition_font_icon = "_";
            	break;  
            default:
                condition_font_icon="_";
                break;
            }
        }  
        weather.setFont(Utils.getWeatherFont());
        weather.setText(condition_font_icon.toString());
    }
    function setWeatherFeelsLike(weather) {
        if(temp == -1 or Utils.weatherUpdated){
            temp = Utils.round(Utils.get_number_from_storage("feelsLikeTemperature")).toString()+"º";
        }  
        weather.setText(temp);
    }
    function setWeatherWindSpeed(weather) {
        if( windSpeed == -1 or Utils.weatherUpdated){  
            windSpeed = Utils.round((Utils.get_number_from_storage("windSpeed"))).toString();
        }
        weather.setText(windSpeed);
    }
    function setWeatherWindDirection(weather) {
        if(windBearing == -1 or Utils.weatherUpdated){
            windBearing = Utils.get_from_storage("windBearing");
        }
        weather.setText(windBearing+"º");
    }
    function setWeatherRainInMmPerHour(weather) {
        if(rainInMmPerHour == -1 or Utils.weatherUpdated){
            rainInMmPerHour = Utils.get_number_from_storage("rainInMmPerHour").format("%.1f").toString();
        }
        weather.setText(rainInMmPerHour);     
    }    
    function setWeatherPop(weather) {
        if(precipitationChance == -1 or Utils.weatherUpdated){
            precipitationChance = Utils.get_number_from_storage("precipitationChance").format("%.1f").toString();
        }
        weather.setText(precipitationChance+"%");
    }      
    /*      
    function setWeatherDesc(weather) {
        weather.setFont(Ui.loadResource(Rez.Fonts.titillium16));
        weather.setText(Utils.get_from_storage("weatherCondition").toString().toUpper());
    }  */ 

    function setWeatherDescGarmin(weather) {
        if(desc == -1 or Utils.weatherUpdated){
            switch(Utils.get_from_storage("condition")){
            case Weather.CONDITION_CLEAR:
            	desc = "clear";
            	break;
            case Weather.CONDITION_PARTLY_CLOUDY:
            	desc = "partly cloudy";
            	break;
            case Weather.CONDITION_MOSTLY_CLOUDY:
            	desc = "mostly cloudy";
            	break;
            case Weather.CONDITION_RAIN:
            	desc = "rain";
            	break;
            case Weather.CONDITION_SNOW:
            	desc = "snow";
            	break;
            case Weather.CONDITION_WINDY:
            	desc = "windy";
            	break;
            case Weather.CONDITION_THUNDERSTORMS:
            	desc = "thunderstorms";
            	break;
            case Weather.CONDITION_WINTRY_MIX:
            	desc = "wintry mix";
            	break;
            case Weather.CONDITION_FOG:
            	desc = "fog";
            	break;
            case Weather.CONDITION_HAZY:
            	desc = "hazy";
            	break;
            case Weather.CONDITION_HAIL:
            	desc = "hail";
            	break;
            case Weather.CONDITION_SCATTERED_SHOWERS:
            	desc = "scattered showers";
            	break;
            case Weather.CONDITION_SCATTERED_THUNDERSTORMS:
            	desc = "scattered thunderstorms";
            	break;
            case Weather.CONDITION_UNKNOWN_PRECIPITATION:
            	desc = "unknown precipitation";
            	break;
            case Weather.CONDITION_LIGHT_RAIN:
            	desc = "light rain";
            	break;
            case Weather.CONDITION_HEAVY_RAIN:
            	desc = "heavy rain";
            	break;
            case Weather.CONDITION_LIGHT_SNOW:
            	desc = "light snow";
            	break;
            case Weather.CONDITION_HEAVY_SNOW:
            	desc = "heavy snow";
            	break;
            case Weather.CONDITION_LIGHT_RAIN_SNOW:
            	desc = "light rain snow";
            	break;
            case Weather.CONDITION_HEAVY_RAIN_SNOW:
            	desc = "heavy rain snow";
            	break;
            case Weather.CONDITION_CLOUDY:
            	desc = "cloudy";
            	break;
            case Weather.CONDITION_RAIN_SNOW:
            	desc = "rain snow";
            	break;
            case Weather.CONDITION_PARTLY_CLEAR:
            	desc = "partly clear";
            	break;
            case Weather.CONDITION_MOSTLY_CLEAR:
            	desc = "mostly clear";
            	break;
            case Weather.CONDITION_LIGHT_SHOWERS:
            	desc = "light showers";
            	break;
            case Weather.CONDITION_SHOWERS:
            	desc = "showers";
            	break;
            case Weather.CONDITION_HEAVY_SHOWERS:
            	desc = "heavy showers";
            	break;
            case Weather.CONDITION_CHANCE_OF_SHOWERS:
            	desc = "chance of showers";
            	break;
            case Weather.CONDITION_CHANCE_OF_THUNDERSTORMS:
            	desc = "chance of thunderstorms";
            	break;
            case Weather.CONDITION_MIST:
            	desc = "mist";
            	break;
            case Weather.CONDITION_DUST:
            	desc = "dust";
            	break;
            case Weather.CONDITION_DRIZZLE:
            	desc = "drizzle";
            	break;
            case Weather.CONDITION_TORNADO:
            	desc = "tornado";
            	break;
            case Weather.CONDITION_SMOKE:
            	desc = "smoke";
            	break;
            case Weather.CONDITION_ICE:
            	desc = "ice";
            	break;
            case Weather.CONDITION_SAND:
            	desc = "sand";
            	break;
            case Weather.CONDITION_SQUALL:
            	desc = "squall";
            	break;
            case Weather.CONDITION_SANDSTORM:
            	desc = "sandstorm";
            	break;
            case Weather.CONDITION_VOLCANIC_ASH:
            	desc = "volcanic ash";
            	break;
            case Weather.CONDITION_HAZE:
            	desc = "haze";
            	break;
            case Weather.CONDITION_FAIR:
            	desc = "fair";
            	break;
            case Weather.CONDITION_HURRICANE:
            	desc = "hurricane";
            	break;
            case Weather.CONDITION_TROPICAL_STORM:
            	desc = "tropical storm";
            	break;
            case Weather.CONDITION_CHANCE_OF_SNOW:
            	desc = "chance of snow";
            	break;
            case Weather.CONDITION_CHANCE_OF_RAIN_SNOW:
            	desc = "chance of rain snow";
            	break;
            case Weather.CONDITION_CLOUDY_CHANCE_OF_RAIN:
            	desc = "cloudy chance of rain";
            	break;
            case Weather.CONDITION_CLOUDY_CHANCE_OF_SNOW:
            	desc = "cloudy chance of snow";
            	break;
            case Weather.CONDITION_CLOUDY_CHANCE_OF_RAIN_SNOW:
            	desc = "cloudy chance of rain snow";
            	break;
            case Weather.CONDITION_FLURRIES:
            	desc = "flurries";
            	break;
            case Weather.CONDITION_FREEZING_RAIN:
            	desc = "freezing rain";
            	break;
            case Weather.CONDITION_SLEET:
            	desc = "sleet";
            	break;
            case Weather.CONDITION_ICE_SNOW:
            	desc = "ice snow";
            	break;
            case Weather.CONDITION_THIN_CLOUDS:
            	desc = "thin clouds";
            	break;
            case Weather.CONDITION_UNKNOWN:
            	desc = "unknown";
            	break;
            }
        }
        weather.setFont(Utils.getWeatherDescFont());
        weather.setText(desc.toUpper());
    }  
    // If lat and long are empty, it means position is not found.
    function setWeatherCity(weather) {
        //var lat = Utils.get_number_from_storage("lat").format("%.2f");
		//var lon = Utils.get_number_from_storage("lon").format("%.2f");
        
        // API weather last update + API weather city (using garmin position) + lat lon using garmin position
        //weather.setText(Utils.get_from_storage("weatherLastUpdate")+" "+Utils.get_from_storage("weatherLocation")+" ["+lat+", "+lon+"]");
        if(weatherLastUpdate_Location== -1 or Utils.weatherUpdated){
            weatherLastUpdate_Location = Utils.get_from_storage("weatherLastUpdate")+" "+Utils.get_from_storage("weatherLocation");
        }        
        weather.setFont(Utils.getWeatherCityFont());
        weather.setText(weatherLastUpdate_Location);
    }  
    /*
    function setGarminWeatherLastUpdate(weather) {
        weather.setColor(Gfx.COLOR_YELLOW);
        weather.setText(Utils.get_from_storage("weatherLastUpdateGarmin").toString());
    }  
    */
    function setWeatherHighLowTemp(weather) {
        if(highAndLowTemp== -1 or Utils.weatherUpdated){
            highAndLowTemp = Utils.get_from_storage("highAndLowTemp").toString();
        }
        weather.setText(highAndLowTemp);
    }   


}