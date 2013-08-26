package {

	import org.flixel.*;
	
	public class PlayState extends FlxState {

        public var backgroundSprite:FlxSprite;
        public var blockGroup:FlxGroup = new FlxGroup();
        public var blockSparkGroup:FlxGroup = new FlxGroup();
        public var currentLevel:int = 1;
        public var currentLevelText:FlxText;
        public var currentLevelTimer:Number = 0;
        public var dottedLine:FlxSprite;
        public var fallingRowTimer:Number = 0;
        public var initialBlockAdded:Boolean = false;
        public var planetSurface:FlxSprite;
		public var player:Player;
        public var randomColNumber:int;
        public var rocketBarFromEarth:RocketBarFromEarth;
        public var rocketFromEarth:RocketFromEarth;
        public var rocketInterval:Number = 6;
        public var scoreText:FlxText;
        public var testing:Boolean = true;
        public var testingString:String;
        public var testingTimer:Number = 4;

        public var previousBlockType:int = 0;
        public var swapBlockType:int = 0;

        public var verticalMatchFound:Boolean = false;

        public var blockTypeToBeMovedDownOne:int = 0;
        public var blockTypeToBeMovedDownThree:int = 0;

		override public function create():void {

			//	The game takes place on a single screen with no scrolling
			FlxG.worldBounds.height = FlxG.height;
			FlxG.worldBounds.width = FlxG.width;

            backgroundSprite = new FlxSprite(0, 0);
			backgroundSprite.loadGraphic(Assets.imgBackground, false, false, 256, 240);

            dottedLine = new FlxSprite(0, 47);
			dottedLine.loadGraphic(Assets.imgDottedLine, false, false, 256, 1);

            planetSurface = new FlxSprite(0, FlxG.height - 32);
			planetSurface.loadGraphic(Assets.imgPlanetSurface, false, false, 256, 32);
            planetSurface.immovable = true;

            player = new Player(Globals.col6XPos, FlxG.height - 48, blockGroup);

            rocketFromEarth = new RocketFromEarth(23, 0);
            rocketFromEarth.addAnimationCallback(frameCheck);

            rocketBarFromEarth = new RocketBarFromEarth(23, 0);
            rocketBarFromEarth.addAnimationCallback(frameCheckBar);

            //  Initialize the block record
            for (var i:int = 0; i < Globals.playfieldRowNumber; i++) {

                Globals.blockRecord[i] = new Array();

                for (var j:int = 0; j < Globals.playfieldColNumber; j++) {
                    Globals.blockRecord[i][j] = 0;
                }
            }

            //  Initial block from title
            Globals.blockRecord[12][0] = 3;

			scoreText = new FlxText(FlxG.width - 80 - 5, FlxG.height - 16, 80, "00000000");
			scoreText.alignment = "right";
			scoreText.color = 0xFF000000;
			scoreText.size = 8;

			currentLevelText = new FlxText(5, FlxG.height - 16, 80, "Level " + currentLevel);
			currentLevelText.alignment = "left";
			currentLevelText.color = 0xFF000000;
			currentLevelText.size = 8;

            FlxG.score = 0;

            add(backgroundSprite);
            add(rocketFromEarth);
            add(rocketBarFromEarth);
            add(planetSurface);
            add(dottedLine);
            add(player);
//            add(blockSparkGroup);
            add(blockGroup);
            add(scoreText);
            add(currentLevelText);

            FlxG.watch(this, "testingTimer", "testingTimer");
            FlxG.watch(this, "fallingRowTimer", "fallingRowTimer");
            FlxG.watch(this, "currentLevelTimer", "currentLevelTimer");
            FlxG.watch(this, "rocketInterval", "rocketInterval");
            FlxG.watch(FlxG, "score", "score");

            FlxG.playMusic(Assets.audStageBGM);

        }

		override public function update():void {

			super.update();

            testingTimer += FlxG.elapsed;
            fallingRowTimer += FlxG.elapsed;
            currentLevelTimer += FlxG.elapsed;

            if (testingTimer >= rocketInterval && fallingRowTimer <= 9.5) {
//                FlxG.log("launching a rocket");

                rocketFromEarth.play("launch");

//                (blockGroup.recycle(Block) as Block).spawn(getRandomColumn(), 0, getRandomBlockType());
//                (blockGroup.recycle(Block) as Block).spawn(getRandomColumn(), 0, getRandomBlockType());
                testingTimer = 0;
            }

            if (fallingRowTimer >= 10) {
                FlxG.log("A row is falling!");
                fallingRowTimer = 0;
                testingTimer = 0;
                rocketBarFromEarth.play("launch");
            }

            if (currentLevelTimer >= 30) {
                FlxG.log("Level up!");
                currentLevelTimer = 0;
                currentLevel += 1;

                if (rocketInterval > 0.75) {
                    rocketInterval -= 0.75;
                }

                currentLevelText.text = "Level " + currentLevel;

                if (Globals.blockBaseMaxVeloY < 300) {
                    Globals.blockBaseMaxVeloY += 20;
                }
                blockGroup.callAll("increaseFallSpeed");
            }

            FlxG.collide(planetSurface, player);

            FlxG.collide(blockGroup, blockGroup, blockHitBlock);
            FlxG.collide(planetSurface, blockGroup, blockHitPlanet);

            FlxG.overlap(blockGroup, player, stunPlayer);

            if (!initialBlockAdded) {
                initialBlockAdded = true;
                (blockGroup.recycle(Block) as Block).spawn(Globals.col0XPos, Globals.row12YPos, 3, blockSparkGroup, true);
            }


/*
            //  DEBUG KEYS

            if (FlxG.keys.justPressed("G")) {

                FlxG.switchState(new GameOverState());

            }


            if (FlxG.keys.justPressed("M")) {
                FlxG.log(getRandomColumn());
            }

            if (FlxG.keys.justPressed("N")) {

                testingString = "";

                for (var k:int = 0; k < Globals.playfieldRowNumber; k++) {

                    for (var l:int = 0; l < Globals.playfieldColNumber; l++) {

                        testingString = testingString + Globals.blockRecord[k][l] + " ";

                    }

                    FlxG.log(testingString);
                    testingString = "";
                }

            }

            if (FlxG.keys.justPressed("B")) {
                FlxG.log("TESTING");
                //  Do this by looping through all blocks in blockGroup and checking their position
                for (var m:int = 0; m < blockGroup.members.length; m++) {
                    FlxG.log("k");
                }
            }

//            if (FlxG.keys.justPressed("V")) {
//                (blockSparkGroup.recycle(BlockSpark) as BlockSpark).spawn(16, 48);
//            }
            //  END DEBUG KEYS
*/

            if (!player.flickering) {
    
    
                if (FlxG.keys.justPressed("LEFT") && player.currentCol > 0) {
    
                    player.x -= player.width;
                    player.currentCol -= 1;
    
                    player.updateYPos();

                    FlxG.play(Assets.audMove);
    
                } else if (FlxG.keys.justPressed("RIGHT") && player.currentCol < Globals.playfieldColNumber - 1) {
    
                    player.x += player.width;
                    player.currentCol += 1;
    
                    player.updateYPos();

                    FlxG.play(Assets.audMove);
    
                } else if (FlxG.keys.justPressed("Z")) {
                    if (FlxG.keys.DOWN) {
                        FlxG.log("Cycle down!");
    
                        //  Sequence for cycling down:
                        //  1. Loop through rows in the blockRecord starting with the row that the player's on, plus 1
                        //  2. This only applies to the column that the player's in
                        //  3. Store the blockType of the current block
                        //  4. On the next row, store the blockType of the current block and then apply the previous blockType
                        //  5. When you reach the last row, apply the last row's block's blockType to the block that you started with
    
                        //  Only do anything if there are at least two blocks underneath the player
    
                        if (player.currentRow < Globals.playfieldRowNumber - 2) {
    
                            //  Store the bottommost block's blockType as the previousBlockType to apply immediately to topmost block
                            previousBlockType = Globals.blockRecord[Globals.playfieldRowNumber - 1][player.currentCol];
    //                        FlxG.log("Bottom blockType = " + previousBlockType);
    
                            for (var i:int = player.currentRow + 1; i < Globals.playfieldRowNumber; i++) {
                                FlxG.log("----------");
                                FlxG.log("i = " + i);
                                FlxG.log("----------");
    //                            FlxG.log("blockType = " + Globals.blockRecord[i][currentCol]);
    
    //                            Globals.blockRecord[i][currentCol] = previousBlockType;
    //                            previousBlockType = Globals.blockRecord[i][currentCol];
    
                                swapBlockType = Globals.blockRecord[i][player.currentCol];
                                Globals.blockRecord[i][player.currentCol] = previousBlockType;
                                previousBlockType = swapBlockType;
    
                                //  Also find the current block and tell it to change type
    //                            block.changeBlockType(Globals.blockRecord[i][currentCol]);
    
    
                                blockGroup.setAll("xPosToCheck", player.getColXPos(player.currentCol));
                                blockGroup.setAll("yPosToCheck", player.getRowYPos(i));
                                blockGroup.setAll("blockTypeToChangeTo", Globals.blockRecord[i][player.currentCol]);
                                blockGroup.callAll("checkIfChange");
    
    
    /*
                                //  Do this by looping through all blocks in blockGroup and checking their position
                                for (var k:int = 0; k < blockGroup.members.length; k++) {
    
                                    if (blockGroup.members[k].alive && blockGroup.members[k].isSetDown) {
    //                                if (blockGroup.members[k].alive) {
    
        //                                FlxG.log(blockGroup.members[k].x);
        //                                FlxG.log(blockGroup.members[k].alive);
        
                                        FlxG.log("block.x = " + FlxU.floor(blockGroup.members[k].x) + ", block.y = " + FlxU.floor(blockGroup.members[k].y));
        //                                FlxG.log("rowYPos: " + getRowYPos(i) + ", colXPos: " + getColXPos(currentCol));
                                        FlxG.log("check.x = " + getColXPos(currentCol) + ", check.y = " + getRowYPos(i));
        
                                        if (FlxU.floor(blockGroup.members[k].x) == getColXPos(currentCol) && FlxU.floor(blockGroup.members[k].y) == getRowYPos(i)) {
                                            blockGroup.members[k].changeBlockType(Globals.blockRecord[i][currentCol]);
    
                                            FlxG.log("changing block at " + FlxU.floor(blockGroup.members[k].x) + ", " + FlxU.floor(blockGroup.members[k].y) + " to " + Globals.blockRecord[i][currentCol]);
                                        }
       
                                    }
                                }
    */
                            }
                        }
    
                        FlxG.play(Assets.audCycleDown);
    
    
                    } else {
                        FlxG.log("Cycle up!");
    
                        //  Same as above but reversed?
    
                        if (player.currentRow < Globals.playfieldRowNumber - 2) {
    
                            //  Store the topmost block's blockType as the previousBlockType to apply immediately to bottommost block
                            previousBlockType = Globals.blockRecord[player.currentRow + 1][player.currentCol];
    //                        FlxG.log("Top blockType = " + previousBlockType);
    
                            for (var j:int = Globals.playfieldRowNumber - 1; j > player.currentRow; j--) {
    //                            FlxG.log("row = " + j);
    //                            FlxG.log("blockType = " + Globals.blockRecord[i][currentCol]);
    
    //                            Globals.blockRecord[i][currentCol] = previousBlockType;
    //                            previousBlockType = Globals.blockRecord[i][currentCol];
    
                                swapBlockType = Globals.blockRecord[j][player.currentCol];
                                Globals.blockRecord[j][player.currentCol] = previousBlockType;
                                previousBlockType = swapBlockType;
    
                                blockGroup.setAll("xPosToCheck", player.getColXPos(player.currentCol));
                                blockGroup.setAll("yPosToCheck", player.getRowYPos(j));
                                blockGroup.setAll("blockTypeToChangeTo", Globals.blockRecord[j][player.currentCol]);
                                blockGroup.callAll("checkIfChange");
    
                            }
                        }
    
                        FlxG.play(Assets.audCycleUp);
    
                    }
    
                    checkForMatches();


                } else if (FlxG.keys.justPressed("X")) {

                        if (!player.holdingABlock && player.currentRow < Globals.playfieldRowNumber - 1) {
    
                            player.holdingABlock = true;
//                            FlxG.log("Lifting the block!");

                            //  Find the block that the player is standing on, then assign its type to the player
//                            FlxG.log("Globals.blockRecord[player.currentRow + 1][player.currentCol] = " + Globals.blockRecord[player.currentRow + 1][player.currentCol]);

                            if (Globals.blockRecord[player.currentRow + 1][player.currentCol] == 1) {
                                player.holdingBlockType = 1;
                            } else if (Globals.blockRecord[player.currentRow + 1][player.currentCol] == 2) {
                                player.holdingBlockType = 2;
                            } else if (Globals.blockRecord[player.currentRow + 1][player.currentCol] == 3) {
                                player.holdingBlockType = 3;
                            } else {
                                player.holdingBlockType = 4;
                            }

//                            FlxG.log("player.holdingBlockType = " + player.holdingBlockType);

                            //  Then remove the block underneath from the blockRecord
                            Globals.blockRecord[player.currentRow + 1][player.currentCol] = 0;

//                            FlxG.log("About to kill block at " + Globals.getColXPos(player.currentRow + 1) + ", " + Globals.getRowYPos(player.currentCol));

                            //  Then remove the block object
                            blockGroup.setAll("xPosIfDead", Globals.getColXPos(player.currentCol));
                            blockGroup.setAll("yPosIfDead", Globals.getRowYPos(player.currentRow + 1));
                            blockGroup.callAll("checkIfDead");

                            //  Then adjust the player's position immediately
                            player.y += 16;
                            player.currentRow += 1;

                            FlxG.play(Assets.audBlockLift);
    
                        } else if (player.holdingABlock) {

//                            FlxG.log("Putting down the block!");

                            player.play("idle");
                            player.holdingABlock = false;
                            player.y -= 16;

                            //  Add a new block of the type that the player is holding, where the player is standing, to the blockRecord
                            Globals.blockRecord[player.currentRow][player.currentCol] = player.holdingBlockType;

                            //  Now add a new block object
                            (blockGroup.recycle(Block) as Block).spawn(Globals.getColXPos(player.currentCol), Globals.getRowYPos(player.currentRow), player.holdingBlockType, blockSparkGroup, false);
    

                            player.holdingBlockType = 0;

                            //  Move the player up

                            player.currentRow -= 1;

    
                        }


                }

            }
            

        }

        public function getRandomColumn():int {

            //  Start with a random integer between 0 and 6 (same as the number of columns)
            randomColNumber = FlxU.floor(FlxG.random() * 7);

            //  Then pull the right column X position for that random number.
            if (randomColNumber == 0) {
                return Globals.col0XPos;
            } else if (randomColNumber == 1) {
                return Globals.col1XPos;
            } else if (randomColNumber == 2) {
                return Globals.col2XPos;
            } else if (randomColNumber == 3) {
                return Globals.col3XPos;
            } else if (randomColNumber == 4) {
                return Globals.col4XPos;
            } else if (randomColNumber == 5) {
                return Globals.col5XPos;
            } else {
                return Globals.col6XPos;
            }

        }

        public function getRandomBlockType():int {

            //  Returns a random integer between 1 and 3.
            return FlxU.floor(FlxG.random() * 4) + 1;

        }

        public function blockHitPlanet(planetSurface:FlxSprite, block:Block):void {

//            if (!block.isSetDown) {
//                FlxG.log("setting down a block");
                block.setDown();
                checkForMatches();
//            }

            
        }

        public function blockHitBlock(blockOne:Block, blockTwo:Block):void {

//            if (!block.isSetDown) {
                FlxG.log("setting down a block");
                blockOne.setDown();
                blockTwo.setDown();
                checkForMatches();
//            }

            
        }

        public function stunPlayer(block:FlxSprite, player:Player):void {

//            FlxG.log("block hit player!");

            if (!player.flickering && block.y < player.y + 4) {

                player.flicker(1);
                player.y -= 16;
                player.currentRow -= 1;
                FlxG.play(Assets.audCurses);

            }

//            if (!block.isSetDown) {
//                FlxG.log("setting down a block");
//                block.setDown();
//                checkForMatches();
//            }

            
        }



        public function frameCheck(animationName:String, frameNumber:uint, frameIndex:uint):void {
            if (animationName == "launch" && frameIndex == 0) {
                rocketFromEarth.play("idle");
                (blockGroup.recycle(Block) as Block).spawn(getRandomColumn(), -48, getRandomBlockType(), blockSparkGroup, false);
//                FlxG.log("Move on screen!");
            }
        }

        public function frameCheckBar(animationName:String, frameNumber:uint, frameIndex:uint):void {
            if (animationName == "launch" && frameIndex == 0) {
                rocketBarFromEarth.play("idle");

                //  whoa it's a whole bar of blocks
//                (blockGroup.recycle(Block) as Block).spawn(Globals.col0XPos, -48, getRandomBlockType(), blockSparkGroup, false);
                (blockGroup.recycle(Block) as Block).spawn(Globals.col1XPos, -48, getRandomBlockType(), blockSparkGroup, false);
                (blockGroup.recycle(Block) as Block).spawn(Globals.col2XPos, -48, getRandomBlockType(), blockSparkGroup, false);
                (blockGroup.recycle(Block) as Block).spawn(Globals.col3XPos, -48, getRandomBlockType(), blockSparkGroup, false);
                (blockGroup.recycle(Block) as Block).spawn(Globals.col4XPos, -48, getRandomBlockType(), blockSparkGroup, false);
                (blockGroup.recycle(Block) as Block).spawn(Globals.col5XPos, -48, getRandomBlockType(), blockSparkGroup, false);
//                (blockGroup.recycle(Block) as Block).spawn(Globals.col6XPos, -48, getRandomBlockType(), blockSparkGroup, false);

//                FlxG.log("Move on screen!");
            }
        }


        public function checkForMatches():void {

//            FlxG.log("checking for matches...");

            //  Horizontal matches:
            //  1. Loop through each row in the blockRecord
            //  2. Loop through each block in the row starting with the third block
            //  3. Compare blockType to the previous two blocks
            //  4. If they're the same, kill all three blocks
            //  (add logic for matches of 4 or more later)

            for (var i:int = 0; i < Globals.playfieldRowNumber; i++) {

                for (var j:int = 2; j < Globals.playfieldColNumber; j++) {

                    if (Globals.blockRecord[i][j] > 0 && Globals.blockRecord[i][j - 1] > 0 && Globals.blockRecord[i][j - 2] > 0) {

//                        FlxG.log("Found three blocks in a row");

                        if (Globals.blockRecord[i][j] == Globals.blockRecord[i][j - 1] && Globals.blockRecord[i][j] == Globals.blockRecord[i][j - 2]) {
//                            FlxG.log("Found a horizontal match!");

                            Globals.blockRecord[i][j] = 0;
                            Globals.blockRecord[i][j - 1] = 0;
                            Globals.blockRecord[i][j - 2] = 0;

                            //  Have all blocks check to see if they are dead now
                            blockGroup.setAll("xPosIfDead", Globals.getColXPos(j));
                            blockGroup.setAll("yPosIfDead", Globals.getRowYPos(i));
                            blockGroup.callAll("checkIfDead");

                            blockGroup.setAll("xPosIfDead", Globals.getColXPos(j - 1));
                            blockGroup.setAll("yPosIfDead", Globals.getRowYPos(i));
                            blockGroup.callAll("checkIfDead");

                            blockGroup.setAll("xPosIfDead", Globals.getColXPos(j - 2));
                            blockGroup.setAll("yPosIfDead", Globals.getRowYPos(i));
                            blockGroup.callAll("checkIfDead");

                            //  And now, go through any blocks above these blocks and move them down by 1.
                            //  First, the current block. Loop upwards through the current column from the current block.
                            for (var w:int = i - 1; w > -1; w--) {

                                //  Check if we've got a block here
                                if (Globals.blockRecord[w][j]) {

                                    //  First, store this block type.
                                    blockTypeToBeMovedDownOne = Globals.blockRecord[w][j];
                                    //  Second, zero out this spot in the record.
        //                            blockGroup.setAll("xPosIfDead", Globals.getColXPos(k));
        //                            blockGroup.setAll("yPosIfDead", Globals.getRowYPos(l));
        //                            blockGroup.callAll("checkIfDead");
                                    Globals.blockRecord[w][j] = 0;
                                    //  Third, move this block down one block in the record.
                                    Globals.blockRecord[w + 1][j] = blockTypeToBeMovedDownOne;
                                    //  Fourth, move this block's object down one block too.
                                    blockGroup.setAll("xPosIfMovedDownOne", Globals.getColXPos(j));
                                    blockGroup.setAll("yPosIfMovedDownOne", Globals.getRowYPos(w));
                                    blockGroup.callAll("checkIfMovedDownOne");


                                }

                            }

                            //  Now do the same thing but for the block one to the left of the current block.
                            for (var e:int = i - 1; e > -1; e--) {

                                //  Check if we've got a block here
                                if (Globals.blockRecord[e][j - 1]) {

                                    //  First, store this block type.
                                    blockTypeToBeMovedDownOne = Globals.blockRecord[e][j - 1];
                                    //  Second, zero out this spot in the record.
        //                            blockGroup.setAll("xPosIfDead", Globals.getColXPos(k));
        //                            blockGroup.setAll("yPosIfDead", Globals.getRowYPos(l));
        //                            blockGroup.callAll("checkIfDead");
                                    Globals.blockRecord[e][j - 1] = 0;
                                    //  Third, move this block down one block in the record.
                                    Globals.blockRecord[e + 1][j - 1] = blockTypeToBeMovedDownOne;
                                    //  Fourth, move this block's object down one block too.
                                    blockGroup.setAll("xPosIfMovedDownOne", Globals.getColXPos(j - 1));
                                    blockGroup.setAll("yPosIfMovedDownOne", Globals.getRowYPos(e));
                                    blockGroup.callAll("checkIfMovedDownOne");


                                }

                            }

                            //  Aaaaaand one more, two blocks over.
                            for (var r:int = i - 1; r > -1; r--) {

                                //  Check if we've got a block here
                                if (Globals.blockRecord[r][j - 2]) {

                                    //  First, store this block type.
                                    blockTypeToBeMovedDownOne = Globals.blockRecord[r][j - 2];
                                    //  Second, zero out this spot in the record.
        //                            blockGroup.setAll("xPosIfDead", Globals.getColXPos(k));
        //                            blockGroup.setAll("yPosIfDead", Globals.getRowYPos(l));
        //                            blockGroup.callAll("checkIfDead");
                                    Globals.blockRecord[r][j - 2] = 0;
                                    //  Third, move this block down one block in the record.
                                    Globals.blockRecord[r + 1][j - 2] = blockTypeToBeMovedDownOne;
                                    //  Fourth, move this block's object down one block too.
                                    blockGroup.setAll("xPosIfMovedDownOne", Globals.getColXPos(j - 2));
                                    blockGroup.setAll("yPosIfMovedDownOne", Globals.getRowYPos(r));
                                    blockGroup.callAll("checkIfMovedDownOne");


                                }

                            }

                            addToScore(100 * currentLevel);
                            player.updateYPos();
                            FlxG.play(Assets.audBlockClear);

                        }

                    }

                }

            }


            //  Vertical matches:
            //  1. Loop through each column in the blockRecord
            //  2. Loop through each block in the column, in reverse (bottom to top), starting with the third block
            //  3. Compare blockType to the previous two blocks
            //  4. If they're the same, kill all three blocks
            //  (add logic for matches of 4 or more later)

            for (var k:int = 0; k < Globals.playfieldColNumber; k++) {

                verticalMatchFound = false;

                for (var l:int = Globals.playfieldRowNumber - 3; l > -1; l--) {

                    //  If a block is found at least two rows from the bottom, we can assume there are blocks underneath it
                    if (Globals.blockRecord[l][k] > 0) {

                        if (!verticalMatchFound) {

    //                        FlxG.log("l = " + l + ", k = " + k);
    //                        FlxG.log("Comparing " + Globals.blockRecord[l][k] + " to " + Globals.blockRecord[l + 1][k] + " and " + Globals.blockRecord[l + 2][k]);
    
                            //  Check for a match
                            if (Globals.blockRecord[l][k] == Globals.blockRecord[l + 1][k] && Globals.blockRecord[l][k] == Globals.blockRecord[l + 2][k]) {
    //                            FlxG.log("Found a VERTICAL match!");
    
                                Globals.blockRecord[l][k] = 0;
                                Globals.blockRecord[l + 1][k] = 0;
                                Globals.blockRecord[l + 2][k] = 0;
    
                                //  Have all blocks check to see if they are dead now
                                blockGroup.setAll("xPosIfDead", Globals.getColXPos(k));
                                blockGroup.setAll("yPosIfDead", Globals.getRowYPos(l));
                                blockGroup.callAll("checkIfDead");
    
                                blockGroup.setAll("xPosIfDead", Globals.getColXPos(k));
                                blockGroup.setAll("yPosIfDead", Globals.getRowYPos(l + 1));
                                blockGroup.callAll("checkIfDead");
    
                                blockGroup.setAll("xPosIfDead", Globals.getColXPos(k));
                                blockGroup.setAll("yPosIfDead", Globals.getRowYPos(l + 2));
                                blockGroup.callAll("checkIfDead");

                                FlxG.log("VERTICAL MATCH FOUND! 1");
                                verticalMatchFound = true;
    
                            }

                        } else {

                            FlxG.log("VERTICAL MATCH FOUND! 2");
                            //  If a vertical match has been found in this column, any additional blocks above the match
                            //  are moved down 3 blocks.

                            //  First, store this block type.
                            blockTypeToBeMovedDownThree = Globals.blockRecord[l][k];
                            //  Second, zero out this spot in the record.
//                            blockGroup.setAll("xPosIfDead", Globals.getColXPos(k));
//                            blockGroup.setAll("yPosIfDead", Globals.getRowYPos(l));
//                            blockGroup.callAll("checkIfDead");
                            Globals.blockRecord[l][k] = 0;
                            //  Third, move this block down three blocks in the record.
                            Globals.blockRecord[l + 3][k] = blockTypeToBeMovedDownThree;
                            //  Fourth, move this block's object down three blocks too.
                            blockGroup.setAll("xPosIfMovedDownThree", Globals.getColXPos(k));
                            blockGroup.setAll("yPosIfMovedDownThree", Globals.getRowYPos(l));
                            blockGroup.callAll("checkIfMovedDownThree");

                        }

                    }

                }

                if (verticalMatchFound) {
                    addToScore(100 * currentLevel);
                    player.updateYPos();
                    FlxG.play(Assets.audBlockClear);

                }

            }

        }

        public function addToScore(numberToAdd:int):void {

            FlxG.score += numberToAdd;
            scoreText.text = addZeros({ inputNumber:FlxG.score, stringLength:8 }).output;

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