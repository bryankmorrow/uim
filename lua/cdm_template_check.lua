-- Global Variables
username = "username"
password = "password"
filename = "cdm-check.txt"

--login for use with NSA
nimbusLoginResult,nimbusLoginSID = nimbus.login(username, password)
-- Open the file with append option
file = io.open(filename, "a")
io.output(file)

local gethubs = nimbus.request("hub","gethubs")
if gethubs ~= nil then
   for i,hub in pairs(gethubs.hublist) do
      -- Get a list of robots from each hub
	local getrobots = nimbus.request(hub.addr,"getrobots")
	if getrobots ~= nil then
	   for j,robot in pairs(getrobots.robotlist) do
            -- probe_config_get for cdm probe, /memory/alarm/paging error/active
	      args = pds.create()
            pds.putString(args,"name","cdm")
            pds.putString(args,"var","/memory/alarm/paging error/active")
            local probe_config_get = nimbus.request(robot.addr.."/controller","probe_config_get",args)
		if probe_config_get ~= nil then
               if probe_config_get.value == "yes" then
                  print(robot.addr.." cdm template not deployed")
                  io.write(robot.addr.." cdm template not deployed\n")
               end
            end
	   end
      end
   end
end
io.close(file)
