package com.jacobalbano.cold;

import net.hxpunk.graphics.Image;
import com.jacobalbano.punkutils.XMLEntity;
import flash.geom.Rectangle;
import net.hxpunk.utils.Input;

/**
	 * @author Jake Albano
	 */
class InventoryItem extends XMLEntity
{
    private var parent : Inventory;
    public var typeName : String;
    
    public function new()
    {
        super();
    }
    
    public function onAdded(parent : Inventory) : Void
    {
        this.parent = parent;
    }
    
    override public function added() : Void
    {
        super.added();
        var img:Image = cast graphic;
        img.centerOrigin();
    }
    
    override public function update() : Void
    {
        super.update();
        
        var image : Image = cast graphic;
        var rect : Rectangle = new Rectangle(x - (image.originX * (image.scale)), y - (image.originY * (image.scale)), image.width * image.scale, image.height * image.scale);
        
        if (rect.contains(Input.mouseX, Input.mouseY))
        {
            if (Input.mouseReleased)
            {
                //	Set this as the type at the mouse
                parent.mouseItem = typeName;
            }
        }
    }
}

