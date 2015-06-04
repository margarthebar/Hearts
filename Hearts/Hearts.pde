//Time
int time;

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
//The number of the card that has most recently been played
int lastPlayed;
//Whether the played cards are about to be reset
boolean willReset;
//The Player that starts the trick
Player startingPlayer;
//Whether hearts have been broken or not
boolean heartsBroken;

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
  size(700, 700);
  background(0, 100, 0);
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
}

void draw() {
  background(0, 100, 0);
  //displays cards
  displaySouth.draw();
  displayNorth.draw();
  displayEast.draw();
  displayWest.draw();
  drawPlayedCards();
  //println("North: " + playedCards[0] + "  South: " + playedCards[1] + "  East: " + playedCards[2] + "  West: " + playedCards[3] + "  HeartsBroken: " + heartsBroken); 
  if (currentPlayer != south && !willReset) {
    if (turnPending) {
      currentPlayer.playCard(lastPlayed, false);
    } else {
      currentPlayer.playCard((int)random(currentPlayer.hand.size()), false);
    }
  }
  if (playedCards[0].number!=0 && playedCards[1].number!=0 && playedCards[2].number!=0 && playedCards[3].number!=0) {
    if (!willReset) {
      willReset = true;
      time = millis();
    }
    if (time + 1200 < millis()) {
      willReset = false;
      resetPlayedCards();
      println("North: " + north.points + "  South: " + south.points + "  East: " + east.points + "  West: " + west.points);
    }
  }
  if (!willReset && north.hand.size() == 0 && south.hand.size() == 0 && east.hand.size() == 0 && west.hand.size() == 0) {
    roundResults();
  }
}

void resetPlayedCards() {
  //println("North: " + playedCards[0] + "  South: " + playedCards[1] + "  East: " + playedCards[2] + "  West: " + playedCards[3] + " HeartsBroken: " + heartsBroken); 
  Player trickWinner = startingPlayer;
  for (int i = 0; i < 4; i++) {
    if (playedCards[i].suit == playedCards[trickWinner.playerNumber].suit && compareCards(playedCards[i], playedCards[trickWinner.playerNumber]) > 0) {
      trickWinner = getPlayer(i);
    }
  }
  for (int i=0; i<4; i++) {
    trickWinner.addCardWon(playedCards[i]);
    playedCards[i]=new Card(0, 0);
  }
  startingPlayer = trickWinner;
  currentPlayer = trickWinner;
}

void keyPressed() {
  ////card selection
  if (keyCode==RIGHT) {
    displaySouth.selectRight();
  }
  if (keyCode==LEFT) {
    displaySouth.selectLeft();
  }
  if (keyCode==UP) {
    if (currentPlayer == south) {
      south.playCard(cardSelected, true);
    }
  }
}

void mouseClicked() {
  displaySouth.click();
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
  int x = 0;
  int y = 0;
  if (playedCards[1].number!=0) {
    x = width/2;
    y = height/2 + 50;
    displaySouth.cardFront(x, y, playedCards[1].number, playedCards[1].suit);
  }
  if (playedCards[0].number!=0) {
    x = width/2;
    y = height/2 - 50;
    displayNorth.cardFront(x, y, playedCards[0].number, playedCards[0].suit);
  }
  if (playedCards[2].number!=0) {
    x = width/2 + 50;
    y = height/2;
    displayEast.cardFront(x, y, playedCards[2].number, playedCards[2].suit);
  }
  if (playedCards[3].number!=0) {
    x = width/2 - 50;
    y = height/2;
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
  println("Hearts have been broken!");
  heartsBroken = true;
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
    getPlayer(i).totalPoints += getPlayer(i).points;   
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
  for (int i = 0; i < 4; i++){
    if (i != roundWinner && getPlayer(i).points == getPlayer(roundWinner).points){
      roundWinnerString += " and " + getPlayerString(i);
    }
  }
  //Display results for the round and overall (later this will be displayed inside the game)
  println("\nRound winner: " + roundWinnerString);
  println("\nRound points:");
  println("   North: " + getPlayer(NORTH).points);
  println("   South: " + getPlayer(SOUTH).points);
  println("   East: " + getPlayer(EAST).points);
  println("   West: " + getPlayer(WEST).points);
  if ((north.totalPoints >= 100 || south.totalPoints >= 100 || east.totalPoints >= 100 || west.totalPoints >= 100) && !gameTied()) {
    gameResults();
  } else {
    println("\nOverall points:");
    println("   North: " + getPlayer(NORTH).totalPoints);
    println("   South: " + getPlayer(SOUTH).totalPoints);
    println("   East: " + getPlayer(EAST).totalPoints);
    println("   West: " + getPlayer(WEST).totalPoints);
    newRound();
  }
}

void newRound() {
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
}

void gameResults() {
  int gameWinner = 0;
  for (int i = 1; i < 4; i++) {
    if (getPlayer(i).totalPoints < getPlayer(gameWinner).totalPoints) {
      gameWinner = i;
    }
  }
  //Display results for the game (will be displayed inside the game later)
  println("\nGame Winner: " + getPlayerString(gameWinner));
  println("\nFinal points:");
  println("   North: " + getPlayer(NORTH).totalPoints);
  println("   South: " + getPlayer(SOUTH).totalPoints);
  println("   East: " + getPlayer(EAST).totalPoints);
  println("   West: " + getPlayer(WEST).totalPoints);
  setup();
}

boolean gameTied(){
  int winningPlayer = 0;
  for (int i = 1; i < 4; i++){
    if (getPlayer(i).totalPoints < getPlayer(winningPlayer).totalPoints){
      winningPlayer = i;
    }
  }
  for (int i = 0; i < 4; i++){
    if (i != winningPlayer && getPlayer(i).totalPoints == getPlayer(winningPlayer).totalPoints){
      return true;
    }
  }
  return false;
}

