package {

	import org.flixel.*;
	
	public class GameOverState extends FlxState {

        public var backgroundSprite:FlxSprite;
        public var blockGroup:FlxGroup = new FlxGroup();
        public var blockSparkGroup:FlxGroup = new FlxGroup();
        public var curses:FlxSprite;
        public var cursesUttered:Boolean = false;
        public var descended:Boolean = false;
        public var gameOver:FlxSprite;
        public var invaders:Invaders;
        public var logotype:FlxSprite;
        public var logoShown:Boolean = false;
        public var planetSurface:FlxSprite;
		public var player:Player;
		public var player2:Player;
		public var player3:Player;
		public var player4:Player;
		public var player5:Player;
        public var pressAnyKey:FlxSprite;
        public var pressAnyKeyShown:Boolean = false;
        public var rocketFromEarth:RocketFromEarth;
        public var scoreText:FlxText;
        public var testingTimer:Number = 0;
        public var rocketFired:Boolean = false;

		override public function create():void {

			//	The game takes place on a single screen with no scrolling
			FlxG.worldBounds.height = FlxG.height;
			FlxG.worldBounds.width = FlxG.width;

            backgroundSprite = new FlxSprite(0, 0);
			backgroundSprite.loadGraphic(Assets.imgBackground, false, false, 256, 240);

            curses = new FlxSprite(162, 158);
			curses.loadGraphic(Assets.imgCurses, false, false, 55, 32);

            logotype = new FlxSprite(0, 74);
            logotype.loadGraphic(Assets.imgLogotype, false, false, 256, 41);

/*
            logotype = new FlxSprite(0, 74);
            logotype.loadGraphic(Assets.imgLogotype, false, false, 256, 41);
*/

            gameOver = new FlxSprite(0, 83);
            gameOver.loadGraphic(Assets.imgGameOver, false, false, 256, 18);

            invaders = new Invaders(16, 0);
//            invaders.loadGraphic(Assets.imgInvaders, false, false, 16, 32);
            invaders.addAnimationCallback(frameCheckTwo);

            planetSurface = new FlxSprite(0, FlxG.height - 32);
			planetSurface.loadGraphic(Assets.imgPlanetSurface, false, false, 256, 32);
            planetSurface.immovable = true;

            player  = new Player(FlxG.width + 16, FlxG.height - 48, blockGroup);
            player2 = new Player(FlxG.width + 48, FlxG.height - 72, blockGroup);
            player3 = new Player(FlxG.width + 32, FlxG.height - 96, blockGroup);
            player4 = new Player(FlxG.width + 24, FlxG.height - 120, blockGroup);
            player5 = new Player(FlxG.width + 36, FlxG.height - 60, blockGroup);

            player.velocity.x = player2.velocity.x = player3.velocity.x = player4.velocity.x = player.velocity.x = -150;

            rocketFromEarth = new RocketFromEarth(23, 0);
            rocketFromEarth.addAnimationCallback(frameCheck);

			scoreText = new FlxText(FlxG.width - 80 - 5, FlxG.height - 16, 80, addZeros({ inputNumber:FlxG.score, stringLength:8 }).output);
			scoreText.alignment = "right";
			scoreText.color = 0xFF000000;
			scoreText.size = 8;


            add(backgroundSprite);
            add(rocketFromEarth);
            add(planetSurface);

            add(invaders);

//            add(blockGroup);
            add(gameOver);

            add(player);
            add(player2);
            add(player3);
            add(player4);
            add(player5);

            add(scoreText);

            FlxG.watch(this, "testingTimer", "testingTimer");
            FlxG.watch(FlxG, "score", "score");

//            FlxG.play(Assets.audTitleBGM);

            FlxG.music.stop();

        }

		override public function update():void {

			super.update();

            testingTimer += FlxG.elapsed;

//            if (testingTimer >= 4 && !rocketFired) {
/*
                FlxG.log("launching a rocket");

                rocketFromEarth.play("launch");
                rocketFired = true;

//                (blockGroup.recycle(Block) as Block).spawn(getRandomColumn(), 0, getRandomBlockType());
//                (blockGroup.recycle(Block) as Block).spawn(getRandomColumn(), 0, getRandomBlockType());
                testingTimer = 0;
*/

            if (testingTimer >= 3 && !descended) {

                FlxG.log("show attack now");
                descended = true;
                invaders.play("descend");
/*
                add(curses);
                FlxG.play(Assets.audCurses);
                cursesUttered = true;
*/

            } else if (testingTimer >= 9 && !logoShown) {

/*
                add(logotype);
                logoShown = true;
                FlxG.play(Assets.audBlockSetDown);
*/

            } else if (testingTimer >= 11 && !pressAnyKeyShown) {

/*
                add(pressAnyKey);
                pressAnyKeyShown = true;
                FlxG.play(Assets.audBlockSetDown);
*/

            }

            FlxG.collide(planetSurface, player);

//            FlxG.collide(blockGroup, blockGroup, blockHitBlock);
            FlxG.collide(planetSurface, blockGroup, blockHitPlanet);


//            if (pressAnyKeyShown) {

                if ((FlxG.keys.justPressed("Z") && FlxG.keys.pressed("X")) || (FlxG.keys.pressed("Z") && FlxG.keys.justPressed("X"))) {
    			
    				FlxG.switchState(new PlayState());
    
    			}

//            }

        }

        public function blockHitPlanet(planetSurface:FlxSprite, block:Block):void {

                FlxG.play(Assets.audBlockSetDown);

//            if (!block.isSetDown) {
                FlxG.log("setting down a block");
                block.setDown();
//                checkForMatches();
//            }


            
        }


        public function frameCheck(animationName:String, frameNumber:uint, frameIndex:uint):void {
            if (animationName == "launch" && frameIndex == 0) {
                rocketFromEarth.play("idle");
                (blockGroup.recycle(Block) as Block).spawn(Globals.col0XPos, -48, 0, blockSparkGroup, false);
//                FlxG.log("Move on screen!");
            }
        }

        public function frameCheckTwo(animationName:String, frameNumber:uint, frameIndex:uint):void {
            if (animationName == "descend" && frameIndex == 13) {
                invaders.play("serpentine");
//                (blockGroup.recycle(Block) as Block).spawn(Globals.col0XPos, -48, 0, blockSparkGroup);
//                FlxG.log("Move on screen!");
            }
        }

        //  http://flashcodetips.blogspot.com/2011/03/add-leading-zeros-to-number-string.html
        /*
        --DESCRIPTION--
            Adds zeros to number
        --PARAMETERS--
            inputNumber:Number    = Number to add zeros to
            stringLength:Number    = Length of output string
        ---RETURNS---
            output:String    = Output string with added zeros
        ---EXAMPLE---
            trace(addZeros({inputNumber:1234, stringLength:6}).output;
            --001234
        */
        private function addZeros(obj:Object):Object {
            var ret:String = String(obj.inputNumber);
            while (ret.length < obj.stringLength) {
                ret = "0" + ret;
            }
            return { output:ret };
        }

    }
}