package com.jacobalbano.punkutils 
{
	import flash.display.Bitmap;
	import flash.geom.Rectangle;
	import net.flashpunk.graphics.Image;
	
	/**
	 * Wrapper class to allow Flashpunk images to take Bitmaps as a source
	 * @author Jacob Albano
	 */
	public class Image extends net.flashpunk.graphics.Image 
	{
		
		public function Image(source:*, clipRect:Rectangle = null) 
		{
			super(source is Bitmap ? (source as Bitmap).bitmapData : source, clipRect);
		}
		
	}

}