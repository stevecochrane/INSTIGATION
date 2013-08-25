package {

    import org.flixel.*;

    public class BlockSpark extends FlxSprite {

        public var sparkTimer:Number = 0;

        public function BlockSpark() {

            super();

        }

        override public function update():void {

            super.update();

            sparkTimer += FlxG.elapsed;

            if (sparkTimer > 0.25) {
                kill();
            }

        }

        public function spawn(X:int, Y:int):void {

            super.reset(X, Y);

            loadGraphic(Assets.imgBlockSpark, false, false, 16, 16);

            sparkTimer = 0;

        }

    }
}