package objects
{
	import events.NavigationEvent;
	
	import starling.animation.Transitions;
	import starling.animation.Tween;
	import starling.core.Starling;
	import starling.display.Sprite;
	import starling.events.Event;
	import starling.text.TextField;
	import starling.utils.Color;
	import starling.utils.HAlign;
	import starling.utils.VAlign;
	
	public class Score extends Sprite  
	{
		[Embed(source="../media/fonts/fallFont.ttf", embedAsCFF="false", fontFamily="fallFont")]
		private static const FallFont:Class;
		
		private var scoreText1:TextField = new TextField(48, 48, "0", "fallFont", 48, Color.BLACK, true);
		private var scoreText10:TextField = new TextField(48, 48, "0", "fallFont", 48, Color.BLACK, true);
		private var scoreText100:TextField = new TextField(48, 48, "0", "fallFont", 48, Color.BLACK, true);
		
		private var scoreText:Sprite = new Sprite();
		private var tapArt:Tap;
		private var scoreInt:int = 0;
		
		public function Score()
		{
			super();
			this.addEventListener(Event.ADDED_TO_STAGE, onAddedToStage);
		}
		private function onAddedToStage(event:Event):void
		{
			this.removeEventListener(Event.ADDED_TO_STAGE, onAddedToStage);
			afficheScore();
		}
		public function afficheScore():void
		{
			scoreText100.x = -48;
			scoreText1.x = 48;
			scoreText.addChild(scoreText100);
			scoreText.addChild(scoreText10);
			scoreText.addChild(scoreText1);
			
			scoreText.alignPivot(HAlign.CENTER, VAlign.CENTER);
			
			changeColor(scoreText100);
			changeColor(scoreText10);
			changeColor(scoreText1);
			
			
			scoreText.x = 320;
			scoreText.y = 24;
			addChild(scoreText);
		}
		public function ajouterScore(scoreTemp:int) :void
		{
			scoreInt += scoreTemp;
			
			var scoreInt100:int = scoreInt / 100;
			var scoreInt10:int = scoreInt / 10 - scoreInt100*10;
			var scoreInt1:int = scoreInt - scoreInt10*10 - scoreInt100*100;
			
			scoreText1.text = String(scoreInt1);
			scoreText10.text = String(scoreInt10);
			scoreText100.text = String(scoreInt100);
			
			changeColor(scoreText100);
			changeColor(scoreText10);
			changeColor(scoreText1);
		}
		private function changeColor(textTemp:Object):void
		{
			var couleurText:uint = Assets.getColor();
			textTemp.color = couleurText;
		}
		public function gameOver():void
		{
			var tweenFall:Tween = new Tween(scoreText, 0.3, Transitions.EASE_OUT_BOUNCE);
			tweenFall.animate("y", 374);
			tweenFall.scaleTo(2);
			Starling.juggler.add(tweenFall);
			tweenFall.onComplete = function ():void
			{ 
				Starling.juggler.removeTweens(scoreText);
				parent.dispatchEvent(new NavigationEvent(NavigationEvent.CHANGE_SCREEN, {id: "donneScore"}, true));
				Starling.juggler.delayCall(function():void{addTap();}, 2); 
			}
		}
		private function addTap():void
		{
			tapArt = new Tap();
			tapArt.x = 640/2  - 60;
			tapArt.y = 960/2 ;
			this.addChild(tapArt);
		}
	}
}