class GameBoard
{
  static final int DIR_UP = 0;
  static final int DIR_UP_RIGHT = 1;
  static final int DIR_RIGHT = 2;
  static final int DIR_DOWN_RIGHT = 3;
  static final int DIR_DOWN = 4;
  static final int DIR_DOWN_LEFT = 5;
  static final int DIR_LEFT = 6;
  static final int DIR_UP_LEFT = 7;

  public static final int BLANK = 0;  
  public static final int BLOB = 1;
  public static final int WALL = 2;
  public static final int CASTLE = 3;
  public static final int TREE = 4;

  private int score;
  private int currentLevel;
  private int currentPlayer;
  private int[] boardArray;
  private int[] lastMove;
  private int[] castles;
  private int[] trees;

  private int[] qualityOfMoves;

  GameBoard(int level)
  {
    boardArray = new int[64];
    lastMove = new int[3];
    qualityOfMoves = new int[64];
    for (int x = 0; x < 64; x++) boardArray[x] = 0;
    boardArray[18] = BLOB;
    boardArray[45] = WALL;
    boardArray[27] = TREE;
    lastMove[BLOB] = 18;
    lastMove[WALL] = 45;
    currentPlayer = BLOB;
    currentLevel = level;
    score = 0;
    print ("Level: " + currentLevel + "\n");
    switch (currentLevel)
    {
    case 2:
    castleImage = loadImage("house1.png");
    background = loadImage("background1.png");
      castles = new int[] {7, 9, 14, 48, 63};
      trees = new int[] {11, 33};
      break;
    case 3:      
      castleImage = loadImage("house.png");
      wallImage = loadImage("wall1.png"); 
      castles = new int[] {10, 48, 49, 51};
      trees = new int[] {0, 6, 7, 42, 61};
      break;
    case 4:
      background = loadImage("background2.png");
      castles = new int[] {3, 5, 28, 41, 54, 63};
      trees = new int[] {8, 31, 58};
      break;        
    case 5:
      castles = new int[] {6, 32, 51, 60};
      trees = new int[] { 8, 38, 58};
      break;
      default:       
      background = loadImage("background2.png");
      castleImage = loadImage("base by Jason Perry.png");
      wallImage = loadImage("wall.png");
      break;
    }
    if (castles == null) // default, level = 1
    {
      castles = new int[] {9, 14, 49, 54};
    }
    if (trees == null)
    {
      trees = new int[] {5, 27, 58};
    }
    for (int x = 0; x < castles.length; x++)
    {
      boardArray[castles[x]] = CASTLE;
    }
    for (int x = 0; x < trees.length; x++)
    {
      boardArray[trees[x]] = TREE;
    }
    calculateScore();
    playPiece(computerAlgorithm1()); //blob goes first
  }

  public int getCurrentPlayer()
  {
    return currentPlayer;
  }

  public boolean playPiece(int square)
  {
    if (putPiece(currentPlayer, square))
    {
      lastMove[currentPlayer] = square;
      if (currentPlayer == BLOB)
      {
        currentPlayer = WALL;
        if(currentLevel < 3)
        wallAudio.play();
        if(currentLevel >=3)
        fenceAudio.play();
      } else
      {
        calculateScore();
        currentPlayer = BLOB;
      }
      if (currentPlayer == BLOB)
      {
        playPiece(computerAlgorithm1());
        return true;
      }
    }
    return false;
  }

  public int getLastMove(int playerColor)
  {
    return lastMove[playerColor];
  }
  public boolean validMovesLeft()
  {
    return validMovesLeft(BLOB) && validMovesLeft(WALL);
  }

  public boolean validMovesLeft(int pieceType)
  {
    boolean valid = false;
    int x = 0;
    while (x < 64 && !valid)
    {
      if (isMoveValid(pieceType, x)) valid = true;
      x++;
    }
    return valid;
  }

  public int getNumPiecesOfColor(int pieceType)
  {
    int count = 0;
    for (int x = 0; x < 64; x++)
    {
      if (boardArray[x] == pieceType) count++;
    }
    return count;
  }

  public boolean putPiece(int pieceType, int square)
  {
    boolean valid = false;
    if (isMoveValid(pieceType, square)) 
    {
      valid = true;
      boardArray[square] = pieceType;
    }
    return valid;
  }

  public boolean isMoveValid(int pieceType, int square)
  {
    boolean adjacentColor = false;
    int x = 0;
    if (boardArray[square] != 0) return false;
    while (!adjacentColor && x <= 7) //loop through 0 through 7 which corresponds to UP, DOWN, etc
    {
      if (getPieceTypeOfSquare(getAdjacentSquare(square, x)) == pieceType) adjacentColor = true;
      x++;
    }
    return adjacentColor;
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

  public int getPieceTypeOfSquare(int square)
  {
    if (square < 0 || square > 63) return -1;
    return boardArray[square];
  }

  public void copyTo(GameBoard otherBoard) //copy current board to this board.
  {
    for (int x = 0; x < 63; x++)
    {
      otherBoard.putPiece(boardArray[x], x);
    }
  }

  private void debugGetAdjacentSquares()
  {
    int startingSquare = 56;
    String direction = "Not Defined";
    for (int x = 0; x < 7; x++)
    {
      switch (x)
      {
      case DIR_UP: 
        direction = "DIR_UP";
        break;
      case DIR_UP_RIGHT: 
        direction = "DIR_UP_RIGHT";
        break;
      case DIR_RIGHT:
        direction = "DIR_RIGHT";
        break;
      case DIR_DOWN_RIGHT:
        direction = "DIR_DOWN_RIGHT";
        break;
      case DIR_DOWN:
        direction = "DIR_DOWN";
        break;
      case DIR_DOWN_LEFT:
        direction = "DIR_DOWN_LEFT";
        break;
      case DIR_LEFT:
        direction = "DIR_LEFT";
        break;
      case DIR_UP_LEFT:
        direction = "DIR_UP_LEFT";
        break;
      }

      print (direction + " from " + startingSquare + " " + getAdjacentSquare(startingSquare, x) + "\n");
    }
  }
  public int winner()
  {
    if (getNumPiecesOfColor(BLANK) == 1 && currentPlayer == BLOB) playPiece(computerAlgorithm1()); //if last play hasn't been played then play it.  
    if (validMovesLeft(BLOB) && !validMovesLeft(WALL)) return BLOB;
    if (validMovesLeft(WALL) && !validMovesLeft(BLOB)) return WALL;
    return 0;
  }
  int countAdjacentSquaresWithItem(int pieceType, int startingSquare) //pieceType 0 is empty
  {
    //counts the number of empty squares adjacent to starting square
    int numOfType = 0;
    for (int direction = 0; direction < 8; direction++)
    {
      if (getPieceTypeOfSquare(getAdjacentSquare(startingSquare, direction)) == pieceType) numOfType++;
    }
    return numOfType;
  }
  boolean isCorner(int square) //not used but maybe in future
  {
    if (square == 0 || square == 7 || square == 56 || square == 63) return true;
    return false;
  }
  boolean isOnEdgeOfBoard(int square, boolean includeCorner) //not used but maybe in future
  {
    if (square/8 == 0 || square/8 == 7 || square%8 == 0 || square%8 == 7)
    {
      if (!includeCorner && isCorner(square)) return false;
      return true;
    }
    return false;
  }
  int computerAlgorithm1()
  {
    blobAudio.play();
    int[] options = new int[64];
    int numOptions=0;
    int highestQuantity = 0;

    for (int x = 0; x < 64; x++)
    {
      qualityOfMoves[x] = 0;
      if (isMoveValid(BLOB, x))
      {
        qualityOfMoves[x] += countAdjacentSquaresWithItem(BLANK, x) + 2*countAdjacentSquaresWithItem(CASTLE, x);
        if (squaresAdjacent(x, lastMove[WALL])) qualityOfMoves[x] += 4; 
        if (qualityOfMoves[x] > highestQuantity) highestQuantity = qualityOfMoves[x];
      }
    }
    for (int x = 0; x < 64; x++)
    {
      if (qualityOfMoves[x] == highestQuantity && highestQuantity != 0)
      {
        options[numOptions] = x;
        numOptions++;
      }
    }
    for (int x = 0; x < 64; x++)
    {
      if (qualityOfMoves[x] == highestQuantity && highestQuantity != 0)
      {
        if (qualityOfMoves[x] > highestQuantity) highestQuantity = qualityOfMoves[x];
      } else
      {
        qualityOfMoves[x] = 0;
      }
    }
    if (numOptions == 0) //found nothing smart. Now just check if there are any moves period.
    {
      for (int x = 0; x < 64; x++)
      {
        if (isMoveValid(BLOB, x))
        {
          options[numOptions] = x;
          numOptions++;
        }
      }
    }
    return options[(int)random(1)*(numOptions+1)];
  }

  boolean squaresAdjacent(int square1, int square2)
  {
    boolean adjacent = false;
    for (int x = 0; x < 8; x++)
    {
      if (getAdjacentSquare(square1, x) == square2) adjacent = true;
    }
    return adjacent;
  }
  private void calculateScore()
  {
    int countBlobs = 0;
    int countValidAdjacentSquares=0;
    for (int x = 0; x < 8; x++)
    {
      if (getPieceTypeOfSquare(getAdjacentSquare(lastMove[WALL], x)) == CASTLE && !wallAlreadyAdjacent(getAdjacentSquare(lastMove[WALL], x)) )
      {
        print ("Square " + getAdjacentSquare(lastMove[WALL], x) + " is castle. Already there? " + wallAlreadyAdjacent(getAdjacentSquare(lastMove[WALL], x))+"\n");
        countValidAdjacentSquares = 0;
        for (int y = 0; y < 8; y++)
        {
          if (getAdjacentSquare(getAdjacentSquare(lastMove[WALL], x), y) != -1) countValidAdjacentSquares++;
          if (getPieceTypeOfSquare(getAdjacentSquare(getAdjacentSquare(lastMove[WALL], x), y)) == BLOB)
          {
            countBlobs++;
          }
        }
      }
    }
    score+= countValidAdjacentSquares-countBlobs;
  }
  public int getCurrentScore()
  {
    return score;
  }
  private boolean wallAlreadyAdjacent(int square)
  {
    for (int x = 0; x < 8; x++)
    {
      if (getPieceTypeOfSquare(getAdjacentSquare(square, x)) == WALL && getAdjacentSquare(square, x) != lastMove[WALL]) return true;
    }
    return false;
  }
  private void printQualityOfMoves()
  {
    for (int x = 0; x < 64; x++)
    {
      print(qualityOfMoves[x] + "\t");
      if (x%8 == 7) print("\n");
    }
  }
}
