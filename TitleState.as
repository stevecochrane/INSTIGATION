package {

	import org.flixel.*;
	
	public class TitleState extends FlxState {

        public var backgroundSprite:FlxSprite;
        public var blockGroup:FlxGroup = new FlxGroup();
        public var blockSparkGroup:FlxGroup = new FlxGroup();
        public var curses:FlxSprite;
        public var cursesUttered:Boolean = false;
        public var logotype:FlxSprite;
        public var logoShown:Boolean = false;
        public var planetSurface:FlxSprite;
		public var player:Player;
        public var pressAnyKey:FlxSprite;
        public var pressAnyKeyShown:Boolean = false;
        public var rocketFromEarth:RocketFromEarth;
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

            logotype = new FlxSprite(0, 70);
            logotype.loadGraphic(Assets.imgLogotype, false, false, 256, 41);

            pressAnyKey = new FlxSprite(0, 119);
            pressAnyKey.loadGraphic(Assets.imgPressAnyKey, false, false, 256, 5);

            planetSurface = new FlxSprite(0, FlxG.height - 32);
			planetSurface.loadGraphic(Assets.imgPlanetSurfaceTitle, false, false, 256, 32);
            planetSurface.immovable = true;

            player = new Player(96 + 96, FlxG.height - 48, blockGroup);

            rocketFromEarth = new RocketFromEarth(23, 0);
            rocketFromEarth.addAnimationCallback(frameCheck);

            add(backgroundSprite);
            add(rocketFromEarth);
            add(planetSurface);
            add(player);
            add(blockGroup);
//            add(logotype);

            FlxG.watch(this, "testingTimer", "testingTimer");

            FlxG.play(Assets.audTitleBGM);

        }

		override public function update():void {

			super.update();

            testingTimer += FlxG.elapsed;

            if (testingTimer >= 4 && !rocketFired) {
                FlxG.log("launching a rocket");

                rocketFromEarth.play("launch");
                rocketFired = true;

//                (blockGroup.recycle(Block) as Block).spawn(getRandomColumn(), 0, getRandomBlockType());
//                (blockGroup.recycle(Block) as Block).spawn(getRandomColumn(), 0, getRandomBlockType());
                testingTimer = 0;

            } else if (testingTimer >= 7 && !cursesUttered) {

                add(curses);
                FlxG.play(Assets.audCurses);
                cursesUttered = true;

            } else if (testingTimer >= 9 && !logoShown) {

                add(logotype);
                logoShown = true;
                FlxG.play(Assets.audBlockSetDown);

            } else if (testingTimer >= 11 && !pressAnyKeyShown) {

                add(pressAnyKey);
                pressAnyKeyShown = true;
                FlxG.play(Assets.audBlockSetDown);

            }

            FlxG.collide(planetSurface, player);

//            FlxG.collide(blockGroup, blockGroup, blockHitBlock);
            FlxG.collide(planetSurface, blockGroup, blockHitPlanet);


            if (pressAnyKeyShown) {

                if ((FlxG.keys.justPressed("Z") && FlxG.keys.pressed("X")) || (FlxG.keys.pressed("Z") && FlxG.keys.justPressed("X"))) {
    			
    				FlxG.switchState(new PlayState());
    
    			}

            }

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

    }
}