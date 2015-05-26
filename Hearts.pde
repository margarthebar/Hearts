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
ArrayList<Card> cardsPlayed;

void setup() {
  size(700, 700);
  background(0, 100, 0);
  deck = new ArrayList();
  southHand = new ArrayList();
  northHand = new ArrayList();
  eastHand = new ArrayList();
  westHand = new ArrayList();
  cardsPlayed = new ArrayList();
  setDeck();
  deal();
  displaySouth = new CardDisplay(southHand, 1);
  displayNorth = new CardDisplay(northHand, NORTH);
  displayEast = new CardDisplay(eastHand, EAST);
  displayWest = new CardDisplay(westHand, WEST);
}

void draw() {
  background(0,100,0);
  //displays cards
  displaySouth.draw();
  displayNorth.draw();
  displayEast.draw();
  displayWest.draw();
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
    displaySouth.playCard();
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
void deal(){
  while (deck.size() > 0){
    southHand.add(deck.remove((int)random(deck.size())));
    northHand.add(deck.remove((int)random(deck.size())));
    eastHand.add(deck.remove((int)random(deck.size())));
    westHand.add(deck.remove((int)random(deck.size())));
  }
}

