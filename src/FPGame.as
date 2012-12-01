package  
{
	import com.jacobalbano.cold.Ambiance;
	import com.jacobalbano.cold.Background;
	import com.jacobalbano.cold.Decal;
	import com.jacobalbano.cold.Hotspot;
	import com.jacobalbano.cold.Inventory;
	import com.jacobalbano.cold.InventoryItem;
	import com.jacobalbano.cold.ParticleEmitter;
	import com.jacobalbano.cold.WorldItem;
	import com.jacobalbano.punkutils.Image;
	import com.jacobalbano.punkutils.OgmoWorld;
	import com.jacobalbano.punkutils.ScriptTick;
	import com.thaumaturgistgames.slang.Memory;
	import com.thaumaturgistgames.slang.Stdlib;
	import net.flashpunk.Engine;
	import net.flashpunk.FP;
	import net.flashpunk.Tween;
	import net.flashpunk.tweens.misc.VarTween;
	import net.flashpunk.utils.Ease;
	import net.flashpunk.utils.Input;
	import flash.ui.Keyboard;
	import com.thaumaturgistgames.flakit.Library;
	import com.jacobalbano.punkutils.Transition;
	import com.jacobalbano.punkutils.CameraPan;
	import com.jacobalbano.punkutils.ScriptTick;
	
	/**
	 * @author Jacob Albano
	 */
	public class FPGame extends Engine 
	{
		private var currentWorld:String;
		private var world:OgmoWorld;
		private var inventory:Inventory;
		
		public function FPGame(width:uint, height:uint) 
		{
			super(width, height);
			currentWorld = "";
			inventory = new Inventory();
		}
		
		override public function init():void 
		{
			super.init();
			
			world = new OgmoWorld();
			FP.world = world;
			
			world.addClass("CameraPan", CameraPan);
			world.addClass("Background", Background);
			world.addClass("Hotspot", Hotspot);
			world.addClass("ParticleEmitter", ParticleEmitter);
			world.addClass("Ambiance", Ambiance);
			world.addClass("WorldItem", WorldItem);
			world.addClass("InventoryItem", InventoryItem);
			world.addClass("Decal", Decal);
			
			Game.instance.console.slang.addFunction("world", loadWorld, [String], this, "Load a world from an Ogmo level");
			Game.instance.console.slang.addFunction("worlds", listWorlds, [], this, "Load a world from an Ogmo level");
			
			Game.instance.console.slang.addFunction("message", message, [String], this, "Sends a message to all scripted entities");
			
			Game.instance.console.slang.addFunction("hasInvItem", inventory.hasItem, [String], inventory, "Check if an item exists in the inventory");
			Game.instance.console.slang.addFunction("addInvItem", inventory.addItem, [String], inventory, "Add an item to the inventory");
			Game.instance.console.slang.addFunction("remInvItem", inventory.removeItem, [String], inventory, "Remove an item from the inventory");
			
			Game.instance.console.slang.addFunction("remWorldItem", remWorldItem, [String], this, "Remove an item from the world");
			
			Game.instance.console.slang.importModule(new Stdlib);
			Game.instance.console.slang.importModule(new Memory);
			
			Game.instance.onReload = function():void { loadWorld(currentWorld); };
			
			loadWorld("start");
		}
		
		private function listWorlds():void 
		{
			var lib:XML = Library.getXML("Library.xml");
			
			for each (var item:String in lib.xmls.children()) 
			{
				if (item.indexOf("map.oel") >= 0)
				{
					Game.instance.console.print(item.substring(0, item.lastIndexOf("/")));
				}
			}
		}
		
		private function remWorldItem(worldItem:String):void
		{
			var list:Array = [];
			FP.world.getClass(WorldItem, list);
			
			for each (var item:WorldItem in list) 
			{
				if (item.typeName == worldItem)
				{
					function realRemoveWorldItem():void 
					{
						world.remove(item);
					}
					
					var tween:VarTween = new VarTween(realRemoveWorldItem, Tween.ONESHOT);
					tween.tween(item.graphic, "alpha", 0, 1, Ease.backOut);
					world.addTween(tween, true);
					return;
				}
			}
		}
		
		private function message(message:String):void 
		{
			var list:Array = [];
			FP.world.getClass(ScriptTick, list);
			
			for each (var item:ScriptTick in list) 
			{
				item.onMessage(message);
			}
		}
		
		private function loadWorld(name:String):void 
		{
			currentWorld = name;
			world.levelName = name;
			
			if (currentWorld == "")
			{
				return;
			}
			
			world.buildWorld("worlds." + name + ".map.oel");
			world.add(new ScriptTick(Game.instance.console.slang, "worlds." + name + ".script.xml"));
			world.add(new Transition);
			world.add(inventory);
		}
		
	}

}