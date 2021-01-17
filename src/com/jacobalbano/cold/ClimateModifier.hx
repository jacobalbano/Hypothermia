package com.jacobalbano.cold;

import com.jacobalbano.punkutils.XMLEntity;

/**
	 * @author Jake Albano
	 */
class ClimateModifier extends XMLEntity
{
    public var temperature : Int;
    
    private var owner : Climate;
    
    public function new()
    {
        super();
    }
    
    public function remove() : Void
    {
        owner.temperature -= temperature;
    }
    
    override public function removed() : Void
    {
        super.removed();
    }
    
    public function onAdded(owner : Climate) : Void
    {
        this.owner = owner;
    }
}

