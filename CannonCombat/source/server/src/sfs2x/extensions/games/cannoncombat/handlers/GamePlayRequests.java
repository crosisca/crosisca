package sfs2x.extensions.games.cannoncombat.handlers;

import java.util.ArrayList;
import java.util.List;

import sfs2x.extensions.games.cannoncombat.CannonCombatGameExtension;
import com.smartfoxserver.v2.SmartFoxServer;
import com.smartfoxserver.v2.annotations.Instantiation;
import com.smartfoxserver.v2.annotations.Instantiation.InstantiationMode;
import com.smartfoxserver.v2.annotations.MultiHandler;
import com.smartfoxserver.v2.entities.Room;
import com.smartfoxserver.v2.entities.User;
import com.smartfoxserver.v2.entities.data.ISFSObject;
import com.smartfoxserver.v2.entities.variables.ReservedRoomVariables;
import com.smartfoxserver.v2.entities.variables.RoomVariable;
import com.smartfoxserver.v2.entities.variables.SFSRoomVariable;
import com.smartfoxserver.v2.extensions.BaseClientRequestHandler;
import com.smartfoxserver.v2.extensions.SFSExtension;

/**
 * CannonCombat - Multi Handler
 * Handle events thrown on a room level 
 *  
 * @author A51 Integrated
 *
 */
@Instantiation(InstantiationMode.SINGLE_INSTANCE)
@MultiHandler
public class GamePlayRequests extends BaseClientRequestHandler
{
	@Override
	public void handleClientRequest(User user, ISFSObject params)
	{		
		//Obtain a reference to this handlers parent extension
		CannonCombatGameExtension gameExt = (CannonCombatGameExtension) getParentExtension();
		Room curRoom = gameExt.getGameRoom();
		
		// Obtain the request id
        String requestId = params.getUtfString(SFSExtension.MULTIHANDLER_REQUEST_ID);
        
        if(requestId.equals(gameExt.CMD_START_GAME)) 
        {
        	// Create and broadcast a global RoomVariable to notify all users not in game room that game has started
			RoomVariable rv = new SFSRoomVariable(ReservedRoomVariables.RV_GAME_STARTED, true);
			rv.setGlobal(true);
			List<RoomVariable> listOfVars = new ArrayList<RoomVariable>();
			listOfVars.add(rv);
			
			// Update the RoomVariables
			SmartFoxServer.getInstance().getAPIManager().getSFSApi().setRoomVariables(user, curRoom, listOfVars);
        }
	}
}