package com.jacobalbano.cold 
{
	import com.jacobalbano.punkutils.Image;
	import com.jacobalbano.punkutils.XMLEntity;
	import com.thaumaturgistgames.flakit.Library;
	import net.flashpunk.FP;
	import net.flashpunk.graphics.Graphiclist;
	import net.flashpunk.Tween;
	import net.flashpunk.tweens.misc.VarTween;
	import net.flashpunk.utils.Ease;
	
	/**
	 * ...
	 * @author Jake Albano
	 */
	public class Sleep extends XMLEntity 
	{
		private var topLid:Image;
		private var bottomLid:Image;
		static private const DURATION:Number = 10;
		private var running:Boolean;
		private var count:int;
		
		public var onComplete:Function;
		
		public function Sleep() 
		{
			count = 0;
			
			topLid = new Image(Library.getImage("art.ui.drowsy.png"));
			bottomLid = new Image(Library.getImage("art.ui.drowsy.png"));
			
			//	Flip the bottom image around
			bottomLid.angle = 180;
			bottomLid.originX = bottomLid.width;
			bottomLid.originY = bottomLid.height;
			
			topLid.x = 0;
			bottomLid.x = 0;
			
			topLid.scrollX = 0;
			bottomLid.scrollX = 0;
			
			topLid.scrollY = 0;
			bottomLid.scrollY = 0;
			
			topLid.y = -topLid.height;
			bottomLid.y = FP.height;
			
			graphic = new Graphiclist(topLid, bottomLid);
		}
		
		public function start():void
		{
			if (!running)
			{
				var topTween:VarTween = new VarTween(onFinished, Tween.ONESHOT);
				var bottomTween:VarTween = new VarTween(onFinished, Tween.ONESHOT);
				
				topTween.tween(topLid, "y", 0, DURATION, Ease.bounceInOut);
				bottomTween.tween(bottomLid, "y", FP.height - bottomLid.height, DURATION, Ease.bounceInOut);
				
				addTween(topTween, true);
				addTween(bottomTween, true);
				
				running = true;
			}
		}
		
		private function onFinished():void 
		{
			if (++count == 2)
			{
				if (onComplete != null)
				{
					onComplete();
				}
				
				count = 0;
				running = false;
			}
		}
		
	}

}