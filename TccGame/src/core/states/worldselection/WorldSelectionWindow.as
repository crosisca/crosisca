package core.states.worldselection
{
	import com.greensock.TweenNano;
	
	import flash.geom.Point;
	import flash.utils.getDefinitionByName;
	
	import away3d.core.math.MathConsts;
	
	import core.data.GameData;
	import core.levels.AbstractLevel;
	import core.utils.ScreenUtils;
	
	import org.osflash.signals.Signal;
	
	import starling.display.Button;
	import starling.display.Image;
	import starling.display.Sprite;
	import starling.events.Event;
	import starling.events.Touch;
	import starling.events.TouchEvent;
	import starling.events.TouchPhase;
	import starling.textures.Texture;
	
	public final class WorldSelectionWindow extends Sprite
	{
		private var _background:Image;
		private var _worldsContainer:WorldsContainer;
		
		//TEste
		private var levelSelectionContainer:Sprite = new Sprite();
		private var btExitLevelSelector:Button;
		private var levelButtonsVector:Vector.<Button> = new Vector.<Button>;
		
		public var onLevelSelected:Signal = new Signal();
		//fim teste
		private var selectingWorld:Boolean = false;
		
		private var gameData:GameData;
		
		public function WorldSelectionWindow()
		{
			super();
			
			gameData = GameData.getInstance();
			
			_background = new Image(Texture.fromColor(2048,1536,0xFF00007F));
			this.addChild(_background);
			
			_worldsContainer = new WorldsContainer();
			_worldsContainer.x = ScreenUtils.SCREEN_REAL_WIDTH * .5;
			_worldsContainer.y = ScreenUtils.SCREEN_REAL_HEIGHT;
			this.addChild(_worldsContainer);
			
			this.addEventListener(TouchEvent.TOUCH, onTouch);
			
			//teste
			var fundoLevelSelectionContainer:Image = new Image(Texture.fromColor(1024,768,0xFF0000FF));
			levelSelectionContainer.addChild(fundoLevelSelectionContainer);
			levelSelectionContainer.x = (ScreenUtils.SCREEN_REAL_WIDTH - levelSelectionContainer.width)/2;
			levelSelectionContainer.y = (ScreenUtils.SCREEN_REAL_HEIGHT - levelSelectionContainer.height)/2;
			
			btExitLevelSelector = new Button(Texture.fromColor(50,50,0xFFFF0000),"X");
			btExitLevelSelector.addEventListener(starling.events.Event.TRIGGERED, onCloseLevelSelector);
			btExitLevelSelector.x = levelSelectionContainer.width - ( btExitLevelSelector.width * 1.5 );
			btExitLevelSelector.y = btExitLevelSelector.height * 1.5;
			levelSelectionContainer.addChild(btExitLevelSelector);
			
			//Cria todos os botoes dos levels
			var levelNumber:int = 0;
			for (var j:int = 0; j < 2; j++) 
			{
				for (var i:int = 0; i < 5; i++) 
				{
					levelNumber++;
					var levelButton:Button = new Button(Texture.fromColor(64,64,0xFFFF00FF),levelNumber.toString());
					levelButton.x = ( ( levelSelectionContainer.width - ( levelButton.width*5 ) ) / 6) * ( i + 1 ) + ( levelButton.width * i );
					levelButton.y = ( ( levelSelectionContainer.height - ( levelButton.height*4 ) ) / 5) * ( j + 1 ) + ( levelButton.height * j );
					levelSelectionContainer.addChild(levelButton);
					levelButton.addEventListener(starling.events.Event.TRIGGERED, onLevelButtonSelected);
					levelButtonsVector.push(levelButton);
				}
			}
			//fimteste
		}
		
		private function onTouch(event:TouchEvent):void
		{
			var touch:Touch = event.getTouch(this, TouchPhase.MOVED);
			
			if(touch)
			{
				//Valor do movimento do touch
				var touchMovement:Point = touch.getMovement(this);
				
				if(touchMovement.x > 50)
				{
					TweenNano.to(_worldsContainer, .5,{rotation:_worldsContainer.rotation + (90 * MathConsts.DEGREES_TO_RADIANS), onComplete:ableTouch});
					this.removeEventListener(TouchEvent.TOUCH, onTouch);
				}
				else if(touchMovement.x < -50)
				{
					TweenNano.to(_worldsContainer, .5,{rotation:_worldsContainer.rotation - (90 * MathConsts.DEGREES_TO_RADIANS), onComplete:ableTouch});
					this.removeEventListener(TouchEvent.TOUCH, onTouch);
				}
				selectingWorld = true;
			}
			else
			{
				selectingWorld = false;
			}
			
			if(!selectingWorld)
			{
				var stationaryTouch:Touch = event.getTouch(this, TouchPhase.ENDED);
				if(stationaryTouch && stationaryTouch.getMovement(this).x < 10 && stationaryTouch.getMovement(this).y < 10)
				{
					if(stationaryTouch.isTouching(_worldsContainer.world1))
					{
						gameData.activeWorld = 1;
						this.addChild(levelSelectionContainer);
					}
					else if(stationaryTouch.isTouching(_worldsContainer.world2))
					{
						gameData.activeWorld = 2;
						this.addChild(levelSelectionContainer);
					}
					else if(stationaryTouch.isTouching(_worldsContainer.world3))
					{
						gameData.activeWorld = 3;
						this.addChild(levelSelectionContainer);
					}
					else if(stationaryTouch.isTouching(_worldsContainer.world4))
					{
						gameData.activeWorld = 4;
						this.addChild(levelSelectionContainer);
					}
				}
			}
		}
		
		private function ableTouch():void
		{
			this.addEventListener(TouchEvent.TOUCH, onTouch);
		}
		
		
		//Testes
		private function onCloseLevelSelector(event:starling.events.Event):void
		{
			this.removeChild(levelSelectionContainer);
		}
		
		private function onLevelButtonSelected(event:starling.events.Event):void
		{
			for (var i:int = 0; i < levelButtonsVector.length; i++) 
			{
				if(event.currentTarget == levelButtonsVector[i])
				{
					gameData.activeLevelNumber = i+1;
				}
			}
			onLevelSelected.dispatch(gameData.activeWorld,gameData.activeLevelNumber);
		}
	}
}