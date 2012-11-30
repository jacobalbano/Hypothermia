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
		[Embed(source = "../lib/fish.png")] private const FLAKIT_ASSET$_1026934739:Class;
		[Embed(source = "../lib/Library.xml", mimeType = "application/octet-stream")] private const FLAKIT_ASSET$_1371418527:Class;
		[Embed(source = "../lib/test2.oel", mimeType = "application/octet-stream")] private const FLAKIT_ASSET$930662781:Class;
		[Embed(source = "../lib/test/map.oel", mimeType = "application/octet-stream")] private const FLAKIT_ASSET$_1321217687:Class;
		[Embed(source = "../lib/test/script.oel", mimeType = "application/octet-stream")] private const FLAKIT_ASSET$_624613313:Class;
		
		public function EmbeddedAssets()
		{
			Library.addImage(new String("fish.png").split("/").join("."), new FLAKIT_ASSET$_1026934739);
			Library.addXML(new String("Library.xml").split("/").join("."), getXML(FLAKIT_ASSET$_1371418527));
			Library.addXML(new String("test2.oel").split("/").join("."), getXML(FLAKIT_ASSET$930662781));
			Library.addXML(new String("test/map.oel").split("/").join("."), getXML(FLAKIT_ASSET$_1321217687));
			Library.addXML(new String("test/script.oel").split("/").join("."), getXML(FLAKIT_ASSET$_624613313));
		}
		private function getXML(c:Class):XML{var d:ByteArray = new c;var s:String = d.readUTFBytes(d.length);return new XML(s);}
	}
}
