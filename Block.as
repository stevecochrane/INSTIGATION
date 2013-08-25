package {

    import org.flixel.*;

    public class Block extends FlxSprite {

        public var blockSparkGroup:FlxGroup;
        public var blockType:int;
        public var currentCol:int = 0;
        public var currentRow:int = 0;
        public var isSetDown:Boolean = false;

        public var xPosToCheck:int = 0;
        public var yPosToCheck:int = 0;
        public var blockTypeToChangeTo:int = 0;

        public var xPosIfDead:int = 0;
        public var yPosIfDead:int = 0;

        public var xPosIfMovedDownOne:int = 0;
        public var yPosIfMovedDownOne:int = 0;

        public var xPosIfMovedDownThree:int = 0;
        public var yPosIfMovedDownThree:int = 0;

        public var stayAtThisX:int = 0;

        public var initialState:Boolean = false;

        public function Block() {

            super();

        }

        override public function update():void {

            super.update();

/*
            if (velocity.y > 0) {
                isSetDown = false;
            }
*/

            if (isSetDown) {
                immovable = true;
                maxVelocity.y = 0;
/*
            } else {
                immovable = false;
                maxVelocity.y = 50;
*/
            }

            //  Make sure the x value doesn't change ever
            acceleration.x = 0;
            maxVelocity.x = 0;
            x = stayAtThisX;


        }

        public function spawn(X:int, Y:int, theBlockType:int, theBlockSparkGroup:FlxGroup, theInitialState:Boolean):void {

            super.reset(X, Y);

            blockType = theBlockType;
            blockSparkGroup = theBlockSparkGroup;
            initialState = theInitialState;

            isSetDown = false;
            immovable = false;

            stayAtThisX = X;

            acceleration.y = 9999;
            maxVelocity.y = Globals.blockBaseMaxVeloY;
            drag.y = 9999;

            acceleration.x = 0;
            maxVelocity.x = 0;
            drag.x = 9999;

            if (blockType == 1) {
                loadGraphic(Assets.imgBlock1, false, false, 16, 16);
            } else if (blockType == 2) {
                loadGraphic(Assets.imgBlock2, false, false, 16, 16);
            } else {
                loadGraphic(Assets.imgBlock3, false, false, 16, 16);
            }

        }

        public function setDown():void {

            if (!isSetDown) {
                
                //  Otherwise this will continue to go off as long as the block is touching other blocks.
                isSetDown = true;

                //  Get the current x and y to determine the current row and column,
                //  then update the block record.
                if (x == Globals.col0XPos) {
                    currentCol = 0;
                } else if (x == Globals.col1XPos) {
                    currentCol = 1;
                } else if (x == Globals.col2XPos) {
                    currentCol = 2;
                } else if (x == Globals.col3XPos) {
                    currentCol = 3;
                } else if (x == Globals.col4XPos) {
                    currentCol = 4;
                } else if (x == Globals.col5XPos) {
                    currentCol = 5;
                } else {
                    currentCol = 6;
                }
    
//                FlxG.log("FlxU.floor(y) = " + FlxU.floor(y));
    
/*
                if (FlxU.floor(y) == Globals.row0YPos) {
                    currentRow = 0;
                } else if (FlxU.floor(y) == Globals.row1YPos) {
                    currentRow = 1;
                } else if (FlxU.floor(y) == Globals.row2YPos) {
                    currentRow = 2;
                } else if (FlxU.floor(y) == Globals.row3YPos) {
                    currentRow = 3;
                } else if (FlxU.floor(y) == Globals.row4YPos) {
                    currentRow = 4;
                } else if (FlxU.floor(y) == Globals.row5YPos) {
                    currentRow = 5;
                } else if (FlxU.floor(y) == Globals.row6YPos) {
                    currentRow = 6;
                } else if (FlxU.floor(y) == Globals.row7YPos) {
                    currentRow = 7;
                } else if (FlxU.floor(y) == Globals.row8YPos) {
                    currentRow = 8;
                } else if (FlxU.floor(y) == Globals.row9YPos) {
                    currentRow = 9;
                } else if (FlxU.floor(y) == Globals.row10YPos) {
                    currentRow = 10;
                } else if (FlxU.floor(y) == Globals.row11YPos) {
                    currentRow = 11;
                } else {
                    currentRow = 12;
                }
*/

                if (FlxU.floor(y) < Globals.row0YPos + 2) {
                    currentRow = 0;
                    y = Globals.row0YPos;
                } else if (FlxU.floor(y) < Globals.row1YPos + 2) {
                    currentRow = 1;
                    y = Globals.row1YPos;
                } else if (FlxU.floor(y) < Globals.row2YPos + 2) {
                    currentRow = 2;
                    y = Globals.row2YPos;
                } else if (FlxU.floor(y) < Globals.row3YPos + 2) {
                    currentRow = 3;
                    y = Globals.row3YPos;
                } else if (FlxU.floor(y) < Globals.row4YPos + 2) {
                    currentRow = 4;
                    y = Globals.row4YPos;
                } else if (FlxU.floor(y) < Globals.row5YPos + 2) {
                    currentRow = 5;
                    y = Globals.row5YPos;
                } else if (FlxU.floor(y) < Globals.row6YPos + 2) {
                    currentRow = 6;
                    y = Globals.row6YPos;
                } else if (FlxU.floor(y) < Globals.row7YPos + 2) {
                    currentRow = 7;
                    y = Globals.row7YPos;
                } else if (FlxU.floor(y) < Globals.row8YPos + 2) {
                    currentRow = 8;
                    y = Globals.row8YPos;
                } else if (FlxU.floor(y) < Globals.row9YPos + 2) {
                    currentRow = 9;
                    y = Globals.row9YPos;
                } else if (FlxU.floor(y) < Globals.row10YPos + 2) {
                    currentRow = 10;
                    y = Globals.row10YPos;
                } else if (FlxU.floor(y) < Globals.row11YPos + 2) {
                    currentRow = 11;
                    y = Globals.row11YPos;
                } else {
                    currentRow = 12;
                    y = Globals.row12YPos;
                }

//                FlxG.log("touched down at y = " + y);

    /*
                FlxG.log("block touched down at " + currentRow + ", " + currentCol);
                FlxG.log("NEW");
                FlxG.log("Before: Globals.blockRecord[" + currentRow + "][" + currentCol + "] = ");
                FlxG.log(Globals.blockRecord[currentRow][currentCol]);
    */
    
                Globals.blockRecord[currentRow][currentCol] = blockType;
    
    /*
                FlxG.log("After: Globals.blockRecord[" + currentRow + "][" + currentCol + "] = ");
                FlxG.log(Globals.blockRecord[currentRow][currentCol]);
    */

                if (!initialState) {
                    FlxG.play(Assets.audBlockSetDown);
                }

                if (y < 48) {
                    FlxG.switchState(new GameOverState());
                }


            }
        }

        public function changeBlockType(newBlockType:int):void {

            blockType = newBlockType;

            if (blockType == 1) {
                loadGraphic(Assets.imgBlock1, false, false, 16, 16);
            } else if (blockType == 2) {
                loadGraphic(Assets.imgBlock2, false, false, 16, 16);
            } else {
                loadGraphic(Assets.imgBlock3, false, false, 16, 16);
            }

        }

        public function checkPosition(checkX:int, checkY:int):Boolean {

            if (x == checkX && y == checkY) {
                return true;
            } else {
                return false;
            }

        }

        public function checkIfChange():void {

            if (alive && isSetDown) {
//                FlxG.log("checking if the type should change!");
//                FlxG.log(xPosToCheck + ", " + yPosToCheck + ", " + blockTypeToChangeTo);

                if (FlxU.floor(x) == xPosToCheck && FlxU.floor(y) == yPosToCheck) {

//                    FlxG.log("changing block at " + FlxU.floor(x) + ", " + FlxU.floor(y) + " to " + blockTypeToChangeTo);
                    changeBlockType(blockTypeToChangeTo);

                }
            }
        }

        public function checkIfDead():void {

            if (alive && isSetDown) {
//                FlxG.log("checking if the type should change!");
//                FlxG.log(xPosToCheck + ", " + yPosToCheck + ", " + blockTypeToChangeTo);

                if (FlxU.floor(x) == xPosIfDead && FlxU.floor(y) == yPosIfDead) {

                    kill();

                }
            }
        }

        public function checkIfMovedDownOne():void {

            if (alive && isSetDown) {
//                FlxG.log("checking if the type should change!");
//                FlxG.log(xPosToCheck + ", " + yPosToCheck + ", " + blockTypeToChangeTo);

                if (FlxU.floor(x) == xPosIfMovedDownOne && FlxU.floor(y) == yPosIfMovedDownOne) {

                    y += 16;

                }
            }
        }


        public function checkIfMovedDownThree():void {

            if (alive && isSetDown) {
//                FlxG.log("checking if the type should change!");
//                FlxG.log(xPosToCheck + ", " + yPosToCheck + ", " + blockTypeToChangeTo);

                if (FlxU.floor(x) == xPosIfMovedDownThree && FlxU.floor(y) == yPosIfMovedDownThree) {

                    y += 48;

                }
            }
        }

        public function increaseFallSpeed():void {

            if (!isSetDown) {

                maxVelocity.y = Globals.blockBaseMaxVeloY;

            }
        }

        override public function kill():void {

            (blockSparkGroup.recycle(BlockSpark) as BlockSpark).spawn(FlxU.floor(x), FlxU.floor(y));

            super.kill();

        }
    }
}