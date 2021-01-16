package com.jacobalbano.punkutils;

import net.hxpunk.Entity;
import net.hxpunk.HP;
import net.hxpunk.graphics.Image;

/**
	 * Transition entity to fade between worlds
	 * @author Jacob Albano
	 */
class Transition extends Entity
{
    public function new()
    {
        super(0, 0, HP.screen.capture());
        graphic.scrollX = graphic.scrollY = 0;
    }
    
    override public function update() : Void
    {
        super.update();
        
        var image :Image = cast graphic;
        if ((image.alpha -= 0.075) <= 0)
        {
            HP.world.remove(this);
        }
    }
}

