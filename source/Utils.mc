using Toybox.WatchUi as Ui;
using Toybox.Time;
using Toybox.Time.Gregorian;
using Toybox.Lang;
using Toybox.System;
import Toybox.Application.Storage;

using Toybox.Position;

(:background)
module Utils {

    var timeFont = null;
    var dateFont = null;
    var iconsFont = null;
    var weatherFont = null;
    var weatherDescFont = null;
    var weatherCityFont = null;

    var weatherUpdated = false;

    function getTimeFont() {
        if (timeFont == null) {
            timeFont = Ui.loadResource(Rez.Fonts.TimeFont1);
        }
        return timeFont; 
    }

    function getDateFont() {
        if (dateFont == null) {
            dateFont = Ui.loadResource(Rez.Fonts.DateFont);
        }
        return dateFont; 
    }

    function getWeatherFont() {
        if (weatherFont == null) {
            weatherFont = Ui.loadResource(Rez.Fonts.WeatherFont);
        }
        return weatherFont; 
    }

    function getIconsFont() {
        if (iconsFont == null) {
            iconsFont = Ui.loadResource(Rez.Fonts.iconsFont);
        }
        return iconsFont; 
    }

    function getWeatherDescFont() {
        if (weatherDescFont == null) {
            weatherDescFont = Ui.loadResource(Rez.Fonts.titillium16);
        }
        return weatherDescFont; 
    }

    function getWeatherCityFont() {
        if (weatherCityFont == null) {
            weatherCityFont = Ui.loadResource(Rez.Fonts.arial15);
        }
        return weatherCityFont; 
    }    
    

    function getDateFromEpoch(epoch) {
        var today = Gregorian.info(new Time.Moment(epoch), Time.FORMAT_SHORT);
        var dateString = Lang.format(
            "$1$:$2$:$3$  $4$/$5$/$6$", 
            [today.hour.format("%02d"), today.min.format("%02d"),today.sec.format("%02d"), 
            today.day, today.month,today.year]);
        return dateString;
    }

    function getDate(epoch) {
        var today = Gregorian.info(new Time.Moment(epoch), Time.FORMAT_SHORT);
        var dateString = Lang.format(
            "$1$/$2$/$3$", 
            [today.day, today.month,today.year]);
        return dateString;
    }   

    function getTime() {
        var clockTime = System.getClockTime();
        var hours = clockTime.hour.format("%02d");
        var mins = clockTime.min.format("%02d");
        return hours+":"+mins;
    }  

    function getTodayDate() {
        return getDateFromEpoch(Time.now().value()).substring(0, 8); 
    }  

    function log(msg){
        System.println(getTodayDate()+" - "+msg);
    }

    function getEpochFitDate(Fitepoch){
        return getDateFromEpoch(Fitepoch+631065600); ////FIT Epoch time is 20y behind unix 
    }

    function getLastSundayEpoch(){
        var today = Gregorian.info(Time.now(), Time.FORMAT_SHORT);
        return Time.today().value()-((today.day_of_week-1)*24*3600);
        
    }

    function round(float){
        if(float-float.toNumber()>0.5){
            return float.toNumber()+1;
        }
        else{
            return float.toNumber();
        }
    }

    function persist(key,value) {
        Storage.setValue(key, value);
    }

    function get_from_storage(key) {
        var value = Storage.getValue(key);
        if (value == null) {
            value = "Er";
        }
        return value;
    } 

    function get_number_from_storage(key) {
        var value = Storage.getValue(key);
        if (value == null) {
            value = -2;
        }
        return value;
    } 

    function getPosition(){
        var info = Position.getInfo();
        //if (info != null && info.accuracy != Position.QUALITY_NOT_AVAILABLE) {
        if (info != null) {
            var pos = info.position.toDegrees();
            persist("lat", pos[0]);
            persist("lon", pos[1]);
            log("[getPosition] called. returned "+pos);
        }  
        else{
            log("position is null. Using last registered position");
        }
    }

    function weatherUpdateFlag(flag){
        weatherUpdated = flag;
    }
}