package objects
{
	import starling.animation.Transitions;
	import starling.animation.Tween;
	import starling.core.Starling;
	import starling.display.Button;
	import starling.display.DisplayObject;
	import starling.display.Image;
	import starling.display.MovieClip;
	import starling.display.Quad;
	import starling.display.Sprite;
	import starling.events.Event;
	import starling.textures.RenderTexture;
	import starling.utils.HAlign;
	import starling.utils.VAlign;
	import starling.utils.deg2rad;
	
	public class Forme extends Sprite
	{
		private var content:Sprite;
		
		private var formeArt:MovieClip;
		public var formeColor:uint;
		public var formeButton:Button; 
		
		private var tapArt:Tap;
		private var letterArt:Image;
		private var letter:String="";
		
		public var depart:Boolean = true;
		public var insert:Boolean = false;
		public var fall:Boolean = false;
		
		private var onClick:Boolean = false;
		public var click:Boolean = false;
		
		public var onRemove:Boolean = false;
		public var removed:Boolean = false;
		public var masterRemove:Boolean = false;
		
		public var titre:Boolean = false;
		
		public var aide:Boolean = false;
		
		public function Forme(formeColorTemp:uint=0x000000, letterTemp:String="")
		{
			super();
			formeColor = formeColorTemp;
			letter = letterTemp;
			this.addEventListener(Event.ADDED_TO_STAGE, onAddedToStage);
		}
//INIT===============================================================================================================
		private function onAddedToStage(event:Event):void
		{
			this.removeEventListener(Event.ADDED_TO_STAGE, onAddedToStage);
			content = new Sprite();
			content.pivotX=64;
			content.pivotY=64;
			this.addChild(content);
			if(letter == ""){
				createFormeArt();
				createButton();
			}
			if(letter == "o" || letter == "m"){
				createFormeArt();
				createLetter(letter);
				createButton();
			}
			if(letter == "c" || letter == "e"){
				formeColor = 0xffffff;
				createLetter(letter);
			}
		}
//CREATE=============================================================================================================
	//FORME-------------------------------------------------------------------
		private function createFormeArt():void
		{
			var tempo:Number = Math.random()*0.5;
			Starling.juggler.delayCall(function():void{anim("forme_create_");},tempo);
		}
	//BOUTON------------------------------------------------------------------
		private function createButton():void
		{
			var rt:RenderTexture = new RenderTexture(96, 96);
			var q:Quad = new Quad(96, 96, 0xffffff);
			q.alpha=0;
			rt.draw(q);
			formeButton = new Button(rt);
			formeButton.x=16;
			formeButton.y=16;
			
			content.addChild(formeButton);
		}
	//LETTER-------------------------------------------------------------------
		private function createLetter(letterTemp:String):void
		{
			letterArt = new Image(Assets.getAtlas().getTexture("title_"+letterTemp));
			titre = true;
			insert = true;
			content.addChild(letterArt);
		}
//CLICK================================================================================================================
		private function onTouch(e:Event):void
		{
			if( onClick == false && onRemove == false) {
				onClick = true;
				click = true;
				anim("forme_click_");
			}
		}
//MOVE OUT===============================================================================================================
		public function moveOut(sens:int):void
		{
			tweenMoveOut(sens);
		}
//ADD TAP=================================================================================================================
		public function addTap():void
		{
			if(tapArt is DisplayObject){ content.removeChild(tapArt);}
			tapArt = new Tap();
			content.addChildAt(tapArt,content.numChildren-1);
		}
//REMOVE==================================================================================================================
	//MASTER------------------------------------------------------------------------
		public function removeMaster():void
		{
			onRemove = true;
			anim("forme_remove_master_");
		}
	//SLAVE------------------------------------------------------------------------
		public function removeSlave(sens:int):void
		{
			tweenRemoveSlave(sens);
			if(formeColor!=0xffffff){
				if(sens==1||sens==2){content.rotation=deg2rad(90);}
			}
		}
	//LETTER-----------------------------------------------------------------------
		public function removeLetter():void
		{
			if(letterArt is DisplayObject){
				titre = false;
				content.removeChild(letterArt);
			}
		}
	//TAP--------------------------------------------------------------------------
		public function removeTap():void
		{
			if(tapArt is DisplayObject){
				aide = false;
				content.removeChild(tapArt);
			}
		}
//ANIM==================================================================================================================
	//INIT------------------------------------------------------------------------
		private function anim(animType:String):void
		{
			if(formeArt is DisplayObject){ content.removeChild(formeArt);}
			formeArt = new MovieClip(Assets.getAtlas().getTextures(animType), 30);
			formeArt.alignPivot(HAlign.CENTER, VAlign.CENTER);
			formeArt.x=64;
			formeArt.y=64;
			formeArt.color=formeColor;
			formeArt.loop = false;
			formeArt.addEventListener(Event.COMPLETE, stopJuggler);
			content.addChildAt(formeArt,0);
			starling.core.Starling.juggler.add(formeArt);
			function stopJuggler(event:Event):void
			{	
				addFinAnim(animType);
			}
		}
	//FIN-------------------------------------------------------------------------
		private function addFinAnim(animType:String):void
		{
			switch(animType){
				case "forme_create_": content.addEventListener(Event.TRIGGERED, onTouch);insert=true; break;
				case "forme_click_":  onClick = false; break;
				case "forme_remove_master_" : removed = true; break;
			}
		}
//TWEEN==================================================================================================================
	//MOVE OUT--------------------------------------------------------------------
		private function tweenMoveOut(sens:int):void
		{
			var moveX:int = 0;
			var moveY:int = 0;
			switch(sens) {
				case 1:moveX = 0; moveY = -16; break;
				case 2:moveX = 0; moveY = 16; break;
				case 3:moveX = -16; moveY = 0; break;
				case 4:moveX = 16; moveY = 0; break;
			}
			var tweenOut:Tween = new Tween(content, 0.15, Transitions.EASE_OUT);
			tweenOut.moveTo(moveX, moveY);
			var tweenIn:Tween = new Tween(content, 0.15, Transitions.EASE_IN);
			tweenIn.moveTo(0, 0);
			Starling.juggler.add(tweenOut);
			tweenOut.onComplete = function ():void {
				Starling.juggler.add(tweenIn);
				Starling.juggler.remove(tweenOut);
			}
			tweenIn.onComplete = function():void {
				Starling.juggler.remove(tweenIn);
			}
		}
	//REMOVE SLAVE---------------------------------------------
		public function tweenRemoveSlave(sensTemp:int):void
		{
			onRemove = true;
			var sensX:int = 0;
			var sensY:int = 0;
			switch(sensTemp) {
				case 1: sensY = 1; break;
				case 2: sensY = -1; break;
				case 3: sensX = 1; break;
				case 4: sensX = - 1; break;
			}
			var tweenRS:Tween = new Tween(content, 0.2, Transitions.EASE_IN);
			tweenRS.moveTo(128*sensX, 128*sensY);
			Starling.juggler.add(tweenRS);
			tweenRS.onComplete = function ():void
			{ 
				removed = true;
				Starling.juggler.remove(tweenRS);
			}
		}
	}
}