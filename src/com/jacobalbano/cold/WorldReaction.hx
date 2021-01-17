package com.jacobalbano.cold;

import haxepunk.input.Mouse;
import com.jacobalbano.punkutils.XMLEntity;

/**
	 * @author Jake Albano
	 */
class WorldReaction extends XMLEntity
{
    public var onMatch : String;
    public var match : String;
    
    public function new()
    {
        super();
    }
    
    override public function update() : Void
    {
        super.update();
        if (collidePoint(x, y, world.mouseX, world.mouseY))
        {
            var all = [];
            var inventory : Inventory;
            world.getClass(Inventory, all);
            
            if (all.length > 0)
            {
                inventory = cast all[0];
            }
            else
            {
                return;
            }
            
            if (inventory.mouseItem == match)
            {
                if (Mouse.mouseReleased)
                {
                    FPGame.slang.doLine(onMatch);
                }
            }
        }
    }
}

