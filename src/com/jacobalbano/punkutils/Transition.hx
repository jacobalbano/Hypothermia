package com.jacobalbano.punkutils;

import openfl.Lib;
import openfl.display.BitmapData;
import openfl.display.Bitmap;
import openfl.geom.Rectangle;
import openfl.geom.Matrix;
import haxepunk.Entity;
import haxepunk.HXP;
import haxepunk.graphics.Image;

/**
	 * Transition entity to fade between worlds
	 * @author Jacob Albano
	 */
class Transition extends Entity
{
    public function new()
    {
        super();
        var stage = Lib.current.stage;
        var bounds = new Rectangle(0, 0, stage.stageWidth, stage.stageHeight);
		var theBitmap:Bitmap = new Bitmap(new BitmapData(Math.floor(bounds.width), Math.floor(bounds.height), false));

		var m:Matrix = new Matrix(1, 0, 0, 1, -bounds.x, -bounds.y);
		theBitmap.bitmapData.draw(stage, m);
        
        graphic = new Image(theBitmap.bitmapData);
        graphic.scrollX = graphic.scrollY = 0;
    }
    
    override public function update() : Void
    {
        super.update();
        
        var image :Image = cast graphic;
        if ((image.alpha -= 0.05) <= 0)
        {
            HXP.world.remove(this);
        }
    }
}

