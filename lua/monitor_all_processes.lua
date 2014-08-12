---Change the address to your /DOMAIN/HUB/ROBOT/PROCESSES
processAddr = "/Nimsoft-Demo/WorldWideHQ/usildodnimms1/processes"


list_processes = nimbus.request(processAddr, "list_processes")
for k,v in pairs(list_processes) do
   for key,value in pairs(v) do
      if key == "short_executable" then
         short = value
      elseif key == "executable" then
         execute = value
      end
   end
   profile = "monitor-process-"..short

   options = pds.create()
   pds.putString(options, "/watchers/"..profile.."/active", "yes")
   pds.putString(options, "/watchers/"..profile.."/description", "Monitoring process "..short)
   pds.putString(options, "/watchers/"..profile.."/action", "none")
   pds.putString(options, "/watchers/"..profile.."/command", execute)
   pds.putString(options, "/watchers/"..profile.."/arguments", "")
   pds.putString(options, "/watchers/"..profile.."/process", short)
   pds.putString(options, "/watchers/"..profile.."/report", "down")
   pds.putString(options, "/watchers/"..profile.."/qos_process_state", "yes")
   pds.putString(options, "/watchers/"..profile.."/qos_process_memory", "yes")
   pds.putString(options, "/watchers/"..profile.."/qos_process_cpu", "yes")
   pds.putString(options, "/watchers/"..profile.."/qos_process_count", "yes")
   pds.putString(options, "/watchers/"..profile.."/qos_process_threads", "yes")
   pds.putString(options, "/watchers/"..profile.."/qos_process_handles", "yes")

   args = pds.create()
   pds.putString(args, "name", "processes")
   pds.putPDS(args, "as_pds", options)

   resp,rc = nimbus.request(processAddr, "probe_config_set", args)
   if resp ~= nil then
      print (short.." probe config set")
   else
      print (short.." probe config failed")
   end
end

output2,return_status2 = nimbus.request (processAddr, "_restart" )
if return_status2 == NIME_OK then
   printf ("Restart successful")
else
   printf ("Restart failed")
end

pds.delete(args)
pds.delete(options)