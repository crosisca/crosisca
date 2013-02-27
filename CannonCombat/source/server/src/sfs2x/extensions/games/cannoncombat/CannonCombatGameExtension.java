package sfs2x.extensions.games.cannoncombat;

import sfs2x.extensions.games.cannoncombat.handlers.GamePlayRequests;
import com.smartfoxserver.v2.SmartFoxServer;
import com.smartfoxserver.v2.entities.Room;
import com.smartfoxserver.v2.entities.Zone;
import com.smartfoxserver.v2.extensions.SFSExtension;

/**
 * CannonCombat - Game room extension
 * 
 * @author A51 Integrated
 *
 */
public class CannonCombatGameExtension extends SFSExtension
{
	public final String VERSION 				= "1.01";
	
	public final String CMD_GAMEPLAY_REQUESTS	= "G";
	public final String CMD_START_GAME			= "S";
	
	SmartFoxServer sfs;
	
	@Override
	public void init()
	{
		trace("CannonCombat Game Extension init. Version: " + VERSION);
						
		// Register Request handlers
		this.addRequestHandler(CMD_GAMEPLAY_REQUESTS, GamePlayRequests.class);
	}
	
	public Room getGameRoom()
	{
		return this.getParentRoom();
	}
	
	public Zone getZone()
	{
		return this.getParentZone();
	}

	@Override
	public void destroy() 
	{
		super.destroy();
	}	
}
