package com.caiorosisca {
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.geom.Rectangle;
	public class square_mc extends Sprite {
		private var new_reg_x,new_reg_y:int;
		private var pin:Sprite=new Sprite();
		public function square_mc(reg_x,reg_y) {
			new_reg_x=reg_x;
			new_reg_y=reg_y;
			addEventListener(Event.ENTER_FRAME,on_enter_frame);
			addEventListener(Event.ADDED_TO_STAGE,on_added);
		}
		public function on_added(e:Event) {
			var rect:Rectangle=getBounds(this);
			var x_offset=new_reg_x+rect.x;
			var y_offset=new_reg_y+rect.y
			// updating container position
			x+=x_offset;
			y+=y_offset;
			// just adding a pin to highlight registration point
			var par:Sprite=this.parent as Sprite
			par.addChild(pin);
			pin.x=x;
			pin.y=y
			for (var i:uint=0; i<numChildren; i++) {
				// updating children position
				getChildAt(i).x-=x_offset;
				getChildAt(i).y-=y_offset;
			}
		}
		public function on_enter_frame(e:Event) {
			rotation+=2;
		}
	}
}