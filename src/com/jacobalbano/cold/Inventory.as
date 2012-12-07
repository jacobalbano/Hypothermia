package com.jacobalbano.cold 
{
	import com.jacobalbano.punkutils.Image;
	import com.jacobalbano.punkutils.XMLEntity;
	import com.thaumaturgistgames.flakit.Library;
	import flash.display.Bitmap;
	import flash.ui.Mouse;
	import flash.ui.MouseCursor;
	import flash.utils.Dictionary;
	import net.flashpunk.Entity;
	import net.flashpunk.masks.Pixelmask;
	import net.flashpunk.Tween;
	import net.flashpunk.tweens.misc.VarTween;
	import net.flashpunk.utils.Ease;
	import net.flashpunk.utils.Input;
	
	/**
	 * @author Jake Albano
	 */
	public class Inventory extends XMLEntity 
	{
		private var _mouseItem:String;
		private var _itemCount:int;
		private var items:Dictionary;
		private var extended:Boolean;
		private var everUsed:Boolean;
		private var mouseEntity:Entity;
		private var contains:Boolean;
		static private const ITEM_PADDING:Number = 20;
		static private const ITEM_SIZE:Number = 100;
		private var nextExtendState:Boolean;
		
		public function Inventory() 
		{
			var image:Bitmap = Library.getImage("art.ui.inventory.png");
			graphic = new Image(image);
			
			mask = new Pixelmask(Library.getImage("art.ui.inventoryMask.png").bitmapData, 0, 0);
			graphic.scrollX = 0;
			graphic.scrollY = 0;
			
			reset();
		}
		
		public function reset():void 
		{
			items = new Dictionary;
			mouseItem = "";
			y = -(graphic as Image).height;
			everUsed = false;
			_itemCount = 0;
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
			
			extended = nextExtendState = nextExtendState;
			
			var lastContain:Boolean = contains;
			contains = collidePoint(x, y, Input.mouseX, Input.mouseY);
			
			var count:int = 0;
			for each (var item:InventoryItem in items) 
			{
				if (item.typeName == mouseItem)
				{
					item.x = Input.mouseX;
					item.y = Input.mouseY;
				}
				else
				{
					item.x = count++ * ITEM_SIZE + ITEM_PADDING + (ITEM_SIZE / 2);
					item.y = y + (ITEM_SIZE / 2) + 15;
				}
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
				if (mouseItem != "")
				{
					_mouseItem = "";
					extended = true;
					return;
				}
				
				if (extended)
				{
					close();
				}
				else
				{
					open();
					extended = true;
				}
			}
		}
		
		private function open():void 
		{
			if (isOpen)
			{
				return;
			}
			
			var tween:VarTween = new VarTween(null, Tween.ONESHOT);
			tween.tween(this, "y", 0, 0.8, Ease.bounceOut);			
			addTween(tween, true);
			nextExtendState = true;
		}
		
		private function close():void 
		{
			if (!isOpen)
			{
				return;
			}
			
			var tween:VarTween = new VarTween(null, Tween.ONESHOT);
			tween.tween(this, "y", y - 150, 0.7, Ease.bounceOut);
			addTween(tween, true);
			nextExtendState = false;
		}
		
		public function hasItem(name:String):Boolean
		{
			return items[name] != null;
		}
		
		public function addItem(name:String):void
		{
			if (hasItem(name))
			{
				return;
			}
			
			var image:Image;
			
			try
			{
				image = new Image(Library.getImage("art.invitems." + name + ".png"));
			}
			catch (e:Error)
			{
				//	Alternate image doesn't exist; don't worry about it
				image = new Image(Library.getImage("art.worlditems." + name + ".png"));
			}
			
			var item:InventoryItem = new InventoryItem();
			item.typeName = name;
			item.graphic = image;
			item.onAdded(this);
			world.add(item);
			
			image.scrollX = 0;
			image.scrollY = 0;
			image.smooth = true;
			image.scale = ITEM_SIZE / Math.max(image.width, image.height);
			
			items[name] = item;
			
			if (!everUsed && ++_itemCount == 1)
			{
				//	First item added to inventory, so show the button in a way that it'll be noticed.
				var tween:VarTween = new VarTween(null, Tween.ONESHOT);
				tween.tween(this, "y", y + 50, 0.9, Ease.bounceOut);
				addTween(tween, true);
			}
			
			everUsed = true;
		}
		
		public function removeItem(name:String):void
		{
			if (!items[name])
			{
				return;
			}
			
			if (name == mouseItem)
			{
				_mouseItem = "";
			}
			
			_itemCount--;
			world.remove(items[name]);
			delete items[name];
		}
		
		public function get itemCount():int 
		{
			return _itemCount;
		}
		
		public function get isOpen():Boolean
		{
			return extended;
		}
		
		public function get mouseItem():String 
		{
			return _mouseItem;
		}
		
		public function set mouseItem(typeName:String):void
		{
			if (typeName == mouseItem)
			{
				return;
			}
			
			if (typeName == "")
			{
				_mouseItem = "";
				return;
			}
			
			if (items[typeName])
			{
				_mouseItem = typeName;
				close();
			}
		}
		
	}

}