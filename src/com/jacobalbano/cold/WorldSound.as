package com.jacobalbano.cold 
{
	import com.jacobalbano.punkutils.XMLEntity;
	import com.thaumaturgistgames.flakit.Library;
	import net.flashpunk.Sfx;
	
	/**
	 * ...
	 * @author Jake Albano
	 */
	public class WorldSound extends XMLEntity 
	{
		public var source:String;
		public var typeName:String;
		private var sound:Sfx;
		
		public function WorldSound() 
		{
		}
		
		override public function added():void 
		{
			super.added();
			
			sound = new Sfx(Library.getSound("sounds." + source));
		}
		
		public function play():void
		{
			if (!sound.playing)
			{
				sound.play();
			}
		}
		
	}

}