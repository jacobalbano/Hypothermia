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

    public var scrollX:Float;
    public var scrollY:Float;
    
    public function new()
    {
        super();
    }

    override public function render():Void
    {
        super.render();
    }
    
    override public function load(entity : Xml) : Void
    {
        super.load(entity);
        graphic = new Image('art/decals/${source}.png');

        graphic.scrollX = scrollY;
        graphic.scrollY = scrollX;
    }
}

