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
	 * BasicArena
	 * 
	 * Physics world logic
	 * 
	 * @author 		Wayne Helman, Fabricio Medeiros
	 * @copyright 	2012 gotoAndPlay() - http://www.smartfoxserver.com
	 * @version		1.0 
	 */
	
	import Box2D.Collision.Shapes.b2CircleShape;
	import Box2D.Collision.Shapes.b2PolygonShape;
	import Box2D.Common.Math.b2Vec2;
	import Box2D.Dynamics.b2Body;
	import Box2D.Dynamics.b2BodyDef;
	import Box2D.Dynamics.b2DebugDraw;
	import Box2D.Dynamics.b2FixtureDef;
	import Box2D.Dynamics.b2World;
	
	import com.greensock.TweenLite;
	import com.smartfoxserver.v2.entities.User;
	import com.smartfoxserver.v2.entities.data.ISFSObject;
	import com.smartfoxserver.v2.entities.data.SFSObject;
	
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.events.Event;
	
	import sfs2x.games.cannoncombat.GameController;
	import sfs2x.games.cannoncombat.config.Settings;
	import sfs2x.games.cannoncombat.events.CustomEvent;
	import sfs2x.games.cannoncombat.managers.InstanceManager;
	import sfs2x.games.cannoncombat.managers.SoundManager;
	
	public class BasicArena extends Sprite
	{
		protected var
			_worldB2				:b2World,
			_customContact			:CustomContactListener,
			_windowID				:String,
			_gameController			:GameController,
			_soundManager			:SoundManager,
			
			_playerTurn				:String,
			_worldScale				:int,
			_numberSoldiers			:int,
			_numberSoldiersKilled	:int,
			
			_following				:Boolean,
			_isSpectator			:Boolean,
			_worldAsleep			:Boolean,
			_collisionInit			:Boolean,
			_p1						:User,
			_p2						:User,
			
			_activeCannon			:Cannon,
			_inActiveCannon			:Cannon,
			_p1Cannon				:Cannon,
			_p2Cannon				:Cannon,
			
			_trajectory				:Sprite,
			
			_body					:MovieClip,
			_bg						:BG,
			_arrBodies				:Array,
				
			_myName					:String;
			
			
		/**
		 * Constructor
		 */
		public function BasicArena()
		{
			
		}
		
		
		
		/**
		 * After the arena is added to the stage we initialize it
		 *
		 * @param $myName :String - User name
		 */
		public function init($myName:String = ''):void
		{
			_worldB2 = new b2World(new b2Vec2(0,10),true);
			
			_customContact = new CustomContactListener();
			_worldB2.SetContactListener(_customContact);
			
			_soundManager = InstanceManager.getSoundManagerInstance(_windowID);
			
			_isSpectator = _gameController.isSpectator;
			
			_p1Cannon = new Cannon();
			_p2Cannon = new Cannon();
			
			_trajectory	= new Sprite();
			
			_following = false;
			_isSpectator = false;
			_worldAsleep = false;
			_collisionInit = false;
			
			_worldScale	= 30;
			_numberSoldiers	= 0;
			_numberSoldiersKilled = 0;
			
			_bg	= new BG();
			
			_arrBodies = [];
			
			// Display list
			addChild(_bg);
			addChild(_trajectory);
			
			//For debug only
			//debugDraw();
			
			if(!_isSpectator)
				_myName = $myName;
			
			//First player always go on the left
			if(_playerTurn == _p1.name)
			{
				_p1Cannon.side = 'left';
				_p2Cannon.side = 'right';
			}
			else
			{
				_p1Cannon.side = 'right';
				_p2Cannon.side = 'left';
			}
			
			//Set up bodies
			setUp();
			
			addChild(_p2Cannon);
			addChild(_p1Cannon);
		}
		
		
		
		/**
		 * Initial setup of the arena (not a reset)
		 */
		public function setUp():void
		{

		}
		
		
		
		/**
		 * It resets the world for each turn played
		 */
		public function reset():void
		{
			TweenLite.killDelayedCallsTo(sleepCheck);
			
			_collisionInit = false;
			
			_p1Cannon.reset();
			_p2Cannon.reset();
			
			_trajectory.graphics.clear();
			_trajectory.graphics.endFill();
		}
		
		
		
		/**
		 * Adds a Box2D body based on parameters
		 * 
		 * @param $w :Number - width
		 * @param $h :Number - height
		 * @param $w :Number - left or right
		 * @param $w :Number - x position
		 * @param $w :Number - y position
		 * @param $w :Number - type of body
		 */
		protected function addBody($w:Number = 0, $h:Number = 0, $side:String = '', $x:Number = 0, $y:Number = 0, $type:String = '', $index:Number = -1):void
		{
			var shape		:*,
				fixture		:b2FixtureDef 		= new b2FixtureDef(),
				bodyDef		:b2BodyDef 			= new b2BodyDef(),
				body		:b2Body,
				density		:Number				= 1,
				restitution	:Number				= .01,
				friction	:Number				= .4;
			
			_body = null;
			
			switch ($type)
			{
				case 'DESK':
					shape = new b2PolygonShape();
					
					$w *= 8;
					
					_body = new Desk();
					_body.name = 'DESK';
					
					fixture.density = 0;
					fixture.friction = 2;
					fixture.restitution = .3;
					
					bodyDef.userData = {assetName:'DESK', index:$index, assetSprite:_body, remove:false};
				break;
				case 'BOOK_RED':
				case 'BOOK_BLUE':
					shape = new b2PolygonShape();
					
					if($type == 'BOOK_BLUE')
					{
						_body = new BookBlue();
						_body.name = 'BOOK_BLUE';
						bodyDef.userData = {assetName:'BOOK_BLUE', index:$index, assetSprite:_body, remove:false};
					}
					else
					{
						_body = new BookRed();
						_body.name = 'BOOK_RED';
						bodyDef.userData = {assetName:'BOOK_RED', index:$index, assetSprite:_body, remove:false};
					}
					
					if($side == 'right')
					{
						_body.gotoAndStop(2);
					}
					
					fixture.density = 0;
					fixture.friction = friction * 5;
					fixture.restitution = restitution;
				break;
				case 'BLOCK_A':
				case 'BLOCK_B':
				case 'BLOCK_C':
					shape = new b2PolygonShape();
					
					if($type == 'BLOCK_A')
					{
						_body = new BlockA();
						_body.name = 'BLOCK_A';
						bodyDef.userData = {assetName:'BLOCK_A', index:$index, assetSprite:_body, remove:false};
					}
					else if($type == 'BLOCK_B')
					{
						_body = new BlockB();
						_body.name = 'BLOCK_B';
						bodyDef.userData = {assetName:'BLOCK_B', index:$index, assetSprite:_body, remove:false};
					}
					else if($type == 'BLOCK_C')
					{
						_body = new BlockC();
						_body.name = 'BLOCK_C';
						bodyDef.userData = {assetName:'BLOCK_C', index:$index, assetSprite:_body, remove:false};
					}
						
					fixture.density = density;
					fixture.friction = friction;
					fixture.restitution = restitution;
					
				break;
				case 'SOLDIER':
					shape = new b2CircleShape($w);
					
					_body = new Soldier();
					_body.name = 'SOLDIER';
					_body.destroy = false;
					
					if($side == 'left')
					{
						_body.gotoAndStop(2);
					}
					
					fixture.density = 2;
					fixture.friction = 6;
					fixture.restitution = 0;
					
					bodyDef.userData = {assetName:'SOLDIER', index:$index, assetSprite:_body, remove:false};
					
					_numberSoldiers ++;
				break;
				case 'DOMINO_1':
				case 'DOMINO_2':
				case 'DOMINO_3':
					shape = new b2PolygonShape();
					
					if($type == 'DOMINO_1')
					{
						_body = new Domino1();
						_body.name = 'DOMINO_1';
						bodyDef.userData = {assetName:'DOMINO_1', index:$index, assetSprite:_body, remove:false};
					}
					else if($type == 'DOMINO_2')
					{
						_body = new Domino2();
						_body.name = 'DOMINO_2';
						bodyDef.userData = {assetName:'DOMINO_2', index:$index, assetSprite:_body, remove:false};
					}
					else if($type == 'DOMINO_3')
					{
						_body = new Domino3();
						_body.name = 'DOMINO_3';
						bodyDef.userData = {assetName:'DOMINO_3', index:$index, assetSprite:_body, remove:false};
					}
					
					fixture.density = density;
					fixture.friction = friction;
					fixture.restitution = restitution;
					
				break;
				case 'PENCIL':
					shape = new b2PolygonShape();
					
					_body = new Pencil();
					_body.name = 'PENCIL';
					
					fixture.density = density + .2;
					fixture.friction = friction;
					fixture.restitution = restitution;
					
					if($side == 'right')
					{
						_body.gotoAndStop(2);
					}

					bodyDef.userData = {assetName:'PENCIL', index:$index, assetSprite:_body, remove:false};
					
				break;
				case 'CRAYON_B':
				case 'CRAYON_P':
				case 'CRAYON_G':
				case 'CRAYON_O':
					shape = new b2PolygonShape();
					
					if($type == 'CRAYON_B')
					{
						_body = new CrayonBlue();
						_body.name = 'CRAYON_B';
						bodyDef.userData = {assetName:'CRAYON_B', index:$index, assetSprite:_body, remove:false};
					}
					else if($type == 'CRAYON_P')
					{
						_body = new CrayonPurple();
						_body.name = 'CRAYON_P';
						bodyDef.userData = {assetName:'CRAYON_P', index:$index, assetSprite:_body, remove:false};
					}
					else if($type == 'CRAYON_G')
					{
						_body = new CrayonGreen();
						_body.name = 'CRAYON_G';
						bodyDef.userData = {assetName:'CRAYON_G', index:$index, assetSprite:_body, remove:false};
					}
					else if($type == 'CRAYON_O')
					{
						_body = new CrayonOrange();
						_body.name = 'CRAYON_O';
						bodyDef.userData = {assetName:'CRAYON_O', index:$index, assetSprite:_body, remove:false};
					}

					if($side == 'right')
					{
						_body.gotoAndStop(2);
					}
					
					fixture.density = density;
					fixture.friction = friction * 5;
					fixture.restitution = 0;
					
				break;
				case 'KNIGHT':
					shape = new b2PolygonShape();
					
					_body = new Knight();
					_body.name = 'KNIGHT';
					
					fixture.density = density;
					fixture.friction = friction;
					fixture.restitution = restitution;
					
					if($side == 'left')
					{
						_body.gotoAndStop(2);
					}
					
					bodyDef.userData = {assetName:'KNIGHT', index:$index, assetSprite:_body, remove:false};
					
				break;
			}
			
			if(_body.name != 'SOLDIER')
			{
				shape.SetAsBox($w, $h)
			}
			
			_body.cacheAsBitmap = true;
			addChild(_body);
			
			bodyDef.position.Set($x, $y);
			
			if(_body.name != 'DESK' && _body.name != 'BOOK_BLUE' && _body.name != 'BOOK_RED')
				bodyDef.type = b2Body.b2_dynamicBody;
			
			fixture.shape = shape;
			
			body = _worldB2.CreateBody(bodyDef);
			//body.ResetMassData();
			body.CreateFixture(fixture);
			
			if(_body.name != 'DESK' && _body.name != 'BOOK_BLUE' && _body.name != 'BOOK_RED')
				_arrBodies.push(body);
		}
		
		
		
		/**
		 * It draws Box2D debug areas
		 */
		protected function debugDraw():void
		{
			var worldDebugDraw	:b2DebugDraw	= new b2DebugDraw(),
				debugSprite		:Sprite 		= new Sprite();
			
			addChild(debugSprite);
			worldDebugDraw.SetSprite(debugSprite);
			worldDebugDraw.SetDrawScale(_worldScale);
			worldDebugDraw.SetFlags(b2DebugDraw.e_shapeBit|b2DebugDraw.e_jointBit);
			worldDebugDraw.SetFillAlpha(0.8);
			_worldB2.SetDebugDraw(worldDebugDraw);
		}
		
		
		
		/**
		 * Resets properties and broadcasts a message once the timer has expired
		 */
		public function timeExpired():void 
		{
			removeEventListener(Event.ENTER_FRAME, updateWorld);
			
			if(!_gameController.isSpectator)
			{
				var update:ISFSObject = new SFSObject();
				update.putBool(Settings.OM_ASLEEP, true);
				
				if(_playerTurn != _myName && !_isSpectator)
				{
					if(update.size() > 0)
						_gameController.broadcastMessage(update);
				}
			}
		}
		
		
		
		/**
		 * Stops the world
		 */
		public function stop():void 
		{
			removeEventListener(Event.ENTER_FRAME, updateWorld);
			
			_trajectory.graphics.clear();
			_trajectory.graphics.endFill();
			
			TweenLite.killDelayedCallsTo(sleepCheck);
			_gameController.killDelayedCallWorld();
			
			_collisionInit = false;
		}
		
		
		
		/**
		 * Sets a body in sleep state
		 */
		public function setAsleep():void
		{
			var	body	:b2Body;
			
			for each (body in _arrBodies)
			{
				body.SetAwake(false);
				body.SetLinearVelocity(new b2Vec2(0,0));
			}
		}
		
		
		
		/**
		 * Checks the array of bodies for movement (not in sleep state)
		 */
		public function sleepCheck():void
		{
			TweenLite.delayedCall(1, sleepCheck);
			
			var awake	:Boolean,
				body	:b2Body,
				data	:*;
			
			_worldAsleep = true;
			
			for each (body in _arrBodies)
			{
				awake = body.IsAwake();

				if(awake || Math.abs(body.GetLinearVelocity().x) > 0.001 || Math.abs(body.GetLinearVelocity().y) > 0.001)
				{
					_worldAsleep = false;
					break;
				}
				else
				{
					_worldAsleep = true;
				}
			}
			
			if(_worldAsleep && _collisionInit)
			{
				_collisionInit = false;

				TweenLite.killDelayedCallsTo(sleepCheck);
				
				//Tell the controller to not trigger the time expired event
				_gameController.stopWorldTimer();
			}
		}
		
		
		
		/**
		 * Removes an element from the bodies array
		 */
		public function setStillFromBodiesArray($index:Number):void
		{
			var n: int = _arrBodies.length;

			while(--n > -1)
			{
				if($index == _arrBodies[n].GetUserData().index)
				{
					(_arrBodies[n] as b2Body).SetAwake(false);
					(_arrBodies[n] as b2Body).SetLinearVelocity(new b2Vec2(0, 0));
					
					return;
				}
			}
		}
		
		
		
		/**
		 * Updates world properties based on an ENTER_FRAME event
		 * 
		 * @param $e :Event - ENTER_FRAME event
		 */
		protected function updateWorld($e:Event):void
		{
			_worldB2.Step(1/_worldScale, 10, 10);

			//Loop through all bodies to update their x, y position and rotation and also remove those that have been set to be removed
			var currentBody	:b2Body = _worldB2.GetBodyList(),
				assetSprite	:*,
				assetName	:String;
				
			for (currentBody; currentBody; currentBody = currentBody.GetNext())
			{
				var data:* = currentBody.GetUserData();
				
				if (data.assetSprite != null)
				{
					assetName = data.assetName.toString();
					assetSprite = data.assetSprite;
					
					if( assetName === 'CANNONBALL')
					{
						//If the cannonball hits one of the moving bodies we set a flag to true for when checking the world state
						//Please see: CustomContactListener
						if(data.init)
							_collisionInit = true;
						
						_trajectory.graphics.drawCircle(_activeCannon.sphere.GetPosition().x * _worldScale, _activeCannon.sphere.GetPosition().y * _worldScale, 1);
						
						if(_activeCannon.side === 'left')
						{
							assetSprite.x = (_activeCannon.sphere.GetPosition().x * _worldScale) - _activeCannon.x;
							assetSprite.y = (_activeCannon.sphere.GetPosition().y * _worldScale) - _activeCannon.y;
						}
						else
						{
							assetSprite.x = ((_activeCannon.sphere.GetPosition().x * _worldScale) - _activeCannon.x) * -1;
							assetSprite.y = ((_activeCannon.sphere.GetPosition().y * _worldScale) - _activeCannon.y) * -1;
						}
						
						assetSprite.rotation = _activeCannon.sphere.GetAngle() * (180/Math.PI);
					}
					else
					{
						assetSprite.x = currentBody.GetPosition().x * _worldScale;
						assetSprite.y = currentBody.GetPosition().y * _worldScale;
						assetSprite.rotation = currentBody.GetAngle() * (180/Math.PI);
					}
					
					if (data.remove)
					{
						var mc:MovieClip = (assetSprite as MovieClip);
						mc.gotoAndPlay(3);
						mc.rotation = 0;
						
						_soundManager.playSound('smash');
						
						//Dispatch soldier killed to add on gamecontroller
						_gameController.dispatchEvent(new CustomEvent(CustomEvent.SOLDIER_KILLED, true, false));
						
						if(_playerTurn === _myName)
						{
							_numberSoldiersKilled ++;
							
							if(_numberSoldiersKilled === _numberSoldiers)
							{
								//Game over once all soldiers are dead
								_gameController.dispatchEvent(new CustomEvent(CustomEvent.GAME_OVER));
							}
						}
						
						_worldB2.DestroyBody(currentBody);
						setStillFromBodiesArray(data.index);
					}
				}
			}
			
			//Camera movement
			if (_following)
			{
				//Decide which direction camera should move
				(_activeCannon.side == 'left') ? x = 400 - _activeCannon.ball.x - _activeCannon.x : x = 400 + _activeCannon.ball.x - _activeCannon.x;
				
				//Lock camera movement
				if (x < -1436)
				x = -1436;
				
				if (x > 0)
				x = 0;
			}

			_worldB2.ClearForces();
			_worldB2.DrawDebugData();
		}
		
		
		
		/**
		 * Removes elements from memory
		 * 
		 */
		public function destroy():void
		{
			while (this.numChildren)
			{
				var child:* = removeChildAt(0);
					child = null;
			}
			
			_worldB2.ClearForces();
			_worldB2 = null;
			_customContact = null;
			_soundManager = null;
			_arrBodies = [];
			_playerTurn = '';
			_myName = '';
			TweenLite.killDelayedCallsTo(sleepCheck);
			_gameController.killDelayedCallWorld();
			_collisionInit = false;
			
			removeEventListener(Event.ENTER_FRAME, updateWorld);
		}
		
		
		
		//--------------------------------------------------------------------------
		//  GETTERS & SETTERS
		//--------------------------------------------------------------------------
		
		
		
		public function get activeCannon():Cannon { return _activeCannon; };
		public function set activeCannon($value:Cannon):void { _activeCannon = $value; }
		
		public function get inActiveCannon():Cannon { return _inActiveCannon; };
		public function set inActiveCannon($value:Cannon):void { _inActiveCannon = $value; }
		
		public function get p1():User { return _p1; };
		public function set p1($value:User):void { _p1 = $value; }
	
		public function get p2():User { return _p2; };
		public function set p2($value:User):void { _p2 = $value; }
		
		public function get following():Boolean { return _following; };
		public function set following($value:Boolean):void { _following = $value; }
		
		public function get playerTurn():String { return _playerTurn; };
		public function set playerTurn($value:String):void { _playerTurn = $value; }
		
		public function get worldScale():int { return _worldScale; };
		public function set worldScale($value:int):void { _worldScale = $value; }
		
		public function get worldB2():b2World { return _worldB2; };
		public function set worldB2($value:b2World):void { _worldB2 = $value; }
		
		public function get gameController():GameController { return _gameController; };
		public function set gameController($value:GameController):void { _gameController = $value; }
		
		public function get trajectory():Sprite { return _trajectory; };
		public function set trajectory($value:Sprite):void { _trajectory = $value; }
		
		public function get windowID():String { return _windowID; };
		public function set windowID($value:String):void { _windowID = $value; }
		
		public function get worldAsleep():Boolean { return _worldAsleep; };
		public function set worldAsleep($value:Boolean):void { _worldAsleep = $value; }
		
		public function get collisionInit():Boolean { return _collisionInit; };
		public function set collisionInit($value:Boolean):void { _collisionInit = $value; }
		
		public function get arrBodies():Array { return _arrBodies; };
		public function set arrBodies($value:Array):void { _arrBodies = $value; }
		
		
	}
}