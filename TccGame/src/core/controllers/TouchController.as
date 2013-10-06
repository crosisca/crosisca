package core.controllers
{
	import flash.geom.Point;
	import flash.utils.Dictionary;
	
	import Box2D.Common.Math.b2Vec2;
	
	import citrus.core.starling.StarlingCitrusEngine;
	import citrus.input.InputController;
	import citrus.physics.box2d.Box2DUtils;
	
	import starling.display.Stage;
	import starling.events.Touch;
	import starling.events.TouchEvent;
	import starling.events.TouchPhase;
	
	import core.utils.ScreenUtils;
	import core.utils.WorldUtils;
	import core.utils.Controls;
	
	public final class TouchController extends InputController
	{
		protected var actions:Dictionary;
		private var _stage:Stage;
		private var swipeLenghtNecessaryToJump:int = 25;
		
		public function TouchController(name:String, params:Object=null)
		{
			if(!actions)
			{
				actions = new Dictionary();
				actions[Controls.LEFT] = false;
				actions[Controls.RIGHT] = false;
				actions[Controls.JUMP] = false;
			}
			super(name, params);
			_stage = (_ce as StarlingCitrusEngine).starling.stage;
			_stage.addEventListener(TouchEvent.TOUCH, onTouch);
			
		}
		
		/*override public function update():void
		{
			if(!actions)
			{
				actions = new Dictionary();
				actions[Controls.LEFT] = false;
				actions[Controls.RIGHT] = false;
				actions[Controls.JUMP] = false;
			}
		}*/
		
		private function onTouch(event:TouchEvent):void
		{
			var touches:Vector.<Touch> = event.getTouches(_stage);
			
			for (var i:int = 0; i < touches.length; i++) 
			{
				var touch:Touch = touches[i];
				if(touches.length == 1)
				{
					switch(WorldUtils.getWorldRotationDeg())
					{
						case 0:
							if(touch.globalX > ScreenUtils.SCREEN_REAL_WIDTH>>1)
							{
								turnOnAction(Controls.RIGHT);
								turnOffAction(Controls.LEFT);
							}
							else
							{
								turnOnAction(Controls.LEFT);
								turnOffAction(Controls.RIGHT);
							}
							break;
						
						case 90:
							if(touch.globalY > ScreenUtils.SCREEN_REAL_HEIGHT>>1)
							{
								turnOnAction(Controls.RIGHT);
								turnOffAction(Controls.LEFT);
							}
							else
							{
								turnOnAction(Controls.LEFT);
								turnOffAction(Controls.RIGHT);
							}
							break;
						
						case 180:
							if(touch.globalX < ScreenUtils.SCREEN_REAL_WIDTH>>1)
							{
								turnOnAction(Controls.RIGHT);
								turnOffAction(Controls.LEFT);
							}
							else
							{
								turnOnAction(Controls.LEFT);
								turnOffAction(Controls.RIGHT);
							}
							break;
						
						case 270:
							if(touch.globalY < ScreenUtils.SCREEN_REAL_HEIGHT>>1)
							{
								turnOnAction(Controls.RIGHT);
								turnOffAction(Controls.LEFT);
							}
							else
							{
								turnOnAction(Controls.LEFT);
								turnOffAction(Controls.RIGHT);
							}
							break;
					}//End switch
					//Tirou o dedo da tela..desliga todas as acoes de movimento
					if(touch.phase == TouchPhase.ENDED)
						turnOffActions();
				}//End if(touches.lenght == 1)
				
				//Valor do movimento do touch
				var touchMovement:Point = touch.getMovement(_stage);
				//Vetor que guarda o valor do movimento do touch(pra poder ser rotacionado)
				var movedTouchVector:b2Vec2 = new b2Vec2(touchMovement.x, touchMovement.y);
				//Vetor do touch a ser rotacionado de acordo com a rotacao do device.
				var adjustedMoveVector:b2Vec2;
				//Rotaciona o vetor do touch de acordo com a rotacao do device.
				if(WorldUtils.getWorldRotationDeg() == 180 || WorldUtils.getWorldRotationDeg() == 0)
				{
					adjustedMoveVector = Box2DUtils.Rotateb2Vec2(movedTouchVector, WorldUtils.getWorldRotation());
				}
				else if(WorldUtils.getWorldRotationDeg() == 90 || WorldUtils.getWorldRotationDeg() == 270)
				{
					adjustedMoveVector = Box2DUtils.Rotateb2Vec2(movedTouchVector, WorldUtils.getWorldInvertedRotation());
				}
				
				//Se for um SwipeUP > pula
				//trace("SwipeForce:",adjustedMoveVector.y, " Necessary Force:",swipeLenghtNecessaryToJump);
				if(adjustedMoveVector.y < -swipeLenghtNecessaryToJump)
				{
					turnOnAction(Controls.JUMP);
				}
				
				//Desliga o pulo pra n ficar ligado pra sempre
				if(touch.phase == TouchPhase.ENDED)
				{
					turnOffAction(Controls.JUMP);
					touches.splice(i,1);
					//verificarSeInverteuMovimento(touches);
				}
			}
		}
		
		private function verificarSeInverteuMovimento(touches:Vector.<Touch>):void
		{
			if(touches.length == 1)
			{
				var touch:Touch = touches[0];
				switch(WorldUtils.getWorldRotationDeg())
				{
					case 0:
						if(touch.globalX > ScreenUtils.SCREEN_REAL_WIDTH>>1)
						{
							turnOnAction(Controls.RIGHT);
							turnOffAction(Controls.LEFT);
						}
						else
						{
							turnOnAction(Controls.LEFT);
							turnOffAction(Controls.RIGHT);
						}
						break;
					
					case 90:
						if(touch.globalY > ScreenUtils.SCREEN_REAL_HEIGHT>>1)
						{
							turnOnAction(Controls.RIGHT);
							turnOffAction(Controls.LEFT);
						}
						else
						{
							turnOnAction(Controls.LEFT);
							turnOffAction(Controls.RIGHT);
						}
						break;
					
					case 180:
						if(touch.globalX < ScreenUtils.SCREEN_REAL_WIDTH>>1)
						{
							turnOnAction(Controls.RIGHT);
							turnOffAction(Controls.LEFT);
						}
						else
						{
							turnOnAction(Controls.LEFT);
							turnOffAction(Controls.RIGHT);
						}
						break;
					
					case 270:
						if(touch.globalY < ScreenUtils.SCREEN_REAL_HEIGHT>>1)
						{
							turnOnAction(Controls.RIGHT);
							turnOffAction(Controls.LEFT);
						}
						else
						{
							turnOnAction(Controls.LEFT);
							turnOffAction(Controls.RIGHT);
						}
						break;
				}//End switch
				//Tirou o dedo da tela..desliga todas as acoes de movimento
				if(touch.phase == TouchPhase.ENDED)
					turnOffActions();
			}//End if(touches.lenght == 1)
		}
		
		private function turnOnAction(action:String):void
		{
			if(!actions.action)
			{
				triggerON(action);
				actions.action = true;
			}
		}
		
		private function turnOffAction(action:String):void
		{
			if(actions.action)
			{
				triggerOFF(action);
				actions.action = false;
			}
		}
		
		private function turnOffActions():void
		{
			triggerOFF(Controls.LEFT);
			actions.left = false;
			triggerOFF(Controls.RIGHT);
			actions.right = false;
			triggerOFF(Controls.JUMP);
			actions.jump = false;
		}
	}
}