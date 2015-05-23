CardDisplay display;

void setup() {
  size(700, 700);
  background(0, 100, 0);
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

