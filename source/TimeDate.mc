import Toybox.System;
import Toybox.Lang;
using Toybox.Time.Gregorian as Gre;
using Toybox.Graphics as Gfx;
using Toybox.Time;
import Toybox.Application.Properties;

module TimeDate {
    var clockTime, hours, moment, day_number, day_of_week;
    var txt_height, txt_width, txt_x, txt_y;
    var x, y_top, y_bot;
    var daynum_txt_y, dayofweek_txt_y;  
    var _totalSwimDistance  = -1;
    var _totalCycleDistance = -1;
    var _totalRunDistance   = -1; 

    var _totalSwimDistanceLastWeek  = -1;
    var _totalCycleDistanceLastWeek = -1;
    var _totalRunDistanceLastWeek   = -1; 

    function setTimeDate(dc){
         // Get the current time and format it correctly
        clockTime = System.getClockTime();
        hours = clockTime.hour;
        if (!System.getDeviceSettings().is24Hour) {
            if (hours > 12) {
                hours = hours - 12;
            }
        }

        moment = Time.now();
        day_number = (Gre.info(moment, Time.FORMAT_LONG).day).toString();
        day_of_week = Gre.info(moment, Time.FORMAT_LONG).day_of_week.toUpper();
        
        var hoursString = hours.format("%02d");
        var minString = clockTime.min.format("%02d");

        var doneColor = Properties.getValue("time_done_color");
        var todoColor = Properties.getValue("time_todo_color");

        if(_totalSwimDistance == -1){
            _totalSwimDistance = Utils.get_number_from_storage("totalSwimDistance");
        }
        if(_totalCycleDistance == -1){
            _totalCycleDistance = Utils.get_number_from_storage("totalCycleDistance");
        }
        if(_totalRunDistance == -1){
            _totalRunDistance = Utils.get_number_from_storage("totalRunDistance");
        }

        // during the first hours of the week while no activity is recorded use last week totals
        if(_totalSwimDistance == 0 and _totalCycleDistance == 0 and _totalRunDistance == 0){
            if(_totalSwimDistanceLastWeek == -1){
                _totalSwimDistance = Utils.get_number_from_storage("totalSwimDistanceLastWeek");
            }
            if(_totalCycleDistanceLastWeek == -1){
                _totalCycleDistance = Utils.get_number_from_storage("totalCycleDistanceLastWeek");
            }
            if(_totalRunDistanceLastWeek == -1){
                _totalRunDistance = Utils.get_number_from_storage("totalRunDistanceLastWeek");
            }
        }

        var swim_per = (_totalSwimDistance.toFloat()/1000)/Properties.getValue("swim_goal");
        var bike_per = (_totalCycleDistance.toFloat()/1000)/Properties.getValue("bike_goal");
        var run_per = (_totalRunDistance.toFloat()/1000)/Properties.getValue("run_goal");

        
        //swim_per = 0.25;
        //bike_per = 0.50;
        //run_per = 0.75;
        //

        if(swim_per>1){
            swim_per = 1;
        }
        if(bike_per>1){
            bike_per = 1;
        }
        if(run_per>1){
            run_per = 1;
        }


        var font = Utils.getTimeFont();
        var date_font = Utils.getDateFont();

        var x_time_sep = 110;
        var y_time_sep = 130;

        //dc.setColor(Gfx.COLOR_BLACK, Gfx.COLOR_YELLOW);
        dc.setColor(Gfx.COLOR_BLACK, Gfx.COLOR_TRANSPARENT);
        dc.drawText(x_time_sep, y_time_sep, font, ":", Gfx.TEXT_JUSTIFY_CENTER|Gfx.TEXT_JUSTIFY_VCENTER);

        // hours
        txt_height = 55;
        txt_width = dc.getTextWidthInPixels(hoursString,font);
        txt_x = x_time_sep - txt_width/2 - 15;
        txt_y = 133;

        x = txt_x - txt_width/2+1;
        y_top = txt_y - txt_height/2 + 3;
        y_bot = txt_y + txt_height/2 + 3;

        // todo box
        dc.setColor(todoColor,Gfx.COLOR_TRANSPARENT);
        dc.fillRectangle(x, y_top, txt_width-1, txt_height);
        // done box
        dc.setColor(doneColor,Gfx.COLOR_TRANSPARENT);
        dc.fillRectangle(x, y_bot-txt_height*swim_per, txt_width-1, txt_height*swim_per+1);

        // magic        
        dc.setColor(Gfx.COLOR_TRANSPARENT,Gfx.COLOR_WHITE);
        dc.setClip(x, y_top, txt_width+5, txt_height);
        dc.drawText(txt_x, txt_y, font, hoursString, Gfx.TEXT_JUSTIFY_CENTER|Gfx.TEXT_JUSTIFY_VCENTER);
        dc.clearClip();

        dc.setColor(todoColor, Gfx.COLOR_TRANSPARENT);

        // min
        txt_width = dc.getTextWidthInPixels(minString,font);
        txt_x = x_time_sep + dc.getTextWidthInPixels(":",font) + 30;

        x = txt_x - txt_width/2 + 1;
        y_top = txt_y - txt_height/2 + 3;
        y_bot = txt_y + txt_height/2 + 3;

        // todo box
        dc.setColor(todoColor,Gfx.COLOR_TRANSPARENT);
        dc.fillRectangle(x, y_top, txt_width-1, txt_height-1);
        // done box
        dc.setColor(doneColor,Gfx.COLOR_TRANSPARENT);
        dc.fillRectangle(x, y_bot-txt_height*bike_per, txt_width-1, txt_height*bike_per);

        // magic       
        dc.setColor(Gfx.COLOR_TRANSPARENT,Gfx.COLOR_WHITE);
        dc.setClip(x, y_top, txt_width+5, txt_height-1);
        dc.drawText(txt_x, txt_y, font, minString, Gfx.TEXT_JUSTIFY_CENTER|Gfx.TEXT_JUSTIFY_VCENTER);
        dc.clearClip();

        dc.setColor(todoColor, Gfx.COLOR_TRANSPARENT);


        // date
        var daynum_txt_height = 30;
        var dayofweek_txt_height = 28;
        var daynum_txt_width = dc.getTextWidthInPixels(day_number,date_font);
        var dayofweek_txt_width = dc.getTextWidthInPixels(day_of_week,date_font);
        var daynum_txt_x = 230;
        var dayofweek_txt_x = 235;
        daynum_txt_y = 121;    
        dayofweek_txt_y = 149;    

        var daynum_x = daynum_txt_x - daynum_txt_width/2f;
        var dayofweek_x = dayofweek_txt_x - dayofweek_txt_width/2f;
        var daynum_y_top = daynum_txt_y - daynum_txt_height/2f + 3;
        var daynum_y_bot = daynum_txt_y + daynum_txt_height/2f + 3;
        //var dayofweek_y_top = dayofweek_txt_y - dayofweek_txt_height/2f +2;
        var dayofweek_y_bot = dayofweek_txt_y + dayofweek_txt_height/2f + 1;
        
        // daynum todo box
        dc.setColor(todoColor,Gfx.COLOR_TRANSPARENT);
        dc.fillRectangle(daynum_x+1, daynum_y_top, daynum_txt_width-1, daynum_txt_height);
        // Tue
        dc.fillRectangle(dayofweek_x+1, dayofweek_y_bot-dayofweek_txt_height, dayofweek_txt_width-1, dayofweek_txt_height+1);
        // done box
        dc.setColor(doneColor,Gfx.COLOR_TRANSPARENT);
        if(run_per>0.5){
            dc.fillRectangle(daynum_x+1, daynum_y_bot-daynum_txt_height*(run_per-0.5)*2, daynum_txt_width-1, daynum_txt_height*(run_per-0.5)*2);
            dc.fillRectangle(dayofweek_x+1, dayofweek_y_bot-dayofweek_txt_height, dayofweek_txt_width-1, dayofweek_txt_height+1);
        }
        else{
            dc.fillRectangle(dayofweek_x+1, dayofweek_y_bot-dayofweek_txt_height*run_per*2, dayofweek_txt_width-1, dayofweek_txt_height*run_per*2+1);
        }

        // magic       
        dc.setColor(Gfx.COLOR_TRANSPARENT,Gfx.COLOR_WHITE);
        
        dc.setClip(daynum_x, daynum_y_top, daynum_txt_width, daynum_txt_height);
        dc.drawText(daynum_txt_x, daynum_txt_y, Utils.getDateFont(), day_number, Gfx.TEXT_JUSTIFY_CENTER|Gfx.TEXT_JUSTIFY_VCENTER);
        dc.clearClip();
        dc.setClip(dayofweek_x, dayofweek_y_bot-dayofweek_txt_height, dayofweek_txt_width, dayofweek_txt_height+1);
        dc.drawText(dayofweek_txt_x, dayofweek_txt_y, Utils.getDateFont(), day_of_week, Gfx.TEXT_JUSTIFY_CENTER|Gfx.TEXT_JUSTIFY_VCENTER);    
        dc.clearClip();

        dc.setColor(todoColor, Gfx.COLOR_TRANSPARENT);

        //dc.setColor(Gfx.COLOR_BLACK, Gfx.COLOR_LT_GRAY);
    }
}