int cardWidth;
int cardHeight;
int numCards;
boolean selected;
int cardSelected;
int NORTH = 0;
int SOUTH = 1;
int EAST = 2;
int WEST = 3;
int HEARTS = 0;
int SPADES = 1;
int DIAMONDS = 2;
int CLUBS = 3;
int JACK = 11;
int QUEEN = 12;
int KING = 13;
int ACE = 1;
int[][] cardHand;

void setup() {
  size(700, 700);
  background(0, 100, 0);
  cardWidth = 50;
  cardHeight = 70;
  numCards = 13;
  selected = false;
  cardSelected = numCards-1;
  //this would interact with card class/might not be here, but just for display purposes:
  int[][] cH = {  
    {
      ACE, SPADES
    }
    , 
    {
      2, CLUBS
    }
    , 
    {
      3, HEARTS
    }
    , 
    {
      4, DIAMONDS
    }
    , 
    {
      5, CLUBS
    }
    , 
    {
      6, DIAMONDS
    }
    , 
    {
      7, HEARTS
    }
    , 
    {
      8, SPADES
    }
    , 
    {
      KING, HEARTS
    }
    , 
    {
      10, SPADES
    }
    , 
    {
      JACK, DIAMONDS
    }
    , 
    {
      QUEEN, CLUBS
    }
    , 
    {
      9, HEARTS
    }
  };
  cardHand = cH;
}

void draw() {
  background(0, 100, 0);
  for (int i=0; i<4; i++) {
    hand(i);
  }
}

void heartSmall(float x, float y) {
  fill(195, 0, 0);
  noStroke();
  ellipse(x-1.5, y, 2, 2);
  ellipse(x+1.5, y, 2, 2);
  triangle(x-3, y, x+3, y, x, y+4);
}

void heartSmall2(float x, float y) {
  fill(195, 0, 0);
  noStroke();
  ellipse(x-1.5, y, 2, 2);
  ellipse(x+1.5, y, 2, 2);
  triangle(x-3, y, x+3, y, x, y-4);
}

void heart(float x, float y) {
  fill(195, 0, 0);
  noStroke();
  ellipse(x-1.75, y, 3.5, 3.5);
  ellipse(x+1.75, y, 3, 3);
  triangle(x-3.5, y, x+3.5, y, x, y+5);
}

void heart2(float x, float y) {
  fill(195, 0, 0);
  noStroke();
  ellipse(x-1.75, y, 3.5, 3.5);
  ellipse(x+1.75, y, 3.5, 3.5);
  triangle(x-3.5, y, x+3.5, y, x, y-5);
}

void nine(float x, float y, int suit) {
  if (suit==HEARTS) {
    heart(x, y);
    heart(x-7, y-10);
    heart(x+7, y-10);
    heart(x-7, y-20);
    heart(x+7, y-20);
    heart2(x-7, y+10);
    heart2(x+7, y+10);
    heart2(x-7, y+20);
    heart2(x+7, y+20);
    heartSmall(x-17, y-18);
    heartSmall2(x+17, y+18);
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
      cardFront(x, height-75, cardHand[i][0], cardHand[i][1]);
      selected = false;
    }
  } else if (place==NORTH) {
    for (int i=numCards-1; i>=0; i--) {
      int x = width/2 - cardsWidth/2 + i*30 + 15;
      cardBack(x, 75);
    }
  } else if (place==EAST) {
    for (int i=numCards-1; i>=0; i--) {
      int y = height/2 - cardsHeight/2 + i*30;
      cardBack2(width-75, y);
    }
  } else if (place==WEST) {
    for (int i=0; i<numCards; i++) {
      int y = height/2 - cardsHeight/2 + i*30;
      cardBack2(75, y);
    }
  }
  rectMode(CORNER);
}

void symbols(float x, float y, int number, int suit) {
  if (number==ACE) {
    nine(x, y, HEARTS);
  } else if (number==1) {
  } else if (number==2) {
  } else if (number==3) {
  } else if (number==4) {
  } else if (number==5) {
  } else if (number==6) {
  } else if (number==7) {
  } else if (number==8) {
  } else if (number==9) {
    nine(x,y,suit);
  } else if (number==10) {
  } else if (number == JACK) {
  } else if (number == QUEEN) {
  } else if (number == KING) {
  }
}

void cardFront(float x, float y, int number, int suit) {
  rectMode(CENTER);
  cardHighlight(x, y);
  cardBorder(x, y);
  rectMode(CENTER);
  stroke(255);
  fill(255);
  rect(x, y, 43, 63);
  stroke(0);
  fill(CORNER);
  cardContent(x, y, number, suit);
}

void cardContent(float x, float y, int number, int suit) {
  textSize(12);
  textAlign(CENTER, CENTER);
  if (suit==SPADES || suit==CLUBS) {
    fill(0);
    stroke(0);
  } else {
    symbols(x, y,number,suit);
    fill(195, 0, 0);
    stroke(195, 0, 0);
  }
  if (number==JACK) {
    translate(width/2, height/2);
    rotate(radians(180));
    text("J", -204+((13-numCards)*15), -304);
    translate(width/2, height/2);
    rotate(radians(180));
    text("J", x-cardWidth/2+8, y-cardHeight/2+8);
  } else if (number==QUEEN) {
    translate(width/2, height/2);
    rotate(radians(180));
    text("Q", -204+((13-numCards)*15), -304);
    translate(width/2, height/2);
    rotate(radians(180));
    text("Q", x-cardWidth/2+8, y-cardHeight/2+8);
  } else if (number==KING) {
    translate(width/2, height/2);
    rotate(radians(180));
    text("K", -204+((13-numCards)*15), -304);
    translate(width/2, height/2);
    rotate(radians(180));
    text("K", x-cardWidth/2+8, y-cardHeight/2+8);
  } else {
    translate(width/2, height/2);
    rotate(radians(180));
    text(""+number, -203+((13-numCards)*15), -303);
    translate(width/2, height/2);
    rotate(radians(180));
    text(""+number, x-cardWidth/2+8, y-cardHeight/2+8);
  }
}

void cardBack(float x, float y) {
  rectMode(CENTER);
  cardHighlight(x, y);
  cardChecker(x, y);
  cardBorder(x, y);
}

void cardBack2(float x, float y) {
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


void cardBorder2(float x, float y) {
  noFill();
  stroke(100);
  rect(x, y, 72, 52, 6, 6, 6, 6);
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
  stroke(100);
  rect(x, y, 52, 72, 6, 6, 6, 6);
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

