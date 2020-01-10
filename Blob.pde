class Blob
{
  static final int DIR_UP = 0;
  static final int DIR_UP_RIGHT = 1;
  static final int DIR_RIGHT = 2;
  static final int DIR_DOWN_RIGHT = 3;
  static final int DIR_DOWN = 4;
  static final int DIR_DOWN_LEFT = 5;
  static final int DIR_LEFT = 6;
  static final int DIR_UP_LEFT = 7;
  
  final String idleImageFileName = "blobIdle.png";
  final String moveImageFileName = "blob move.png";
  int boardXOffset;
  int boardYOffset;
  int boardSingleSquareSize;

  PImage idleSpriteSheet;
  PImage moveSpriteSheet;
  
  Blob(int boardXOffset, int boardYOffset, int boardSingleSquareSize)
  {
    idleSpriteSheet = loadImage(idleImageFileName);
    moveSpriteSheet = loadImage(moveImageFileName);
    this.boardXOffset = boardXOffset;
    this.boardYOffset = boardYOffset;
    this.boardSingleSquareSize = boardSingleSquareSize;
  }
  
   void draw(int currentFrameCount_, int frameCountAtPlay_, int fromSquare, int toSquare)
   {
     int xSign=0, ySign=0;
     PImage spriteSheet;
     int numImagesOnSheet, displayX, displayY;
     if (currentFrameCount_ - frameCountAtPlay_ > 12) 
     {
       displayX = boardXOffset+(toSquare%8)*boardSingleSquareSize+boardSingleSquareSize/2;
       displayY = boardXOffset+(toSquare/8)*boardSingleSquareSize+boardSingleSquareSize/2;
       spriteSheet=idleSpriteSheet;
       numImagesOnSheet = 3;
     }
     else
     {
       for (int x = 0; x < 8; x++)
       {
         if (getAdjacentSquare(fromSquare, x) == toSquare)
         {
           switch(x)
           {
             case DIR_UP:
                xSign = 0;
                ySign = -1;
                break;
              case DIR_UP_RIGHT:
                xSign = 1;
                ySign = -1;
                break;
              case DIR_RIGHT:
                xSign = 1;
                ySign = 0;
                break;
              case DIR_DOWN_RIGHT:
                xSign = 1;
                ySign = 1;
                break;
              case DIR_DOWN:
                xSign = 0;
                ySign = 1;
                break;
              case DIR_DOWN_LEFT:
                xSign = -1;
                ySign = 1;
                break;
              case DIR_LEFT:
                xSign = -1;
                ySign = 0;
                break;
              case DIR_UP_LEFT:
                xSign = -1;
                ySign = -1;
                break;
            }
         }
       }
       displayX = boardXOffset+(fromSquare%8)*boardSingleSquareSize+boardSingleSquareSize/2 + xSign*boardSingleSquareSize/12*(currentFrameCount_-frameCountAtPlay_);
       displayY = boardXOffset+(fromSquare/8)*boardSingleSquareSize+boardSingleSquareSize/2 + ySign*boardSingleSquareSize/12*(currentFrameCount_-frameCountAtPlay_);
       spriteSheet=moveSpriteSheet;
       numImagesOnSheet = 4;
     }
     
     int W = spriteSheet.width/numImagesOnSheet;
     int H = spriteSheet.height;
     
     //print("fromSquare: " + fromSquare + " toSquare: " + toSquare + "\n");
     PImage sprite = spriteSheet.get(W * ((currentFrameCount_ - frameCountAtPlay_) % numImagesOnSheet), 0, W, H);
     image(sprite, displayX, displayY);
  } 

  public int getAdjacentSquare(int startingSquare, int direction)
  {
    int x, y;
    y = startingSquare/8;
    x = startingSquare%8;
    switch (direction)
    {
      case DIR_UP:
        y--;
        break;
      case DIR_UP_RIGHT:
        y--;
        x++;
        break;
      case DIR_RIGHT:
        x++;
        break;
      case DIR_DOWN_RIGHT:
        y++;
        x++;
        break;
      case DIR_DOWN:
        y++;
        break;
      case DIR_DOWN_LEFT:
        y++;
        x--;
        break;
      case DIR_LEFT:
        x--;
        break;
      case DIR_UP_LEFT:
        y--;
        x--;
        break;
    }
    if (x == -1 && (y*8+x == -9 || y*8+x == -8 || y*8+x == -1 || y*8+x == 0)) return -2; 
    if (y == -1 && (y*8+x == -1 || y*8+x == -55) ) return -2;
    if (x == 8 && (y*8+x == 63 || y*8+x == 64 || y*8+x == 71 || y*8+x == 72)) return -2;
    if (y == 8 && (y*8+x == 8 || y*8+x == 63) ) return -2;
    //the above indicate the 3 spaces just beyond each corner. (Each corner has 3)
    
    if (x < 0 || x > 7 || y < 0 || y > 7) return -1;
    
    return y*8+x;
  }
}
