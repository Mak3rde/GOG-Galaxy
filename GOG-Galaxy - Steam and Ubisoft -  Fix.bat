@echo off

set "sourceFolder=%~dp0"
set "destinationFolder1=C:\Users\%USERNAME%\AppData\Local\GOG.com\Galaxy\plugins\installed\uplay_afb5a69c-b2ee-4d58-b916-f4cd75d4999a\"
set "destinationFolder2=C:\Users\%USERNAME%\AppData\Local\GOG.com\Galaxy\plugins\installed\steam_ca27391f-2675-49b1-92c0-896d43afa4f8\"
set "file1=consts.py"
set "file2=backend_steam_network.py"

rem Aktuelles Datum und Uhrzeit im Format YYYY-MM-DD_HH-MM-SS
for /f "tokens=1-3 delims=/" %%a in ("%DATE%") do set "currentDate=%%c-%%a-%%b"
for /f "tokens=1-3 delims=:." %%a in ("%TIME%") do set "currentTime=%%a-%%b-%%c"

set "backupSuffix=_%currentDate%_%currentTime%_BACKUP"

echo Backing up original files...
copy "%destinationFolder1%%file1%" "%destinationFolder1%%file1%%backupSuffix%" > nul
copy "%destinationFolder2%%file2%" "%destinationFolder2%%file2%%backupSuffix%" > nul

echo Original files have been backed up.

echo Copying new files to destination folders...
copy /Y /Z "%sourceFolder%%file1%" "%destinationFolder1%"
copy /Y /Z "%sourceFolder%%file2%" "%destinationFolder2%"

echo New files have been copied to destination folders.

pause
