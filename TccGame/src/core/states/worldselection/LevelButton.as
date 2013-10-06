package core.states.worldselection
{
	import core.art.AssetsManager;
	import core.data.GameData;
	import core.utils.Debug;
	import core.utils.LevelInfo;
	
	import starling.display.Button;
	import starling.display.Image;
	import starling.textures.Texture;
	import starling.textures.TextureAtlas;
	
	public final class LevelButton extends Button
	{
		private var secretItem:Image;
		private var menuAtlas:TextureAtlas;
		private var isLocked:Boolean = true;
		private var levelNumber:int;
		public var hasSecretItem:Boolean = false;
		
		public function LevelButton(upState:Texture, text:String="", downState:Texture=null)
		{
			super(upState, text, downState);
			
			levelNumber = int(text);
			
			secretItem = new Image(AssetsManager.getInstance().getTextureAtlas("MenuAtlas").getTexture("secretItem"));
			secretItem.pivotX = secretItem.width>>1;
			secretItem.pivotY = secretItem.height>>1;
			secretItem.x = this.width;
			secretItem.y = this.height;
			secretItem.visible = false;
			
			this.addChild(secretItem);
		}
		
		/**
		 * Happens each time a new world is selected..update all button's info
		 */
		public function updateInfo(texture:Texture, worldNumber:int):void
		{
			//Texture update - locked/unlocked
			upState = texture;
			downState = texture;

			//Secret Item found or not
			var index:int = (((worldNumber -1) * GameData.getInstance().LevelsQuantityByWorld) + int(this.text))-1;
			if(LevelInfo(GameData.levelsInfo[index]).gotSecretItem)
				secretItem.visible = true;
			else
				secretItem.visible = false;
			Debug.log("[LevelButton] levelsInfo["+index+"]"," secretItem found:",LevelInfo(GameData.levelsInfo[index]).gotSecretItem);
		}
		
		public function getLocked(worldNumber:int):Boolean
		{
			var index:int = (((worldNumber -1) * GameData.getInstance().LevelsQuantityByWorld) + int(this.text))-1;
			Debug.log("[LevelButton] level index:",index," Locked:",LevelInfo(GameData.levelsInfo[index]).locked);
			if( !LevelInfo(GameData.levelsInfo[index]).locked)
			{
				isLocked = false;
			}
			return isLocked;
		}
	}
}