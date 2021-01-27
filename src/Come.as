package 
{
	import flash.display.Shape;
	import flash.display.MovieClip;
	import flash.display.StageAlign;
	import flash.display.StageScaleMode;
	import flash.events.Event;
	import flash.geom.Rectangle;
	
	import net.hires.debug.Stats;
	
	import starling.core.Starling;
	import starling.events.ResizeEvent;
	
	[SWF(width="640", height="960", frameRate="60", backgroundColor="#ffffff")]
	public class Come extends MovieClip
	{
		private var mStarling:Starling;
		private var shapeScaler:Shape;
		private var originalViewPort:Rectangle;
		
		public function Come()
		{
			this.stage.scaleMode = StageScaleMode.NO_SCALE;
			this.stage.align = StageAlign.TOP_LEFT;
			
			originalViewPort = new Rectangle(0, 0, stage.fullScreenWidth, stage.fullScreenHeight);
			
			shapeScaler = new Shape();
			shapeScaler.graphics.beginFill(0);
			shapeScaler.graphics.drawRect(originalViewPort.x, originalViewPort.y, originalViewPort.width, originalViewPort.height);
			shapeScaler.graphics.endFill();
			
			Starling.multitouchEnabled = true;
			
			mStarling = new Starling(Game, stage, originalViewPort);
			mStarling.antiAliasing=2;
			Starling.current.stage.addEventListener(ResizeEvent.RESIZE, starlingStageResizeListener);
			
			mStarling.start();
			
			mStarling.simulateMultitouch = true;	
			
			//this.addChild(new Stats());		
		}
		private function starlingStageResizeListener(evt:ResizeEvent):void
		{
			starlingStageResize(evt.width, evt.height);
		}
		private function starlingStageResize(_width:Number, _height:Number):void {
			shapeScaler.width = _width;
			shapeScaler.height = _height;
			
			( shapeScaler.scaleX < shapeScaler.scaleY ) ? shapeScaler.scaleY = shapeScaler.scaleX : shapeScaler.scaleX = shapeScaler.scaleY;
			
			( shapeScaler.scaleX > shapeScaler.scaleY ) ? shapeScaler.scaleY = shapeScaler.scaleX : shapeScaler.scaleX = shapeScaler.scaleY;
			
			Starling.current.viewPort = new Rectangle((_width - shapeScaler.width)/2,(_height - shapeScaler.height)/2,shapeScaler.width,shapeScaler.height);
		}
	}
}