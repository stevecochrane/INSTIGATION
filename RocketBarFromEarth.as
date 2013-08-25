package {

    import org.flixel.*;

    public class RocketBarFromEarth extends FlxSprite {

        public function RocketBarFromEarth(X:int, Y:int) {

            super(X, Y);

            loadGraphic(Assets.imgRocketBarFromEarth, true, true, 6, 24);

            addAnimation("idle", [0]);
            addAnimation("launch", [1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16, 17, 18, 19, 20, 21, 22, 23, 24, 0], 30, false);

            play("idle");

        }

        override public function update():void {

            super.update();

        }

    }
}