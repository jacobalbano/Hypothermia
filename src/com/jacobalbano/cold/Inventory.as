package com.jacobalbano.cold 
{
	import com.jacobalbano.punkutils.XMLEntity;
	import flash.utils.Dictionary;
	
	/**
	 * ...
	 * @author Jake Albano
	 */
	public class Inventory extends XMLEntity 
	{
		private var _itemCount:int;
		private var items:Dictionary;
		
		public function Inventory() 
		{
			items = new Dictionary;
		}
		
		public function hasItem(name:String):Boolean
		{
			if (items[name])
			{
				return true;
			}
			
			return false;
		}
		
		public function addItem(name:String):void
		{
			_itemCount++;
			items[name] = true;
			//	TODO: Actually store the items
		}
		
		public function removeItem(name:String):void
		{
			itemCount--;
			delete items[name];
			//	TODO: Remove item entities from world
		}
		
		public function get itemCount():int 
		{
			return _itemCount;
		}
		
	}

}