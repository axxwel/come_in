package objects
{
	import events.NavigationEvent;
	
	import starling.display.Button;
	import starling.display.Quad;
	import starling.display.Sprite;
	import starling.events.Event;
	import starling.textures.RenderTexture;
	
	public class ScreenTouch extends Sprite
	{
		private var screenButton:Button;
		
		public function ScreenTouch()
		{
			super();
			this.addEventListener(Event.ADDED_TO_STAGE, onAddedToStage);
		}
		private function onAddedToStage(e:Event):void
		{
			var rt:RenderTexture = new RenderTexture(stage.stageWidth, stage.stageHeight);
			var q:Quad = new Quad(stage.stageWidth, stage.stageHeight, 0xffffff);
			q.alpha=0;
			rt.draw(q);
			screenButton = new Button(rt);
			this.addChild(screenButton);
			addEventListener(Event.TRIGGERED, screenTouch)
		}
		private function screenTouch(e:Event):void
		{
			parent.dispatchEvent(new NavigationEvent(NavigationEvent.CHANGE_SCREEN, {id: "startGame"}, true));
			this.removeFromParent(true);
		}
	}
}