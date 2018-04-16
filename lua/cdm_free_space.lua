a = alarm.get ("RA76667813-56787")
msg = a.message
newAlarm = {}
newAlarm.nimid = a.nimid
var = split(a.supp_key, "/")
var = sprintf (var[2])
address = "/"..a.domain.."/"..a.hub.."/"..a.robot.."/cdm"

local args = pds.create()
pds.putString(args, "filesys", var)

local probe_config_get = nimbus.request(address,"disk_status", args)
if probe_config_get ~= nil then
   for key,value in pairs(probe_config_get) do
      if key == "DiskAvail" then
        if value <= 5000 then
           -- DO SOMETHING HERE
        end
        b = sprintf( value .. " MB free | " .. value / 1000 .. " GB free")
      --  print (b)
      elseif key == "Drive" then
        c = sprintf( value )
      --  print (c)
      elseif key == "DiskUsedPct" then
        d = sprintf( 100 - value .. "%% free ")
      --  print (d)
      end
   end
  print (msg.. " with " .. b)


  newAlarm.message = msg.. " with " .. b
  alarm.set(newAlarm)
end
