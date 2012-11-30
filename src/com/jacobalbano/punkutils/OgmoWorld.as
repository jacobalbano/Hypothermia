package com.jacobalbano.punkutils 
{
	import com.jacobalbano.punkutils.Image;
	import com.thaumaturgistgames.flakit.Library;
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import flash.utils.Dictionary;
	import net.flashpunk.Entity;
	import net.flashpunk.Graphic;
	import net.flashpunk.World;
	import net.flashpunk.FP;
	
	/**
	 * @author Jacob Albano
	 */
	public class OgmoWorld extends World
	{
		private var types:Dictionary;
		private var layerIndices:Dictionary;
		private var numLayers:int;
		private var defaultImage:Bitmap;
		
		public var levelName:String;
		public var wraparound:Boolean;
		public var size:Point;
		
		public function OgmoWorld() 
		{
			super();
			types = new Dictionary;
			layerIndices = new Dictionary;
			numLayers = 0;
			size = new Point;
			
			defaultImage = new Bitmap(new BitmapData(100, 100, false, 0xFF0080));
			var flip:Boolean = false;
			
			for (var j:int = 0; j < 10; ++j)
			{
				for (var k:int = -1; k < 10; ++k)
				{
					if (flip = !flip)
					{
						defaultImage.bitmapData.fillRect(new Rectangle(j * 10, k * 10, 10, 10), 0x00000000);
					}
				}
			}
		}
		
		/**
		 * Register a class with the scene builder
		 * @param	name	The name to associate with the class
		 * @param	type	The entity class that will be added to the world when the name is found in the level file. It must have a constructor that takes an XML parameter
		 */
		public function addClass(name:String, type:Class):void
		{
			types[name] = type;
		}
		
		/**
		 * Unregister a class from the scene builder
		 * @param	name	The name the class was added with
		 */
		public function removeClass(name:String):void
		{
			delete types[name];
		}
		
		/**
		 * Load a world from an Ogmo level in the library
		 * @param	source	The level filename
		 */
		public function buildWorld(source:String):void
		{
			var level:XML = Library.getXML(source);
			
			removeAll();
			
			camera.x = level.camera.@x;
			camera.y = level.camera.@y;
			
			size.x = level.@width;
			size.y = level.heigh;
			
			for each (var layer:XML in level.children()) 
			{
				if (layer.hasSimpleContent())
				{
					//	This node has no children, so it isn't really a layer
					continue;
				}
				
				layerIndices[layer.name()] = ++numLayers;
				
				for each (var entity:XML in layer.children()) 
				{
					var ent:Entity;
					
					var type:Class = types[entity.name()];
					if (!type)
					{
						trace("No entity type registered for", entity.name());
						ent = new Entity(0, 0, new Image(defaultImage));
					}
					else
					{
						ent = new type();
						if (ent is XMLEntity)
						{
							(ent as XMLEntity).load(entity);
						}
					}
					
					//	Set up scale and position to match the values in the xml definition
					if (ent.graphic)
					{
						var image:Image = ent.graphic as Image;
						if (image)
						{
							var angle:int = entity.@angle;
							var size:Point = new Point(entity.@width, entity.@height);
							image.angle = -angle;
							image.scaleX = size.x / image.width || 1;
							image.scaleY = size.y / image.height || 1;
						}
					}
					
					ent.layer = numLayers;
					
					add(ent);
				}
			}
		}
		
		override public function update():void 
		{
			super.update();
		}
		
		override public function begin():void 
		{
			super.begin();
			
			FP.camera.x = camera.x;
			FP.camera.y = camera.y;
		}
		
		override public function render():void 
		{
			if (wraparound)
			{
				var original:int = FP.camera.x;
				
				FP.camera.x = original + size.x
				super.render();
				FP.camera.x = original - size.x;
				super.render();
				
				FP.camera.x = original % size.x;
			}
			
			super.render();
		}
	}
}