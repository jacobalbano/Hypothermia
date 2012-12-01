package com.jacobalbano.cold 
{
	import com.jacobalbano.punkutils.Image;
	import com.jacobalbano.punkutils.XMLEntity;
	import flash.geom.Rectangle;
	import net.flashpunk.utils.Input;
	
	/**
	 * @author Jake Albano
	 */
	public class InventoryItem extends XMLEntity 
	{
		private var parent:Inventory;
		public var typeName:String;
		
		public function InventoryItem() 
		{
		}
		
		public function onAdded(parent:Inventory):void
		{
			this.parent = parent;
		}
		
		override public function added():void 
		{
			super.added();
			(graphic as Image).centerOrigin();
		}
		
		override public function update():void 
		{
			super.update();
			
			var image:Image = graphic as Image;
			var rect:Rectangle = new Rectangle(x - image.originX, y - image.originY, image.width, image.height);
			
			if (rect.contains(Input.mouseX, Input.mouseY))
			{
				if (Input.mouseReleased)
				{
					//	Set this as the type at the mouse
					parent.mouseItem = typeName;
				}
			}
		}
	}

}