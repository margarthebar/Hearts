//time thingy
long time = 0;
long timeWhenDone = 0;
long timeWhenCleared = 0;
int count = 0;
long realTime = 0;

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
  time = 2000 + millis();
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
}

void draw() {
  background(0, 100, 0);
  //displays cards
  displaySouth.draw();
  displayNorth.draw();
  displayEast.draw();
  displayWest.draw();
  drawPlayedCards();
  //
  //  //play cards
  //  //if all four, set timeWhenDone
  //  if (timeWhenDone==0) {
  //    if (playedCards[0].number!=0 && playedCards[1].number!=0 && playedCards[2].number!=0 && playedCards[3].number!=0) {
  //      timeWhenDone = realTime;
  //      println("done");
  //    }
  //  }
  //  //if millis()>=timeWhenDone+1000, clear, reset timeWhenDone, set timeWhenCleared
  //  if (timeWhenDone>0 && realTime>=timeWhenDone+1000) {
  //    resetPlayedCards();
  //    timeWhenDone = 0;
  //    timeWhenCleared = time;
  //  }
  //  //if millis()==timeWhenCleared+1000, play
  //  if ((timeWhenCleared>0 && realTime>=timeWhenCleared+1000) || (timeWhenCleared==0 && realTime>=time+400)) {
  //    if (currentPlayer != south) {
  //      currentPlayer.playCard((int)random(currentPlayer.hand.size()));
  //    }
  //    timeWhenCleared = 0;
  //    time = realTime;
  //  }
  //  if(currentPlayer!=south){
  //    realTime=millis();
  //  }

  long timeNow = time;
  boolean reset=false;
  if (!myWait(time, 800)) {
    if (playedCards[0].number!=0 && playedCards[1].number!=0 && playedCards[2].number!=0 && playedCards[3].number!=0) {
      if (!myWait(timeNow, 600)) {
        resetPlayedCards();
        reset = true;
      }
    }
    if (reset) {
      if (!myWait(timeNow, 2000)) {
        if (currentPlayer != south) {
          currentPlayer.playCard((int)random(currentPlayer.hand.size()));
        }
        time = millis();
        reset = false;
      }
    } else {
      if (!myWait(timeNow, 1500)) {
        if (currentPlayer != south) {
          currentPlayer.playCard((int)random(currentPlayer.hand.size()));
        }
        time = millis();
      }
    }
  }
}

void resetPlayedCards() {
  for (int i=0; i<4; i++) {
    playedCards[i]=new Card(0, 0);
  }
}

boolean myWait(long startTime, long howLong) {
  return millis()-startTime < howLong;
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
    south.playCard(cardSelected);
  }
}

void mouseClicked() {
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

