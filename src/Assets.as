package
{
	import flash.display.Bitmap;
	import flash.media.Sound;
	import flash.media.SoundChannel;
	import flash.utils.Dictionary;
	import flash.utils.getDefinitionByName;
	
	import starling.textures.Texture;
	import starling.textures.TextureAtlas;

	public class Assets
	{
		
		private static var gameTextureAtlas:TextureAtlas;
		private static var gameTextures:Dictionary =new Dictionary();
		private static var gameSounds:Dictionary = new Dictionary();
		
		[Embed(source="../media/graphics/graphics.png")]
		public static const AtlasTextureGame:Class;
		
		[Embed(source="../media/graphics/graphics.xml", mimeType="application/octet-stream")]
		public static const AtlasXmlGame:Class;
		
		[Embed(source="../media/sounds/ComeVoice.mp3")]
		public static const SoundComeVoice:Class;
		
		[Embed(source="../media/sounds/gameOver.mp3")]
		public static const GameOver:Class;
		
		[Embed(source="../media/sounds/sonCome.mp3")]
		public static const SoundCome:Class;

		[Embed(source="../media/sounds/sonFall.mp3")]
		public static const SoundFall:Class;
		
		private static const bleu:uint= 0x27A9E1;
		private static const red:uint= 0xED1C24;
		private static const yellow:uint= 0xFFDD17;
		private static const green:uint= 0x8CC63E;
		private static const orange:uint= 0xF7931D;
		private static const purple:uint= 0x9060A8;
		public static var color:uint;
		
		public static function getAtlas():TextureAtlas
		{
			if(gameTextureAtlas == null)
			{
				var texture:Texture = getTexture("AtlasTextureGame");
				var xml:XML =XML(new AtlasXmlGame());
				gameTextureAtlas = new TextureAtlas(texture, xml);
			}
			return gameTextureAtlas;
		}
		public static function getTexture(name:String):Texture
		{
			if(gameTextures[name] == undefined)
			{
				var bitmap:Bitmap = new Assets[name]();
				gameTextures[name] = Texture.fromBitmap(bitmap);
			}
			return gameTextures[name];
		}
		public static function getColor():uint
		{
			var c:int=Math.random()*5;
			switch(c){
				case 0: color=bleu;break;
				case 1: color=red;break;
				case 2: color=yellow;break;
				case 3: color=green;break;
				case 4: color=orange;break;
				case 5: color=purple;break;	
			}
			return color;
		}
		public static function getSound(name:String):Sound
		{
			if(gameSounds[name] == undefined){
				var sound:Sound = new Assets[name]();
				gameSounds[name] = sound;
			}
			return gameSounds[name];
		}
	}
}