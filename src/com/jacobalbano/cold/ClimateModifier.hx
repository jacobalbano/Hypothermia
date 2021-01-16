package com.jacobalbano.cold;

import com.jacobalbano.punkutils.XMLEntity;

/**
	 * @author Jake Albano
	 */
class ClimateModifier extends XMLEntity
{
    public var temperature : Int;
    
    private var parent : Climate;
    
    public function new()
    {
        super();
    }
    
    public function remove() : Void
    {
        parent.temperature -= temperature;
    }
    
    override public function removed() : Void
    {
        super.removed();
    }
    
    public function onAdded(parent : Climate) : Void
    {
        this.parent = parent;
    }
}

