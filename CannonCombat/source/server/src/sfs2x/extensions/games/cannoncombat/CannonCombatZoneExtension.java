package sfs2x.extensions.games.cannoncombat;

import java.util.Collection;

import com.smartfoxserver.v2.entities.User;
import com.smartfoxserver.v2.entities.Zone;
import com.smartfoxserver.v2.extensions.SFSExtension;

/**
 * CannonCombat - Zone Extension
 * 
 * @author A51 Integrated
 * 
 */
public class CannonCombatZoneExtension extends SFSExtension
{
	public static final String VERSION 						= "1.01";
	
	public static final String LOBBY_ROOM 					= "lobby";
	
	@Override
	public void init()
	{		
		trace("CannonCombat Zone Extension init. Version: " + VERSION);
	}
	
	public Zone getZone()
	{
		return this.getParentZone();
	}
	
	public Collection<User> getConnectedUsers()
	{
		return this.getParentZone().getUserList();
	}
	
	@Override
	public void destroy() 
	{
		super.destroy();
		trace("CannonCombat Zone Extension destroyed.");
	}	
}
