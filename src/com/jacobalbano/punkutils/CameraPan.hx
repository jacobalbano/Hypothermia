package com.jacobalbano.punkutils;

import haxepunk.input.Mouse;
import flash.geom.Rectangle;
import haxepunk.Entity;
import haxepunk.tweens.misc.VarTween;
import haxepunk.input.Input;
import haxepunk.HXP;
import com.jacobalbano.punkutils.XMLEntity;
import com.jacobalbano.punkutils.OgmoWorld;

/**
	 * @author Jacob Albano
	 */
class CameraPan extends XMLEntity
{
    public var wrapAround : Bool;
    public var worldWidth : Int;
    public var worldHeight : Int;
    public var buffer : Int;
    public var scrollSpeed : Int;
    
    private var leftBuffer : Rectangle;
    private var rightBuffer : Rectangle;
    private var topBuffer : Rectangle;
    private var bottomBuffer : Rectangle;
    
    private var tween : VarTween;
    public var speedX : Float;
    public var speedY : Float;
    private var mouseInXBuffer : Bool;
    private var mouseInYBuffer : Bool;
    
    public function new()
    {
        super();
        worldWidth = 0;  //	default  
        worldHeight = 0;  //	default  
        tween = new VarTween();
        addTween(tween, true);
        speedX = 0;
        speedY = 0;
    }
    
    override public function added() : Void
    {
        super.added();
        
        HXP.camera.x = x;
        HXP.camera.y = y;
        
        if (!Std.is(world, OgmoWorld))
            return;
        
        var oWorld : OgmoWorld = cast world;
        this.worldWidth = Std.int(oWorld.size.x);
        this.worldHeight = Std.int(oWorld.size.y);
        oWorld.wraparound = this.wrapAround;
        
        leftBuffer = new Rectangle(0, 0, buffer, HXP.height);
        rightBuffer = new Rectangle(HXP.width - buffer, 0, buffer, HXP.height);
        topBuffer = new Rectangle(0, 0, HXP.width, buffer);
        bottomBuffer = new Rectangle(0, HXP.height - buffer, HXP.width, buffer);
    }
    
    override public function update() : Void
    {
        super.update();
        
        if (wrapAround || (HXP.camera.x >= 0 && HXP.camera.x + HXP.width <= worldWidth))
        {
            if (leftBuffer.contains(Mouse.mouseX, Mouse.mouseY))
            {
                onEnterLeft();
            }
            else if (rightBuffer.contains(Mouse.mouseX, Mouse.mouseY))
            {
                onEnterRight();
            }
            else
            {
                speedX = 0;
                mouseInXBuffer = false;
            }
        }
        
        if (!wrapAround && HXP.camera.y >= 0 && HXP.camera.y + HXP.height <= worldHeight)
        {
            if (topBuffer.contains(Mouse.mouseX, Mouse.mouseY))
            {
                onEnterTop();
            }
            else if (bottomBuffer.contains(Mouse.mouseX, Mouse.mouseY))
            {
                onEnterBottom();
            }
            else
            {
                speedY = 0;
                mouseInYBuffer = false;
            }
        }
        
        HXP.camera.x += speedX;
        HXP.camera.y += speedY;
        
        if (!wrapAround)
        {
            if (HXP.width <= worldWidth)
            {
                if (HXP.camera.x < 0)
                {
                    HXP.camera.x = 0;
                }
                else if (HXP.camera.x + HXP.width >= worldWidth)
                {
                    HXP.camera.x = worldWidth - HXP.width;
                }
            }
            
            if (HXP.height <= worldHeight)
            {
                if (HXP.camera.y < 0)
                {
                    HXP.camera.y = 0;
                }
                else if (HXP.camera.y + HXP.height >= worldHeight)
                {
                    HXP.camera.y = worldHeight - HXP.height;
                }
            }
        }
        else
        {
            HXP.camera.x = HXP.camera.x % worldWidth;
            HXP.camera.y = HXP.camera.y % worldHeight;
        }
    }
    
    private function onEnterRight() : Void
    {
        if (!mouseInXBuffer)
        {
            mouseInXBuffer = true;
            speedX = 0;
            tween.tween(this, "speedX", scrollSpeed, 0.25);
        }
    }
    
    private function onEnterLeft() : Void
    {
        if (!mouseInXBuffer)
        {
            mouseInXBuffer = true;
            speedX = 0;
            tween.tween(this, "speedX", -scrollSpeed, 0.25);
        }
    }
    
    private function onEnterBottom() : Void
    {
        if (!mouseInYBuffer)
        {
            mouseInYBuffer = true;
            speedY = 0;
            tween.tween(this, "speedY", scrollSpeed, 0.25);
        }
    }
    
    private function onEnterTop() : Void
    {
        if (!mouseInYBuffer)
        {
            mouseInYBuffer = true;
            speedY = 0;
            tween.tween(this, "speedY", -scrollSpeed, 0.25);
        }
    }
}

