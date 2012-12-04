package com.jacobalbano.punkutils 
{
	import flash.geom.Rectangle;
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
		public var worldHeight:int;
		public var buffer:int;
		public var scrollSpeed:int;
		
		private var leftBuffer:Rectangle;
		private var rightBuffer:Rectangle;
		private var topBuffer:Rectangle;
		private var bottomBuffer:Rectangle;
		
		private var tween:VarTween;
		public var speedX:Number;
		public var speedY:Number;
		private var mouseInXBuffer:Boolean;
		private var mouseInYBuffer:Boolean;
		
		public function CameraPan() 
		{
			super();
			worldWidth = 0;		//	default
			worldHeight = 0;	//	default
			tween = new VarTween;
			addTween(tween, true);
			speedX = 0;
			speedY = 0;
		}
		
		override public function added():void 
		{
			super.added();
			
			FP.camera.x = x;
			FP.camera.y = y;
			
			var oWorld:OgmoWorld = world as OgmoWorld;
			if (!oWorld)
			{
				return;
			}
			
			this.worldWidth = oWorld.size.x;
			this.worldHeight = oWorld.size.y;
			oWorld.wraparound = this.wrapAround;
			
			leftBuffer = new Rectangle(0, 0, buffer, FP.height);
			rightBuffer = new Rectangle(FP.width - buffer, 0, buffer, FP.height);
			topBuffer = new Rectangle(0, 0, FP.width, buffer);
			bottomBuffer = new Rectangle(0, FP.height - buffer, FP.width, buffer);
		}
		
		override public function update():void 
		{
			super.update();
			
			if (wrapAround || (FP.camera.x >= 0 && FP.camera.x + FP.width <= worldWidth))
			{
				if (leftBuffer.contains(Input.mouseX, Input.mouseY))
				{
					onEnterLeft();
				}
				else if (rightBuffer.contains(Input.mouseX, Input.mouseY))
				{
					onEnterRight();
				}
				else
				{
					speedX = 0;
					mouseInXBuffer = false;
				}
			}
			
			if (!wrapAround && FP.camera.y >= 0 && FP.camera.y + FP.height <= worldHeight)
			{
				if (topBuffer.contains(Input.mouseX, Input.mouseY))
				{
					onEnterTop();
				}
				else if (bottomBuffer.contains(Input.mouseX, Input.mouseY))
				{
					onEnterBottom();
				}
				else
				{
					speedY = 0;
					mouseInYBuffer = false;
				}
			}
			
			FP.camera.x += speedX;
			FP.camera.y += speedY;
			
			if (!wrapAround)
			{
				if (FP.width <= worldWidth)
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
				
				if (FP.height <= worldHeight)
				{
					if (FP.camera.y < 0)
					{
						FP.camera.y = 0;
					}
					else if (FP.camera.y + FP.height >= worldHeight)
					{
						FP.camera.y = worldHeight - FP.height;
					}
				}
			}
			else
			{
				FP.camera.x = FP.camera.x % worldWidth;
				FP.camera.y = FP.camera.y % worldHeight;
			}
		}
		
		private function onEnterRight():void 
		{
			if (!mouseInXBuffer)
			{
				mouseInXBuffer = true;
				speedX = 0;
				tween.tween(this, "speedX", scrollSpeed, 0.25);
			}
		}
		
		private function onEnterLeft():void 
		{
			if (!mouseInXBuffer)
			{
				mouseInXBuffer = true;
				speedX = 0;
				tween.tween(this, "speedX", -scrollSpeed, 0.25);
			}
		}
		
		private function onEnterBottom():void 
		{
			if (!mouseInYBuffer)
			{
				mouseInYBuffer = true;
				speedY = 0;
				tween.tween(this, "speedY", scrollSpeed, 0.25);
			}
		}
		
		private function onEnterTop():void 
		{
			if (!mouseInYBuffer)
			{
				mouseInYBuffer = true;
				speedY = 0;
				tween.tween(this, "speedY", -scrollSpeed, 0.25);
			}
		}
	}

}