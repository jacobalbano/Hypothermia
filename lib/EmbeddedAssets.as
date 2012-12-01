package
{
	import com.thaumaturgistgames.flakit.Library;
	import flash.utils.ByteArray;
	
	/**
	* Generated with LibraryBuilder for FLAKit
	* http://www.thaumaturgistgames.com/FLAKit
	*/
	public class EmbeddedAssets
	{
		[Embed(source = "../lib/ogmo/ambiance.png")] private const FLAKIT_ASSET$26896941:Class;
		[Embed(source = "../lib/ogmo/background.png")] private const FLAKIT_ASSET$_1157757234:Class;
		[Embed(source = "../lib/ogmo/camera.png")] private const FLAKIT_ASSET$_862204225:Class;
		[Embed(source = "../lib/ogmo/Decal.png")] private const FLAKIT_ASSET$338515033:Class;
		[Embed(source = "../lib/ogmo/emitter.png")] private const FLAKIT_ASSET$_438935123:Class;
		[Embed(source = "../lib/ogmo/invitem.png")] private const FLAKIT_ASSET$_612164355:Class;
		[Embed(source = "../lib/art/worlditems/axe.png")] private const FLAKIT_ASSET$366605660:Class;
		[Embed(source = "../lib/art/ui/inventory.png")] private const FLAKIT_ASSET$1018619379:Class;
		[Embed(source = "../lib/art/ui/inventoryMask.png")] private const FLAKIT_ASSET$428753614:Class;
		[Embed(source = "../lib/art/particles/snowflake.png")] private const FLAKIT_ASSET$_430274975:Class;
		[Embed(source = "../lib/art/decals/cabinThroughWindow.png")] private const FLAKIT_ASSET$1025033428:Class;
		[Embed(source = "../lib/art/decals/windowPeekPane.png")] private const FLAKIT_ASSET$2088416321:Class;
		[Embed(source = "../lib/art/backgrounds/frontLawn.png")] private const FLAKIT_ASSET$2049309920:Class;
		[Embed(source = "../lib/art/backgrounds/halfway.png")] private const FLAKIT_ASSET$_2011110511:Class;
		[Embed(source = "../lib/art/backgrounds/start.png")] private const FLAKIT_ASSET$_782423215:Class;
		[Embed(source = "../lib/sounds/windHowl.mp3")] private const FLAKIT_ASSET$_531661301:Class;
		[Embed(source = "../lib/Library.xml", mimeType = "application/octet-stream")] private const FLAKIT_ASSET$_1371418527:Class;
		[Embed(source = "../lib/worlds/start/script.xml", mimeType = "application/octet-stream")] private const FLAKIT_ASSET$89061255:Class;
		[Embed(source = "../lib/worlds/start/map.oel", mimeType = "application/octet-stream")] private const FLAKIT_ASSET$_475205487:Class;
		[Embed(source = "../lib/worlds/peekWindow/script.xml", mimeType = "application/octet-stream")] private const FLAKIT_ASSET$_1312711882:Class;
		[Embed(source = "../lib/worlds/peekWindow/map.oel", mimeType = "application/octet-stream")] private const FLAKIT_ASSET$_1628931935:Class;
		[Embed(source = "../lib/worlds/halfway/script.xml", mimeType = "application/octet-stream")] private const FLAKIT_ASSET$_573752608:Class;
		[Embed(source = "../lib/worlds/halfway/map.oel", mimeType = "application/octet-stream")] private const FLAKIT_ASSET$1047624235:Class;
		[Embed(source = "../lib/worlds/frontLawn/script.xml", mimeType = "application/octet-stream")] private const FLAKIT_ASSET$1123057315:Class;
		[Embed(source = "../lib/worlds/frontLawn/map.oel", mimeType = "application/octet-stream")] private const FLAKIT_ASSET$_518081528:Class;
		
		public function EmbeddedAssets()
		{
			Library.addImage(new String("ogmo/ambiance.png").split("/").join("."), new FLAKIT_ASSET$26896941);
			Library.addImage(new String("ogmo/background.png").split("/").join("."), new FLAKIT_ASSET$_1157757234);
			Library.addImage(new String("ogmo/camera.png").split("/").join("."), new FLAKIT_ASSET$_862204225);
			Library.addImage(new String("ogmo/Decal.png").split("/").join("."), new FLAKIT_ASSET$338515033);
			Library.addImage(new String("ogmo/emitter.png").split("/").join("."), new FLAKIT_ASSET$_438935123);
			Library.addImage(new String("ogmo/invitem.png").split("/").join("."), new FLAKIT_ASSET$_612164355);
			Library.addImage(new String("art/worlditems/axe.png").split("/").join("."), new FLAKIT_ASSET$366605660);
			Library.addImage(new String("art/ui/inventory.png").split("/").join("."), new FLAKIT_ASSET$1018619379);
			Library.addImage(new String("art/ui/inventoryMask.png").split("/").join("."), new FLAKIT_ASSET$428753614);
			Library.addImage(new String("art/particles/snowflake.png").split("/").join("."), new FLAKIT_ASSET$_430274975);
			Library.addImage(new String("art/decals/cabinThroughWindow.png").split("/").join("."), new FLAKIT_ASSET$1025033428);
			Library.addImage(new String("art/decals/windowPeekPane.png").split("/").join("."), new FLAKIT_ASSET$2088416321);
			Library.addImage(new String("art/backgrounds/frontLawn.png").split("/").join("."), new FLAKIT_ASSET$2049309920);
			Library.addImage(new String("art/backgrounds/halfway.png").split("/").join("."), new FLAKIT_ASSET$_2011110511);
			Library.addImage(new String("art/backgrounds/start.png").split("/").join("."), new FLAKIT_ASSET$_782423215);
			Library.addSound(new String("sounds/windHowl.mp3").split("/").join("."), new FLAKIT_ASSET$_531661301);
			Library.addXML(new String("Library.xml").split("/").join("."), getXML(FLAKIT_ASSET$_1371418527));
			Library.addXML(new String("worlds/start/script.xml").split("/").join("."), getXML(FLAKIT_ASSET$89061255));
			Library.addXML(new String("worlds/start/map.oel").split("/").join("."), getXML(FLAKIT_ASSET$_475205487));
			Library.addXML(new String("worlds/peekWindow/script.xml").split("/").join("."), getXML(FLAKIT_ASSET$_1312711882));
			Library.addXML(new String("worlds/peekWindow/map.oel").split("/").join("."), getXML(FLAKIT_ASSET$_1628931935));
			Library.addXML(new String("worlds/halfway/script.xml").split("/").join("."), getXML(FLAKIT_ASSET$_573752608));
			Library.addXML(new String("worlds/halfway/map.oel").split("/").join("."), getXML(FLAKIT_ASSET$1047624235));
			Library.addXML(new String("worlds/frontLawn/script.xml").split("/").join("."), getXML(FLAKIT_ASSET$1123057315));
			Library.addXML(new String("worlds/frontLawn/map.oel").split("/").join("."), getXML(FLAKIT_ASSET$_518081528));
		}
		private function getXML(c:Class):XML{var d:ByteArray = new c;var s:String = d.readUTFBytes(d.length);return new XML(s);}
	}
}
