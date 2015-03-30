-- Nimsoft Enviroment Audit

-- Login so that I can run this from the command line
-- Comment out if running from NAS
-- nimbus.login("administrator","nimsoft")

-- Initialize the SQLite database
--database.open("NimsoftEnviromentAudit.db")

-- Initialize the NIS database
database.open("provider=nis;database=nis;driver=none")

-- Drop the table
query = "DROP TABLE probe_audit"
printf("DB QUERY -> %s",query)
database.query(query)
-- And re-create it so that it's empty
query = "CREATE TABLE probe_audit (id integer primary key, hub varchar(255), robot varchar(255), ip varchar(255), probe varchar(255), section varchar(255), key varchar(255), value text);"
printf("DB QUERY -> %s",query)
database.query(query)

-- Populate the audit table with probe configuration information

-- Start by getting a list of the hubs
printf("NIM REQUEST -> %s %s","hub","gethubs")
local gethubs = nimbus.request("hub","gethubs")
if gethubs ~= nil then
	for i,hub in pairs(gethubs.hublist) do

		-- Get a list of robots from each hub
		--printf("NIM REQUEST -> %s %s",hub.addr,"getrobots")
		local getrobots = nimbus.request(hub.addr,"getrobots")
		if getrobots ~= nil then
			for j,robot in pairs(getrobots.robotlist) do

				-- Get some information from each robot
				--printf("NIM REQUEST -> %s %s",robot.addr.."/controller","probe_list")
				local probe_list = nimbus.request(robot.addr.."/controller","probe_list")
				if probe_list ~= nil then
					for k,probe in pairs(probe_list) do

						-- Get some information from each probe
						args = pds.create()
                  pds.putString(args,"name",probe.name)
                  --printf("NIM REQUEST -> %s %s",robot.addr.."/controller","probe_list")
						local probe_config_get = nimbus.request(robot.addr.."/controller","probe_config_get",args)
						if probe_config_get ~= nil then
							for section,tableid in pairs(probe_config_get) do
                        for key,value in pairs(probe_config_get[section]) do

                           -- And dump the config file in the DB for later use
                           query = sprintf("INSERT INTO probe_audit (hub,robot,ip,probe,section,key,value) VALUES ('%s','%s','%s','%s','%s','%s','%s');",hub.name,robot.name,robot.ip,probe.name,section,key,value)
                           printf("DB QUERY -> %s",query)
                           database.query(query)

								end
							end
						end

                  -- Commit our changes to the DB after each probe
                  query = "COMMIT TRANSACTION;"
                  printf("DB QUERY -> %s",query)
                  database.query(query)

					end
				end
			end
		end
	end
end

-- Commit our changes to the DB
query = "COMMIT TRANSACTION;"
printf("DB QUERY -> %s",query)
database.query(query)

-- Close the database and return
database.close()
return
