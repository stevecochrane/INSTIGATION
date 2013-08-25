package {

    import org.flixel.*;

    public class Globals {

        static public var blockRecord:Array = new Array();

        static public var blockBaseMaxVeloY:int = 50;

        static public var col0XPos:int = 96;
        static public var col1XPos:int = 112;
        static public var col2XPos:int = 128;
        static public var col3XPos:int = 144;
        static public var col4XPos:int = 160;
        static public var col5XPos:int = 176;
        static public var col6XPos:int = 192;

        static public var colOuterLeftXPos:int = 80;
        static public var colOuterRightXPos:int = 208;

        static public var row0YPos:int = playfieldTopEdge;
        static public var row1YPos:int = playfieldTopEdge + 16;
        static public var row2YPos:int = playfieldTopEdge + 32;
        static public var row3YPos:int = playfieldTopEdge + 48;
        static public var row4YPos:int = playfieldTopEdge + 64;
        static public var row5YPos:int = playfieldTopEdge + 80;
        static public var row6YPos:int = playfieldTopEdge + 96;
        static public var row7YPos:int = playfieldTopEdge + 112;
        static public var row8YPos:int = playfieldTopEdge + 128;
        static public var row9YPos:int = playfieldTopEdge + 144;
        static public var row10YPos:int = playfieldTopEdge + 160;
        static public var row11YPos:int = playfieldTopEdge + 176;
        static public var row12YPos:int = playfieldTopEdge + 192;

        static public var playfieldLeftEdge:int = 96;
        static public var playfieldRightEdge:int = 208;
        static public var playfieldTopEdge:int = 0;

        static public var playfieldColNumber:int = 7;
        static public var playfieldRowNumber:int = 13;


        static public function getRowYPos(rowNumber:int):int {

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

        static public function getColXPos(colNumber:int):int {

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