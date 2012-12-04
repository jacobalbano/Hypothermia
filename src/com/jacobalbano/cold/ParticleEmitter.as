package com.jacobalbano.cold 
{
	import com.jacobalbano.punkutils.Image;
	import com.jacobalbano.punkutils.XMLEntity;
	import com.thaumaturgistgames.flakit.Library;
	import flash.display.Bitmap;
	import net.flashpunk.graphics.Emitter;
	
	/**
	 * @author Jake Albano
	 */
	public class ParticleEmitter extends XMLEntity 
	{
		public var particleType:String;
		public var vary:Number;
		public var max:int;
		public var emitter:Emitter;
		public var angle:int;
		public var distance:Number;
		public var duration:Number;
		public var angleRange:Number;
		public var distanceRange:Number;
		public var durationRange:Number;
		public var fadeOut:Boolean;
		
		public function ParticleEmitter() 
		{
		}
		
		override public function load(entity:XML):void 
		{
			super.load(entity);
			var bmp:Bitmap = Library.getImage("art.particles." + particleType + ".png");
			
			emitter = new Emitter(bmp.bitmapData, bmp.width, bmp.height);
			graphic = emitter;
			
			emitter.relative = false;
			emitter.newType(particleType);
			emitter.setMotion(particleType, -angle, distance, duration, angleRange, distanceRange, durationRange);
			emitter.setAlpha(particleType, 1, fadeOut ? 0 : 1);
			
		}
		
		override public function update():void 
		{
			super.update();
			
			if (emitter.particleCount < max)
			{
				emitter.emit(particleType, x, y);
			}
		}
		
	}

}