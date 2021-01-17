package com.jacobalbano.cold;

import haxepunk.graphics.Image;
import com.jacobalbano.punkutils.XMLEntity;
import flash.geom.Rectangle;

/**
	 * ...
	 * @author Jake Albano
	 */
class WorldItem extends XMLEntity
{
    public var typeName : String;
    
    private var hotSpot : Hotspot;
    
    public function new()
    {
        super();
        hotSpot = new Hotspot();
    }
    
    override public function load(entity : Xml) : Void
    {
        super.load(entity);
        hotSpot.load(entity);
        
        var image : Image = new Image('art/worlditems/${typeName}.png');
        image.smooth = true;
        graphic = image;
    }
    
    override public function added() : Void
    {
        super.added();
        world.add(hotSpot);
    }
    
    override public function removed() : Void
    {
        super.removed();
        world.remove(hotSpot);
    }
}

