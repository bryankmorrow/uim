-- Load entries from a file
-- Save the file in the root of the NAS folder /Nimsoft/probes/service/nas
-- Each entry needs to be on a new line in the following format for net_connect:
-- net_connect,robotaddress,profile,hostname,ip,group
-- url_response,robotaddress,profile,url,group
fileName = "netconnect-urlresponse-profiles.txt"

-- see if the file exists
function file_exists(file)
  local f = io.open(file, "rb")
  if f then f:close() end
  return f ~= nil
end

-- get all lines from a file, returns an empty 
-- list/table if the file does not exist
function lines_from(file)
  if not file_exists(file) then return {} end
  lines = {}
  for line in io.lines(file) do 
    lines[#lines + 1] = line
  end
  return lines
end



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

-- URL Response Profile
function urAddProfile(addr, profile, url, group)
   args = pds.create()
   -- CORE PROFILE SETTINGS
   pds.putString(args, "/profiles/"..profile.."/active", "yes")
   pds.putString(args, "/profiles/"..profile.."/url", url)
   pds.putString(args, "/profiles/"..profile.."/group", group)
   -- OPTION QOS/ALARM/MESSAGE SETTINGS
   pds.putString(args, "/profiles/"..profile.."/timeout", "10")
   pds.putString(args, "/profiles/"..profile.."/retry", "3")
   pds.putString(args, "/profiles/"..profile.."/QoS", "yes")
   pds.putString(args, "/profiles/"..profile.."/QoS_dns_resolution_time", "yes")
   pds.putString(args, "/profiles/"..profile.."/QoS_firstbyte_time", "yes")
   pds.putString(args, "/profiles/"..profile.."/interval", "60")
   pds.putString(args, "/profiles/"..profile.."/UrlFolderPathEncoding", "UTF-8")
   pds.putString(args, "/profiles/"..profile.."/alarm/active", "yes")
   pds.putString(args, "/profiles/"..profile.."/alarm/max_samples", "5")
   pds.putString(args, "/profiles/"..profile.."/alarm/average", "no")
   pds.putString(args, "/profiles/"..profile.."/alarm/threshold", "8000")
   pds.putString(args, "/profiles/"..profile.."/alarm/dns_resolution_time", "20")
   options = pds.create()
   pds.putString(options, "name", "url_response")
   pds.putPDS(options, "as_pds", args)
   resp,rc = nimbus.request(addr.."/controller", "probe_config_set", options)
   if rc == NIME_OK then
      print ("URL Response on "..addr.." configured for profile: "..profile)
   else
      print ("URL Response failed to configure for profile: "..profile.." on "..addr)
   end

end


-- Start Script
-- Check for the probes before continuing
ncArgs = pds.create()
pds.putString(ncArgs, "name", "net_connect")
list_probes_netconnect, rc = nimbus.request(netconnectAddr.."/controller", "probe_list", ncArgs)
if rc == NIME_OK then
   netconnectFound = true
else
   print ("Net Connect Not Found")
end

urArgs = pds.create()
pds.putString(urArgs, "name", "url_response")
list_probes_urlresponse, rc = nimbus.request(urlResponseAddr.."/controller", "probe_list", urArgs)
if rc == NIME_OK then
   urlresponseFound = true
else
   print ("URL Response Not Found")
end

-- Load the file and check each line

lines = lines_from(fileName)

for k,v in pairs(lines) do
   str = split(v, ",")
   if str[1] == "net_connect" then
      ncAddProfile(str[2], str[3], str[4], str[5], str[6])
   elseif str[1] == "url_response" then
      urAddProfile(str[2], str[3], str[4], str[5])
   end
end

