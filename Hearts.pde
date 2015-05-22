int cardWidth;
int cardHeight;
int numCards;

void setup() {
  size(700, 700);
  background(0, 100, 0);
  cardWidth = 50;
  cardHeight = 70;
  numCards = 1;
}

void draw() {
  for (int i=0; i<13; i++) {
    //could be a draw method in the card class?
    //cardBack(145+(i*30), 550);
  }

  rectMode(CENTER);
  //rect(width/2-15,550,cardWidth,cardHeight);
  //rect(width/2+15,550,cardWidth,cardHeight);
  //cardBack(width/2-15,550);
  int cardsWidth = cardWidth + (numCards-1)*30;
  for (int i=0; i<numCards; i++) {
    int x = width/2 - cardsWidth/2 + i*30;
    cardBack(x, 550);
  }
  rectMode(CORNER);
}

//varying in orientation based on player
void cardBack(float x, float y) {
  boolean redFirst = true;
  rectMode(CENTER);
  for (float j=3.5; j<66.5; j+=3.5) {
    for (float i=5; i<45; i+=5) {
      if (redFirst) {
        fill(195, 0, 0);
        stroke(195, 0, 0);
        rect(x-cardWidth/2+i+2, y-cardHeight/2+j+2, 2.5, 3.5);
        fill(255);
        stroke(255);
        rect(x-cardWidth/2+i+2.5+2, y-cardHeight/2+j+2, 2.5, 3.5);
      } else {
        fill(255);
        stroke(255);
        rect(x-cardWidth/2+i+2, y-cardHeight/2+j+2, 2.5, 3.5);
        fill(195, 0, 0);
        stroke(195, 0, 0);
        rect(x-cardWidth/2+i+2.5+2, y-cardHeight/2+j+2, 2.5, 3.5);
      }
    }
    redFirst = !redFirst;
  }
  noFill();
  //  stroke(0, 100, 0);
  //  rect(x, y, 50, 70);
  stroke(255);
  rect(x, y, 50, 70, 6, 6, 6, 6);
  rect(x, y, 48, 68, 6, 6, 6, 6);
  rect(x, y, 46, 66, 6, 6, 6, 6);
  rect(x, y, 44, 64, 6, 6, 6, 6);
  stroke(195, 0, 0);
  strokeWeight(1);
  rect(x, y, 42, 62);
  rect(x, y, 40, 60);
  strokeWeight(1);
  stroke(0);
  rectMode(CORNER);
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

