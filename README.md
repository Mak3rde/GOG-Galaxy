# GOG-Galaxy
For some time now, the connection to Steam and Ubisoft Connect in GOG Galaxy has not been working.  

Two files are responsible for the connection to Steam (backend_steam_network.py) and Ubisoft (consts.py), unfortunately, these are not up to date, which is why the connection cannot be established.

The necessary customization is not complicated but not easy for many users, so I have prepared a simple bat file to automate it.

All you have to do is click on the green button "< > Code" at the top right and then click on "Download zip". 

The zip package contains: 

A .bat file, which, when executed, "double click" or "right-click -> open"  
will install a modified backend_steam_network.py (steam) and a consts.py (Ubisoft).
The original files are not overwritten. They are renamed and remain unchanged.

In addition, the customized files 
- Steam - backend_steam_network.py  
- Ubisoft - consts.py
are available if you do not want to use the .bat file,
you can then manually copy or move them to the relevant directory as described below.

1 - Close GOG galaxy  
2 - download the zip file  
3 - extract  
4 - execute the bat file (default steam backend_steam_network.py and Ubisoft consts.py will be renamed so you will have them as backup)  
5 - start GOG Galaxy and connect to Steam / Ubisoft connect  
6 - Done  

### or if you want to do it yourself  

#### Ubisoft Connect  

You have to replace the old not working App-IDs with the new ones in the consts.py file.  
After that, there should be no more disconnections (unless the ids get changed again).  

to edit the consts.py  
press WindowsKey+R and paste 
this will open the folder that contains the consts.py

> [!NOTE]
> This only works if you have already installed the Ubisoft plugin in GOG Galaxy,
> Otherwise the directory does not yet exist.
> you have to press "WIN+R" and paste this here 
> %LOCALAPPDATA%\GOG.com\Galaxy\
> This will open the folder in which you have to create the necessary sub-folders yourself
> Create the following folder -> plugins\installed\uplay_afb5a69c-b2ee-4d58-b916-f4cd75d4999a
 
       plugins\installed\uplay_afb5a69c-b2ee-4d58-b916-f4cd75d4999a

Replace the old CLUB_APPID and CLUB_GENOME_ID with  

        CLUB_APPID = "314d4fef-e568-454a-ae06-43e3bece12a6"
        CLUB_GENOME_ID = "85c31714-0941-4876-a18d-2c7e9dce8d40"

 - Source: https://github.com/FriendsOfGalaxy/galaxy-integration-uplay/issues/33#issuecomment-1019254379  


#### Steam  
You just have to replace some more lines of code  

to edit the backend_steam_network.py  
press WindowsKey+R and paste  

      %LOCALAPPDATA%\GOG.com\Galaxyplugins\installed\steam_ca27391f-2675-49b1-92c0-896d43afa4f8

Change Lines 186 - 194 to:


            async def _get_websocket_auth_step(self):
        try:
            result = await asyncio.wait_for(
                self._websocket_client.communication_queues["plugin"].get(), 20
            )
            return result["auth_result"]
        except asyncio.TimeoutError:
            return UserActionRequired.NoActionRequired
            #raise BackendTimeout() 


Change Lines 240 - 246 to :

        if result != UserActionRequired.NoActionRequired:
            return next_step_response(fail, finish)
        else:
            self._auth_data = None
            self._store_credentials(self._user_info_cache.to_dict())
            return Authentication(self._user_info_cache.steam_id, self._user_info_cache.persona_name)

            
  - Source: https://github.com/FriendsOfGalaxy/galaxy-integration-steam/issues/159#issuecomment-1489032765

## source code of the bat file in the zip file  


```        
@echo off

set "sourceFolder=%~dp0"
set "destinationFolder1=C:\Users\%USERNAME%\AppData\Local\GOG.com\Galaxy\plugins\installed\uplay_afb5a69c-b2ee-4d58-b916-f4cd75d4999a\"
set "destinationFolder2=C:\Users\%USERNAME%\AppData\Local\GOG.com\Galaxy\plugins\installed\steam_ca27391f-2675-49b1-92c0-896d43afa4f8\"
set "file1=consts.py"
set "file2=backend_steam_network.py"

rem Current date and time in the format YYYY-MM-DD_HH-MM-SS
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
```
