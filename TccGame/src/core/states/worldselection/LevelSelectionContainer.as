package core.states.worldselection
{
	import core.art.AssetsManager;
	import core.data.GameData;
	import core.utils.Debug;
	import core.utils.LevelInfo;
	
	import org.osflash.signals.Signal;
	
	import starling.display.Button;
	import starling.display.Image;
	import starling.display.Sprite;
	import starling.events.Event;
	import starling.textures.Texture;
	
	public final class LevelSelectionContainer extends Sprite
	{
		private var _background:Image;
		private var levelButtonsVector:Vector.<LevelButton> = new Vector.<LevelButton>;
		public var onLevelChosen:Signal = new Signal();
		public var onClose:Signal = new Signal();
		private var closeButton:Button;
		
		public function LevelSelectionContainer(background:Texture)
		{
			super();
			
			_background = new Image(background);
			this.addChild(_background);
			
			closeButton = new Button(AssetsManager.getInstance().getTextureAtlas("MenuAtlas").getTexture("quitButton"));
			closeButton.pivotX = closeButton.width>>1;
			closeButton.pivotY = closeButton.height>>1;
			closeButton.x = (_background.x + _background.width) - closeButton.width;
			closeButton.y = _background.y + closeButton.height;
			closeButton.addEventListener(Event.TRIGGERED, onClosePressed);
			this.addChild(closeButton);
			
			var levelNumber:int = 0;
			
			for (var j:int = 0; j < 2; j++) 
			{
				for (var i:int = 0; i < 5; i++) 
				{
					levelNumber++;
					var levelButton:LevelButton = new LevelButton(Texture.empty(64,64),levelNumber.toString());
					levelButton.x = ( ( this.width - ( levelButton.width*5 ) ) / 6) * ( i + 1 ) + ( levelButton.width * i );
					levelButton.y = ( ( this.height - ( levelButton.height*4 ) ) / 5) * ( j + 1 ) + ( levelButton.height * j );
					this.addChild(levelButton);
					levelButton.addEventListener(Event.TRIGGERED, onLevelButtonPressed);
					levelButtonsVector.push(levelButton);
				}
			}
		}
		
		private function onLevelButtonPressed(event:starling.events.Event):void
		{
			for (var i:int = 0; i < levelButtonsVector.length; i++) 
			{
				if(event.currentTarget == levelButtonsVector[i])
				{
					GameData.getInstance().activeLevelNumber = i+1;
				}
			}
			onLevelChosen.dispatch(GameData.getInstance().activeWorld,GameData.getInstance().activeLevelNumber);
		}
		
		public function updateInfo(worldNumber:int):void
		{
			Debug.log("[LevelSelectionContainer] UpdatingButtonInfo","world:",worldNumber);
			var lockedButton:Texture = AssetsManager.getInstance().getTextureAtlas("MenuAtlas").getTexture("world"+worldNumber+"levelLocked");
			var unlockedButton:Texture = AssetsManager.getInstance().getTextureAtlas("MenuAtlas").getTexture("world"+worldNumber+"levelUnlocked");
				
			var index:int;
			
			
			
			for each (var button:LevelButton in levelButtonsVector) 
			{
				index  = ((worldNumber-1) * GameData.getInstance().LevelsQuantityByWorld) + (int(button.text) -1);
				
				//Locked or unlocked
				if(LevelInfo(GameData.levelsInfo[index]).locked)
				{
					button.updateInfo(lockedButton,worldNumber);
					//button.upState = lockedButton;
					//button.downState = lockedButton;
				}
				else
				{
					button.updateInfo(unlockedButton,worldNumber);
					//button.upState = unlockedButton;
					//button.downState = unlockedButton;
				}
				
				
			}
		}
		
		private function onClosePressed():void
		{
			onClose.dispatch();
		}
		
		public function destroy():void
		{
			this.removeChild(_background);
			_background = null;
		}
	}
}