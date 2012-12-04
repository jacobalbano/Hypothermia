package com.jacobalbano.cold 
{
	import com.jacobalbano.punkutils.XMLEntity;
	import net.flashpunk.utils.Input;
	
	/**
	 * @author Jake Albano
	 */
	public class WorldReaction extends XMLEntity 
	{
		public var onMatch:String;
		public var match:String;
		
		public function WorldReaction() 
		{
		}
		
		override public function update():void 
		{
			super.update();
			if (collidePoint(x, y, world.mouseX, world.mouseY))
			{
				var all:Array = [];
				var inventory:Inventory;
				world.getClass(Inventory, all);
				
				if (all.length > 0)
				{
					inventory = all[0];
				}
				else
				{
					return;
				}
				
				if (inventory.mouseItem == match)
				{
					if (Input.mouseReleased)
					{
						Game.instance.console.slang.doLine(onMatch);
					}
				}
			}
		}
		
	}

}