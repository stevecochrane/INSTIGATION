package {

    import org.flixel.*;

    public class Invaders extends FlxSprite {

        public function Invaders(X:int, Y:int) {

            super(X, Y);

            loadGraphic(Assets.imgInvaders, false, false, 16, 32);

            addAnimation("idle", [0]);
            addAnimation("descend", [1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13], 5, false);
            addAnimation("serpentine", [13, 13, 13, 14, 15, 16, 16, 16, 15, 14], 5, true);

            play("idle");

        }

        override public function update():void {

            super.update();

        }

    }
}