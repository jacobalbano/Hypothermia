package com.jacobalbano.cold 
{
	import com.jacobalbano.punkutils.Image;
	import com.jacobalbano.punkutils.OgmoWorld;
	import com.jacobalbano.punkutils.XMLEntity;
	import com.thaumaturgistgames.flakit.Library;
	/**
	 * ...
	 * @author Jake Albano
	 */
	public class Background extends XMLEntity
	{
		public var source:String;
		
		public function Background() 
		{
		}
		
		override public function added():void 
		{
			super.added();
			graphic = new Image(Library.getImage("art.backgrounds." + source + ".png"));
		}
		
	}

}