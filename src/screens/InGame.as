package screens
{
	import flash.media.Sound;
	
	import objects.Forme;
	import objects.Score;
	
	import sounds.GameSounds;
	
	import starling.animation.Transitions;
	import starling.animation.Tween;
	import starling.core.Starling;
	import starling.display.DisplayObject;
	import starling.display.Sprite;
	import starling.errors.AbstractClassError;
	import starling.events.Event;
	
	public class InGame extends Sprite
	{
		private const tailleGrille:Array =[4,7];
		private const nbrForme:int = 6;
		
		private var contentGrid:Sprite;
		private var contentScore:Sprite;
		
		public var score:Score;
		
		private var grilleArray:Array;
		private var delArray:Array;
		
		private var removeTitre:Boolean;
		
		private var start:Boolean;
		
		private var gameOver:Boolean;
		private var gameOverTimer:int;
		
		private var aide:Boolean;
		private var aideTimer:int;
		
		private var gameSound:GameSounds;
		
		public function InGame()
		{
			super();
			this.addEventListener(Event.ADDED_TO_STAGE, onAddedToStage);
		}
		private function onAddedToStage(event:Event):void
		{
			this.removeEventListener(Event.ADDED_TO_STAGE, onAddedToStage);
			this.addEventListener(Event.ENTER_FRAME, run);
			initGame();
		}
//RUN===================================================================================================
		private function run(e:Event):void{
			testCase();
			testGameOver();
		}
//INIT==================================================================================================
		private function initGame():void
		{
			start = false;
			
			delArray= new Array();
			removeTitre=false;
			gameOver=false;
			gameOverTimer=0;
			
			aide=false;
			aideTimer=0;
			
			gameSound = new GameSounds();
			
			contentGrid=new Sprite();
			contentGrid.x=128;
			contentGrid.y=112;
			this.addChild(contentGrid);
			
			contentScore=new Sprite();
			this.addChild(contentScore);
			initGrid();
		}
	//INIT GRID--------------------------------------------------------------
		private function initGrid():void
		{
			grilleArray=new Array();
			for(var l:int=0;l < tailleGrille[1];l++){
				var arrTemp:Array = new Array();
				for(var c:int=0;c < tailleGrille[0];c++){
					
					arrTemp[c]=0;
				}
				grilleArray[l]=arrTemp;
			}
			createTittle();
		}
	//START GAME---------------------------------------------------------------
		private function startGame():void
		{
			createLigne();
			score = new Score();
			contentScore.addChild(score);
			start = true;		
		}
//CREATE==================================================================================================
	//CREATE TITTLE------------------------------------------------------------
		private function createTittle():void
		{
			var forme_C:Forme = new Forme(Assets.getColor(),"c");
			forme_C.x = 1 * 128 ;
			forme_C.y = 2 * 128 ;
			forme_C.name = "forme_2_1";
			
			var forme_O:Forme = new Forme(Assets.getColor(),"o");
			forme_O.x = 2 * 128 ;
			forme_O.y = 2 * 128 ;
			forme_O.name = "forme_2_2";
			
			var forme_M:Forme = new Forme(Assets.getColor(),"m");
			forme_M.x = 1 * 128 ;
			forme_M.y = 3 * 128 ;
			forme_M.name = "forme_3_1";
			
			var forme_E:Forme = new Forme(Assets.getColor(),"e");
			forme_E.x = 2 * 128 ;
			forme_E.y = 3 * 128 ;
			forme_E.name = "forme_3_2";
			
			contentGrid.addChild(forme_C);
			contentGrid.addChild(forme_O);
			contentGrid.addChild(forme_M);
			contentGrid.addChild(forme_E);
			
			Starling.juggler.delayCall(function():void{gameSound.play("titre");}, 0.8); 
		}
	//CREATE LIGNE---------------------------------------------------------------------
		private function createLigne():void
		{
			if (gameOver == false) {
				for (var c:int = 0; c < grilleArray[0].length; c++) { 
					if (grilleArray[0][c] == 0) {
						var formeTemp:Forme = new Forme(Assets.getColor());
						formeTemp.x = c * 128 ;
						formeTemp.name = "forme_0_" + c;
						
						contentGrid.addChild(formeTemp);
					}
				}
				Starling.juggler.delayCall(function():void{createLigne();}, 2); 
			}
		}
//TEST=====================================================================================================
	//TEST CASE-------------------------------------------------------------------------
		private function testCase():void
		{
			for (var nf:int = 0; nf < contentGrid.numChildren; nf++) {
				var formeTemp:Object = contentGrid.getChildAt(nf);
				if (formeTemp.insert == true) {
					grilleArray[formeTemp.y / 128][formeTemp.x / 128] = formeTemp.formeColor;
					formeTemp.depart = false;
					formeTemp.insert = false;
				}
				if (formeTemp.fall == false
					&& formeTemp.onRemove == false
					&& formeTemp.masterRemove == false
					&& formeTemp.depart == false
					&& gameOver == false) {
					if( formeTemp.titre == false){testCaseFall(formeTemp);}
					testCaseClick(formeTemp);
				}
				if (removeTitre == true){
					if( start == false && formeTemp.titre == true && contentGrid.numChildren <= 1){startGame();}
					formeTemp.removeLetter();
				}	
			}
			addAide();
			testCaseRemove();
		}
	//TEST FALL---------------------------------------------------------------------------
		private function testCaseFall(formeTemp:Object):void
		{
			var fLigne:int = formeTemp.y/128;
			var fColone:int = formeTemp.x / 128;
			var hauteurFall:int = 0; 
			while (fLigne+1 < grilleArray.length ) {
				fLigne++;
				if (grilleArray[fLigne][fColone] == 0) { hauteurFall++; } else { break;}
				
			}
			if (hauteurFall > 0) {
				formeTemp.fall = true;
				animateDown(formeTemp, hauteurFall);
			}
		}
	//TEST CLICK--------------------------------------------------------------------------------
		private function testCaseClick(formeTemp:Object):void
		{
			var scoreClick:int = 0;
			
			if (formeTemp.click == true) {
				contentGrid.setChildIndex(DisplayObject(formeTemp),contentGrid.numChildren);
				
				var delArrayTemp:Array = new Array();
				var arrayTest:Array = new Array();
				arrayTest = testCaseAround(formeTemp);
				if(arrayTest.length>0){
					for (var ft:int = 0; ft < arrayTest.length; ft++){
						var formeTested:Object = contentGrid.getChildByName("forme_" + arrayTest[ft][0] + "_" + arrayTest[ft][1]);
						var sensTested:int =  arrayTest[ft][3];
						if(arrayTest[ft][2] == true){
							formeTested.onRemove = true;
							formeTested.removeSlave(sensTested);
							delArrayTemp.push(formeTested);
							scoreClick++;
							removeAide();
						}
						else if (formeTested is Forme) { formeTested.moveOut(sensTested);}
					}
				}
				if(delArrayTemp.length>0){
					delArrayTemp.unshift(formeTemp);
					delArray.push(delArrayTemp);
					formeTemp.masterRemove = true;
					scoreClick++;
				}
				if(score is DisplayObject){score.ajouterScore(scoreClick);}
				formeTemp.click=false;
			}
		}
	//TEST REMOVE--------------------------------------------------------------------------------
		private function testCaseRemove():void
		{
			for (var ra:int = 0; ra < delArray.length; ra++) {
				var formeMaster:Object = Object(delArray[ra][0]);
				if (formeMaster.masterRemove == true) {
					for (var rf:int = 1; rf < delArray[ra].length; rf++) {
						var formeTemp:Object = delArray[ra][rf];
						if(formeTemp.removed == true){
							grilleArray[formeTemp.y / 128][formeTemp.x / 128] = 0;
							Sprite(formeTemp).removeFromParent(true);
							delArray[ra].splice(rf,1);
							gameSound.play("come");
						}
					}
					if(delArray[ra].length <= 1){
						if(formeMaster.onRemove == false){formeMaster.removeMaster();}
						if(formeMaster.removed == true ){
							grilleArray[formeMaster.y / 128][formeMaster.x / 128] = 0;
							Sprite(formeMaster).removeFromParent(true);
							delArray[ra] = [];
							removeTitre=true;
						}
					}
				}
			}
		}
	//TEST AIDE-----------------------------------------------------------------------------------
		private function addAide():void
		{
			if(aide == false){
				var maxTest:int = 0;
				var formeAide:Object;
				for (var nf:int = 0; nf < contentGrid.numChildren; nf++) {
					var formeTemp:Object = contentGrid.getChildAt(nf);
					var arrayTested:Array = testCaseAround(formeTemp);
					var nTest:int = 0;
					for (var f:int = 0; f < arrayTested.length; f++){
						if (arrayTested[f][2] == true){nTest++;}
					}
					if(nTest > 0){
						if(nTest > maxTest){ maxTest = nTest; formeAide = formeTemp;}
					}
				}
				if (formeAide is DisplayObject){
					if (aideTimer >= 300){
						formeAide.addTap();
						aide = true;
					}else{aideTimer++;}
				}
			}
			if(aide == true){
				aideTimer = 0;
			}
		}
		private function removeAide():void
		{
			for (var rf:int = 0; rf < contentGrid.numChildren; rf++) {
				var formeTempRemove:Object = contentGrid.getChildAt(rf);
				formeTempRemove.removeTap();
			}
			aideTimer = 0;
			aide = false;
		}
//TEST CASE AROUND==================================================================================================================
		private function testCaseAround(formeTemp:Object):Array
		{
			var L:int = formeTemp.y / 128;
			var C:int = formeTemp.x / 128; 
			var col:int = formeTemp.formeColor; 
			
			var testTab:Array=new Array();
			
			var formesArrayTemp:Array = new Array();
				
			for(var f:int=1; f<= 4;f++){
				switch(f){
					case 1: testTab=[L-1,C,col];break;
					case 2: testTab=[L+1,C,col];break;
					case 3: testTab=[L,C-1,col];break;
					case 4: testTab=[L,C+1,col];break;
				}
				if (testTab[0] >= 0 && testTab[0] <= grilleArray.length-1) {
					if (testTab[1] >= 0 && testTab[1] <= grilleArray[0].length-1) {
						var arrayTested:Array = new Array();
						if (grilleArray[testTab[0]][testTab[1]] == testTab[2] || grilleArray[testTab[0]][testTab[1]] == 0xffffff) {
							arrayTested = [testTab[0], testTab[1], true, f];
						}else{
							arrayTested = [testTab[0], testTab[1], false, f];
						}
						formesArrayTemp.push(arrayTested);
					}
				}
			}
			return formesArrayTemp;
		}
//GAME OVER======================================================================================================================
		private function testGameOver():void
		{
			var goTemp:Boolean = true;
			for (var l:int = 0; l < grilleArray.length; l++) {
				for (var c:int = 0; c < grilleArray[l].length; c++) {
					if (grilleArray[l][c] == 0) { goTemp = false;}
				}
			}
			if (goTemp == false) { gameOverTimer = 0; } else { gameOverTimer++; }
			if (goTemp == true && gameOverTimer >= 120) { startGO(); }
		}
		private function startGO():void
		{
			this.removeEventListener(Event.ENTER_FRAME, run);
			gameSound.play("gameOver");
			if(gameOver==false){	
				for (var nf:int = 0; nf < contentGrid.numChildren; nf++) {
					var formeTemp:Object = contentGrid.getChildAt(nf);
					formeTemp.fall = true;
					animateGameOver(formeTemp);
				}
			}
			gameOver = true;
		}
//ANIMATION==================================================================================================
	//ANIM DOWN----------------------------------------------------------------------------------
		private function animateDown(objectTemp:Object, nbrCaseTombe:int):void
		{	
			var formeTemp:Object = objectTemp;
			var lDepart:int = formeTemp.y / 128;
			var cDepart:int = formeTemp.x / 128;
			
			var hTombe:int = lDepart * 128 + nbrCaseTombe * 128;
			var vitesseFall:Number = 0.1 * nbrCaseTombe;
			var tweenFall:Tween = new Tween(formeTemp, vitesseFall, Transitions.EASE_OUT_BOUNCE);
			
			tweenFall.animate("y", hTombe);
			Starling.juggler.add(tweenFall);
			gameSound.play("fall");
			tweenFall.onComplete = function ():void
			{ 
				grilleArray[lDepart][cDepart] = 0;
				grilleArray[formeTemp.y / 128][formeTemp.x / 128] = formeTemp.formeColor;
				formeTemp.name = "forme_" + formeTemp.y / 128 + "_" + formeTemp.x / 128;
				formeTemp.fall = false;
			}
		}
	//ANIM GAME OVER------------------------------------------------------------------------------
		private function animateGameOver(objectTemp:Object):void
		{
			var formeTemp:Object = objectTemp;
			var tweenFall:Tween = new Tween(formeTemp, 0.2*(7-formeTemp.y/128), Transitions.EASE_IN);
			var rot:Number = Math.random();
			tweenFall.animate("y", 1000);
			Starling.juggler.add(tweenFall);
			tweenFall.onComplete = function ():void
			{ 
				Starling.juggler.removeTweens(formeTemp);
				Sprite(formeTemp).removeFromParent(true);
				if(contentGrid.numChildren<=0){
					if(score is DisplayObject){score.gameOver();}}
			}
		}
	}
}