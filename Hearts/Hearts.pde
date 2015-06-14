//card images: courtesy of http://www.jfitz.com/cards/
PImage[] imageList = new PImage[54];
PImage greenFeltBackground;
PFont font;
PFont font2;

//The number of the screen being displayed
int screen;
int MAIN = -1;
int GAME = 0;
int MENU = 1;
int DIRECTIONS = 2;
int RULES = 3;

//buttons on main
Button[] mainButtons;
//buttons in game
Button[] gameButtons;
//buttons on menu
Button[] menuButtons;
//buttons on rules screen
Button[] rulesButtons;
//buttons on directions screen
Button[] directionsButtons;

//Time
int time;
int count;

ArrayList<Card> deck; //The deck of cards
Card[] playedCards; //The cards currently played (length 4, with indices corresponding to player number)
//The 4 players
Player south;
Player north;
Player east;
Player west;
//The on-screen display of the four hands
CardDisplay displaySouth;
CardDisplay displayNorth;
CardDisplay displayEast;
CardDisplay displayWest;
//The player whose turn it is to play a card
Player currentPlayer;
//Whether the first card (two of clubs) has been played
boolean firstPlayed;
//Whether the program is currently waiting for a turn
boolean turnPending;
//Distance cards in a trick should move;
int dx, dy;
//The number of the card that has most recently been played
int lastPlayed;
//Whether the played cards are about to be reset
boolean willReset;
//The Player that starts the trick
Player startingPlayer;
//Whether hearts have been broken or not
boolean heartsBroken;
//Whether results are currently being displayed
boolean displayingResults;
//Whether cards are currents being selected to be passed
boolean passingCards;
//Keeps track of the number of rounds
int roundNumber;
//Set to true when the game is finished
boolean gameFinished;
//Keeps track of error message being displayed
boolean messageDisplayed;
String message;

//The hands for the 4 players
ArrayList<Card> southHand;
ArrayList<Card> northHand;
ArrayList<Card> eastHand;
ArrayList<Card> westHand;

//constants
int NORTH = 0;
int SOUTH = 1;
int EAST = 2;
int WEST = 3;

void setup() {
  font = loadFont("LatinWide-48.vlw");
  font2 = loadFont("LucidaGrande-48.vlw");
  for (int i=1; i<55; i++) {
    if (i==53) {
      imageList[i-1] = loadImage("b2fh.png");
    } else if (i==54) {
      imageList[i-1] = loadImage("b2fv.png");
    } else {
      imageList[i-1] = loadImage(i+".png");
    }
  }
  greenFeltBackground = loadImage("greenFelt3.jpg");
  greenFeltBackground.resize(850, 700);
  screen = MAIN;
  count = 0;
  size(850, 700);
  //background(0, 100, 0);
  background(greenFeltBackground);
  deck = new ArrayList();
  southHand = new ArrayList();
  northHand = new ArrayList();
  eastHand = new ArrayList();
  westHand = new ArrayList();
  playedCards = new Card[4];
  for (int i = 0; i < 4; i++) {
    playedCards[i] = new Card(0, 0);
  }  
  south = new Player(SOUTH);
  north = new Player(NORTH);
  east = new Player(EAST);
  west = new Player(WEST);

  displaySouth = new CardDisplay(south);
  displayNorth = new CardDisplay(north);
  displayEast = new CardDisplay(east);
  displayWest = new CardDisplay(west);

  cardSelected = 12;

  setDeck();
  deal();

  firstPlayed = false;
  turnPending = false;
  lastPlayed = 0;
  willReset = false;
  heartsBroken = false;
  displayingResults = false;
  gameFinished = false;
  dx = 0;
  dy = 0;

  passingCards = true;
  roundNumber = 0;

  messageDisplayed = false;
  message = "";

  //buttons in main screen
  Button newGame = new Button("NEW GAME", width/2, 300);
  Button showRules = new Button("RULES", width/2, 400);
  mainButtons = new Button[] { 
    newGame, showRules
  };

  //menu button in game screen
  Button menuButton = new Button("MENU", width-100, height-50);
  gameButtons = new Button[] {
    menuButton
  };

  //buttons in menu screen 
  Button leaveGame = new Button("LEAVE GAME", width/2, 200);
  Button resumeGame = new Button("RESUME GAME", width/2, 300);
  Button showDirections = new Button("PLAY DIRECTIONS", width/2, 400);
  menuButtons = new Button[] {
    leaveGame, resumeGame, showDirections
  };

  //buttons in rules screen
  Button mainMenu = new Button("BACK TO MAIN MENU", width/2, 600);
  rulesButtons = new Button[] {
    mainMenu
  };

  //buttons in direction screen
  Button backToMenu = new Button("BACK TO MENU", width/2, 600);
  directionsButtons = new Button[] {
    backToMenu
  };
}

void draw() {
  if (screen==GAME) {
    if (!displayingResults) {
      gameDisplay();
      if (!passingCards) {
        if (currentPlayer != south && !willReset) {
          if (turnPending) {
            currentPlayer.playCard(lastPlayed, false);
          } else {
            currentPlayer.playCard(currentPlayer.pickCard(), false);
          }
        }
        if (playedCards[0].number!=0 && playedCards[1].number!=0 && playedCards[2].number!=0 && playedCards[3].number!=0) {
          if (!willReset) {
            willReset = true;
            time = millis();
          }
          if (time + 1200 < millis() && time + 1500 >= millis()) {
            takeTrick();
            drawPlayedCards();
          }
          if (time + 1500 < millis()) {
            dx = 0;
            dy = 0;
            willReset = false;
            resetPlayedCards();
          }
        }
        if (!willReset && north.hand.size() == 0 && south.hand.size() == 0 && east.hand.size() == 0 && west.hand.size() == 0) {
          gameDisplay();
          displayingResults = true;
          roundResults();
        }
      } else {
        pickPassingCards();
      }
    }
  } else if (screen==DIRECTIONS) {
    background(greenFeltBackground);
    drawDirections();
  } else if (screen==MENU) {
    background(greenFeltBackground);
    drawMenu();
  } else if (screen==MAIN) {
    background(greenFeltBackground);
    drawMain();
  } else if (screen==RULES) {
    background(greenFeltBackground);
    drawRules();
  }
}

void drawDirections() {
  fill(0, 0, 0, 150);
  noStroke();
  rectMode(CENTER);
  rect(width/2, height/2, width-125, height-100);
  rectMode(CORNER);
  stroke(255, 255, 255);
  fill(255);
  textSize(20);
  textAlign(CENTER, CENTER);
  fill(255);
  stroke(255);
  textSize(20);
  text("Click or use the LEFT and RIGHT arrow keys", width/2, 250);
  text("to highlight a card", width/2, 275);
  text("Play highlighted cards", width/2, 325);
  text("with the UP arrow key", width/2, 350);

  fill(255, 0, 0);
  stroke(255, 0, 0);
  text("Click", width/2-186, 250);
  text("LEFT", width/2-31.10, 250);
  text("RIGHT", width/2+69.35, 250);
  text("highlight", width/2-20, 275);
  text("Play", width/2-87.75, 325);
  text("UP", width/2-8.15, 350);
  fill(255);
  stroke(255);

  textAlign(CENTER, CENTER);
  textSize(20);
  //text("Press enter to return to play menu", width / 2, height-100);
  for (Button b : directionsButtons) {
    b.draw();
  }
}

void drawMenu() {
  fill(0, 0, 0, 150);
  noStroke();
  rectMode(CENTER);
  rect(width/2, height/2, width-125, height-100);
  rectMode(CORNER);
  stroke(255, 255, 255);
  fill(255);
  textSize(20);
  textAlign(CENTER, CENTER);

  for (Button b : menuButtons) {
    b.draw();
  }
}

void drawMain() {
  textAlign(CENTER, CENTER);
  textSize(100);
  fill(255, 0, 0);
  textFont(font, 85);
  text("HEARTS", width/2, 125);
  textSize(20);
  textFont(font2, 20);
  stroke(255, 255, 255);
  fill(255);
  textSize(20);

  for (Button b : mainButtons) {
    b.draw();
  }
}

void drawRules() {
  fill(0, 0, 0, 150);
  noStroke();
  rectMode(CENTER);
  rect(width/2, height/2, width-125, height-100);
  rectMode(CORNER);
  stroke(255, 0, 0);
  fill(255, 0, 0);
  textSize(36);
  textAlign(CENTER, CENTER);
  text("RULES:", width/2, 100);

  noStroke();
  //stroke(255, 255, 255);
  textAlign(LEFT, CENTER);
  textSize(20);
  text("Objective:", 100, 130);
  fill(255,0,0);
  ellipse(150,155,7.5,7.5);
  fill(255);
  textSize(16);
  text("To have the least amount of points by the game's end.", 160, 155);
  fill(255, 0, 0);
  textSize(20);
  text("Points:", 100, 180);
  fill(255);
  textSize(16);
  fill(255,0,0);
  ellipse(150,205,7.5,7.5);
  fill(255);
  text("Each heart card taken is worth 1 point.", 160, 205);
  fill(255,0,0);
  ellipse(150,225,7.5,7.5);
  fill(255);
  text("The Queen of Spades is worth 13 points.", 160, 225);
  fill(255,0,0);
  ellipse(150,245,7.5,7.5);
  fill(255);
  text("A player can win 0 points either by taking NO point cards", 160, 245);
  text("OR", 350, 265);
  text("by taking ALL of the point cards ('shooting the moon').", 160, 285);
  fill(255, 0, 0);
  textSize(20);
  text("Playing the Game:", 100, 320);
  fill(255);
  textSize(16);
  fill(255,0,0);
  ellipse(150,345,7.5,7.5);
  fill(255);
  text("The player with the 2 of Clubs in hand leads the first trick.", 160, 345);
  fill(255,0,0);
  ellipse(150,365,7.5,7.5);
  fill(255);
  text("Each subsequent player must follow suit if able.", 160, 365);
  fill(255,0,0);
  ellipse(150,385,7.5,7.5);
  fill(255);
  text("The player with the highest card of the correct suit wins the trick.", 160, 385);
  fill(255,0,0);
  ellipse(150,405,7.5,7.5);
  fill(255);
  text("The player who won the last trick leads the next trick.", 160, 405);
  fill(255,0,0);
  ellipse(150,425,7.5,7.5);
  fill(255);
  text("Hearts cannot be led unless hearts have been broken.", 160, 425);
  fill(255,0,0);
  ellipse(150,445,7.5,7.5);
  fill(255);
  text("Hearts may be played if it is impossible to follow suit.", 160, 445);
  fill(255,0,0);
  ellipse(150,465,7.5,7.5);
  fill(255);
  text("Once Hearts have been broken, they can be played like any other card.", 160, 465);
  fill(255,0,0);
  ellipse(150,485,7.5,7.5);
  fill(255);
  text("Note: points cannot be played in the first trick!", 160, 485);
  fill(255, 0, 0);
  textSize(20);
  text("Game End:", 100, 515);
  fill(255,0,0);
  textSize(16);
  ellipse(150,535,7.5,7.5);
  fill(255);
  text("The game ends once one or more players reach 100 points.", 160, 535);
  fill(255,0,0);
  ellipse(150,555,7.5,7.5);
  fill(255);
  text("The player with the least amount of points is the winner!", 160, 555);

  for (Button b : rulesButtons) {
    b.draw();
  }
}

void gameDisplay() {
  background(greenFeltBackground);
  //displays heartsBroken
  heartsBrokenAnimation();
  displaySouth.draw();
  displayNorth.draw();
  displayEast.draw();
  displayWest.draw();
  drawPlayedCards();
  fill(255, 255, 255);
  textAlign(CENTER);
  if (passingCards) {
    fill(0, 0, 0, 150);
    noStroke();
    rectMode(CENTER);
    rect(width/2, height/2, width-400, height-350);
    rectMode(CORNER);
    textSize(30);
    fill(255, 0, 0);
    stroke(255, 0, 0);
    text("Select 3 cards to pass", width / 2, 225);
    fill(255);
    stroke(255);
    textSize(20);
    text("Click or use the LEFT and RIGHT arrow keys", width/2, 275);
    text("to highlight a card", width/2, 300);
    text("Select highlighted cards", width/2, 350);
    text("with the UP arrow key", width/2, 375);
    text("Deselect selected cards", width/2, 425);
    text("with the DOWN arrow key", width/2, 450);
    text("Press ENTER to pass the selected cards", width/2, 500);

    fill(255, 0, 0);
    stroke(255, 0, 0);
    text("Click", width/2-186, 275);
    text("LEFT", width/2-31.10, 275);
    text("RIGHT", width/2+69.35, 275);
    text("highlight", width/2-20, 300);
    text("Select", width/2-87.5, 350);
    text("UP", width/2-8.15, 375);
    text("Deselect", width/2-72.08, 425);
    text("DOWN", width/2-8, 450);
    text("ENTER", width/2-99.75, 500);
    text("pass", width/2-16, 500);
    fill(255);
    stroke(255);
  }
  if (!passingCards && south.hand.size()==13 && currentPlayer.playerNumber==SOUTH) {
    text("Play highlighted cards", width/2, 200);
    text("with the UP arrow key", width/2, 225);
    fill(255, 0, 0);
    stroke(255, 0, 0);
    text("Play", width/2-87.75, 200);
    text("UP", width/2-8.15, 225);
    fill(255);
    stroke(255);
  }
  textSize(20);
  text("Points: " + north.points, width / 2 - 70, 27);
  text("Total: " + north.totalPoints, width / 2 + 70, 27);
  text("Points: " + south.points, width / 2 - 70, height - 13);
  text("Total: " + south.totalPoints, width / 2 + 70, height - 13);
  textAlign(LEFT);
  text("Points: " + west.points, 10, height / 2 - 15);
  text("Total: " + west.totalPoints, 10, height / 2 + 15);
  textAlign(RIGHT);
  text("Points: " + east.points, width - 10, height / 2 - 15);
  text("Total: " + east.totalPoints, width - 10, height / 2 + 15);

  for (Button b : gameButtons) {
    b.draw();
  }
}

void takeTrick() {
  Player trickWinner = startingPlayer;
  for (int i = 0; i < 4; i++) {
    if (playedCards[i].suit == playedCards[trickWinner.playerNumber].suit && compareCards(playedCards[i], playedCards[trickWinner.playerNumber]) > 0) {
      trickWinner = getPlayer(i);
    }
  }
  if (dx==0 && dy==0) {
    for (int i=0; i<4; i++) {
      trickWinner.addCardWon(playedCards[i]);
    }
  }
  if (trickWinner.playerNumber==SOUTH) {
    dy+=20;
  } else if (trickWinner.playerNumber==NORTH) {
    dy-=20;
  } else if (trickWinner.playerNumber==EAST) {
    dx+=20;
  } else {
    dx-=20;
  }
  startingPlayer = trickWinner;
  currentPlayer = trickWinner;
}

void resetPlayedCards() {
  for (int i=0; i<4; i++) {
    playedCards[i]=new Card(0, 0);
  }
}

void keyPressed() {
  if (screen==GAME) {
    ////card selection
    if (keyCode==RIGHT) {
      displaySouth.selectRight();
    }
    if (keyCode==LEFT) {
      displaySouth.selectLeft();
    }
    if (keyCode==UP) {
      if (passingCards) {
        Card card = south.hand.get(cardSelected);
        if (south.cardsToPass.size() < 3 && !south.cardsToPass.contains(card)) {
          south.cardsToPass.add(card);
        }
      } else {
        if (currentPlayer == south) {
          south.playCard(cardSelected, true);
        }
      }
    }
    if (keyCode==DOWN) {
      if (passingCards) {
        Card card = south.hand.get(cardSelected);
        if (south.cardsToPass.contains(card)) {
          south.cardsToPass.remove(card);
        }
      }
    }
    if (keyCode == ENTER) {
      if (passingCards && south.cardsToPass.size() == 3) {
        passCards();
        passingCards = false;
      }
      if (displayingResults) {
        displayingResults = false;
        newRound();
      }
    }
  } else if (screen==DIRECTIONS) {
    //to exit (later scroll through) directions
    //if (keyCode==ENTER) {
    //screen = MENU;
    //}
  }
}

void mouseClicked() {
  if (screen==MAIN) {
    if (mainButtons[0].hoveredOver()) {//newGame
      setup();
      screen = GAME;
    } else if (mainButtons[1].hoveredOver()) {//showRules
      screen = RULES;
    }
  }
  if (screen==GAME) {
    displaySouth.click();
    if (gameButtons[0].hoveredOver()) {//menuButton
      screen=MENU;
    }
  }
  if (screen==MENU) {
    if (menuButtons[0].hoveredOver()) {//leaveGame
      screen = MAIN;
    }
    if (menuButtons[1].hoveredOver()) {//resumeGAme
      screen=GAME;
    }
    if (menuButtons[2].hoveredOver()) {//showDirections
      screen=DIRECTIONS;
    }
  }
  if (screen==DIRECTIONS) {
    if (directionsButtons[0].hoveredOver()) {//backToMenu
      screen = MENU;
    }
  }
  if (screen==RULES) {
    if (rulesButtons[0].hoveredOver()) {//mainMenu
      screen = MAIN;
    }
  }
}

//Creates the deck
void setDeck() {
  for (int i = 1; i <= 13; i++) {
    for (int j = 0; j < 4; j++) {
      deck.add(new Card(i, j));
    }
  }
}


//Separates the deck into 4 hands
void deal() {
  while (deck.size () > 0) {
    Card randomCard = deck.remove((int)random(deck.size()));
    int playerDealtTo = deck.size() % 4;
    if (randomCard.number == 2 && randomCard.suit == CLUBS) {
      currentPlayer = getPlayer(playerDealtTo);
      startingPlayer = currentPlayer;
    }
    if (playerDealtTo == NORTH) {
      north.addCard(randomCard);
    } else if (playerDealtTo == SOUTH) {
      south.addCard(randomCard);
    } else if (playerDealtTo == EAST) {
      east.addCard(randomCard);
    } else {
      west.addCard(randomCard);
    }
  }
}

//displays cards played by all four players;
void drawPlayedCards() {
  int x = 0 +dx;
  int y = 0 +dy;
  if (playedCards[1].number!=0) {
    x = width/2 + dx;
    y = height/2 + 50 + dy;
    displaySouth.cardFront(x, y, playedCards[1].number, playedCards[1].suit);
  }
  if (playedCards[0].number!=0) {
    x = width/2 + dx;
    y = height/2 - 50 + dy;
    displayNorth.cardFront(x, y, playedCards[0].number, playedCards[0].suit);
  }
  if (playedCards[2].number!=0) {
    x = width/2 + 50 + dx;
    y = height/2 + dy;
    displayEast.cardFront(x, y, playedCards[2].number, playedCards[2].suit);
  }
  if (playedCards[3].number!=0) {
    x = width/2 - 50 + dx;
    y = height/2 + dy;
    displayWest.cardFront(x, y, playedCards[3].number, playedCards[3].suit);
  }
}

Player getPlayer(int num) {
  if (num == NORTH) {
    return north;
  } else if (num == SOUTH) {
    return south;
  } else if (num == EAST) {
    return east;
  } else {
    return west;
  }
}

String getPlayerString(int num) {
  if (num == NORTH) {
    return "North";
  } else if (num == SOUTH) {
    return "South";
  } else if (num == EAST) {
    return "East";
  } else {
    return "West";
  }
}

Player getNextPlayer(Player current) {
  if (current == north) {
    return east;
  } else if (current == east) {
    return south;
  } else if (current == south) {
    return west;
  } else {
    return north;
  }
}

int compareCards(Card first, Card second) {
  int firstNumber = first.number;
  int secondNumber = second.number;
  if (firstNumber == 1) {
    firstNumber = 14;
  }
  if (secondNumber == 1) {
    secondNumber = 14;
  }
  return firstNumber - secondNumber;
}

//Breaks hearts (later this may lead to a more complicated display)
void breakHearts() {
  heartsBroken = true;
  displaySouth.heartBigBroken(width/2, height/2, 0);
}

void heartsBrokenAnimation() {
  if (heartsBroken) {
    int dist = count;
    if (count<=300) {
      dist = 0;
    } else if (count<=1000) {
      dist = 25;
    } else {
      dist = count-975;
    }
    count+=15;
    displaySouth.heartBigBroken(width/2, height/2, dist);
  }
}

void roundResults() {
  int roundWinner = 0;
  //If a player shot the moon, is set to the player's number
  int moonShotBy = -1;
  for (int i = 0; i < 4; i++) {
    if (getPlayer(i).points == 26) {
      moonShotBy = i;
      roundWinner = i;
    }
    if (moonShotBy == -1 && getPlayer(i).points < getPlayer(roundWinner).points) {
      roundWinner = i;
    }
  }
  if (moonShotBy != -1) {
    for (int i = 0; i < 4; i++) {
      if (i == moonShotBy) {
        getPlayer(i).points -= 26;
        getPlayer(i).totalPoints -= 26;
      } else {
        getPlayer(i).points += 26;
        getPlayer(i).totalPoints += 26;
      }
    }
  }
  String roundWinnerString = getPlayerString(roundWinner);
  for (int i = 0; i < 4; i++) {
    if (i != roundWinner && getPlayer(i).points == getPlayer(roundWinner).points) {
      roundWinnerString += " and " + getPlayerString(i);
    }
  }
  if ((north.totalPoints >= 100 || south.totalPoints >= 100 || east.totalPoints >= 100 || west.totalPoints >= 100) && !gameTied()) {
    gameFinished = true;
    gameResults(roundWinnerString);
  } else {
    displayRoundResults(roundWinnerString);
  }
}

void displayRoundResults(String winner) {
  fill(0, 200, 0);
  stroke(255, 255, 255);
  rectMode(CORNER);
  rect(width / 2 - 200, height / 2 - 150, 400, 300);
  fill(255, 255, 255);
  textSize(24);
  textAlign(CENTER);
  text("Round winner: " + winner, width / 2, 230);
  line(600, 255, 600, 455);
  line(530, 255, 530, 455);
  line(460, 255, 460, 455);
  line(390, 255, 390, 455);
  line(320, 255, 320, 455);
  line(250, 455, 600, 455);
  line(250, 388, 600, 388);
  line(250, 321, 600, 321);
  textSize(20);
  text("North", 355, 295);
  text("South", 425, 295);
  text("East", 495, 295);
  text("West", 565, 295);
  text("Round\nPoints", 285, 345);
  text("Total\nPoints", 285, 412);
  text("" + north.points, 355, 360);
  text("" + south.points, 425, 360);
  text("" + east.points, 495, 360);
  text("" + west.points, 565, 360);
  text("" + north.totalPoints, 355, 427);
  text("" + south.totalPoints, 425, 427);
  text("" + east.totalPoints, 495, 427);
  text("" + west.totalPoints, 565, 427);
  text("Press enter to go to the next round", width / 2, 490);
}

void newRound() {
  if (gameFinished) {
    setup();
    screen = GAME;
  } else {
    count = 0;
    for (int i = 0; i < 4; i++) {
      getPlayer(i).resetPlayer();
    }
    displaySouth = new CardDisplay(south);
    displayNorth = new CardDisplay(north);
    displayEast = new CardDisplay(east);
    displayWest = new CardDisplay(west);
    cardSelected = 12;
    setDeck();
    deal();
    firstPlayed = false;
    turnPending = false;
    lastPlayed = 0;
    willReset = false;
    heartsBroken = false;
    displayingResults = false;
    gameFinished = false;
    roundNumber++;
    if (roundNumber % 4 == 3) {
      passingCards = false;
    } else {
      passingCards = true;
    }
    messageDisplayed = false;
    message = "";
  }
}

void gameResults(String roundWinner) {
  int gameWinner = 0;
  for (int i = 1; i < 4; i++) {
    if (getPlayer(i).totalPoints < getPlayer(gameWinner).totalPoints) {
      gameWinner = i;
    }
  }
  String gameWinnerString = getPlayerString(gameWinner);
  displayGameResults(roundWinner, gameWinnerString);
}

void displayGameResults(String roundWinner, String gameWinner) {
  fill(0, 200, 0);
  stroke(255, 255, 255);
  rect(width / 2 - 200, height / 2 - 150, 400, 330);
  textAlign(CENTER);
  fill(0, 0, 255);
  textSize(28);
  text("Game winner: " + gameWinner, width / 2, 230);
  fill(255, 255, 255);
  textSize(24);
  text("Round winner: " + roundWinner, width / 2, 260);
  line(600, 285, 600, 485);
  line(530, 285, 530, 485);
  line(460, 285, 460, 485);
  line(390, 285, 390, 485);
  line(320, 285, 320, 485);
  line(250, 485, 600, 485);
  line(250, 418, 600, 418);
  line(250, 351, 600, 351);
  textSize(20);
  text("North", 355, 325);
  text("South", 425, 325);
  text("East", 495, 325);
  text("West", 565, 325);
  text("Round\nPoints", 285, 375);
  text("Total\nPoints", 285, 442);
  text("" + north.points, 355, 390);
  text("" + south.points, 425, 390);
  text("" + east.points, 495, 390);
  text("" + west.points, 565, 390);
  text("" + north.totalPoints, 355, 457);
  text("" + south.totalPoints, 425, 457);
  text("" + east.totalPoints, 495, 457);
  text("" + west.totalPoints, 565, 457);
  text("Press enter to play again", width / 2, 520);
}

boolean gameTied() {
  int winningPlayer = 0;
  for (int i = 1; i < 4; i++) {
    if (getPlayer(i).totalPoints < getPlayer(winningPlayer).totalPoints) {
      winningPlayer = i;
    }
  }
  for (int i = 0; i < 4; i++) {
    if (i != winningPlayer && getPlayer(i).totalPoints == getPlayer(winningPlayer).totalPoints) {
      return true;
    }
  }
  return false;
}

void pickPassingCards() {
  for (int i = 0; i < 4; i++) {
    if (i != 1) {
      Player current = getPlayer(i);
      //while (current.cardsToPass.size () < 3) {
      //  Card card = current.hand.get((int)random(current.hand.size()));
      //  if (!current.cardsToPass.contains(card)) {
      //    current.cardsToPass.add(card);
      //  }
      current.pickPassingCards();
    }
  }
}


void passCards() {
  for (int n=0; n<3; n++) {
    boolean nFound = false;
    boolean eFound = false;
    boolean wFound = false;
    for (int i=0; i<13-n; i++) {
      if (!nFound) {
        if (north.hand.get(i)==null) {
          north.hand.remove(i);
          nFound=true;
        }
      }
      if (!eFound) {
        if (east.hand.get(i)==null) {
          east.hand.remove(i);
          eFound=true;
        }
      }
      if (!wFound) {
        if (west.hand.get(i)==null) {
          west.hand.remove(i);
          wFound=true;
        }
      }
    }
  }
  if (roundNumber % 4 == 0) {
    passCards(north, east);
    passCards(east, south);
    passCards(south, west);
    passCards(west, north);
  } else if (roundNumber % 4 == 1) {
    passCards(north, west);
    passCards(west, south);
    passCards(south, east);
    passCards(east, north);
  } else if (roundNumber % 4 == 2) {
    passCards(north, south);
    passCards(south, north);
    passCards(east, west);
    passCards(west, east);
  }
}

void passCards(Player from, Player to) {
  for (int i = 0; i < 3; i++) {
    Card card = from.cardsToPass.remove(0);
    if (card.number == 2 && card.suit == CLUBS) {
      currentPlayer = to;
      startingPlayer = to;
    }
    from.hand.remove(card);
    to.addCard(card);
  }
}

