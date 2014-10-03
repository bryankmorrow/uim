--
-- This script uses the _add_baselines and _add_thresholds hidden callbacks in the
-- baseline_engine to create dynamic baselines and thresholds.
--------------------------------------------------------------------------------
-- Variables
--
-- Modify the following variables to create your baseline
--
metric_id = "M1a4f1bdb56acccf2305789fdc6df8faf"
thr_subsystem = "8.8.8"
-- [  {"id":"MFAFFC5AB5DD58B1648B6C7264E95AB4B","threshold_id":0,"thresholdType":"dynamic","calcType":"stddev","operator":"increasing","subsysId":"1.1.19","levels":[0.5,1.0,1.5,2.0,2.5]} ]
-- calc_type options are "stddev" "percent" 
calc_type = "stddev"
-- operator options are "increasing" and "decreasing"
operator = "increasing"
thr_1 = "1.0"
thr_2 = "5.0"
thr_3 = "10.0"
thr_4 = "15.0"
thr_5 = "20.0"
--
--------------------------------------------------------------------------------
-- Code Block for Baseline Creation
--
args = pds.create()
pds.putString (args, "metIds", '["' .. metric_id .. '"]')
req, rc = nimbus.request("baseline_engine", "_add_baselines", args)
if rc == 0 then
   print ("Baseline for metric_id: " .. metric_id .. " was successful. Now creating threshold.")
   --msg = '[{"id":"' .. metric_id .. '","threshold_id":0,"thresholdType":"dynamic","calcType":"' .. calc_type .. '","operator":"' .. operator .. '","subsysId":"' .. thr_subsystem .. '","levels":['..thr_1..','..thr_2..','..thr_3..','..thr_4..','..thr_5..']}]'
   msg = sprintf( '[{"id":"%s","threshold_id":0,"thresholdType":"dynamic","calcType":"%s","operator":"%s","subsysId":"%s","levels":[%.2f,%.2f,%.2f,%.2f,%.2f]}]', metric_id, calc_type, operator, thr_subsystem, thr_1, thr_2, thr_3, thr_4, thr_5 ) 
   print (msg)
   args1 = pds.create()
   pds.putString (args1, "thresholds", msg)
   requ, rc = nimbus.request("baseline_engine", "_add_thresholds", args1)
   if rc == 0 then
      print ("Baseline thresholds for :" .. metric_id .. " are now set")
   else
      print ("Something went wrong with the thresholds " .. rc)
   end
else
   print ("Something went wrong")
end