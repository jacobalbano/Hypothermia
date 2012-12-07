package
{
	import com.jacobalbano.punkutils.OgmoWorld;
	import com.thaumaturgistgames.flakit.Library;
	import com.thaumaturgistgames.flakit.Engine;
	import com.jacobalbano.punkutils.ScriptTick;
	import flash.geom.Point;
	import flash.utils.Dictionary;
	
	[Frame(factoryClass = "Preloader")]
	[SWF(width = "800", height = "400")]
	public class Game extends Engine 
	{
		public static var instance:Game;
		public function Game()
		{
			//	Initialize library
			super(Library.USE_EMBEDDED, EmbeddedAssets);
			instance = this;
		}
		
		override public function init():void 
		{
			super.init();
			//	Entry point
			addChild(new FPGame());
			console.print("initialized");
		}
	}

}