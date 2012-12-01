package com.jacobalbano.cold 
{
	import com.jacobalbano.punkutils.XMLEntity;
	
	/**
	 * @author Jake Albano
	 */
	public class InventoryItem extends XMLEntity 
	{
		private var parent:Inventory;
		public var typeName:String;
		
		public function InventoryItem() 
		{
		}
		
		public function onAdded(parent:Inventory):void
		{
			this.parent = parent;
		}
	}

}