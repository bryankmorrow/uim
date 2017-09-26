--metric_one = "QOS_QUEUE_CURRENT_DEPTH "
metric_two = "QOS_QUEUE_OLDEST_MESSAGE_AGE "
probe = "websphere_mq"
regex_value = "(%d+.%d+)"
regex_source = ".*source%s(.*)%stargeting"
regex_target = ".*targeting%s(.*)%shas"
regex_age = "QOS_QUEUE_OLDEST_MESSAGE_AGE%s+=%s(.*)%sfrom"
alert_age = 120
 
al = alarm.list()
a = alarm.get()
one_list = {}
two_list = {}
count = 1
 
---------- FUNCTIONS -------------
function createAlarm(domain,source,robot,origin,dev_id,nim,prid,message,subsys,severity,metric_id,suppkey)
 
   msg = pds.create ()
 
   -- Create message header
   pds.putString (msg,"nimid",nim)
   pds.putInt    (msg,"nimts",timestamp.now() )
   pds.putInt    (msg,"tz_offset",25200)
   pds.putString (msg,"source",source)
   pds.putString (msg,"robot",robot)
   pds.putString (msg,"domain",domain)
   pds.putString (msg,"origin",origin)
   pds.putString (msg,"subject","alarm")
   pds.putInt    (msg,"pri",1)
   pds.putString (msg,"prid",prid)
   pds.putString (msg,"dev_id",dev_id)
   pds.putString (msg,"met_id",metric_id)
   pds.putString (msg,"suppression","y+000000000#" .. suppkey)
   pds.putString (msg,"supp_key",suppkey)
 
 
   udata = pds.create()
   pds.putString (udata,"message",message)
   pds.putString (udata,"subsys",subsys)
   pds.putInt (udata, "level",severity)
 
   pds.putPDS (msg,"udata",udata)
 
   t,rc = nimbus.request ("spooler","hubpost",msg)
 
   pds.delete (udata)
   pds.delete (msg)
   return rc
end
 
function unique_id()
 
   key = ""
   base="ABCDEFGHIJKLMNOPQRSTUVWXYZ"
   math.random();math.random()
   key = mid(base,math.random(1,26),1) .. mid(base,math.random(1,26),1) ..
   sprintf("%07d", math.random(1,100000000)) .. "-" ..
   sprintf("%05d",math.random(1,100000))
   return key
end
 
-- Create list of tables for each QOS metric
for k,v in pairs (al) do
   -- Build array for all Age messages
   if (v.prid == probe and string.match(v.message, metric_two)) then
      two_list[count] = v
   end
   count = count + 1
end
 
 
   --print (y.message)
   one_source = string.match(a.message, regex_source)
   one_target = string.match(a.message, regex_target)
   one_depth = string.match(a.message, regex_value)
   -- For each alarm in one_list, loop through two_list and match the source and target
   for s,t in pairs(two_list) do
      two_source = string.match(t.message, regex_source)
      two_target = string.match(t.message, regex_target)
      two_age = tonumber(string.match(t.message, regex_age))
     -- print (one_source.." "..two_source.."  "..one_target.." "..two_target)
      if (one_source == two_source and one_target == two_target and two_age >= alert_age) then
         --print ("          "..one_source.." "..two_source.."  "..one_target.." "..two_target)
         --print ("          "..y.message)
         --print ("          "..t.message)
         --print ("          "..two_age)
         message = "Message age and queue depth over threshold for "..one_source.." and queue "..one_target..", message age is "..two_age..", queue depth is "..one_depth
         print ("Generating correlation alarm "..message)
         -- initialize the random generator
         math.randomseed(os.time())
         nimid = unique_id()
         suppkey = two_source.."+"..two_target.."+DEPTH+AGE"
         createAlarm(t.domain,t.source,t.robot,t.origin,t.dev_id,nimid,probe,message,t.subsys,5,t.met_id,suppkey)
         --return nil;
         break
       end
   end
