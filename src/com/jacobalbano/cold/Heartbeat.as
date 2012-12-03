package com.jacobalbano.cold 
{
	import com.jacobalbano.punkutils.XMLEntity;
	import net.flashpunk.FP;
	import net.flashpunk.Sfx;
	import net.flashpunk.Tween;
	import net.flashpunk.tweens.misc.VarTween;
	import net.flashpunk.utils.Ease;
	import com.thaumaturgistgames.flakit.Library;
	
	/**
	 * ...
	 * @author Jake Albano
	 */
	public class Heartbeat extends XMLEntity 
	{
		private var heartbeat:Sfx;
		
		private static const STOPPED:int = 0;
		private static const SLOW:int = 1;
		private static const FAST:int = 2;
		private var state:int;
		private var toState:int;
		
		public function Heartbeat() 
		{
			heartbeat = new Sfx(Library.getSound("sounds.singleBeatSlow.mp3"), beatHeart);
			state = STOPPED;
		}
		
		override public function added():void 
		{
			super.added();
		}
		
		public function stop():void
		{
			if (state == STOPPED)
			{
				return;
			}
			
			toState = STOPPED;
		}
		
		public function slow():void
		{
			if (state == SLOW)
			{
				return;
			}
			
			toState = SLOW;
			
			if (heartbeat && !heartbeat.playing)
			{
				beatHeart();
			}
			
		}
		
		public function fast():void
		{
			if (state == FAST)
			{
				return;
			}
			
			toState = FAST;
			
			if (heartbeat && !heartbeat.playing)
			{
				beatHeart();
			}
		}
		
		private function pulseIn():void
		{
			var tween:VarTween = new VarTween(pulseOut, Tween.ONESHOT);
			tween.tween(FP.screen, "scale", 1, heartbeat.length / 2, Ease.sineOut);
			world.addTween(tween);
		}
		
		private function pulseOut():void 
		{
			FP.screen.scale = 1.005;
		}
		
		private function beatHeart():void 
		{
			switch (toState)
			{
				case STOPPED:
					heartbeat.stop();
					return;
				case SLOW:
					heartbeat = new Sfx(Library.getSound("sounds.singleBeatSlow.mp3"), beatHeart);
					break;
				case FAST:
					heartbeat = new Sfx(Library.getSound("sounds.singleBeatFast.mp3"), beatHeart);
					break;
				default:
					throw new Error("WHAT'S GOING ON");
					break;
			}
			
			state = toState;
			trace("changed state to ", ["stopped", "slow", "fast"][state]);
			
			pulseIn();
			heartbeat.play(1.3);
		}
		
	}

}