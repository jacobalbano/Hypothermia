package com.jacobalbano.cold 
{
	import com.jacobalbano.punkutils.XMLEntity;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import net.flashpunk.FP;
	import net.flashpunk.utils.Input;
	import flash.ui.Mouse;
	import flash.ui.MouseCursor;
	
	/**
	 * @author Jake Albano
	 */
	public class Hotspot extends XMLEntity 
	{
		private var size:Point;
		private var contains:Boolean;
		public var onClick:String;
		public var onEnter:String;
		public var onExit:String;
		
		public function Hotspot() 
		{
		}
		
		override public function load(entity:XML):void 
		{
			super.load(entity);
			
			size = new Point(entity.@width, entity.@height);
		}
		
		override public function removed():void 
		{
			super.removed();
			Mouse.cursor = MouseCursor.ARROW;
		}
		
		override public function update():void 
		{
			super.update();
			
			
			var all:Array = [];
			var inventory:Inventory;
			
			world.getClass(Inventory, all);
			if (all.length > 0)
			{
				inventory = all[0];	
			}
			
			var lastContain:Boolean = contains;
			contains = collidePoint(x, y, world.mouseX, world.mouseY);
			
			if (contains)
			{
				if (inventory && inventory.isOpen)
				{
					return;
				}
				else
				{
					if (Input.mouseReleased)
					{
						callback(onClick);
					}
				}
				
				Mouse.cursor = MouseCursor.BUTTON;
			}
			
			if (lastContain != contains)
			{
				if (contains)
				{
					callback(onEnter);
				}
				else
				{
					Mouse.cursor = MouseCursor.ARROW;
					callback(onExit);
				}
			}
		}
		
		private function callback(script:String):void 
		{
			Game.instance.console.slang.doLine(script);
		}
		
	}

}