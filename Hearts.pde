int cardWidth;
int cardHeight;
int numCards;
boolean selected;
int cardSelected;
int NORTH = 0;
int SOUTH = 1;
int EAST = 2;
int WEST = 3;

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
  background(0, 100, 0);
  for (int i=0; i<4; i++) {
    hand(i);
  }
}

void hand(int place) {
  rectMode(CENTER);
  int cardsWidth = cardWidth + (numCards-2)*30;
  int cardsHeight = cardHeight + (numCards-3)*30;
  if (place==SOUTH) {
    for (int i=0; i<numCards; i++) {
      int x = width/2 - cardsWidth/2 + i*30 + 15;
      if (i==cardSelected) {
        selected = true;
      }
      cardBack(x, height-75);
      selected = false;
    }
  }else if(place==NORTH){
    for (int i=numCards-1; i>=0; i--) {
      int x = width/2 - cardsWidth/2 + i*30 + 15;
      cardBack(x, 75);
    }
  }else if(place==EAST){
    for (int i=numCards-1; i>=0; i--) {
      int y = height/2 - cardsHeight/2 + i*30;
      cardBack2(width-75, y);
    }
  }else if(place==WEST){
    for (int i=0; i<numCards; i++) {
      int y = height/2 - cardsHeight/2 + i*30;
      cardBack2(75, y);
    }
  }
  rectMode(CORNER);
}

//varying in orientation based on player
void cardBack(float x, float y) {
  rectMode(CENTER);
  cardHighlight(x, y);
  cardChecker(x, y);
  cardBorder(x, y);
}

void cardBack2(float x, float y){
  rectMode(CENTER);
  cardHighlight(x, y);
  cardChecker2(x, y);
  cardBorder2(x, y);
}
void cardHighlight(float x, float y) {
  if (selected) {
    stroke(200, 200, 0, 200);
    fill(200, 200, 0, 200);
    rect(x, y, 58, 78, 6, 6, 6, 6);
    noFill();
  }
}

void cardChecker(float x, float y) {
  boolean redFirst = true;
  float xcor = x-cardWidth/2+2;
  float ycor = y-cardHeight/2+2;
  for (float j=3.5; j<66.5; j+=3.5) {
    for (float i=5; i<45; i+=5) {
      if (redFirst) {
        fill(195, 0, 0);
        stroke(195, 0, 0);
        rect(xcor+i, ycor+j, 2.5, 3.5);
        fill(255);
        stroke(255);
        rect(xcor+i+2.5, ycor+j, 2.5, 3.5);
      } else {
        fill(255);
        stroke(255);
        rect(xcor+i, ycor+j, 2.5, 3.5);
        fill(195, 0, 0);
        stroke(195, 0, 0);
        rect(xcor+i+2.5, ycor+j, 2.5, 3.5);
      }
    }
    redFirst = !redFirst;
  }
}

void cardChecker2(float x, float y) {
  boolean redFirst = true;
  float xcor = x-cardHeight/2+2;
  float ycor = y-cardWidth/2+2;
  for (float j=3.5; j<66.5; j+=3.5) {
    for (float i=5; i<45; i+=5) {
      if (redFirst) {
        fill(195, 0, 0);
        stroke(195, 0, 0);
        rect(xcor+j, ycor+i, 2.5, 3.5);
        fill(255);
        stroke(255);
        rect(xcor+j, ycor+i+3.5, 2.5, 3.5);
      } else {
        fill(255);
        stroke(255);
        rect(xcor+j, ycor+i, 2.5, 3.5);
        fill(195, 0, 0);
        stroke(195, 0, 0);
        rect(xcor+j, ycor+i+3.5, 2.5, 3.5);
      }
    }
    redFirst = !redFirst;
  }
}


void cardBorder2(float x, float y){
  noFill();
  stroke(255);
  rect(x, y, 70, 50, 6, 6, 6, 6);
  rect(x, y, 68, 48, 6, 6, 6, 6);
  rect(x, y, 66, 46, 6, 6, 6, 6);
  rect(x, y, 64, 44, 6, 6, 6, 6);
  stroke(195, 0, 0);
  rect(x, y, 62, 42);
  rect(x, y, 60, 40);
  stroke(0);
  rectMode(CORNER);
}

void cardBorder(float x, float y) {
  noFill();
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
  if (keyCode==RIGHT) {
    if (cardSelected<numCards-1) {
      cardSelected++;
    }
  }
  if (keyCode==LEFT) {
    if (cardSelected>0) {
      cardSelected--;
    }
  }
  if (keyCode==UP) {
    if (cardSelected==numCards-1) {
      cardSelected--;
    }
    numCards--;
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

