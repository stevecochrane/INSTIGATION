package {

    import org.flixel.*;

    public class Player extends FlxSprite {

        public var blockGroup:FlxGroup;
        public var currentCol:int = 6;
        public var currentRow:int = 12;
        public var holdingABlock:Boolean = false;
        public var holdingBlockType:int = 0;
        public var previousBlockType:int = 0;
        public var swapBlockType:int = 0;

        public function Player(X:int, Y:int, theBlockGroup:FlxGroup) {

            super(X, Y);

            blockGroup = theBlockGroup;

            loadGraphic(Assets.imgPlayer, true, true, 16, 32);

            width = 16;
            height = 16;

            offset.y = 16;

            FlxG.watch(this, "currentCol", "playerCol");
            FlxG.watch(this, "currentRow", "playerRow");
            FlxG.watch(this, "holdingBlockType", "holdingBlockType");

            addAnimation("idle", [0]);
            addAnimation("holding_block_1", [1]);
            addAnimation("holding_block_2", [2]);
            addAnimation("holding_block_3", [3]);
            addAnimation("holding_block_4", [4]);

            play("idle");

        }

        override public function update():void {

            super.update();

/*
            if (FlxG.keys.justPressed("LEFT") && currentCol > 0) {

                x -= width;
                currentCol -= 1;

                updateYPos();

            } else if (FlxG.keys.justPressed("RIGHT") && currentCol < Globals.playfieldColNumber - 1) {

                x += width;
                currentCol += 1;

                updateYPos();

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

                    if (currentRow < Globals.playfieldRowNumber - 2) {

                        //  Store the bottommost block's blockType as the previousBlockType to apply immediately to topmost block
                        previousBlockType = Globals.blockRecord[Globals.playfieldRowNumber - 1][currentCol];
//                        FlxG.log("Bottom blockType = " + previousBlockType);

                        for (var i:int = currentRow + 1; i < Globals.playfieldRowNumber; i++) {
                            FlxG.log("----------");
                            FlxG.log("i = " + i);
                            FlxG.log("----------");
//                            FlxG.log("blockType = " + Globals.blockRecord[i][currentCol]);

//                            Globals.blockRecord[i][currentCol] = previousBlockType;
//                            previousBlockType = Globals.blockRecord[i][currentCol];

                            swapBlockType = Globals.blockRecord[i][currentCol];
                            Globals.blockRecord[i][currentCol] = previousBlockType;
                            previousBlockType = swapBlockType;

                            //  Also find the current block and tell it to change type
//                            block.changeBlockType(Globals.blockRecord[i][currentCol]);


                            blockGroup.setAll("xPosToCheck", getColXPos(currentCol));
                            blockGroup.setAll("yPosToCheck", getRowYPos(i));
                            blockGroup.setAll("blockTypeToChangeTo", Globals.blockRecord[i][currentCol]);
                            blockGroup.callAll("checkIfChange");


//                            //  Do this by looping through all blocks in blockGroup and checking their position
//                            for (var k:int = 0; k < blockGroup.members.length; k++) {

//                                if (blockGroup.members[k].alive && blockGroup.members[k].isSetDown) {
//                                if (blockGroup.members[k].alive) {

    //                                FlxG.log(blockGroup.members[k].x);
    //                                FlxG.log(blockGroup.members[k].alive);
    
//                                    FlxG.log("block.x = " + FlxU.floor(blockGroup.members[k].x) + ", block.y = " + FlxU.floor(blockGroup.members[k].y));
    //                                FlxG.log("rowYPos: " + getRowYPos(i) + ", colXPos: " + getColXPos(currentCol));
//                                    FlxG.log("check.x = " + getColXPos(currentCol) + ", check.y = " + getRowYPos(i));
    
//                                    if (FlxU.floor(blockGroup.members[k].x) == getColXPos(currentCol) && FlxU.floor(blockGroup.members[k].y) == getRowYPos(i)) {
//                                        blockGroup.members[k].changeBlockType(Globals.blockRecord[i][currentCol]);

//                                        FlxG.log("changing block at " + FlxU.floor(blockGroup.members[k].x) + ", " + FlxU.floor(blockGroup.members[k].y) + " to " + Globals.blockRecord[i][currentCol]);
//                                    }
   
//                                }
//                            }
//                        }
//                    }

                    FlxG.play(Assets.audCycleDown);


                } else {
                    FlxG.log("Cycle up!");

                    //  Same as above but reversed?

                    if (currentRow < Globals.playfieldRowNumber - 2) {

                        //  Store the topmost block's blockType as the previousBlockType to apply immediately to bottommost block
                        previousBlockType = Globals.blockRecord[currentRow + 1][currentCol];
//                        FlxG.log("Top blockType = " + previousBlockType);

                        for (var j:int = Globals.playfieldRowNumber - 1; j > currentRow; j--) {
//                            FlxG.log("row = " + j);
//                            FlxG.log("blockType = " + Globals.blockRecord[i][currentCol]);

//                            Globals.blockRecord[i][currentCol] = previousBlockType;
//                            previousBlockType = Globals.blockRecord[i][currentCol];

                            swapBlockType = Globals.blockRecord[j][currentCol];
                            Globals.blockRecord[j][currentCol] = previousBlockType;
                            previousBlockType = swapBlockType;

                            blockGroup.setAll("xPosToCheck", getColXPos(currentCol));
                            blockGroup.setAll("yPosToCheck", getRowYPos(j));
                            blockGroup.setAll("blockTypeToChangeTo", Globals.blockRecord[j][currentCol]);
                            blockGroup.callAll("checkIfChange");

                        }
                    }

                    FlxG.play(Assets.audCycleUp);

                }
            }
*/

            if (holdingABlock) {
                if (holdingBlockType == 1) {
                    play("holding_block_1");
                } else if (holdingBlockType == 2) {
                    play("holding_block_2");
                } else if (holdingBlockType == 3) {
                    play("holding_block_3");
                } else {
                    play("holding_block_4");
                }
            } else {
                play("idle");
            }

        }

        public function updateYPos():void {

            //  Changing the row is harder. We'll need to loop through the rows in the blockRecord starting from the bottom,
            //  then check each row in the current column to see if there's a block there. If so, keep going, if not, stop.

/*
            if (currentCol == -1 || currentCol == Globals.playfieldColNumber) {

                currentRow = Globals.playfieldRowNumber - 1;

            } else {
*/

                for (var i:int = Globals.playfieldRowNumber - 1; i > 0; i--) {
    
                    currentRow = i;
    
                    if (Globals.blockRecord[i][currentCol] == 0) {
                        break;
                    }
    
                }
/*

            }
*/

            if (currentRow == 12) {
                y = Globals.row12YPos;
            } else if (currentRow == 11) {
                y = Globals.row11YPos;
            } else if (currentRow == 10) {
                y = Globals.row10YPos;
            } else if (currentRow == 9) {
                y = Globals.row9YPos;
            } else if (currentRow == 8) {
                y = Globals.row8YPos;
            } else if (currentRow == 7) {
                y = Globals.row7YPos;
            } else if (currentRow == 6) {
                y = Globals.row6YPos;
            } else if (currentRow == 5) {
                y = Globals.row5YPos;
            } else if (currentRow == 4) {
                y = Globals.row4YPos;
            } else if (currentRow == 3) {
                y = Globals.row3YPos;
            } else if (currentRow == 2) {
                y = Globals.row2YPos;
            } else if (currentRow == 1) {
                y = Globals.row1YPos;
            } else {
                y = Globals.row0YPos;
            }

        }

        public function getRowYPos(rowNumber:int):int {

            if (rowNumber == 12) {
                return Globals.row12YPos;
            } else if (rowNumber == 11) {
                return Globals.row11YPos;
            } else if (rowNumber == 10) {
                return Globals.row10YPos;
            } else if (rowNumber == 9) {
                return Globals.row9YPos;
            } else if (rowNumber == 8) {
                return Globals.row8YPos;
            } else if (rowNumber == 7) {
                return Globals.row7YPos;
            } else if (rowNumber == 6) {
                return Globals.row6YPos;
            } else if (rowNumber == 5) {
                return Globals.row5YPos;
            } else if (rowNumber == 4) {
                return Globals.row4YPos;
            } else if (rowNumber == 3) {
                return Globals.row3YPos;
            } else if (rowNumber == 2) {
                return Globals.row2YPos;
            } else if (rowNumber == 1) {
                return Globals.row1YPos;
            } else {
                return Globals.row0YPos;
            }

        }

        public function getColXPos(colNumber:int):int {

            if (colNumber == 6) {
                return Globals.col6XPos;
            } else if (colNumber == 5) {
                return Globals.col5XPos;
            } else if (colNumber == 4) {
                return Globals.col4XPos;
            } else if (colNumber == 3) {
                return Globals.col3XPos;
            } else if (colNumber == 2) {
                return Globals.col2XPos;
            } else if (colNumber == 1) {
                return Globals.col1XPos;
            } else {
                return Globals.col0XPos;
            }

        }

    }
}