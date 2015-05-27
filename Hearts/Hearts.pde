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
//The number of the player that will start (is dealt the 2 of clubs)
int startingPlayer;


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
}

void draw() {
  background(0, 100, 0);
  //displays cards
  displaySouth.draw();
  displayNorth.draw();
  displayEast.draw();
  displayWest.draw();
  drawPlayedCards();
//  println(playedCards[0].number + " " + playedCards[0].suit);
//  println(playedCards[1].number + " " + playedCards[1].suit);
//  println(playedCards[2].number + " " + playedCards[2].suit);
//  println(playedCards[3].number + " " + playedCards[3].suit);
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
    println("cardSelected"+cardSelected);
    south.playCard(cardSelected, true);
    //For now, plays a random card from each opponent's hand
    north.playCard((int)random(north.hand.size()), false);
    east.playCard((int)random(east.hand.size()), false);
    west.playCard((int)random(west.hand.size()), false);
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
      startingPlayer = playerDealtTo;
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
    x = width/2 - 50;
    y = height/2;
    displayEast.cardFront(x, y, playedCards[2].number, playedCards[2].suit);
  }
  if (playedCards[3].number!=0) {
    x = width/2 + 50;
    y = height/2;
    displayWest.cardFront(x, y, playedCards[3].number, playedCards[3].suit);
  }
}
