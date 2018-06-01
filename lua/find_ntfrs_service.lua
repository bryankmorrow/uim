local gethubs = nimbus.request("hub","gethubs")
if gethubs ~= nil then
  for i,hub in pairs(gethubs.hublist) do
    local getrobots = nimbus.request(hub.addr,"getrobots")
	  if getrobots ~= nil then
	    for j,robot in pairs(getrobots.robotlist) do
        listargs = pds.create()
        pds.putString(listargs, "name", "ntservices")
		    local probe_list = nimbus.request(robot.addr.."/controller","probe_list", listargs)
		    if probe_list ~= nil then
		      --print ("ntservices probe was found on "..robot.addr)
          local service_list = nimbus.request(robot.addr.."/ntservices", "list_services")
          if service_list ~= nil then
            for k, service in pairs(service_list) do
              if k == "NtFrs" then -- Use this if its the table header name
              -- if service.display == "NtFrs" then -- Use this if its the service display name
                print ("NtFrs service found on robot: "..robot.name.." at address: "..robot.addr)
              end
            end
          end
		    end
	    end
	  end
  end
end
