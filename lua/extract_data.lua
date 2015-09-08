--------------------------------------------------------------------------------
-- extract-data-from-nis
--
-- This script queries the contents of a table in the NiS database and
-- prints it in CSV format. The table name is a setting that can be changed
-- as needed.
--------------------------------------------------------------------------------

--------------------------------------------------------------------------------
-- quoteval()
--
-- Quote a value for the CSV file if necessary (contains a comma or quote)
--------------------------------------------------------------------------------
function quoteval (value)
   if value == nil then
      return ""
   end

   if string.match(value, '[,"]') then
      value = '"'..string.gsub(value, '"', '""')..'"'
   end
   return value
end

--------------------------------------------------------------------------------
-- printcsv()
--
-- Print a line for the CSV file without a trailing comma
--------------------------------------------------------------------------------
function printcsv (line)
   print(string.sub(line, 1, -2))
end

--------------------------------------------------------------------------------
-- MAIN
--------------------------------------------------------------------------------

database.open("provider=nis;database=nis;driver=none")

local result,rc,err = database.query("SELECT STATEMENT GOES HERE")

if rc ~= NIME_OK then
   print("*** Query error (", rc, "): ", err)
   return
end

if #result == 0 then
   print("*** No rows returned")
   return
end

-- Extract column names from keys in first row of results
local keys = {}
for key,value in pairs(result[1]) do
   table.insert(keys, key)
end
table.sort(keys)

-- Print the column names
local line = ""
for x,key in ipairs(keys) do
   line = line..quoteval(key)..","
end
printcsv(line)

-- Print each row using the same order of keys
for x,row in ipairs(result) do
   local line = ""
   for x,key in ipairs(keys) do
      line = line..quoteval(row[key])..","
   end
   printcsv(line)
end
