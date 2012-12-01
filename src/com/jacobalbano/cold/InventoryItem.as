package com.jacobalbano.cold 
{
	import com.jacobalbano.punkutils.XMLEntity;
	
	/**
	 * @author Jake Albano
	 */
	public class InventoryItem extends XMLEntity 
	{
		private var xml:XML;
		private var parent:Inventory;
		public var typeName:String;
		
		public function InventoryItem() 
		{
		}
		
		public function onAdded(parent:Inventory):void
		{
			this.parent = parent;
		}
		
		override public function load(entity:XML):void 
		{
			super.load(entity);
			xml = entity;
		}
		
		override public function update():void 
		{
			super.update();
			
			if (!parent)
			{
				var all:Array = [];
				var inventory:Inventory;
				world.getClass(Inventory, all);
				
				if (all.length > 0)
				{
					inventory = all[0];
					world.remove(this);
				}
				else
				{
					return;
				}
				
				inventory.addType(typeName, xml);
			}
		}
	}

}