package com.jacobalbano.cold;

import net.hxpunk.graphics.Image;
import com.jacobalbano.punkutils.XMLEntity;

/**
	 * ...
	 * @author Jake Albano
	 */
class Background extends XMLEntity
{
    public var source : String;
    
    public function new()
    {
        super();
    }
    
    override public function added() : Void
    {
        super.added();
        graphic = new Image('art/backgrounds/${source}.png');
    }
}

