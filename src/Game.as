package
{
	import events.NavigationEvent;
	
	import objects.Forme;
	import objects.ScreenTouch;
	
	import screens.InGame;
	
	import starling.display.Sprite;
	import starling.events.Event;
	
	
	public class Game extends Sprite
	{
		private var screenInGame:InGame;
		private var screenButton:ScreenTouch;
		
		public function Game()
		{
			super();
			this.addEventListener(Event.ADDED_TO_STAGE, onAddedToStage);
		}
		private function onAddedToStage(event:Event):void
		{			
			init();
			this.addEventListener(events.NavigationEvent.CHANGE_SCREEN, onChangeScreen);
		}
		private function onChangeScreen(event:NavigationEvent):void
		{
			switch(event.params.id){
				case  "donneScore": reset();break;
				case  "startGame": init();break;
			}
		}
		private function reset():void
		{
			screenButton = new ScreenTouch();
			this.addChild(screenButton);
		}
		private function init():void
		{
			while(this.numChildren > 0){Object(this.getChildAt(0)).removeFromParent(true);}
			screenInGame = new InGame();
			this.addChild(screenInGame);
		}
	}
}