CardDisplay display;
ArrayList<Card> deck; //The deck of cards

void setup() {
  size(700, 700);
  background(0, 100, 0);
  deck = new ArrayList();
  setDeck();
  display = new CardDisplay();
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

void setDeck() {
  for (int i = 1; i <= 13; i++) {
    for (int j = 0; j < 4; j++) {
      deck.add(new Card(i, j));
    }
  }
}

