package objects
{
	import starling.core.Starling;
	
	import starling.display.MovieClip;
	import starling.display.Sprite;
	import starling.events.Event;
	
	import starling.utils.HAlign;
	import starling.utils.VAlign;
	
	public class Tap extends Sprite
	{
		private var tapArt:MovieClip;
		
		public function Tap()
		{
			super();
			this.addEventListener(Event.ADDED_TO_STAGE, onAddedToStage);
		}
		
		private function onAddedToStage(e:Event):void
		{
			create();
			this.removeEventListener(Event.ADDED_TO_STAGE, onAddedToStage);
		}
		
		private function create():void
		{
			tapArt = new MovieClip(Assets.getAtlas().getTextures("tap_"), 30);
			tapArt.alignPivot(HAlign.CENTER, VAlign.CENTER);
			tapArt.x=64;
			tapArt.y=64;
			tapArt.loop = true;
			
			this.addChildAt(tapArt,0);
			Starling.juggler.add(tapArt);			
		}
	}
}