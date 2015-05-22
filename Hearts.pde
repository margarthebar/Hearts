int cardWidth;
int cardHeight;
int numCards;
boolean selected;
int cardSelected;

void setup() {
  size(700, 700);
  background(0, 100, 0);
  cardWidth = 50;
  cardHeight = 70;
  numCards = 13;
  selected = false;
  cardSelected = numCards-1;
}

void draw() {
  background(0,100,0);
  hand();
}

void hand() {
  rectMode(CENTER);
  int cardsWidth = cardWidth + (numCards-1)*30;
  for (int i=0; i<numCards; i++) {
    int x = width/2 - cardsWidth/2 + i*30;
    if (i==cardSelected) {
      selected = true;
    }
    cardBack(x, 550);
    selected = false;
  }
  rectMode(CORNER);
}

//varying in orientation based on player
void cardBack(float x, float y) {
  boolean redFirst = true;
  rectMode(CENTER);
  if (selected) {
    stroke(200, 200, 0, 200);
    fill(200, 200, 0, 200);
    rect(x, y, 58, 78, 6, 6, 6, 6);
    noFill();
  }
  
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
  rect(x, y, 42, 62);
  rect(x, y, 40, 60);
  stroke(0);
  rectMode(CORNER);
}

void keyPressed() {
  if (keyCode==39) {
    if(cardSelected<numCards-1){
       cardSelected++; 
    }
  }
  if (keyCode==37) {
    if(cardSelected>0){
       cardSelected--; 
    }
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

