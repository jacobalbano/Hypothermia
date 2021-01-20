package com.jacobalbano.cold;

import haxepunk.masks.Hitbox;
import haxepunk.input.Mouse;
import openfl.Assets;
import flash.errors.Error;
import haxepunk.graphics.Image;
import com.jacobalbano.punkutils.XMLEntity;
import flash.display.Bitmap;
import flash.ui.MouseCursor;
import haxepunk.Entity;
import haxepunk.Tween;
import haxepunk.tweens.misc.VarTween;
import haxepunk.utils.Ease;
import haxepunk.input.Input;
import haxepunk.HXP;

/**
	 * @author Jake Albano
	 */
class Inventory extends XMLEntity
{
    public var isOpen(default, null) : Bool = false;
    public var mouseItem(default, set) : String = null;
    
    public function new()
    {
        super();
        graphic = new Image("art/ui/inventory.png");
        graphic.scrollX = 0;
        graphic.scrollY = 0;

        mask = new Hitbox(100, 100, HXP.width - 200, 100);
        
        reset();
    }
    
    public function reset() : Void
    {
        items = new Map();
        y = -cast(graphic, Image).height;
        everUsed = false;
    }
    
    override public function added() : Void
    {
        super.added();
        
        for (item in items)
            world.add(item);
    }
    
    override public function removed() : Void
    {
        super.removed();
        
        for (item in items)
            world.remove(item);
    }
    
    override public function update() : Void
    {
        super.update();
        
        var lastContain : Bool = contains;
        contains = collidePoint(x, y, Mouse.mouseX, Mouse.mouseY);
        
        var count : Int = 0;
        for (item in items)
        {
            if (item.typeName == mouseItem)
            {
                item.x = Mouse.mouseX;
                item.y = Mouse.mouseY;
            }
            else
            {
                item.x = count++ * ITEM_SIZE + ITEM_PADDING + (ITEM_SIZE / 2);
                item.y = y + (ITEM_SIZE / 2) + 15;
                item.update();
            }
        }
        
        if (lastContain != contains)
        {
            if (contains)
            {
                flash.ui.Mouse.cursor = MouseCursor.BUTTON;
            }
            else
            {
                flash.ui.Mouse.cursor = MouseCursor.ARROW;
            }
        }
        
        if (Mouse.mouseReleased && contains)
        {
            if (isOpen) close(); else if (mouseItem == null) open();
            mouseItem = null;
        }
    }
    
    public function open() : Void
    {
        if (isOpen || transitioning)
            return;
        
        transitioning = true;
        var tween : VarTween = new VarTween(TweenType.OneShot);
        tween.tween(this, "y", 0, 0.8, Ease.bounceOut);
        tween.onComplete.bind(() -> transitioning = false);
        addTween(tween, true);
        isOpen = true;
    }
    
    public function close() : Void
    {
        if (!isOpen || transitioning)
            return;
        
        transitioning = true;
        var tween : VarTween = new VarTween(TweenType.OneShot);
        tween.tween(this, "y", y - 150, 0.7, Ease.bounceOut);
        tween.onComplete.bind(() -> transitioning = false);
        addTween(tween, true);
        isOpen = false;
    }
    
    public function hasItem(name : String) : Bool
    {
        return items.exists(name);
    }
    
    public function addItem(name : String) : Void
    {
        if (hasItem(name))
        {
            return;
        }
        
        var image : Image;
        
        var source = 'art/worlditems/${name}.png';
        if (Assets.exists('art/invitems/${name}.png'))
            source = 'art/invitems/${name}.png';

        image = new Image(source);
        
        var item : InventoryItem = new InventoryItem();
        item.typeName = name;
        item.graphic = image;
        item.onAdded(this);
        world.add(item);
        
        image.scrollX = 0;
        image.scrollY = 0;
        image.smooth = true;
        image.scale = ITEM_SIZE / Math.max(image.width, image.height);
        
        items.set(name, item);
        
        if (!everUsed)
        {
            //	First item added to inventory, so show the button in a way that it'll be noticed.
            transitioning = true;
            var tween : VarTween = new VarTween(TweenType.OneShot);
            tween.tween(this, "y", y + 50, 0.9, Ease.bounceOut);
            tween.onComplete.bind(() -> transitioning = false);
            addTween(tween, true);
            everUsed = true;
        }
        
    }
    
    public function removeItem(name : String) : Void
    {
        if (!items.exists(name))
        {
            return;
        }
        
        if (name == mouseItem)
            mouseItem = null;
        
        world.remove(items.get(name));
        items.remove(name);
    }
    
    private function set_mouseItem(typeName : String) : String
    {
        if (typeName == null || items.exists(typeName))
        {
            mouseItem = typeName;
            close();
        }

        return typeName;
    }
    
    private var items : Map<String, InventoryItem> = new Map();
    private var extended : Bool = false;
    private var everUsed : Bool = false;
    private var contains : Bool = false;
    private var transitioning:Bool = false;
    private static inline var ITEM_PADDING : Float = 20;
    private static inline var ITEM_SIZE : Float = 100;
}

