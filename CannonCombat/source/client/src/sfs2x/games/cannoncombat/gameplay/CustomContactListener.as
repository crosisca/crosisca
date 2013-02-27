package sfs2x.games.cannoncombat.gameplay
{
	/*******************************************************************************************
	 * 
	 * TITLE: 		SFS2X Cannon Combat
	 * VERSION:		1.0
	 * RELEASE:		2012-03-14
	 * COPYRIGHT:	2012 gotoAndPlay() - http://www.smartfoxserver.com
	 * DEVELOPER:	A51 Integrated - http://a51integrated.com
	 * 
	 * This file is part of Cannon Combat.
	 * 
	 * Contributers: Wayne Helman, Fabricio Medeiros,
	 * 				 Steve Schoger, Andy Rohan
	 * 
	 * Cannon Combat is distributed in the hope that it will be useful,
	 * but WITHOUT ANY WARRANTY; without even the implied warranty of
	 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
	 * included license for more details.
	 *
	 * You are not allowed to rent, lend, lease, license or distribute SFS2X Cannon Combat or a
	 * modified version of Cannon Combat to any other person or organization in any way.
	 * 
	 * For commercial licensing information, please contact gotoAndPlay().
	 * 
	 *******************************************************************************************/
	
	/**
	 * CustomContactListener
	 * 
	 * Sets a boolean property on a Box2D body upon contact
	 * 
	 * @author 		Wayne Helman, Fabricio Medeiros
	 * @copyright 	2012 gotoAndPlay() - http://www.smartfoxserver.com
	 * @version		1.0 
	 */
	
	import Box2D.Dynamics.b2ContactListener;
	import Box2D.Dynamics.b2ContactImpulse;
	import Box2D.Dynamics.Contacts.b2Contact;
	
	import sfs2x.games.cannoncombat.managers.InstanceManager;
	import sfs2x.games.cannoncombat.managers.SoundManager;
	
	public class CustomContactListener extends b2ContactListener
	{
		private var
			MAX_IMPULSE			:Number = 10;
		
		override public function PostSolve(contact:b2Contact, impulse:b2ContactImpulse):void
		{
			if (impulse.normalImpulses[0] > MAX_IMPULSE)
			{
				var nameA	:String = contact.GetFixtureA().GetBody().GetUserData().assetName.toString(),
					nameB	:String = contact.GetFixtureB().GetBody().GetUserData().assetName.toString();

				if(nameA != 'DESK' && nameA != 'BOOK_BLUE' && nameA != 'BOOK_RED')
				{
					if(nameB == 'CANNONBALL')
						contact.GetFixtureB().GetBody().GetUserData().init = true;
				}
				
				if(nameB != 'DESK' && nameB != 'BOOK_BLUE' && nameB != 'BOOK_RED')
				{
					if(nameA == 'CANNONBALL')
						contact.GetFixtureA().GetBody().GetUserData().init = true;
				}
				
				if (nameA == 'SOLDIER')
					contact.GetFixtureA().GetBody().GetUserData().remove = true;

				if (nameB == 'SOLDIER')
					contact.GetFixtureB().GetBody().GetUserData().remove = true;
				
				
			}
		}
		
	}
}