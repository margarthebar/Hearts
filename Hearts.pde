void setup() {
  size(700, 700);
  background(0, 100, 0);
}

void draw() {
  for (int i=0; i<13; i++) {
    //could be a draw method in the card class?
    cardBack(145+(i*30), 550);
  }
}

//varying in orientation based on player
void cardBack(float x, float y) {
  boolean redFirst = false;
  for (int j=0; j<70; j+=3.5) {
    for (int i=0; i<50; i+=5) {
      if (redFirst) {
        fill(195, 0, 0);
        rect(x+i, y+j, 2.5, 3.5);
        fill(255);
        rect(x+i+2.5, y+j, 2.5, 3.5);
      } else {
        fill(255);
        rect(x+i, y+j, 2.5, 3.5);
        fill(195, 0, 0);
        rect(x+i+2.5, y+j, 2.5, 3.5);
      }
    }
    redFirst = !redFirst;
  }
  stroke(255);
  strokeWeight(2);
  noFill();
  rect(x, y, 50, 70);
  strokeWeight(1);
  stroke(0);
}

void mouseClicked() {
  for (int i=0; i<13; i++) {
    int cardX = 145+(i*30);
    int cardY = 550;
      if (mouseX>cardX+2 && mouseX<cardX+48 &&
      mouseY>cardY+2 && mouseY<cardY+48) {
      stroke(150,150,0);
      strokeWeight(6);
      noFill();
      rect(cardX-2, cardY-2, 54, 74);
      strokeWeight(1);
      stroke(0);
      print("here");
    }
  }
}

