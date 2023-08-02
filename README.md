# GOG-Galaxy

since some time the connection to Steam and Ubisoft connect is not working in GOG Galaxy.  
the fix is not complicated but is sux to do it, so I prepared a simple setup using inno setup to automate it.  
The setup installs modified backend_steam_network.py / consts.py files to fix the connection problems with Steam and Ubisoft connect.  

1 - Close GOG galaxy  
2 - download the setup file  
3 - execute the setup file (default steam and Ubisoft consts.py will be replaced)  
4 - start GOG Galaxy and connect to Steam / Ubisoft connect  
5 - Done  

### or if you want to do it yourself  

#### Ubisoft Connect  

You just have to replace the old App-IDs with the new ones in the consts.py file.  
After that, there should be no more disconnections (unless the ids get changed again).  

to edit the consts.py  
press WindowsKey+R and paste  
 
        %LOCALAPPDATA%\GOG.com\Galaxy\plugins\installed\uplay_afb5a69c-b2ee-4d58-b916-f4cd75d4999a

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


