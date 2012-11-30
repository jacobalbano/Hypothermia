package com.jacobalbano.punkutils 
{
	import flash.media.Camera;
	import net.flashpunk.Entity;
	import net.flashpunk.tweens.misc.VarTween;
	import net.flashpunk.utils.Input;
	import net.flashpunk.FP;
	import com.jacobalbano.punkutils.XMLEntity;
	import com.jacobalbano.punkutils.OgmoWorld;
	
	/**
	 * @author Jacob Albano
	 */
	public class CameraPan extends XMLEntity 
	{
		public var wrapAround:Boolean;
		public var worldWidth:int;
		public var buffer:int;
		public var scrollSpeed:int;
		private var tween:VarTween;
		private var mouseInBuffer:Boolean;
		public var speed:Number;
		
		public function CameraPan() 
		{
			super();
			worldWidth = 0;	//	default
			tween = new VarTween;
			addTween(tween, true);
			speed = 0;
		}
		
		override public function added():void 
		{
			super.added();
			
			FP.camera.x = x;
			
			var oWorld:OgmoWorld = world as OgmoWorld;
			if (!oWorld)
			{
				return;
			}
			
			this.worldWidth = oWorld.size.x;
			oWorld.wraparound = this.wrapAround;
		}
		
		override public function update():void 
		{
			super.update();
			
			if (wrapAround || (FP.camera.x >= 0 && FP.camera.x + FP.width <= worldWidth))
			{
				if (Input.mouseX < buffer)
				{
					onEnterLeft();
				}
				else if (Input.mouseX > FP.width - buffer )
				{
					onEnterRight();
				}
				else
				{
					speed = 0;
					mouseInBuffer = false;
				}
			}
			
			
			FP.camera.x += speed;
			
			if (!wrapAround)
			{
				if (FP.width < worldWidth)
				{
					if (FP.camera.x < 0)
					{
						FP.camera.x = 0;
					}
					else if (FP.camera.x + FP.width >= worldWidth)
					{
						FP.camera.x = worldWidth - FP.width;
					}
				}
			}
		}
		
		private function onEnterRight():void 
		{
			
			if (!mouseInBuffer)
			{
				mouseInBuffer = true;
				speed = 0;
				tween.tween(this, "speed", scrollSpeed, 0.25);
			}
		}
		
		private function onEnterLeft():void 
		{
			if (!mouseInBuffer)
			{
				mouseInBuffer = true;
				speed = 0;
				tween.tween(this, "speed", -scrollSpeed, 0.25);
			}
		}
	}

}