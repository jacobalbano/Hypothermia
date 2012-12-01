package com.jacobalbano.cold 
{
	import com.jacobalbano.punkutils.Image;
	import com.jacobalbano.punkutils.XMLEntity;
	import com.thaumaturgistgames.flakit.Library;
	
	/**
	 * ...
	 * @author Jake Albano
	 */
	public class Decal extends XMLEntity 
	{
		public var source:String;
		
		public function Decal() 
		{
		}
		
		override public function load(entity:XML):void 
		{
			super.load(entity);
			graphic = new Image(Library.getImage("art.decals." + source + ".png"));
			
			graphic.scrollX = entity.@scrollX;
			graphic.scrollY = entity.@scrollY;
		}
		
	}

}