package core.states.worldselection
{
	import flash.geom.Point;
	
	import core.art.AssetsManager;
	import core.data.GameData;
	
	import org.osflash.signals.Signal;
	
	import starling.display.Button;
	import starling.display.DisplayObject;
	import starling.display.Image;
	import starling.display.Sprite;
	import starling.events.Touch;
	import starling.events.TouchEvent;
	import starling.events.TouchPhase;
	
	public final class WorldSelectionWindow extends Sprite
	{
		private var _background:Image;
		//private var _worldsContainer:WorldsContainer;
		
		//TEste
		private var levelSelectionContainer:LevelSelectionContainer;
		private var btExitLevelSelector:Button;
		
		public var onLevelSelected:Signal = new Signal();
		//fim teste
		private var selectingWorld:Boolean = false;
		
		private var gameData:GameData;
		private var _assets:AssetsManager;
		
		private var world1Button:Button;
		private var world2Button:Button;
		private var world3Button:Button;
		private var world4Button:Button;
		private var helperPoint:Point = new Point();
		
		public function WorldSelectionWindow()
		{
			super();
			
			gameData = GameData.getInstance();
			
			_assets = AssetsManager.getInstance();
			
			_background = new Image(_assets.getTextureAtlas("MenuAtlas").getTexture("backgroundMenu"));
			this.addChild(_background);
			
			world1Button = new Button(_assets.getTextureAtlas("MenuAtlas").getTexture("world1button"));
			world1Button.pivotX = world1Button.width * .5;
			world1Button.pivotY = world1Button.height * .5;
			world1Button.x = _background.x + _background.width * .2;
			world1Button.y = _background.y + _background.height * .5;
			this.addChild(world1Button);
			
			world2Button = new Button(_assets.getTextureAtlas("MenuAtlas").getTexture("world2button"));
			world2Button.pivotX = world2Button.width * .5;
			world2Button.pivotY = world2Button.height * .5;
			world2Button.x = _background.x + _background.width * .4;
			world2Button.y = _background.y + _background.height * .5;
			this.addChild(world2Button);
			
			world3Button = new Button(_assets.getTextureAtlas("MenuAtlas").getTexture("world3button"));
			world3Button.pivotX = world3Button.width * .5;
			world3Button.pivotY = world3Button.height * .5;
			world3Button.x = _background.x + _background.width * .6;
			world3Button.y = _background.y + _background.height * .5;
			this.addChild(world3Button);8;
			
			world4Button = new Button(_assets.getTextureAtlas("MenuAtlas").getTexture("world4button"));
			world4Button.pivotX = world4Button.width * .5;
			world4Button.pivotY = world4Button.height * .5;
			world4Button.x = _background.x + _background.width * .8;
			world4Button.y = _background.y + _background.height * .5;
			this.addChild(world4Button);
			
			/*_worldsContainer = new WorldsContainer();
			_worldsContainer.x = ScreenUtils.SCREEN_REAL_WIDTH * .5;
			_worldsContainer.y = ScreenUtils.SCREEN_REAL_HEIGHT;
			this.addChild(_worldsContainer);*/
			
			levelSelectionContainer = new LevelSelectionContainer(_assets.getTextureAtlas("MenuAtlas").getTexture("backgroundLevelSelection"));
			levelSelectionContainer.onLevelChosen.add(onLevelChosen);
			levelSelectionContainer.onClose.add(onCloseLevelSelection);
			this.addEventListener(TouchEvent.TOUCH, onTouch);
			
			//teste
			/*var fundoLevelSelectionContainer:Image = new Image(Texture.fromColor(1024,768,0xFF0000FF));
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
			}*/
		}
		
		private function onTouch(event:TouchEvent):void
		{
			var touch:Touch = event.getTouch(this, TouchPhase.ENDED);
			
			if(touch)
			{
				helperPoint.x = touch.globalX;
				helperPoint.y = touch.globalY;
				var hitObject:DisplayObject = this.stage.hitTest(helperPoint, true);
				
				if(world1Button.contains(hitObject))
					selectWorld(1);
				else if(world2Button.contains(hitObject))
					selectWorld(2);
				else if(world3Button.contains(hitObject))
					selectWorld(3);
				else if(world4Button.contains(hitObject))
					selectWorld(4);
			}
		}
		
		private function selectWorld(worldNumber:int):void
		{
			gameData.activeWorld = worldNumber;
			levelSelectionContainer.updateInfo(worldNumber);
			this.addChild(levelSelectionContainer);
		}
		
		private function onLevelChosen(worldNumber:int,levelNumber:int):void
		{
			onLevelSelected.dispatch(worldNumber,levelNumber);
		}
		
		private function onCloseLevelSelection():void
		{
			this.removeChild(levelSelectionContainer);
		}
		
		/*private function onTouch(event:TouchEvent):void
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
		}*/
	}
}