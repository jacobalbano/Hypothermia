package com.jacobalbano.cold 
{
	import com.jacobalbano.punkutils.Image;
	import com.jacobalbano.punkutils.XMLEntity;
	import com.thaumaturgistgames.flakit.Library;
	import flash.geom.Rectangle;
	
	/**
	 * ...
	 * @author Jake Albano
	 */
	public class WorldItem extends XMLEntity 
	{
		public var typeName:String;
		
		private var hotSpot:Hotspot;
		
		public function WorldItem() 
		{
			hotSpot = new Hotspot();
		}
		
		override public function load(entity:XML):void 
		{
			super.load(entity);
			hotSpot.load(entity);
			
			trace(typeName);
			
			var image:Image = new Image(Library.getImage("art.worlditems." + typeName + ".png"));
			graphic = image;
			image.smooth = true;
		}
		
		override public function added():void 
		{
			super.added();
			world.add(hotSpot);
		}
		
		override public function removed():void 
		{
			super.removed();
			world.remove(hotSpot);
		}
	}

}