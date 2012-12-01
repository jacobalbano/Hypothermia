package com.jacobalbano.cold 
{
	import com.jacobalbano.punkutils.XMLEntity;
	import com.thaumaturgistgames.flakit.Library;
	import net.flashpunk.Sfx;
	import net.flashpunk.Tween;
	import net.flashpunk.tweens.sound.SfxFader;
	
	/**
	 * ...
	 * @author Jake Albano
	 */
	public class Ambiance extends XMLEntity 
	{
		
		public var loop:Boolean;
		public var source:String;
		public var tween:Number;
		public var volume:Number;
		private var sound:Sfx;
		private var fader:SfxFader;
		
		public function Ambiance() 
		{
		}
		
		override public function added():void 
		{
			super.added();
			
			sound = new Sfx(Library.getSound("sounds." + source), repeat);
			
			repeat();
		}
		
		private function repeat():void 
		{
			sound.play(0);
			fader = new SfxFader(sound, null, Tween.ONESHOT);
			fader.fadeTo(volume, tween);
			addTween(fader, true);
		}
		
		override public function removed():void 
		{
			super.removed();
			
			fader = new SfxFader(sound, sound.stop, Tween.ONESHOT);
			fader.fadeTo(0, tween);
			
			world.addTween(fader, true);
		}
		
	}

}