package com.jacobalbano.cold 
{
	import com.jacobalbano.punkutils.Image;
	import com.jacobalbano.punkutils.XMLEntity;
	import com.thaumaturgistgames.flakit.Library;
	import flash.display.Bitmap;
	import flash.utils.Dictionary;
	import net.flashpunk.Entity;
	import net.flashpunk.FP;
	import net.flashpunk.graphics.Graphiclist;
	import net.flashpunk.Mask;
	import net.flashpunk.masks.Pixelmask;
	import net.flashpunk.Tween;
	import net.flashpunk.tweens.misc.VarTween;
	import net.flashpunk.utils.Ease;
	import flash.ui.Mouse;
	import flash.ui.MouseCursor;
	import flash.geom.Rectangle;
	import net.flashpunk.utils.Input;
	
	/**
	 * ...
	 * @author Jake Albano
	 */
	public class Inventory extends XMLEntity 
	{
		private var _mouseItem:String;
		private var _itemCount:int;
		private var items:Dictionary;
		private var extended:Boolean;
		private var contains:Boolean;
		
		public function Inventory() 
		{
			items = new Dictionary;
			
			var image:Bitmap = Library.getImage("art.ui.inventory.png");
			graphic = new Image(image);
			
			mask = new Pixelmask(Library.getImage("art.ui.inventoryMask.png").bitmapData, 0, 0);
			
			y = -image.height;
			graphic.scrollX = 0;
			graphic.scrollY = 0;
		}
		
		override public function added():void 
		{
			super.added();
			
			for each (var item:InventoryItem in items) 
			{
				world.add(item);
			}
		}
		
		override public function update():void 
		{
			super.update();
			
			var lastContain:Boolean = contains;
			contains = collidePoint(x, y, Input.mouseX, Input.mouseY);
			
			var count:int = 0;
			for each (var item:InventoryItem in items) 
			{
				item.x = count++ * 100 + 20;
				item.y = y + 15;
			}
			
			if (lastContain != contains)
			{
				if (contains)
				{
					Mouse.cursor = MouseCursor.BUTTON;
				}
				else
				{
					Mouse.cursor = MouseCursor.ARROW;
				}
			}
			
			if (Input.mouseReleased && contains)
			{
				var tween:VarTween = new VarTween(null, Tween.ONESHOT);
				if (extended)
				{
					tween.tween(this, "y", y - 150, 0.7, Ease.bounceOut);
				}
				else
				{
					tween.tween(this, "y", 0, 0.8, Ease.bounceOut);
				}
				
				extended = !extended;
				addTween(tween, true);
			}
		}
		
		public function hasItem(name:String):Boolean
		{
			if (items[name])
			{
				return true;
			}
			
			return false;
		}
		
		public function addItem(name:String):void
		{
			if (items[name])
			{
				return;
			}
			
			var image:Image = new Image(Library.getImage("art.worlditems." + name + ".png"));
			var item:InventoryItem = new InventoryItem();
			item.graphic = image;
			item.onAdded(this);
			world.add(item);
			
			image.scrollX = 0;
			image.scrollY = 0;
			image.smooth = true;
			image.scale = 100 / Math.min(image.width, image.height);
			
			items[name] = item;
			
			if (++_itemCount == 1)
			{
				//	First item added to inventory, so show the button in a way that it'll be noticed.
				var tween:VarTween = new VarTween(null, Tween.ONESHOT);
				tween.tween(this, "y", y + 50, 0.9, Ease.bounceOut);
				addTween(tween, true);
			}
		}
		
		public function removeItem(name:String):void
		{
			if (!items[name])
			{
				return;
			}
			
			_itemCount--;
			world.remove(items[name]);
			delete items[name];
		}
		
		public function get itemCount():int 
		{
			return _itemCount;
		}
		
		public function get mouseItem():String 
		{
			return _mouseItem;
		}
		
	}

}