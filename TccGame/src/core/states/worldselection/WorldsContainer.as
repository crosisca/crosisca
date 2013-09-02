package core.states.worldselection
{
	import away3d.core.math.MathConsts;
	
	import remake.AssetsManagerLixo;
	
	import starling.display.Image;
	import starling.display.Sprite;
	
	public final class WorldsContainer extends Sprite
	{
		public var world1:Image;
		public var world2:Image;
		public var world3:Image;
		public var world4:Image;
		
		public function WorldsContainer()
		{
			super();
			
			//world1 = new Image(Texture.fromColor(500,1000,0x7FFF0000));
			world1 = new Image(AssetsManagerLixo.World1Texture());
			world1.pivotX = world1.width * .5;
			world1.pivotY = world1.height;
			this.addChild(world1);
			
			//world2 = new Image(Texture.fromColor(500,1000,0x7F00FF00));
			world2 = new Image(AssetsManagerLixo.World2Texture());
			world2.pivotX = world2.width * .5;
			world2.pivotY = world2.height;
			world2.rotation = 90 * MathConsts.DEGREES_TO_RADIANS;
			this.addChild(world2);
			
			//world3 = new Image(Texture.fromColor(500,1000,0x7FFF00FF));
			world3 = new Image(AssetsManagerLixo.World3Texture());
			world3.pivotX = world3.width * .5;
			world3.pivotY = world3.height;
			world3.rotation = 180 * MathConsts.DEGREES_TO_RADIANS;
			this.addChild(world3);
			
			//world4 = new Image(Texture.fromColor(500,1000,0x7F7F007F));
			world4 = new Image(AssetsManagerLixo.World4Texture());
			world4.pivotX = world4.width * .5;
			world4.pivotY = world4.height;
			world4.rotation = 270 * MathConsts.DEGREES_TO_RADIANS;
			this.addChild(world4);
		}
	}
}
