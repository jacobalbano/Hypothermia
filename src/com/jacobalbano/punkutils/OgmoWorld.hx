package com.jacobalbano.punkutils;

import openfl.Assets;
import haxe.xml.Access;
import flash.display.Bitmap;
import flash.display.BitmapData;
import flash.geom.Point;
import flash.geom.Rectangle;
import net.hxpunk.Entity;
import net.hxpunk.Graphic;
import net.hxpunk.graphics.Image;
import net.hxpunk.Sfx;
import net.hxpunk.World;
import net.hxpunk.HP;

/**
	 * @author Jacob Albano
	 */
class OgmoWorld extends World
{
    private var types : Map<String, Class<Entity>>;
    private var layerIndices : Map<String, Int>;
    private var numLayers : Int;
    private var defaultImage : BitmapData;
    private var canLoad : Bool;
    
    //public var levelName:String;
    public var wraparound : Bool;
    public var size : Point;
    
    public function new()
    {
        super();
        types = new Map();
        layerIndices = new Map();
        numLayers = 0;
        size = new Point();
        canLoad = true;
        
        defaultImage = new BitmapData(100, 100, false, 0xFF0080);
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
    }
    
    override public function update() : Void
    {
        super.update();
        canLoad = true;
    }
    
    /**
		 * Register a class with the scene builder
		 * @param	name	The name to associate with the class
		 * @param	type	The entity class that will be added to the world when the name is found in the level file. It must have a constructor that takes an XML parameter
		 */
    public function addClass(name : String, type : Class<Entity>) : Void
    {
        types.set(name, type);
    }
    
    /**
		 * Unregister a class from the scene builder
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
    public function buildWorld(source : String) : Void
    {
        if (!canLoad)
        {
            return;
        }
        
        var level = Xml.parse(Assets.getText(source));
        
        removeAll();
        size.x = Std.parseFloat(level.get("width"));
        size.y = Std.parseFloat(level.get("height"));
        
        for (layer in level)
        {
            if (layer.firstChild() == null)
                continue; //	This node has no children, so it isn't really a layer
            
            layerIndices[layer.nodeName] = ++numLayers;
            
            for (entity in layer)
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
                    {
                        cast(ent, XMLEntity).load(entity);
                    }
                }
                
                //	Set up scale and position to match the values in the xml definition
                if (Std.is(ent.graphic, Image))
                {
                    var image: Image = cast ent.graphic;
                    var angle = Std.parseInt(entity.get("angle"));
                    var size: Point = new Point(
                        Std.parseFloat(entity.get("width")),
                        Std.parseFloat(entity.get("height"))
                    );

                    image.angle = -angle;
                    image.scaleX = size.x / image.width != 0 ? image.width : 1;
                    image.scaleY = size.y / image.height != 0 ? image.height : 1;
                }
                
                ent.layer = numLayers;
                
                add(ent);
            }
        }
        
        canLoad = false;
    }
    
    override public function begin() : Void
    {
        super.begin();
    }
    
    override public function render() : Void
    {
        if (wraparound)
        {
            var original = HP.camera.x;
            HP.camera.x = original + size.x;
            super.render();
            HP.camera.x = original - size.x;
            super.render();
            HP.camera.x = original;
        }
        
        super.render();
    }
    
    override private function get_mouseX() : Int
    {
        var mx : Int = super.mouseX;
        if (wraparound)
        {
            if (mx < 0)
            {
                mx += Std.int(size.x);
            }
            else
            {
                mx %= Std.int(size.x);
            }
        }
        
        return mx;
    }
}
