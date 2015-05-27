CardDisplay displaySouth;
CardDisplay displayNorth;
CardDisplay displayEast;
CardDisplay displayWest;
ArrayList<Card> deck; //The deck of cards
//The hands for the 4 players
ArrayList<Card> southHand;
ArrayList<Card> northHand;
ArrayList<Card> eastHand;
ArrayList<Card> westHand;
int NORTH = 0;
int SOUTH = 1;
int EAST = 2;
int WEST = 3;
Card[] cardsPlayed;
int cardTurn = 13;

void setup() {
  size(700, 700);
  background(0, 100, 0);
  deck = new ArrayList();
  southHand = new ArrayList();
  northHand = new ArrayList();
  eastHand = new ArrayList();
  westHand = new ArrayList();
  cardsPlayed = new Card[4];
  setDeck();
  deal();
  displaySouth = new CardDisplay(southHand, SOUTH);
  displayNorth = new CardDisplay(northHand, NORTH);
  displayEast = new CardDisplay(eastHand, EAST);
  displayWest = new CardDisplay(westHand, WEST);
}

void draw() {
  background(0, 100, 0);
  //displays cards
  displaySouth.draw();
  displayNorth.draw();
  displayEast.draw();
  displayWest.draw();
  playedCards();
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
    int cs = displaySouth.cardSelected;
    int nc = displaySouth.numCards;
    displayNorth.cardSelected = cardTurn-1;
    displayNorth.numCards = cardTurn;
    displayEast.cardSelected = cardTurn-1;
    displayEast.numCards = cardTurn;
    displayWest.cardSelected = cardTurn-1;
    displayWest.numCards = cardTurn;

    displaySouth.playCard();
    displayNorth.playCard();
    displayEast.playCard();
    displayWest.playCard();

    cardTurn --;
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
    southHand.add(deck.remove((int)random(deck.size())));
    northHand.add(deck.remove((int)random(deck.size())));
    eastHand.add(deck.remove((int)random(deck.size())));
    westHand.add(deck.remove((int)random(deck.size())));
  }
}

//displays cards played by all four players;
void playedCards() {
  int x = 0;
  int y = 0;
  if (cardsPlayed[1]!=null) {
    x = width/2;
    y = height/2 + 50;
    displaySouth.cardFront(x, y, cardsPlayed[1].number, cardsPlayed[1].suit);
  }
  if (cardsPlayed[0]!=null) {
    x = width/2;
    y = height/2 - 50;
    displayNorth.cardFront(x, y, cardsPlayed[0].number, cardsPlayed[0].suit);
  }
  if (cardsPlayed[2]!=null) {
    x = width/2 + 50;
    y = height/2;
    displayEast.cardFront(x, y, cardsPlayed[2].number, cardsPlayed[2].suit);
  }
  if (cardsPlayed[3]!=null) {
    x = width/2 - 50;
    y = height/2;
    displayWest.cardFront(x, y, cardsPlayed[3].number, cardsPlayed[3].suit);
  }
}

