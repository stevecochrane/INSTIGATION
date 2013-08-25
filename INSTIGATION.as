package {

	import org.flixel.*;

	[SWF(width="512", height="480", backgroundColor="#000000")]
	[Frame(factoryClass="Preloader")]
	
	public class INSTIGATION extends FlxGame {

		public function INSTIGATION():void {

/* 			FlxG.debug = true; */
			super(256, 240, TitleState, 2, 30, 30);
/* 			super(256, 240, PlayState, 2, 30, 30); */

/*             FlxG.visualDebug = true; */

		}
	}
}