package sounds
{
	import flash.media.Sound;
	import flash.media.SoundTransform;

	public class GameSounds
	{
		private var titre:Sound;
		private var fall:Sound;
		private var come:Sound;
		private var gameOver:Sound;
		
		private var transform:SoundTransform = new SoundTransform();
		
		public function GameSounds()
		{
			
		}
		public function play(name:String):void
		{
			titre = Assets.getSound("SoundComeVoice");
			fall = Assets.getSound("SoundFall");
			come = Assets.getSound("SoundCome");
			gameOver = Assets.getSound("GameOver");
			
			transform.volume = 0.2;
			
			
			switch(name){
				case "titre" : titre.play();break;
				case "fall" : fall.play(0,0,transform);break;
				case "come" : come.play(0,0,transform);break;
				case "gameOver" : gameOver.play();break;
			}
		}
	}
}