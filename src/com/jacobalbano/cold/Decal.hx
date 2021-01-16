package com.jacobalbano.cold;

import net.hxpunk.graphics.Image;
import com.jacobalbano.punkutils.XMLEntity;

/**
	 * ...
	 * @author Jake Albano
	 */
class Decal extends XMLEntity
{
    public var source : String;
    
    public function new()
    {
        super();
    }
    
    override public function load(entity : Xml) : Void
    {
        super.load(entity);
        graphic = new Image('art/decals/${source}.png');
        
        graphic.scrollX = Std.parseFloat(entity.get("scrollX"));
        graphic.scrollY = Std.parseFloat(entity.get("scrollY"));
    }
}

