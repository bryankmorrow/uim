--Please note: You will need to create folders in the net_connect probe before running this script
--Name the folders with just the Hub Name
-- Example: hub   (/domain/hub/robot)

group = ""
profile = ""
host = ""
ip = ""
netconnect = "/domain/hub/robot"

-- Net Connect Profile
function ncAddProfile(addr, profile, hostname, ip, group)
   args = pds.create()
   -- CORE PROFILE SETTINGS
   pds.putString(args, "/profiles/"..profile.."/active", "yes")
   pds.putString(args, "/profiles/"..profile.."/hostname", hostname)
   pds.putString(args, "/profiles/"..profile.."/ip", ip)
   pds.putString(args, "/profiles/"..profile.."/group", group)
   -- OPTION QOS/ALARM/MESSAGE SETTINGS
   pds.putString(args, "/profiles/"..profile.."/QoS", "yes")
   pds.putString(args, "/profiles/"..profile.."/ping", "yes")
   pds.putString(args, "/profiles/"..profile.."/interval", "1min")
   pds.putString(args, "/profiles/"..profile.."/timeout", "2")
   pds.putString(args, "/profiles/"..profile.."/failures", "1")
   pds.putString(args, "/profiles/"..profile.."/retries", "3")
   pds.putString(args, "/profiles/"..profile.."/dynamic_ip_monitoring", "no")
   pds.putString(args, "/profiles/"..profile.."/msg_ok", "MsgConnectOk")
   pds.putString(args, "/profiles/"..profile.."/msg_fail", "MsgConnectFail")
   pds.putString(args, "/profiles/"..profile.."/qos_source", "0")
   pds.putString(args, "/profiles/"..profile.."/source", "0")
   pds.putString(args, "/profiles/"..profile.."/target", "2")
   pds.putString(args, "/profiles/"..profile.."/icmp_size", "0")
   pds.putString(args, "/profiles/"..profile.."/flags", "0")
   pds.putString(args, "/profiles/"..profile.."/alarm", "1")
   pds.putString(args, "/profiles/"..profile.."/threshold_ok", "ping threshold OK")
   pds.putString(args, "/profiles/"..profile.."/threshold_fail", "ping threshold failed")
   pds.putString(args, "/profiles/"..profile.."/icmp_threshold", "100")
   pds.putString(args, "/profiles/"..profile.."/alarm_on_packet_loss", "no")
   pds.putString(args, "/profiles/"..profile.."/packets_to_send", "0")
   pds.putString(args, "/profiles/"..profile.."/max_packets_lost", "0")
   pds.putString(args, "/profiles/"..profile.."/qos_on_packets_lost", "no")
   pds.putString(args, "/profiles/"..profile.."/delay_between_pack_to_send", "0")
   pds.putString(args, "/profiles/"..profile.."/max_jitter", "")
   pds.putString(args, "/profiles/"..profile.."/alarm_on_jitter", "0")
   options = pds.create()
   pds.putString(options, "name", "net_connect")
   pds.putPDS(options, "as_pds", args)
   resp,rc = nimbus.request(addr.."/controller", "probe_config_set", options)
   if rc == NIME_OK then
      print ("Net Connect on "..addr.." configured for profile: "..profile)
   else
      print ("Net Connect failed to configure for profile: "..profile.." on "..addr)
   end
end

local gethubs = nimbus.request("hub","gethubs")
if gethubs ~= nil then
   for i,hub in pairs(gethubs.hublist) do
      local getrobots = nimbus.request(hub.addr,"getrobots")
	if getrobots ~= nil then
	   for j,robot in pairs(getrobots.robotlist) do
            group = hub.name
            profile = robot.name  
            host = robot.name
            ip = robot.ip
            --printf ("Group: %s  Profile: %s  Host: %s  IP: %s", group, profile, host, ip) 
            -- For each robot create a net connect profile
            ncAddProfile(netconnect, profile, host, ip, group)
         end
	end
   end
end
