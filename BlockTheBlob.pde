//Block the Blob //<>// //<>//
//****************************
//Castle image from https://finalbossblues.itch.io/pixel-shooter-towers-asset-pack

import processing.sound.*;
import ddf.minim.*;
import processing.video.*;

GameBoard BtBBoard;
Blob activeBlob;
Movie clip;
//SoundFile titleAudio;
//SoundFile gameplayAudio;
SoundFile blobAudio;
SoundFile wallAudio;
SoundFile fenceAudio;

Minim minim;
Minim minim2;

AudioPlayer gameplayAudio;
AudioPlayer titleAudio;

final int boardXOffset = 40;
final int boardYOffset = 40;
final int boardSingleSquareSize = 80;

PImage emptyImage;
PImage blobImage;
PImage castleImage;
PImage wallImage;
PImage treeImage;
PImage background;
PImage moves;
PImage playButton;
PImage rulesButton;
PImage credits;
int currentIndex = 0; //image index
int DIM;
int W;
int H;
int x1;
int y1;
int xpos; //set animation x-pos
int ypos; // set animation y-pos
int i = 0;
int m = -130;
//button positions
int buttonXpos = 240;
int buttonYpos = 240;
int x = 240; //'start'
int y = 240;
int w = 240;
int h = 60;
int mouseClickedX, mouseClickedY;
int texty = 350;
int frameCountAtLastPlay;
int fromSquare;
int sec;
int num = 0;
int num2;
int frame;
int sec2;
int current = 0; //current info
int score = 0; //running score

boolean pMousePressed;
boolean displayCredits = true;
boolean play = false;
boolean gameplay = false;

PFont font1; //Arial-BoldMT-48.vlw //m5x7-48.vlw
boolean mouseOver = false;
boolean buttonPressed = false;
String currentMode = "menu";
String lastMode;
int peopleSavedAtLevelStart;
int currentLevel;
//buttons
Button playGameButton;
Button startGameButton;
Button rulesGameButton;
Button nextLevelGameButton;
Button startOverButton;
Button quitButton;
Button returnButton;
Button creditsButton;

void setup()
{
  //Set window, font, and alignments
  size(720, 720);
  imageMode(CENTER); //use the center point for calculation
  textSize(42);
  textAlign(CENTER, CENTER);
  font1 = loadFont("m5x7-48.vlw");
  textFont(font1, 42);
  //images load and resize
  emptyImage = loadImage("empty.png");
  blobImage = loadImage("blob.png");
  blobImage.resize(64, 64);
  playButton = loadImage("playButton.png");
  castleImage = loadImage("base by Jason Perry.png");
  wallImage = loadImage("wall.png");
  treeImage = loadImage("tree.png");
  background = loadImage("background1.png");
  moves = loadImage("moves.png");
  moves.resize(256, 128);
  credits = loadImage("creditsButton.png");
  rulesButton = loadImage("rulesButton.png");
  minim2 = new Minim(this);
  titleAudio = minim2.loadFile("title.mp3");
  minim = new Minim(this);
  gameplayAudio = minim.loadFile("gameplay.mp3");
  blobAudio = new SoundFile(this, "blobsound.aif");
  wallAudio = new SoundFile(this, "wall.mp3");
  fenceAudio = new SoundFile(this, "fence.mp3");
  clip = new Movie(this, "BlockTheBlob.mp4");
  clip.play();
  playButton.resize(72, 72);
  rulesButton.resize(64, 64);
  credits.resize(64, 64);
  //buttons
  startGameButton = new Button("START", 240, 240, 240, 60, "start over");
  rulesGameButton = new Button("RULES", 240, 315, 240, 60, "rules");
  nextLevelGameButton = new Button("NEXT LEVEL", 240, 240, 240, 60, "next level");
  returnButton = new Button("RETURN", 240, 240, 240, 60, "game");
  startOverButton = new Button("START OVER", 240, 315, 240, 60, "start over");
  quitButton = new Button("QUIT", 240, 465, 240, 60, "quit");
  //animation dimensions
  xpos = width/2;
  ypos = height/2;
  frameRate(12);
  fromSquare = -1;
}
//monitor credits to return to previous mode
void keyPressed()
{
  if (keyPressed || mousePressed)
    displayCredits = false;
  if (key == 'p' && currentMode == "game")
    currentMode = "ingame menu";
  else if (key == 'p' && currentMode == "ingame menu")
    currentMode = "game";
}
//in-game menu to access other modes
void drawMenuButton()
{
  stroke(0);
  line(5, 10, 30, 10);
  line(5, 20, 30, 20);
  line(5, 30, 30, 30);
}
//draws the main menu
void mainMenu()
{
  background(#D6FFF2);
  imageMode(CENTER);
  mainAnimation();

  PImage img = loadImage("title1.png"); //title

  img.resize(384, 256);
  image(img, width/2, height/4);

  displayCredits = true;
  imageMode(CORNER);

  Button buttons[] = new Button[3];
  buttons[0] = new Button("PLAY", width/2-40, height-height/4-25, playButton.width, playButton.height, "start over");
  buttons[1] = new Button("RULES", width/2 + playButton.width - 20, height-height/4 -20, rulesButton.width, rulesButton.height, "rules");
  buttons[2] = new Button("CREDITS", width/2 - playButton.width - 50, height-height/4-20, credits.width, credits.height, "credits");

  image(playButton, buttons[0].buttonX, buttons[0].buttonY);
  image(rulesButton, buttons[1].buttonX, buttons[1].buttonY);
  image(credits, buttons[2].buttonX, buttons[2].buttonY);

  for (int x = 0; x < 3; x++)
  {
    buttons[x].draw(mouseX, mouseY, buttons[x].strButtonText);
    if (!mousePressed && pMousePressed)
    {
      if (buttons[x].checkIfClicked(mouseClickedX, mouseClickedY))
      {
        print ("Clicked: setting to mode" + buttons[x].modeIfClicked());
        currentMode = buttons[x].modeIfClicked();
        buttons = null;
        return;
      }
    }
  }
}
//display end of level/ game result
void gameEndMenu(boolean showNextLevel)
{
  fill(0);  
  rect(0, 35, width, height/8);
  if (showNextLevel)
  {
    String winnerText1 = "Game Tied! You saved";
    String winnerText2 = BtBBoard.getCurrentScore() + " people from the blob.";
    if (BtBBoard.winner() == GameBoard.BLOB) 
    {
      winnerText1 = "The blob wins, but you saved ";
    }
    if (BtBBoard.winner() == GameBoard.WALL)
    {
      winnerText1 = "You win and you saved";
    }
    fill(255);
    text(winnerText1, 360, 60);
    text(winnerText2, 360, 100);
  }
  Button buttons[] = new Button[4];
  buttons[0] = showNextLevel ? nextLevelGameButton : returnButton;
  buttons[1] = new Button("START OVER", 240, buttonYpos-75, 240, 60, "start over");
  if (showNextLevel)
  {
    lastMode = "ingame menu";
  }
  buttons[2] = new Button("RULES", 240, buttonYpos+75, 240, 60, "rules");
  buttons[3] = new Button("QUIT", 240, 390, 240, 60, "quit");
  for (int x = 0; x < 4; x++)
  {
    buttons[x].draw(mouseX, mouseY);
    if (!mousePressed && pMousePressed)
    {
      if (buttons[x].checkIfClicked(mouseClickedX, mouseClickedY))
      {
        print ("Clicked: setting to mode" + buttons[x].modeIfClicked());
        currentMode = buttons[x].modeIfClicked();
        buttons = null;
        return;
      }
    }
  }
}

void draw ()
{
  background(120, 240, 180);
  fill (0);
  textSize(42);
  imageMode(CENTER);
  image(clip, width/2, height/2, width, height);
  
  if(num2 >= 424)
  {
  if (mousePressed)
  {
    mouseClickedX = mouseX;
    mouseClickedY = mouseY;
  }
  switch(currentMode) //changes the mode
  {
  case "menu":
    if (play == false)
    {
      titleAudio.play();
      play = true;
    }
    if (!titleAudio.isPlaying())
    {
      titleAudio.pause();
      titleAudio.rewind();
      titleAudio.play();
    }
    lastMode = "menu";
    mainMenu();
    break;
  case "rules": 
    if (!titleAudio.isPlaying())
    {
      gameplayAudio.pause();
      titleAudio.pause();
      titleAudio.rewind();
      titleAudio.play();
    }
    rules();
    break;
  case "start over":
    titleAudio.pause();
    currentLevel = 1;
    peopleSavedAtLevelStart = 0;
    BtBBoard = new GameBoard(currentLevel);
    activeBlob = new Blob(boardXOffset, boardYOffset, boardSingleSquareSize);
    currentMode = "game";
    frame = frameCount;
    break;
  case "next level":
    currentLevel++;
    score += BtBBoard.getCurrentScore() + BtBBoard.getNumPiecesOfColor(GameBoard.BLANK); 
    BtBBoard = new GameBoard(currentLevel);
    currentMode = "game";
    break;
  case "animation": 
    break;
  case "game":
    if (gameplay == false)
    {
      gameplayAudio.play();
      gameplay = true;
    }
    if (!gameplayAudio.isPlaying())
    {
      gameplayAudio.pause();
      gameplayAudio.rewind();
      gameplayAudio.play();
    }
    break;
  case "ingame menu":
    if (!gameplayAudio.isPlaying())
    {
      titleAudio.pause();
      gameplayAudio.pause();
      gameplayAudio.rewind();
      gameplayAudio.play();
    }
    lastMode = "ingame menu";
    gameEndMenu(false);
    break;
  case "post game":
    gameEndMenu(true);
    break;
  case "credits":
    if (!titleAudio.isPlaying())
    {
      titleAudio.pause();
      titleAudio.rewind();
      titleAudio.play();
    }
    lastMode = "menu";
    if (displayCredits)
      credits();
    else
      currentMode = "menu";
    break;
  default:
    exit();
  }
  if (currentMode.equals("game"))
  {
    if (!mousePressed & pMousePressed)
    {      
      int clickedSquare = getSquareNumber(mouseX, mouseY);
      if (frameCount - frameCountAtLastPlay > 12) fromSquare = -1;
      if (clickedSquare != -1)
      {
        if (BtBBoard.playPiece(clickedSquare))
        {
          frameCountAtLastPlay = frameCount;
          if (fromSquare == -1)
          {
            x = 0;
            while (x < 8 && fromSquare == -1)
            {
              if (BtBBoard.getPieceTypeOfSquare(BtBBoard.getAdjacentSquare(BtBBoard.getLastMove(GameBoard.BLOB), x)) == GameBoard.BLOB)
              {
                fromSquare = BtBBoard.getAdjacentSquare(BtBBoard.getLastMove(GameBoard.BLOB), x);
              }
              x++;
            }
            print ("Computer played so finding adjacent square to " + BtBBoard.getLastMove(GameBoard.BLOB) + ": " + fromSquare + "\n");
          }
        }
      }
      if (mouseX >=5 && mouseX <= 30 && mouseY >= 0 && mouseY <= 40)
      {
        currentMode = "ingame menu";
      }
    }
    drawBoard();
    drawMenuButton();
    if (!BtBBoard.validMovesLeft())
    {
      currentMode = "post game";
    }
  }
  pMousePressed = mousePressed;
  }
}

void drawBoard()
{
  String player;
  boolean lastMove;

  if (frameCount - frameCountAtLastPlay < 12) 
  {
    background(0);
    player = "Blob";
  } else 
  {
    player = "You";
  }
  background(background);
  fill(0, 175);
  rect(40, 0, width-85, 35);
  fill(255);
  text("Player: " + player, 120, 16);
  text("Score: " + (score + BtBBoard.getCurrentScore()), width/3+60, 16); 
  text("Blob: " + BtBBoard.getNumPiecesOfColor(GameBoard.BLOB) + " You: " + BtBBoard.getNumPiecesOfColor(GameBoard.WALL), width- width/4, 15);
  stroke(0);
  fill(255, 255, 255, 0);
  rect(boardXOffset, boardYOffset, 640, 640);
  for (int i = boardXOffset; i < 640; i+=boardSingleSquareSize)
  {
    line(i, boardYOffset, i, boardYOffset+boardSingleSquareSize*8);
    line(boardXOffset, i, boardXOffset+boardSingleSquareSize*8, i);
  }
  for (int i = 0; i < 64; i++)
  {
    if (i == BtBBoard.getLastMove(GameBoard.BLOB) || i == BtBBoard.getLastMove(GameBoard.WALL))
    {
      lastMove = true;
      if (i == BtBBoard.getLastMove(GameBoard.BLOB)) activeBlob.draw(frameCount, frameCountAtLastPlay, fromSquare, i);
    } else
    {
      lastMove = false;
    }
    drawPiece(i, BtBBoard.getPieceTypeOfSquare(i), lastMove);
  }
}

void drawPiece(int square, int piece, boolean lastPiece)
{
  int x, y;
  y = square/8;
  x = square%8;
  boolean valid = false;
  PImage imageHolder= emptyImage; //just in case logic below fails.
  if (piece == GameBoard.BLOB)
  {
    imageHolder = blobImage;
    valid = true;
  } else if (piece == GameBoard.WALL)
  {
    imageHolder = wallImage;
    valid = true;
  } else if (piece == GameBoard.TREE)
  {
    imageHolder = treeImage;
    valid = true;
  } else if (piece == GameBoard.CASTLE)
  {
    imageHolder = castleImage;
    valid = true;
  }
  if (valid)
  {
    if ( (!lastPiece && imageHolder == blobImage) || (imageHolder != blobImage) ) 
    {
      image(imageHolder, boardXOffset+x*boardSingleSquareSize+boardSingleSquareSize/2, boardYOffset+y*boardSingleSquareSize+boardSingleSquareSize/2, boardSingleSquareSize*.90, boardSingleSquareSize*.90);
    }
    if (lastPiece)
    {
      fill(#FFE30D, 40);
      rect(boardXOffset+x*boardSingleSquareSize, boardYOffset+y*boardSingleSquareSize, boardSingleSquareSize, boardSingleSquareSize);
    }
  }
}

int getSquareNumber(int mousePositionX, int mousePositionY)
{
  int x, y;
  if (mousePositionX < boardXOffset || mousePositionX > boardXOffset+boardSingleSquareSize*8 || mousePositionY < boardYOffset || mousePositionY > boardYOffset+boardSingleSquareSize*8) return -1; //off game board 
  x = (mousePositionX-boardXOffset)/boardSingleSquareSize;
  y = (mousePositionY-boardYOffset)/boardSingleSquareSize;
  return y*8+x;
}

//to display rules screen
void rules()
{
  background(#FFE079);
  PImage[] temp = new PImage [2];
  temp[0] = loadImage("moves2.png");
  temp[1] = loadImage("moves3.png");
  temp[0].resize(128, 128);
  temp[1].resize(128, 128);
  //add info. + image.
  Button rulesB;
  Button rightArrow;
  Button leftArrow;
  fill(0);
  if (current == 0)
  { 
    background(#FFE079);
    text("1/2", width-50, height-120);
    text("WELCOME HEROES!\n", width/2, 80);
    //   fill(255);
    text("\n\nNo? Not a hero? No problem, we aren't picky!\nWe are under attack by blobs! Despite their\n cute appearances, they are destructive.\nPlease, help us!", width/2, 140);
    pushMatrix();
    scale(2);
    image(castleImage, width/4, height/4);
    image(blobImage, width/3+20, height/4);
    image(wallImage, width/8, height/4);
    popMatrix();
    text("YOU", width/4, height/2 +96);
    text("US", width/2, height/2 +96);
    text("THEM", width-width/4-20, height/2 +96);
    textSize(36);
    text("(Don't worry! It's simple, but somehow we just can\'t do it!)", width/2, height - 180);

    rightArrow = new Button("Next", (width)-150, height-(height/8), 110, 50);
    rightArrow.draw(mouseX, mouseY);
    if (!mousePressed && pMousePressed)
    {
      if (rightArrow.checkIfClicked(mouseClickedX, mouseClickedY))
      {
        print ("Clicked: setting to mode" + rightArrow.modeIfClicked());
        //currentMode = rightArrow.modeIfClicked();
        current = 1;
        //return;
      }
    }
    /*if (keyCode == RIGHT)
     current =1;*/
  }  
  fill(0);
  if (current == 1)
  {
    textSize(42);
    background(#FFE079);
    fill(0);
    text("2/2", width-50, height-120);
    text("HOW TO PLAY\n", width/2, 80);
    text("Be careful though, or you'll lose!", width/2, 260);

    //fill(255);
    image(moves, width/4+30, height/2 + 25);
    image(temp[0], moves.width+158, height/2 + 25);
    image(temp[1], moves.width+304, height/2 + 25);
    text("Safe!", moves.width+304, height/2 -50);
    text("You can build in 8 directions onto an unoccupied spot.\n(The sneaky blobs can also move 8 ways too!)\n\nSurround us with your walls to save more people.", width/2, height/2 + 70 + moves.height/2+15);
    //    text("Victory!\n We will await YOU to save us.", width/2, height-height/4);
    //fill(255, 0, 0);
    text("Outnumber and outsmart the blobs\n by building walls, the more walls you build,\n the better your chances are to save us.", width/2, 160);

    leftArrow = new Button("Prev", 80, height-(height/8), 110, 50);
    leftArrow.draw(mouseX, mouseY);
    if (!mousePressed && pMousePressed)
    {
      if (leftArrow.checkIfClicked(mouseClickedX, mouseClickedY))
      {
        print ("Clicked: setting to mode" + leftArrow.modeIfClicked());
        //currentMode = rightArrow.modeIfClicked();
        current = 0;
        //return;
      }
    }
    /*if (keyCode == LEFT)
     current = 0;*/
  } 

  rulesB = new Button("RETURN", (width/2)-60, height-(height/8), 110, 50, lastMode);
  rulesB.draw(mouseX, mouseY);
  if (!mousePressed && pMousePressed)
  {
    if (rulesB.checkIfClicked(mouseClickedX, mouseClickedY))
    {
      print ("Clicked: setting to mode" + rulesB.modeIfClicked());
      currentMode = rulesB.modeIfClicked();
      current = 0;
      return;
    }
  }
}

void credits()
{
  background(255); 
  fill(0); //text color
  //  textAlign(CENTER);
  { 
    text("A game made by \n" + 
      "Gameplay & AI & Animation: Jason Brunelle\n" +
      "Menus & Graphics: Vi Ta\n" + 
      "Level Design & Music: Jonathon Viesca\n" +
      "Inro Clip by Viesca Studios\n" +
      "castle/base by Jason Perry\n" +
      "'Upward-Blip-ility'\n" +
      "'Crazy-Candy-Highway-2'\n" +
      "by Eric Matyas\n" +
      "Thank You for playing!", 
      width/2, texty--);
    if (texty <= -50)
      texty = height + 50;
    if (mousePressed)
      currentMode = "menu";
  }
}

void mainAnimation()
{
  image(blobImage, m, 490);
  pushMatrix();
  scale(2);
  translate(100, -50);
  image(wallImage, xpos/4-15, ypos/2);
  if (ypos < 550)
  {
    ypos+=5;  
    m+=10;
  } else
  {
    if (ypos > 550 && ypos <680) 
    {
      ypos--;
    }
  }
  popMatrix();
}

void movieEvent(Movie clip)
{
  clip.read();
  num2++;
}
void mousePressed()
{
  clip.jump(18);
  num2 = 424;
}
