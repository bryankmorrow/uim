--Open connection to NIS database for new USM Alarm annotations
database.open("provider=nis;database=nis;driver=none")

-- get nimid (for notename), hostname (robotname)
alist = alarm.get()
if alist == nil then
   note_name = "TESTNOTE" -- running stand alone
   processes = "processes"
else
   note_name = "processes-"..alist.nimid
   processes = "/"..alist.domain.."/"..alist.hub.."/"..alist.robot.."/processes"
end

note_id = note.find (note_name)
if note_id == nil then
   note_id = note.create (note_name,"Initial Create at " ..timestamp.format(),1)
end

if alist ~= nil then
   note.attach (note_id,alist.nimid)
end

note.append (note_id," ")
note.append (note_id,"***Process information from "..processes.." added at "..timestamp.format())

--
-- Get the process-list from the processes probe, show all cpu-consuming processes
--
plist = nimbus.request(processes,"list_processes")

if plist == nil then
   printf ("The 'processes' probe does not run on the robot '%s'.",processes)
   note.append (note_id,"Probe "..processes.." does not run ")
else
   buff = ""
   for pid,proc in pairs(plist) do
      if proc.cpu_usage == nil then
         printf ("Executable pid:%05d cpu value is non-existent !!!!",proc.process_id)
      elseif proc.cpu_usage > 0 then
         if proc.short_executable == "java.exe" then
            printf ("Executable pid:%05d, cpu: %0.2f%% mem: %d MB - %s (%s)",proc.process_id,proc.cpu_usage,proc.working_set_size/1024,proc.short_executable,proc.command_line)
            process = string.format("%05d, cpu: %0.2f%% mem: %d MB - %s (%s)",proc.process_id,proc.cpu_usage,proc.working_set_size/1024,proc.short_executable,proc.command_line)
            buff = buff .. process .. "\n"
            print (process)
            note.append(note_id,process)
         elseif proc.short_executable ~= "Idle" then
            printf ("Executable pid:%05d, cpu: %0.2f%% mem: %d MB - %s (%s) ",proc.process_id,proc.cpu_usage,proc.working_set_size/1024,proc.short_executable,proc.executable)
            process = string.format("%05d, cpu: %0.2f%% mem: %d MB - %s (%s) ",proc.process_id,proc.cpu_usage,proc.working_set_size/1024,proc.short_executable,proc.executable)
            buff = buff .. process .. "\n"
            print (process)
            note.append(note_id,process)
         end
      end
   end
   query = string.format("INSERT INTO umpAlarmAnnotations (nimid,created,username,annotation) VALUES ('%s','%s','nas','%s')",alist.nimid,os.date("%c", timestamp.now()),buff)
   database.query(query)
end
