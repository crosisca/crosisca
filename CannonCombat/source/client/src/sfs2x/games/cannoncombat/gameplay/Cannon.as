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
	 * Cannon
	 * 
	 * Cannon logic
	 * 
	 * @author 		Wayne Helman, Fabricio Medeiros
	 * @copyright 	2012 gotoAndPlay() - http://www.smartfoxserver.com
	 * @version		1.0 
	 */
	
	import Box2D.Collision.Shapes.b2CircleShape;
	import Box2D.Common.Math.b2Vec2;
	import Box2D.Dynamics.b2Body;
	import Box2D.Dynamics.b2BodyDef;
	import Box2D.Dynamics.b2FixtureDef;
	
	import com.smartfoxserver.v2.entities.data.ISFSObject;
	import com.smartfoxserver.v2.entities.data.SFSObject;
	
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.geom.Point;
	
	import sfs2x.games.cannoncombat.GameController;
	import sfs2x.games.cannoncombat.config.Settings;
	import sfs2x.games.cannoncombat.managers.InstanceManager;
	import sfs2x.games.cannoncombat.managers.SoundManager;
	
	public class Cannon extends Sprite
	{
		private var
			_gameController		:GameController,
			_cannon				:CannonAsset 			= new CannonAsset(),			//Graphical asset from swc
			_fakeBall			:MovieClip				= _cannon.chamber.ball,			//Graphical asset from swc position at the end of the cannon
			_ball				:CannonBall				= new CannonBall(),				//Actual ball to be associated with the physics body
			_world				:BasicArena,											//Reference to the parent class
			_sphere				:b2Body,												//Physics body
			_soundManager		:SoundManager,
			_powerMeter			:PowerMeter				= new PowerMeter(),
			_power				:Number,
			
			_p1					:Point,
			_p2					:Point,
			_ballPoint			:Point,
			_distance			:Number,
			_angle				:Number,
			_initX				:int					= 700,
			_initY				:int					= 460,
			_posX				:int,
			_posY				:int,
			_side				:String					= '',
			
			_trajectory			:Sprite,
			_myCannon			:Boolean				= false;
		
			
			
		/**
		 * Constructor
		 */
		public function Cannon()
		{
			addEventListener(Event.ADDED_TO_STAGE, init, false, 0, true);
		}
		

		
		/**
		 * Initialize graphical elements and set properties
		 * 
		 * @param $e :Event - Event.ADDED_TO_STAGE
		 */
		private function init($e:Event = null):void
		{
			_soundManager = InstanceManager.getSoundManagerInstance((parent as BasicArena).windowID);
			removeEventListener(Event.ADDED_TO_STAGE, init);
			addChild(_cannon);
			addChild(_ball);
			
			//PowerMeter
			_powerMeter.x = 404;
			_powerMeter.y = 450;
			addChild(_powerMeter);
			_powerMeter.visible = false;
			
			
			_fakeBall.visible = true;
			_ball.visible = false;
			
			_world = (parent as BasicArena);
			_gameController = _world.gameController;
		}
		
		
		
		/**
		 * Add a MOUSE_DOWN listener to the cannon
		 */
		public function load():void
		{
			addEventListener(MouseEvent.MOUSE_DOWN, cannonBallClick, false, 0, true);
		}
			
		
		
		/**
		 * Opponent cannon shot
		 * 
		 * @param $bodyPosX :Number - 
		 * @param $posX 	:Number - x position
		 * @param $posY 	:Number - y position
		 * @param $dist 	:Number - distance from origin
		 * @param $angle 	:Number - angle
		 */
		public function oppShoot($posX:Number, $ballPointX:Number = 0, $ballPointY:Number = 0, $dist:Number = 0, $angle:Number = 0):void
		{
			_soundManager.playSound('boing');
			_soundManager.playSound('cannon');
			
			//Now only the opponent is responsible for the timer. If param is true, the world timer call starts.
			_gameController.stopShootingClock(true);
			
			//Visual adjustments
			_cannon.chamber.gotoAndStop(1);
			_fakeBall.visible = false;
			_ball.visible = true;
			
			//World properties
			_world.following = true;
			_world.trajectory.graphics.clear();
			_world.trajectory.graphics.beginFill(0xff0000);
			_gameController.shootingClock.visible = false;
			
			//Remove listeners
			stage.removeEventListener(MouseEvent.MOUSE_MOVE, cannonBallMoved);
			stage.removeEventListener(MouseEvent.MOUSE_UP, shoot);
			
			//Box2D physics
			var sphereShape		:b2CircleShape	= new b2CircleShape(15/_world.worldScale),
				sphereFixture	:b2FixtureDef 	= new b2FixtureDef(),
				sphereBodyDef	:b2BodyDef 		= new b2BodyDef();
			
			sphereFixture.density = 100;
			sphereFixture.friction = .6;
			sphereFixture.restitution = .05;
			sphereFixture.shape = sphereShape;
			sphereBodyDef.type = b2Body.b2_dynamicBody;
			sphereBodyDef.userData = {assetName:'CANNONBALL', assetSprite:_ball, remove:false, init:false};
			
			//Negative value (for _posX or _posY) gives you the opposite quadrant, where the actual ball is
			//We also need to add the cannon position and divide all that by the world scale ratio
			sphereBodyDef.position.Set( (_world.activeCannon.x + $ballPointX) / _world.worldScale , (_world.activeCannon.y + $ballPointY) / _world.worldScale);
			sphereBodyDef.linearDamping = .4; 
			_sphere = _world.worldB2.CreateBody(sphereBodyDef);
			_sphere.SetBullet(true);
			_sphere.CreateFixture(sphereFixture);
			
			//For shooting 
			_angle	= Math.atan2(_posY, Math.abs($posX));

			//Check for sleep state
			//Now only the opponent is responsible for checking Box2d bodies. Much better performance.
			_world.sleepCheck();
			
			//On the right hand side direction is inverted (negative) for x only
			//We cut the x component in half cos the screen is small
			(_side == 'right')
			?
				_sphere.SetLinearVelocity(new b2Vec2(-$dist * Math.cos($angle) * .5, -$dist * Math.sin($angle)))
				:
				_sphere.SetLinearVelocity(new b2Vec2($dist * Math.cos($angle) * .5, -$dist * Math.sin($angle)));
		}
		
		
		
		
		/**
		 * Remove cannon ball
		 */
		public function removeCannonball():void
		{
			if(_sphere != null)	_world.worldB2.DestroyBody(_sphere);
		}
		
		
		
		/**
		 * Resets the cannon
		 */
		public function reset():void
		{
			if(_sphere != null)	_world.worldB2.DestroyBody(_sphere);
				
			if(hasEventListener(MouseEvent.MOUSE_DOWN))
				removeEventListener(MouseEvent.MOUSE_DOWN, cannonBallClick);
			if(stage != null)
			{
				if(stage.hasEventListener(MouseEvent.MOUSE_MOVE))
					stage.removeEventListener(MouseEvent.MOUSE_MOVE, cannonBallMoved);
				if(stage.hasEventListener(MouseEvent.MOUSE_UP))
					stage.removeEventListener(MouseEvent.MOUSE_UP, shoot);
			}
			
			//Cannon position and rotation
			(_side == 'left') ? x = _initX : x = 2300 - _initX;
			(_side == 'left') ? rotation = 0 : rotation = 180;
			y = _initY;
			
			if(_gameController != null) _powerMeter.scaleY = _powerMeter.scaleX = 1;
			
				
			//Visual adjustments
			_fakeBall.visible = true;
			_ball.visible = false;
			_powerMeter.visible = false;
			_cannon.chamber.rotation = 0;
			_cannon.chamber.gotoAndStop(1);
		}
		
		
		
		/**
		 * Removes from memory
		 */
		public function destroy():void
		{
			reset();
			
			removeEventListener(MouseEvent.MOUSE_DOWN, cannonBallClick);
			
			while (numChildren) 
			{
				var child:*  = removeChildAt(0);
				if('destroy' in child) child.destroy();
				child = null;
			}
			
			_gameController = null;
			_cannon = null;
			_fakeBall = null;
			_ball = null;
			_world = null;
			_sphere = null;
			_soundManager = null;
			
			_p1 = null;
			_p2 = null;
			_side = null;
			_trajectory = null;
		}
		
		
		
		//--------------------------------------------------------------------------
		//  EVENT HANDLERS
		//--------------------------------------------------------------------------
		
		
		
		/**
		 * Makes the cannon rotate and be ready to shoot
		 * 
		 * @param $e :MouseEvent - MOUSE_DOWN event 
		 */
		private function cannonBallClick($e:MouseEvent):void
		{
			removeEventListener(MouseEvent.MOUSE_DOWN, cannonBallClick);
			stage.addEventListener(MouseEvent.MOUSE_MOVE, cannonBallMoved, false, 0, true);
			stage.addEventListener(MouseEvent.MOUSE_UP, shoot, false, 0, true);
			
			_cannon.chamber.gotoAndStop(2);
		} 
		
	
		
		/**
		 * Collects coordinates data while moving the cannon
		 * 
		 * @param $e :MouseEvent - MOUSE_MOVE event 
		 */
		private function cannonBallMoved($e:MouseEvent):void
		{
			_posX = _cannon.mouseX;
			_posY = _cannon.mouseY;

			//Limit the x axis
			if(_posX < -120)	_posX = -120;
			else if(_posX > 0)	_posX = 0;
			
			//Limit the y axis
			if(_posY < -60)	_posY = -60;
			else if(_posY > 60)	_posY = 60;
			
			//Get the distance between those two points to define power
			_p1 = new Point();
			_p2 = new Point(_posX * .5, _posY * .5);
			_distance = Point.distance(_p1, _p2);

			//Define the angle
			_angle = Math.atan2(_posY, _posX * .5) * (180/Math.PI) + 180;
			
			//Limit the angle (half circle)
			if(_angle >= 90 && _angle <= 180)
			{
				_angle = 90;
			}
			else if(_angle <= 270 && _angle >= 180)
			{
				_angle = 270;
			}

			//Powermeter
			_powerMeter.visible = true;
			
			_power =  (_distance / 10) + 1;
			
			//Move the powermeter and scale it according to the intensity
			_powerMeter.x = _cannon.mouseX;
			_powerMeter.y = _cannon.mouseY;
			_powerMeter.scaleX = _powerMeter.scaleY = _power;
			
			//Rotate the cannon
			_cannon.chamber.rotation = _angle;
			
			//Broadcast cannon rotation and power to opponent
			var update:ISFSObject = new SFSObject();
			update.putFloat(Settings.OM_CANNON_ANGLE, _angle);
			
			if(update.size() > 0)	_gameController.broadcastMessage(update);//In production this could take advantage of UDP as an Extension instead
		}
		
		
		
		/**
		 * Shoots the cannonball
		 * 
		 * @param $e :MouseEvent - MOUSE_UP event 
		 */
		private function shoot($e:MouseEvent):void
		{
			//Remove listeners
			stage.removeEventListener(MouseEvent.MOUSE_MOVE, cannonBallMoved);
			stage.removeEventListener(MouseEvent.MOUSE_UP, shoot);
			
			_powerMeter.visible = false;
			
			_soundManager.playSound('boing');
			_soundManager.playSound('cannon');
			_gameController.stopShootingClock(false);
			
			//Visual adjustments
			_cannon.chamber.gotoAndStop(1);
			_fakeBall.visible = false;
			_ball.visible = true;
			
			//World properties
			_world.following = true;
			_world.trajectory.graphics.clear();
			_world.trajectory.graphics.beginFill(0x026602);
			_gameController.shootingClock.visible = false;
			
			//Box2D physics
			var sphereShape		:b2CircleShape	= new b2CircleShape(15/_world.worldScale),
				sphereFixture	:b2FixtureDef 	= new b2FixtureDef(),
				sphereBodyDef	:b2BodyDef 		= new b2BodyDef();
			
			sphereFixture.density = 100;
			sphereFixture.friction = .6;
			sphereFixture.restitution = .05;
			sphereFixture.shape = sphereShape;
			sphereBodyDef.type = b2Body.b2_dynamicBody;
			sphereBodyDef.userData = {assetName:'CANNONBALL', assetSprite:_ball, remove:false, init:false};
			
			//We determine the fake ball (visual ball asset inside the chamber in the .fla) location in its grand parent (the whole cannon, not only the chamber)
			_ballPoint = new Point(_fakeBall.x, 0);
			_ballPoint = localToGlobal(_ballPoint);
			_ballPoint = _cannon.chamber.globalToLocal(_ballPoint);

			//On the right hand side we switch direction
			if (_side == 'right')
			{
				_posX *= -1; 
				_posY *= -1; 
				
				if(_ballPoint.x > 0)
					_ballPoint.x *= -1;
			}
			else
			{
				_ballPoint.y *= -1;
			}
			
			//For shooting 
			_angle	= Math.atan2(_posY, Math.abs(_posX));
			 
			//Negative value (for _posX or _posY) gives you the opposite quadrant, where the actual ball is
			//We also need to add the cannon position and divide all that by the world scale ratio
			sphereBodyDef.position.Set( (_world.activeCannon.x + _ballPoint.x) / _world.worldScale , (_world.activeCannon.y + _ballPoint.y) / _world.worldScale);
			sphereBodyDef.linearDamping = .4;
			
			_sphere = _world.worldB2.CreateBody(sphereBodyDef);
			_sphere.SetBullet(true);
			_sphere.CreateFixture(sphereFixture);

			//On the right hand side direction is inverted (negative) for x only
			//We cut the x component in half cos the screen is small
			(_side == 'right')
			?
				_sphere.SetLinearVelocity(new b2Vec2(-_distance * Math.cos(_angle) * .5, -_distance * Math.sin(_angle)))
			:
				_sphere.SetLinearVelocity(new b2Vec2(_distance * Math.cos(_angle) * .5, -_distance * Math.sin(_angle)));
			
			//Update the room variable with cannonball's angle and distance to be picked up by opponent in the same room
			var update		:ISFSObject = new SFSObject();
			
			update.putDouble('ballPointX', _ballPoint.x);
			update.putDouble('ballPointY', _ballPoint.y);
			update.putDouble('dist', _distance);
			update.putDouble('angle', _angle);

			_gameController.broadcastRoomVariable(update, Settings.RV_CANNON);
		}
		
		
		
		//--------------------------------------------------------------------------
		//  GETTERS & SETTERS
		//--------------------------------------------------------------------------
		
		
		
		public function get cannon():CannonAsset { return _cannon; };
		public function set cannon($value:CannonAsset):void { _cannon = $value; }
		
		public function get ball():CannonBall { return _ball; };
		public function set ball($value:CannonBall):void { _ball = $value; }
		
		public function get sphere():b2Body { return _sphere; };
		public function set sphere($value:b2Body):void { _sphere = $value; }
		
		public function get side():String { return _side; };
		public function set side($value:String):void
		{
			if ($value == 'right')
			{
				_cannon.base.rotation = 180;
				_cannon.base.y -= 112;
			}
			_side = $value;
		}
		
	}
}