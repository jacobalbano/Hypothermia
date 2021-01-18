package com.jacobalbano.punkutils;

import openfl.Assets;
import haxe.xml.Access;
import flash.display.Bitmap;
import flash.display.BitmapData;
import flash.geom.Point;
import flash.geom.Rectangle;
import haxepunk.Entity;
import haxepunk.Graphic;
import haxepunk.graphics.Image;
import haxepunk.Sfx;
import haxepunk.World;
import haxepunk.HXP;

/**
	 * @author Jacob Albano
	 */
class OgmoLoader
{
    private var types(default, never):Map<String, Class<Entity>> = new Map();
    private static var defaultImage(default, never):BitmapData = generateDefaultImage();
    
    public function new()
    {
    }
    
    /**
		 * Register a class with the world builder
		 * @param	name	The name to associate with the class
		 * @param	type	The entity class that will be added to the world when the name is found in the level file. It must have a constructor that takes an XML parameter
		 */
    public function addClass(name : String, type : Class<Entity>) : Void
    {
        types.set(name, type);
    }
    
    /**
		 * Unregister a class from the world builder
		 * @param	name	The name the class was added with
		 */
    public function removeClass(name : String) : Void
    {
        types.remove(name);
    }
    
    /**
		 * Load a world from an Ogmo level in the library
		 * @param	source	The level filename
		 */
    public function buildWorld(source:String):OgmoWorld
    {
        var level = Xml.parse(Assets.getText(source)).firstChild();
        var layerIndices = new Map();
        var numLayers = 0;

        var world = new OgmoWorld(new Point(
            Std.parseFloat(level.get("width")),
            Std.parseFloat(level.get("height"))
        ));
        
        for (layer in level.elements())
        {
            if (layer.firstChild() == null)
                continue; //	This node has no children, so it isn't really a layer
            
            layerIndices[layer.nodeName] = ++numLayers;
            
            for (entity in layer.elements())
            {
                var ent : Entity;
                
                var type = types.get(entity.nodeName);
                if (type == null)
                {
                    trace("No entity type registered for", entity.nodeName);
                    ent = new Entity(0, 0, new Image(defaultImage));
                }
                else
                {
                    ent = Type.createInstance(type, []);
                    if (Std.is(ent, XMLEntity))
                        cast(ent, XMLEntity).load(entity);
                }
                
                //	Set up scale and position to match the values in the xml definition
                if (Std.is(ent.graphic, Image))
                {
                    var image: Image = cast ent.graphic;

                    var angleStr = entity.get("angle");
                    var widthStr = entity.get("width");
                    var heightStr = entity.get("height");

                    var angle = angleStr == null ? 0 : Std.parseInt(angleStr);
                    var width = widthStr == null ? 0 : Std.parseFloat(widthStr);                    
                    var height = heightStr == null ? 0 : Std.parseFloat(heightStr);

                    if (angle != 0) image.angle = -angle;
                    if (width != 0) image.scaleX = width / image.width;
                    if (height != 0) image.scaleY = height / image.height;
                }
                
                ent.layer = numLayers;
                world.add(ent);
            }
        }
        
        return world;
    }

    private static inline function generateDefaultImage():BitmapData
    {
        var defaultImage = new BitmapData(100, 100, false, 0xFF0080);
        var flip : Bool = false;
        
        for (j in 0...10)
        {
            for (k in -1...10)
            {
                if (flip = !flip)
                {
                    defaultImage.fillRect(new Rectangle(j * 10, k * 10, 10, 10), 0x00000000);
                }
            }
        }

        return defaultImage;
    }
}
