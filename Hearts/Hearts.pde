CardDisplay display;
ArrayList<Card> deck; //The deck of cards
//The 4 players
Player south;
Player north;
Player east;
Player west;

void setup() {
  size(700, 700);
  background(0, 100, 0);
  deck = new ArrayList();
  south = new Player();
  north = new Player();
  east = new Player();
  west = new Player();
  setDeck();
  deal();
  display = new CardDisplay(south.hand);
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
    south.addCard(deck.remove((int)random(deck.size())));
    north.addCard(deck.remove((int)random(deck.size())));
    east.addCard(deck.remove((int)random(deck.size())));
    west.addCard(deck.remove((int)random(deck.size())));
  }
}

