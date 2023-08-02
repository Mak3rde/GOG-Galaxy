# GOG-Galaxy
i made a setup that installs modifiey files to fixx the connection problems with Steam and Ubisoft connect


what it does

since some time the connection to steam an ubisoft connect is not workin in GOG Galaxy.
the fix is not complicated but is sux to do it so i preparead a simple setup file using inno setup to automate it 

For some time the connection to Ubisoft Connect (Uplay) and Steam is disconnected after a few seconds or isn't established at all. 
This is most likely because the app IDs have changed for Ubisoft Connect and Steam.

##Solution:

###ubisoft Connect
You just have to replace the old App-IDs with the new ones in the consts.py file. 
After that there should be no more disconnections (unless the ids get changed again).

to edit the consts.py
press WindowsKey+R and paste 
%LOCALAPPDATA%\GOG.com\Galaxy\plugins\installed\uplay_afb5a69c-b2ee-4d58-b916-f4cd75d4999a. 


replace the two app IDs in the consts.py file as follows:

Replace the old CLUB_APPID and CLUB_GENOME_ID with  

CLUB_APPID = "314d4fef-e568-454a-ae06-43e3bece12a6".
CLUB_GENOME_ID = "85c31714-0941-4876-a18d-2c7e9dce8d40".

 - Source: https://github.com/FriendsOfGalaxy/galaxy-integration-uplay/issues/33#issuecomment-1019254379

Steam:

###Steam
You just have to replace some more lines of code 

to edit the consts.py
press WindowsKey+R and paste 

%LOCALAPPDATA%\GOG.com\Galaxyplugins\installed\steam_ca27391f-2675-49b1-92c0-896d43afa4f8

Change Line 186 - 194 to:


            async def _get_websocket_auth_step(self):
        try:
            result = await asyncio.wait_for(
                self._websocket_client.communication_queues["plugin"].get(), 20
            )
            return result["auth_result"]
        except asyncio.TimeoutError:
            return UserActionRequired.NoActionRequired
            #raise BackendTimeout() 


Change Line 240 - 246 to :

        if result != UserActionRequired.NoActionRequired:
            return next_step_response(fail, finish)
        else:
            self._auth_data = None
            self._store_credentials(self._user_info_cache.to_dict())
            return Authentication(self._user_info_cache.steam_id, self._user_info_cache.persona_name)

            
  - Source: https://github.com/FriendsOfGalaxy/galaxy-integration-steam/issues/159#issuecomment-1489032765


