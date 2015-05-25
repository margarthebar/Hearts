CardDisplay display;
ArrayList<Card> deck; //The deck of cards
//The hands for the 4 players
ArrayList<Card> southHand;
ArrayList<Card> northHand;
ArrayList<Card> eastHand;
ArrayList<Card> westHand;

void setup() {
  size(700, 700);
  background(0, 100, 0);
  deck = new ArrayList();
  southHand = new ArrayList();
  northHand = new ArrayList();
  eastHand = new ArrayList();
  westHand = new ArrayList();
  setDeck();
  deal();
  display = new CardDisplay(southHand);
}

void draw() {
  //displays cards
  display.draw();
}

void keyPressed() {
  ////card selection
  if (keyCode==RIGHT) {
    display.selectRight();
  }
  if (keyCode==LEFT) {
    display.selectLeft();
  }
  if (keyCode==UP) {
    display.playCard();
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

