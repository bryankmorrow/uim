--set the nexec profile name here
profile_name = "alarm_profile"

--get the incoming alarm information
al = alarm.get()

--create the nexec address from alarm information
address = "/" .. al.domain .. "/" .. al.hub .. "/" .. al.robot .. "/nexec"

--request to nexec probe
args = pds.create()
pds.putString(args, "profile", profile_name)
nreq,rc = nimbus.request(address, "nexec", args)
if rc == NIME_OK then
  print (profile_name .. " successfully enabled on " .. al.robot)
else
  print (profile_name .. "failed to start on " .. al.robot)
end
pds.delete(args)
