import Toybox.Lang;
import Toybox.Graphics;
using Toybox.Activity;
using Toybox.UserProfile;
import Toybox.ActivityMonitor;
import Toybox.Time;
using Toybox.SensorHistory;
using Toybox.Time.Gregorian as Gre;
import Toybox.System;

module Triathlon {
    var sample;
    var type;
    var distance;

    var userActivityIterator;
    var activityTime;

    var _totalSwimDistance = -1;
    var _totalCycleDistance = -1;
    var _totalRunDistance = -1;

    var _totalSwimDistance_lastweek = -1;
    var _totalCycleDistance_lastweek = -1;
    var _totalRunDistance_lastweek = -1;

    var _total_sport_time = -1;
    var hours = -1;
    var min = -1;

    var totalSwimDistance=0;
    var totalCycleDistance=0;
    var totalRunDistance=0;

    var totalSwimDistanceLastWeek=0;
    var totalCycleDistanceLastWeek=0;
    var totalRunDistanceLastWeek=0;

    var lastSundayDate;
    var lastlastSundayDate;

    var totalDuration;

    // Ascent
    var totalmetersClimbedWeek;
    var total_climbed_this_week_to_now = -1;
    var oneTimepersist = false;

    // get total distances every 30min
    function getThisWeekTotals(){

        oneTimepersist = true;
        
        lastSundayDate = Utils.getLastSundayEpoch(); // Saturday at midnight to include sunday 
        lastlastSundayDate = lastSundayDate - 7*24*3600;
        Utils.log("updating triathlon totals from "+lastSundayDate);
        userActivityIterator = UserProfile.getUserActivityHistory();
        sample = userActivityIterator.next();  
        totalSwimDistance = 0;
        totalCycleDistance = 0;
        totalRunDistance = 0;        

        totalDuration = 0;
        
        totalSwimDistanceLastWeek=0;
        totalCycleDistanceLastWeek=0;
        totalRunDistanceLastWeek=0;

/*
        sample.startTime= new Time.Moment(1709127570);
        sample.distance = 14000;
        sample.duration = new Time.Duration(5500);
        sample.type = Activity.SPORT_RUNNING;
*/
        while (sample!=null) {
            if(sample.startTime!=null){
                // Fit epoch time is 20years behind
                activityTime = sample.startTime.value()+631065600;
                //activityTime = sample.startTime.value();
                if(activityTime>lastSundayDate){
                    type = sample.type;
                    distance = sample.distance;
                    totalDuration += sample.duration.value();
                    switch (type){
                        case Activity.SPORT_SWIMMING:
                            totalSwimDistance+=distance;
                            break;
                        case Activity.SPORT_CYCLING:
                            totalCycleDistance+=distance;
                            break;
                        case Activity.SPORT_RUNNING:
                            totalRunDistance+=distance;
                            break;
                        default:
                            Utils.log("other activity distance "+distance); 
                            break;
                    }
                }
                else if(activityTime<lastSundayDate and activityTime>lastlastSundayDate){
                    type = sample.type;
                    distance = sample.distance;
                    switch (type){
                        case Activity.SPORT_SWIMMING:
                            totalSwimDistanceLastWeek+=distance;
                            break;
                        case Activity.SPORT_CYCLING:
                            totalCycleDistanceLastWeek+=distance;
                            break;
                        case Activity.SPORT_RUNNING:
                            totalRunDistanceLastWeek+=distance;
                            break;
                        default:
                            Utils.log("other activity distance "+distance); 
                            break;
                    }
                 }
            }
            sample = userActivityIterator.next();
        }
        Utils.persist("totalSwimDistance", totalSwimDistance);
        Utils.persist("totalCycleDistance", totalCycleDistance);
        Utils.persist("totalRunDistance", totalRunDistance);

        Utils.persist("totalDuration", totalDuration);

        Utils.persist("totalSwimDistanceLastWeek", totalSwimDistanceLastWeek);
        Utils.persist("totalCycleDistanceLastWeek", totalCycleDistanceLastWeek);
        Utils.persist("totalRunDistanceLastWeek", totalRunDistanceLastWeek);

        Utils.log("totalSwimDistance "+totalSwimDistance+" totalCycleDistance "+totalCycleDistance+" totalRunDistance "+totalRunDistance);
    
        // total meters Climbed this week

        var _totalmetersClimbedWeek = Utils.get_number_from_storage("totalmetersClimbedWeek");
        var climbedToday = ActivityMonitor.getInfo().metersClimbed;
        var total_climbed_this_week_to_now = _totalmetersClimbedWeek + climbedToday;
        Utils.persist("total_climbed_this_week_to_now", total_climbed_this_week_to_now);

        // store metersClimbed today to totalmetersClimbedWeek
        if(System.getClockTime().hour == 23 and System.getClockTime().min>=30){
            var day_of_week = Gre.info(Time.now(), Time.FORMAT_SHORT).day_of_week;
            if(day_of_week == 7){ // Saturday
                Utils.persist("totalmetersClimbedWeek", 0);    
                Utils.log("totalmetersClimbedWeek reset because it's sat at 23");
            }else if(oneTimepersist){
                oneTimepersist = false;
                var todayClimb = ActivityMonitor.getInfo().metersClimbed;
                totalmetersClimbedWeek = Utils.get_number_from_storage("totalmetersClimbedWeek");
                Utils.persist("totalmetersClimbedWeek", totalmetersClimbedWeek+todayClimb);
                //Utils.log("totalmetersClimbedWeek daily persistance at 23");
            }
        }
    
    }    

    function getTotalSwim(total_swim){
        if(_totalSwimDistance == -1){
            _totalSwimDistance = Utils.get_number_from_storage("totalSwimDistance");
        }
         
        total_swim.setColor(Graphics.COLOR_BLUE);
        total_swim.setFont(Graphics.FONT_MEDIUM);
        total_swim.setText((_totalSwimDistance.toFloat()/1000).format("%.1f"));
    } 

    function getTotalBike(total_bike){
        if(_totalCycleDistance == -1){
            _totalCycleDistance = Utils.get_number_from_storage("totalCycleDistance");
        }
        total_bike.setColor(Graphics.COLOR_YELLOW);
        total_bike.setFont(Graphics.FONT_LARGE);
        total_bike.setText(Utils.round(_totalCycleDistance.toFloat()/1000).toString());
    }

    function getTotalRun(total_run){
        if(_totalRunDistance == -1){
            _totalRunDistance = Utils.get_number_from_storage("totalRunDistance");
        }        
        total_run.setColor(Graphics.COLOR_GREEN);
        total_run.setFont(Graphics.FONT_MEDIUM);
        //total_run.setText((totalRunDistance.toFloat()/1000).format("%.1f"));
        total_run.setText(Utils.round(_totalRunDistance.toFloat()/1000).toString());
    }

    function getTotalSwimLastWeek(f){
        if(_totalSwimDistance_lastweek == -1){
            _totalSwimDistance_lastweek = Utils.get_number_from_storage("totalSwimDistanceLastWeek");
        }                
        f.setText((_totalSwimDistance_lastweek.toFloat()/1000).format("%.1f"));
    } 

    function getTotalBikeLastWeek(f){
        if(_totalCycleDistance_lastweek == -1){
            _totalCycleDistance_lastweek = Utils.get_number_from_storage("totalCycleDistanceLastWeek");
        }                
        f.setText(Utils.round(_totalCycleDistance_lastweek.toFloat()/1000).toString());
    }

    function getTotalRunLastWeek(f){
        if(_totalRunDistance_lastweek == -1){
            _totalRunDistance_lastweek = Utils.get_number_from_storage("totalRunDistanceLastWeek");
        }                
        f.setText(Utils.round(_totalRunDistance_lastweek.toFloat()/1000).toString());
    }

    function getTotalSportTime(f){
        if(_total_sport_time == -1){
            _total_sport_time=Utils.get_number_from_storage("totalDuration");
            hours = _total_sport_time.toNumber()/3600;
            min = (_total_sport_time.toNumber()%3600)/60;
        }
        f.setText(hours.format("%02d")+":"+min.format("%02d"));
    }
    function getTotalAscent(f){
        if(total_climbed_this_week_to_now == -1){
            total_climbed_this_week_to_now = Utils.get_number_from_storage("total_climbed_this_week_to_now");
        }
        f.setText(total_climbed_this_week_to_now.toNumber()+"m");
        /*
        var sensorIter = SensorHistory.getElevationHistory({
            :period => new Time.Duration(3600)
        });
        if (sensorIter != null) {
            var sample;
            while(sensorIter != null and sensorIter has :next){
                sample = sensorIter.next();   
                if(sample!=null){     
                    if (sample has :when and sample has :data){
                        //Utils.log(sample.data.toNumber());
                        //Utils.log("sensorIter "+sample.when+" - "+sample.data);    
                        Utils.log("sensorIter "+sample.when.value()+" - "+sample.data.toString());    
                    }
                } 
            }
        }
*/

    }
}