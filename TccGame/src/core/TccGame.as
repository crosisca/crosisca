package core
{
	import flash.display.Bitmap;
	import flash.display.Sprite;
	import flash.display.StageOrientation;
	import flash.display.StageQuality;
	import flash.display3D.Context3DProfile;
	import flash.system.ApplicationDomain;
	import flash.system.Capabilities;
	import flash.system.System;
	
	import citrus.core.starling.StarlingCitrusEngine;
	import citrus.utils.LevelManager;
	
	import core.art.AssetsManager;
	import core.data.GameData;
	import core.levels.AbstractLevel;
	import core.states.StartState;
	
	import starling.core.Starling;
	
	[SWF(width="2048",height="1536",frameRate="30")]
	public class TccGame extends StarlingCitrusEngine
	{
		/**
		 * Used to display the minimap of a level, for debug purposes.*/
		public var debugSpriteRectangle:Sprite = new Sprite();

		[Embed(source="../Default-LandscapeRight@2x.png")]
		private var LoadImageClass:Class;
		public static var loadImage:Bitmap;
		private var assets:AssetsManager;
		
		public function TccGame()
		{
			//Set stage properties
			stage.setOrientation(StageOrientation.ROTATED_RIGHT);
			stage.quality = StageQuality.LOW;
			stage.showDefaultContextMenu = true;
			
			//Minimap
			addChild(debugSpriteRectangle);
			
			//Setup Starling
			Starling.multitouchEnabled = true;
			Starling.handleLostContext = false;//only on iOS
			setUpStarling(true,1,null,Context3DProfile.BASELINE_EXTENDED);
			
			//Add LoadImage
			var backgroundArtBitmap:Bitmap = new LoadImageClass();
			loadImage = backgroundArtBitmap;
			loadImage.name = "loadImage";
			Starling.current.nativeOverlay.addChild(loadImage);
			
			//Prepare assets manager
			assets = AssetsManager.getInstance();
			assets.verbose = Capabilities.isDebugger;
			//var appDir:File = File.applicationDirectory;
			//assets.enqueue(appDir.resolvePath("../../assets/images/menu"));
			
			//state = new StartState();
			
			levelManager = new LevelManager(AbstractLevel);
			levelManager.applicationDomain = ApplicationDomain.currentDomain;
			levelManager.onLevelChanged.add(_onLevelChanged);
			levelManager.levels = GameData.getInstance().allLevels;
						
			state = new StartState();
			
			//Testar o garbage collector aki
			System.pauseForGCIfCollectionImminent(0);
			System.gc();
		}
		
		private function _onLevelChanged(lvl:AbstractLevel):void {
			
			state = lvl;
			
			//lvl.lvlEnded.add(_nextLevel);
			//lvl.restartLevel.add(_restartLevel);
		}
		
		private function _nextLevel():void {
			
			//levelManager.nextLevel();
		}
		
		private function _restartLevel():void {
			
			//state = levelManager.currentLevel as IState;
		}
	}
}