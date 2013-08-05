package states
{
	import citrus.core.starling.StarlingState;
	
	import starling.display.Button;
	import starling.display.Image;
	import starling.display.Sprite;
	import starling.events.Event;
	import starling.textures.Texture;
	
	public final class MenuState extends StarlingState
	{
		private var backgroundImg:Image;
		private var world1Img:Button;
		private var world2Img:Button;
		private var world3Img:Button;
		private var world4Img:Button;
		private var world5Img:Button;
		private var worldSelectionContainer:Sprite = new Sprite();
		private var levelSelectionContainer:Sprite = new Sprite();
		private var currentlySelectedWorld:int = 0;
		private var levelButtonsVector:Vector.<Button> = new Vector.<Button>;
		
		public function MenuState()
		{
			super();
		}
		
		override public function initialize():void
		{
			super.initialize();

			backgroundImg = new Image(AssetsManager.getMenuAtlas().getTexture("MenuWorldBg"));
			addChild(backgroundImg);
			
			var offset:int = backgroundImg.width*.1;
			
			world1Img = new Button(AssetsManager.getMenuAtlas().getTexture("World1"));
			world1Img.y = 100;
			world1Img.x = offset + 100*1;
			worldSelectionContainer.addChild(world1Img);
			world1Img.addEventListener(Event.TRIGGERED, handleWorldSelection);
			
			world2Img = new Button(AssetsManager.getMenuAtlas().getTexture("World2"));
			world2Img.y = 100;
			world2Img.x = offset + 100*2;
			worldSelectionContainer.addChild(world2Img);
			world2Img.addEventListener(Event.TRIGGERED, handleWorldSelection);
			
			world3Img = new Button(AssetsManager.getMenuAtlas().getTexture("World3"));
			world3Img.y = 100;
			world3Img.x = offset + 100*3;
			worldSelectionContainer.addChild(world3Img);
			world3Img.addEventListener(Event.TRIGGERED, handleWorldSelection);
			
			world4Img = new Button(AssetsManager.getMenuAtlas().getTexture("World4"));
			world4Img.y = 100;
			world4Img.x = offset + 100*4;
			worldSelectionContainer.addChild(world4Img);
			world4Img.addEventListener(Event.TRIGGERED, handleWorldSelection);
			
			world5Img = new Button(AssetsManager.getMenuAtlas().getTexture("World5"));
			world5Img.y = 100;
			world5Img.x = offset + 100*5;
			worldSelectionContainer.addChild(world5Img);
			world5Img.addEventListener(Event.TRIGGERED, handleWorldSelection);
			
			addChild(worldSelectionContainer);
			
			var levelNumber:int = 0;
			for (var i:int = 0; i < 5; i++) 
			{
				for (var j:int = 0; j < 4; j++) 
				{
					levelNumber++;
					var levelButton:Button = new Button(Texture.fromColor(64,64,0xFF00FF),levelNumber.toString());
					levelButton.x = 100+(50*i);
					levelButton.y = 100+ (50*j);
					levelSelectionContainer.addChild(levelButton);
					levelButton.addEventListener(Event.TRIGGERED, onLevelSelected);
					levelButtonsVector.push(levelButton);
				}
			}
		}
		
		private function handleWorldSelection(event:Event):void
		{
			switch(event.currentTarget)
			{
				case world1Img:
					gotoLevelSelection(1);
					break;
				case world2Img:
					gotoLevelSelection(2);
					break;
				case world3Img:
					gotoLevelSelection(3);
					break;
				case world4Img:
					gotoLevelSelection(4);
					break;
				case world5Img:
					gotoLevelSelection(5);
					break;
			}
		}
		
		private function gotoLevelSelection(worldNumber:int):void
		{
			currentlySelectedWorld = worldNumber;
			removeChild(worldSelectionContainer);
			addChild(levelSelectionContainer);
		}
		
		private function onLevelSelected(event:Event):void
		{
			var selectedLevelNumber:int;
			for (var i:int = 0; i < levelButtonsVector.length; i++) 
			{
				if(event.currentTarget == levelButtonsVector[i])
				{
					selectedLevelNumber = i;
				}
			}
			var selectedLevel:String = "level"+currentlySelectedWorld+"_"+selectedLevelNumber;
			
			//load currently selected level atlas
			AssetsManager.getAtlas(selectedLevel);
			//init new level state
		}
	}
}

















