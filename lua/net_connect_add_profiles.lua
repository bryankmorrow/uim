---------PROBE INSTRUCTIONS------------
-- To get a list of all devices that were discovered with credentials leave filter_by_origin set to false
-- To get a filtered list of those devices by origin, set filter_by_origin to true and modify the origin variable
-- You can drag and drop the output directly into the net_connect probe to create profiles
-- You will just need to make sure your default or bulk configuration settings are correct in order to collect QOS and alarm
---------------------------------------


---------VARIABLES---------------------
filter_by_origin = false
origin = ""

---DO NOT CHANGE CODE BELOW THIS LINE
database.open("provider=nis;database=nis;driver=none")
if (filter_by_origin == false) then
   var = sprintf("SELECT name, ip FROM cm_computer_system WHERE os_type IS NOT NULL ORDER BY origin")
else
   var = sprintf("SELECT name, ip FROM cm_computer_system WHERE os_type IS NOT NULL AND origin = '%s' ORDER BY origin", origin)

end
print ("HIGHLIGHT THE TEXT IN THE CONSOLE OUTPUT THEN DRAG AND DROP TO NET_CONNECT")
print ("==========================================================================")


---------FUNCTIONS---------------------
function quoteval (value)
   if value == nil then
      return ""
   end

   if string.match(value, '[,"]') then
      value = '"'..string.gsub(value, '"', '""')..'"'
   end
   return value
end


---------DATABASE QUERY----------------
local result,rc,err = database.query(var)

if rc ~= NIME_OK then
   print("*** Query error (", rc, "): ", err)
   return
end

if #result == 0 then
   print("*** No rows returned")
   --return
end

------EXTRACT COLUMN NAMES-------------
local keys = {}
for key,value in pairs(result[1]) do
   table.insert(keys, key)
end
table.sort(keys)


------PRINT EACH ROW-------------------
for x,row in ipairs(result) do
   local ip = "" 
   local name = ""
   for x,key in ipairs(keys) do
      if (x == 1) then
         ip = quoteval(row[key])
      elseif (x ==2) then
         name = quoteval(row[key])
      end
   end
   print(ip.."\t"..name)
end
