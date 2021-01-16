package com.jacobalbano.cold;

import com.jacobalbano.punkutils.XMLEntity;
import net.hxpunk.utils.Input;

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
                if (Input.mouseReleased)
                {
                    FPGame.slang.doLine(onMatch);
                }
            }
        }
    }
}

