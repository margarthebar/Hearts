CardDisplay display;

void setup() {
  size(700, 700);
  background(0, 100, 0);
  display = new CardDisplay();
}

void draw() {
  display.draw(); 
}

void keyPressed() {
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
  //  for (int i=0; i<13; i++) {
  //    int cardX = 145+(i*30);
  //    int cardY = 550;
  //      if (mouseX>cardX+2 && mouseX<cardX+48 &&
  //      mouseY>cardY+2 && mouseY<cardY+48) {
  //      stroke(150,150,0);
  //      strokeWeight(6);
  //      noFill();
  //      rect(cardX-2, cardY-2, 54, 74);
  //      strokeWeight(1);
  //      stroke(0);
  //      print("here");
  //    }
  //  }
}

