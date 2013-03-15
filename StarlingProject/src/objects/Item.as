package objects
{
	import starling.display.Image;
	import starling.display.Sprite;
	
	public class Item extends Sprite
	{
		
		private var _foodItemType:int;
		private var itemImage:Image;
		
		
		public function Item(_foodItemType:int)
		{
			super();
			this.foodItemType = _foodItemType;
		}

		public function get foodItemType():int
		{
			return _foodItemType;
		}

		public function set foodItemType(value:int):void
		{
			_foodItemType = value;
			
			itemImage = new Image(Assets.getAtlas().getTexture("item"+_foodItemType));
			itemImage.x = -itemImage.texture.width*.5;
			itemImage.y = -itemImage.texture.height*.5;
			addChild(itemImage);
		}

	}
}