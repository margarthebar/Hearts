//// This class is for display and play purposes only.
//// The cards contain therein are only physical representations
//// of actual functional cards.
//// Later the information from the actual functional cards
//// could be passed into this class to display them.

int cardWidth;
int cardHeight;
boolean selected;//says if a card has been selected
int cardSelected;//says which card has been selected
int HEARTS = 0;
int SPADES = 1;
int DIAMONDS = 2;
int CLUBS = 3;
int JACK = 11;
int QUEEN = 12;
int KING = 13;
int ACE = 1;

class CardDisplay {
  int numCards;//says how many cards are currently in a player's hand
  int place;
  //ArrayList<Card> hand;

  CardDisplay(Player p) {
    cardWidth = 50;
    cardHeight = 70;
    numCards = 13;
    selected = false;

    //hand = p.hand;
    place = p.playerNumber;
  }

  void draw() {
    hand();
  }


  void selectRight() {//moves highlight (cardSelected) right
    if (cardSelected<south.hand.size()-1) {
      cardSelected++;
    }
  }

  void selectLeft() {// moves highlight (cardSelected) left
    if (cardSelected>0) {
      cardSelected--;
    }
  }


  void click() {//selects a card by clicking
    if (place==SOUTH) {
      int cardsWidth = cardWidth + (numCards-2)*30;
      for (int i=0; i<south.hand.size (); i++) {
        int x = width/2 - cardsWidth/2 + i*30 + 15;
        if (mouseY>height-75-cardHeight/2 && mouseY<height-75+cardHeight/2) {
          if (i==south.hand.size()-1) {
            if (mouseX>x && mouseX<x+cardsWidth) {
              cardSelected = i;
            }
          } else {
            if (mouseX>x-30 && mouseX<x+cardsWidth) {
              cardSelected = i;
            }
          }
        }
      }
    }
  }

  void playCard() {//plays card highlighted (right now this just removes it)
    if (cardSelected>numCards-1 || cardSelected>=south.hand.size()) {
      cardSelected--;
    }
    numCards--;
  }

  ////////////////////////////////PHYSICAL CARD REPRESENTATIONS////////////////////////////////////////

  void hand() {//creates hands for all four players
    rectMode(CENTER);
    int cardsWidth = cardWidth + (numCards-2)*30;
    int cardsHeight = cardHeight + (numCards-3)*30;
    if (place==SOUTH) {
      for (int i=0; i<south.hand.size (); i++) {
        int x = width/2 - cardsWidth/2 + i*30 + 15;
        if (i==cardSelected) {
          selected = true;
        }
        if (south.cardsToPass.contains(south.hand.get(i))) {
          cardFront(x, height-100, south.hand.get(i).number, south.hand.get(i).suit);
        } else {
          cardFront(x, height-75, south.hand.get(i).number, south.hand.get(i).suit);
        }
        selected = false;
      }
    } else if (place==NORTH) {
      for (int i=0; i<north.hand.size (); i++) {
        int x = width/2 - cardsWidth/2 + i*30 + 15;
        cardBack(x, 75);
        //cardFront(x, 75, north.hand.get(i).number, north.hand.get(i).suit);
      }
    } else if (place==EAST) {
      for (int i=0; i<east.hand.size (); i++) {
        int y = height/2 - cardsHeight/2 + i*30;
        cardBack2(width-150, y);
        //cardFront(width-150, y, east.hand.get(i).number, east.hand.get(i).suit);
      }
    } else if (place==WEST) {
      for (int i=0; i<west.hand.size (); i++) {
        int y = height/2 - cardsHeight/2 + i*30;
        cardBack2(150, y);
        //cardFront(150, y, west.hand.get(i).number, west.hand.get(i).suit);
      }
    }
    rectMode(CORNER);
  }

  void cardFront(float x, float y, int number, int suit) {//cards that are face up
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

  void cardContent(float x, float y, int number, int suit) {//number on card
    textSize(12);
    textAlign(CENTER, CENTER);
    symbols(x, y, number, suit);//prints out symbols on card
    if (suit==SPADES || suit==CLUBS) {
      fill(0);
      stroke(0);
    } else {
      fill(195, 0, 0);
      stroke(195, 0, 0);
    }
    rotate(radians(180));
    float xcor = x-cardWidth/2+8;
    float ycor = y-cardHeight/2+8;
    String s = "";

    if (number==ACE) {
      s = "A";
      xcor+=1;
      text(s, -xcor-cardWidth+16, -ycor-cardHeight+16);
      xcor-=1;
    } else if (number==10) {
      s = "10";
      xcor+=2;
      text(s, -xcor-cardWidth+16, -ycor-cardHeight+16);
      xcor-=3;
    } else if (number==JACK) {
      s = "J";
      xcor+=1;
      text(s, -xcor-cardWidth+16, -ycor-cardHeight+16);
      xcor-=1;
    } else if (number==QUEEN) {
      s = "Q";
      xcor+=1;
      text(s, -xcor-cardWidth+16, -ycor-cardHeight+16);
      xcor-=1;
    } else if (number==KING) {
      s = "K";
      xcor+=1;
      text(s, -xcor-cardWidth+16, -ycor-cardHeight+16);
      xcor-=1;
    } else {
      s = ""+number;
      text(s, -xcor-cardWidth+16, -ycor-cardHeight+16);
    }
    rotate(radians(180));
    text(s, xcor, ycor);
    rectMode(CORNER);
  }

  void cardBack(float x, float y) {//cards that are face down and facing NORTH and SOUTH
    rectMode(CENTER);
    cardHighlight(x, y);
    cardChecker(x, y);
    cardBorder(x, y);
  }

  void cardBack2(float x, float y) {//cards that are face down and facing EAST or WEST
    rectMode(CENTER);
    cardHighlight(x, y);
    cardChecker2(x, y);
    cardBorder2(x, y);
  }

  void cardHighlight(float x, float y) {//indicates that a card has been selected
    if (selected) {
      stroke(200, 200, 0, 200);
      fill(200, 200, 0, 200);
      rect(x, y, 58, 78, 6, 6, 6, 6);
      noFill();
    }
  }

  void cardChecker(float x, float y) {//creates design on card backs for cards oriented NORTH and SOUTH
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

  void cardChecker2(float x, float y) {//creates design on card backs for cards oriented towards EAST and WEST
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


  void cardBorder2(float x, float y) {//creates card border for cards oriented EAST and WEST 
    noFill();
    stroke(100);
    rect(x, y, 72, 52, 6, 6, 6, 6);
    stroke(255);
    rect(x, y, 70, 50, 6, 6, 6, 6);
    rect(x, y, 68, 48, 6, 6, 6, 6);
    rect(x, y, 66, 46, 6, 6, 6, 6);
    rect(x, y, 64, 44, 6, 6, 6, 6);
    stroke(195, 0, 0);
    if (x>width/2) {
      rect(x-1, y, 62, 42);
      rect(x-1, y, 60, 40);
      stroke(255);
      rect(x-1, y, 64, 44);
    } else {
      rect(x-1, y-1, 62, 42);
      rect(x-1, y-1, 60, 40);
      stroke(255);
      rect(x-1, y-1, 64, 44);
    }
    stroke(0);
    rectMode(CORNER);
  }

  void cardBorder(float x, float y) {//creates card border for cards oriented NORTH and SOUTH
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

  ////////////////////////////////////CARD SYMBOLS////////////////////////////////////////////
  void symbols(float x, float y, int number, int suit) {//prints display specific to nuber and suit of card
    if (number==ACE) {
      ace(x, y, suit);
    } else if (number==2) {
      two(x, y, suit);
    } else if (number==3) {
      three(x, y, suit);
    } else if (number==4) {
      four(x, y, suit);
    } else if (number==5) {
      five(x, y, suit);
    } else if (number==6) {
      six(x, y, suit);
    } else if (number==7) {
      seven(x, y, suit);
    } else if (number==8) {
      eight(x, y, suit);
    } else if (number==9) {
      nine(x, y, suit);
    } else if (number==10) {
      ten(x, y, suit);
    } else if (number == JACK) {
      jack(x, y, suit);
    } else if (number == QUEEN) {
      queen(x, y, suit);
    } else if (number == KING) {
      king(x, y, suit);
    }
  }

  ///////////HEART SYMBOLS///////////
  void heartSmall(float x, float y) {//hearts under the number
    fill(195, 0, 0);
    noStroke();
    ellipse(x-1.5, y, 2, 2);
    ellipse(x+1.5, y, 2, 2);
    triangle(x-3, y, x+3, y, x, y+4);
  }

  void heartSmall2(float x, float y) {//upside down hearts under the number
    fill(195, 0, 0);
    noStroke();
    ellipse(x-1.5, y, 2, 2);
    ellipse(x+1.5, y, 2, 2);
    triangle(x-3, y, x+3, y, x, y-4);
  }

  void heart(float x, float y) {//rightside up hearts representing the number
    fill(195, 0, 0);
    noStroke();
    ellipse(x-1.75, y, 3.5, 3.5);
    ellipse(x+1.75, y, 3.5, 3.5);
    triangle(x-3.5, y, x+3.5, y, x, y+5);
  }

  void heart2(float x, float y) {//upside down hearts representing the number
    fill(195, 0, 0);
    noStroke();
    ellipse(x-1.75, y, 3.5, 3.5);
    ellipse(x+1.75, y, 3.5, 3.5);
    triangle(x-3.5, y, x+3.5, y, x, y-5);
  }

  void heartBig(float x, float y) {//rightside up heart for Ace
    fill(195, 0, 0);
    noStroke();
    ellipse(x-3.5, y, 7, 7);
    ellipse(x+3.5, y, 7, 7);
    triangle(x-7, y, x+7, y, x, y+10);
  }

  void heartBigBroken(float x, float y, float dist) {//the heart displayed when hearts are broken
    heartHalfLeft(x-dist, y);
    heartHalfRight(x+dist, y);
  }

  void heartHalfLeft(float x, float y) {
    fill(195, 0, 0);
    noStroke();
    ellipse(x-40.5, y, 80, 80);
    triangle(x-70+1, y+30-1, x, y-2, x, y+100-1);
  }

  void heartHalfRight(float x, float y) {
    fill(195, 0, 0);
    noStroke();
    ellipse(x+40.5, y, 80, 80);
    triangle(x, y-2, x+70-1, y+30-1, x, y+100-1);
  }

  ///////////SPADE SYMBOLS///////////
  void spadeSmall(float x, float y) {//spades under the number
    fill(0);
    noStroke();
    y+=2;
    ellipse(x-1.5, y, 2, 2);
    ellipse(x+1.5, y, 2, 2);
    triangle(x-3, y, x+3, y, x, y-4);
    rect(x, y, 1, 5.5);
  }

  void spadeSmall2(float x, float y) {//upside down spades under the number
    fill(0);
    noStroke();
    y-=2;
    ellipse(x-1.5, y, 2, 2);
    ellipse(x+1.5, y, 2, 2);
    triangle(x-3, y, x+3, y, x, y+4);
    rect(x, y, 1, 5.5);
  }

  void spade(float x, float y) {//rightside up spades representing the number
    fill(0);
    noStroke();
    ellipse(x-1.75, y, 3.5, 3.5);
    ellipse(x+1.75, y, 3.5, 3.5);
    triangle(x-3.5, y, x+3.5, y, x, y-5);
    rect(x, y, 1.5, 8);
  }

  void spade2(float x, float y) {//upside down spades representing the number
    fill(0);
    noStroke();
    ellipse(x-1.75, y, 3.5, 3.5);
    ellipse(x+1.75, y, 3, 3);
    triangle(x-3.5, y, x+3.5, y, x, y+5);
    rect(x, y, 1.5, 8);
  }

  void spadeBig(float x, float y) {//rightside up spade for Ace
    fill(0);
    noStroke();
    ellipse(x-3.5, y, 7, 7);
    ellipse(x+3.5, y, 7, 7);
    triangle(x-7, y, x+7, y, x, y-10);
    //rect(x, y, 3, 16);
    triangle(x, y, x+2, y+8, x-2, y+8);
  }
  ///////////DIAMOND SYMBOLS///////////
  void diamondSmall(float x, float y) {//diamonds under the number
    fill(195, 0, 0);
    noStroke();
    y+=2;
    triangle(x-2.25, y, x+2.25, y, x, y-3.5);
    triangle(x-2.25, y, x+2.25, y, x, y+3.5);
  }

  void diamondSmall2(float x, float y) {//upside down diamonds under the number
    diamondSmall(x, y-4);
  }

  void diamond(float x, float y) {//rightside up diamonds representing the number
    fill(195, 0, 0);
    noStroke();
    triangle(x-3, y, x+3, y, x, y-4.5);
    triangle(x-3, y, x+3, y, x, y+4.5);
  }

  void diamond2(float x, float y) {//upside down diamonds representing the number
    diamond(x, y);
  }

  void diamondBig(float x, float y) {//rightside up diamond for Ace
    fill(195, 0, 0);
    noStroke();
    triangle(x-6, y, x+6, y, x, y-9);
    triangle(x-6, y, x+6, y, x, y+9);
  }

  ///////////CLUB SYMBOLS///////////
  void clubSmall(float x, float y) {//clubs under the number
    fill(0);
    noStroke();
    y+=2;
    ellipse(x-1.5, y, 2.5, 2.5);
    ellipse(x+1.5, y, 2.5, 2.5);
    ellipse(x, y-1.5, 2.5, 2.5);
    triangle(x, y, x+1, y+3, x-1, y+3);
  }

  void clubSmall2(float x, float y) {//upside down clubs under the number
    fill(0);
    noStroke();
    y-=2;
    ellipse(x-1.5, y, 2.5, 2.5);
    ellipse(x+1.5, y, 2.5, 2.5);
    ellipse(x, y+1.5, 2.5, 2.5);
    triangle(x, y, x+1, y-3, x-1, y-3);
  }

  void club(float x, float y) {//rightside up clubs representing the number
    fill(0);
    noStroke();
    ellipse(x-2, y, 3.3, 3.3);
    ellipse(x+2, y, 3.3, 3.3);
    ellipse(x, y-3, 3.3, 3.3);
    triangle(x, y, x+1, y+4, x-1, y+4);
    rect(x, y, 2, 3);
  }

  void club2(float x, float y) {//upside down clubs representing the number
    fill(0);
    noStroke();
    ellipse(x-2, y, 3.3, 3.3);
    ellipse(x+2, y, 3.3, 3.3);
    ellipse(x, y+3, 3.3, 3.3);
    triangle(x, y, x+1, y-4, x-1, y-4);
    rect(x, y, 2, 3);
  }

  void clubBig(float x, float y) {//rightside up club for Ace
    fill(0);
    noStroke();
    ellipse(x-4, y, 6.6, 6.6);
    ellipse(x+4, y, 6.6, 6.6);
    ellipse(x, y-6, 6.6, 6.6);
    triangle(x, y, x+2, y+8, x-2, y+8);
    ellipse(x, y-1, 3, 3);
    ellipse(x, y-2, 3, 3);
  }

  //////////////NUMBERS///////////
  void ace(float x, float y, int suit) {//prints correct number of symbols for Ace cards
    if (suit==HEARTS) {
      heartBig(x, y);
      heartSmall(x-17, y-18);
      heartSmall2(x+17, y+18);
    } else if (suit==SPADES) {
      spadeBig(x, y);
      spadeSmall(x-17, y-18);
      spadeSmall2(x+17, y+18);
    } else if (suit==DIAMONDS) {
      diamondBig(x, y);
      diamondSmall(x-17, y-18);
      diamondSmall2(x+17, y+18);
    } else if (suit==CLUBS) {
      clubBig(x, y);
      clubSmall(x-17, y-18);
      clubSmall2(x+17, y+18);
    }
  }

  void two(float x, float y, int suit) {//prints correct number of symbols for 2 cards
    if (suit==HEARTS) {
      heart(x, y-20);
      heart2(x, y+20);
      heartSmall(x-17, y-18);
      heartSmall2(x+17, y+18);
    } else if (suit==SPADES) {
      spade(x, y-20);
      spade2(x, y+20);
      spadeSmall(x-17, y-18);
      spadeSmall2(x+17, y+18);
    } else if (suit==DIAMONDS) {
      diamond(x, y-20);
      diamond2(x, y+20);
      diamondSmall(x-17, y-18);
      diamondSmall2(x+17, y+18);
    } else if (suit==CLUBS) {
      club(x, y-20);
      club2(x, y+20);
      clubSmall(x-17, y-18);
      clubSmall2(x+17, y+18);
    }
  }

  void three(float x, float y, int suit) {//prints correct number of symbols for 3 cards
    two(x, y, suit);
    if (suit==HEARTS) {
      heart(x, y);
    } else if (suit==SPADES) {
      spade(x, y);
    } else if (suit==DIAMONDS) {
      diamond(x, y);
    } else if (suit==CLUBS) {
      club(x, y);
    }
  }

  void four(float x, float y, int suit) {//prints correct number of symbols for 4 cards
    if (suit==HEARTS) {
      heart(x-7, y-20);
      heart(x+7, y-20);
      heart2(x-7, y+20);
      heart2(x+7, y+20);
      heartSmall(x-17, y-18);
      heartSmall2(x+17, y+18);
    } else if (suit==SPADES) {
      spade(x-7, y-20);
      spade(x+7, y-20);
      spade2(x-7, y+20);
      spade2(x+7, y+20);
      spadeSmall(x-17, y-18);
      spadeSmall2(x+17, y+18);
    } else if (suit==DIAMONDS) {
      diamond(x-7, y-20);
      diamond(x+7, y-20);
      diamond2(x-7, y+20);
      diamond2(x+7, y+20);
      diamondSmall(x-17, y-18);
      diamondSmall2(x+17, y+18);
    } else if (suit==CLUBS) {
      club(x-7, y-20);
      club(x+7, y-20);
      club2(x-7, y+20);
      club2(x+7, y+20);
      clubSmall(x-17, y-18);
      clubSmall2(x+17, y+18);
    }
  }

  void five(float x, float y, int suit) {//prints correct number of symbols for 5 cards
    four(x, y, suit);
    if (suit==HEARTS) {
      heart(x, y);
    } else if (suit==SPADES) {
      spade(x, y);
    } else if (suit==DIAMONDS) {
      diamond(x, y);
    } else if (suit==CLUBS) {
      club(x, y);
    }
  }

  void six(float x, float y, int suit) {//prints correct number of symbols for 6 cards
    four(x, y, suit);
    if (suit==HEARTS) {
      heart(x-7, y);
      heart(x+7, y);
    } else if (suit==SPADES) {
      spade(x-7, y);
      spade(x+7, y);
    } else if (suit==DIAMONDS) {
      diamond(x-7, y);
      diamond(x+7, y);
    } else if (suit==CLUBS) {
      club(x-7, y);
      club(x+7, y);
    }
  }

  void seven(float x, float y, int suit) {//prints correct number of symbols for 7 cards
    six(x, y, suit);
    if (suit==HEARTS) {
      heart(x, y-10);
    } else if (suit==SPADES) {
      spade(x, y-10);
    } else if (suit==DIAMONDS) {
      diamond(x, y-10);
    } else if (suit==CLUBS) {
      club(x, y-10);
    }
  }

  void eight(float x, float y, int suit) {//prints correct number of symbols for 8 cards
    seven(x, y, suit);
    if (suit==HEARTS) {
      heart2(x, y+10);
    } else if (suit==SPADES) {
      spade2(x, y+10);
    } else if (suit==DIAMONDS) {
      diamond2(x, y+10);
    } else if (suit==CLUBS) {
      club2(x, y+10);
    }
  }

  void nine(float x, float y, int suit) {//prints correct number of symbols for 9 cards
    five(x, y, suit);
    if (suit==HEARTS) {
      heart(x-7, y-8);
      heart(x+7, y-8);
      heart2(x-7, y+8);
      heart2(x+7, y+8);
    } else if (suit==SPADES) {
      spade(x, y);
      spade(x-7, y-8);
      spade(x+7, y-8);
      spade2(x-7, y+8);
      spade2(x+7, y+8);
    } else if (suit==DIAMONDS) {
      diamond(x, y);
      diamond(x-7, y-8);
      diamond(x+7, y-8);
      diamond2(x-7, y+8);
      diamond2(x+7, y+8);
    } else if (suit==CLUBS) {
      club(x, y);
      club(x-7, y-8);
      club(x+7, y-8);
      club2(x-7, y+8);
      club2(x+7, y+8);
    }
  }

  void ten(float x, float y, int suit) {//prints correct number of symbols for 10 cards
    four(x, y, suit);
    if (suit==HEARTS) {
      heart(x, y-14);
      heart2(x, y+14);
      heart(x-7, y-8);
      heart(x+7, y-8);
      heart2(x-7, y+8);
      heart2(x+7, y+8);
    } else if (suit==SPADES) {
      spade(x, y-14);
      spade2(x, y+14);
      spade(x-7, y-8);
      spade(x+7, y-8);
      spade2(x-7, y+8);
      spade2(x+7, y+8);
    } else if (suit==DIAMONDS) {
      diamond(x, y-14);
      diamond2(x, y+14);
      diamond(x-7, y-8);
      diamond(x+7, y-8);
      diamond2(x-7, y+8);
      diamond2(x+7, y+8);
    } else if (suit==CLUBS) {
      club(x, y-14);
      club(x, y+14);
      club(x-7, y-8);
      club(x+7, y-8);
      club2(x-7, y+8);
      club2(x+7, y+8);
    }
  }

  void jack(float x, float y, int suit) {
    if (suit==HEARTS) {
      heartSmall(x-17, y-18);
      heartSmall2(x+17, y+18);
    } else if (suit==SPADES) {
      spadeSmall(x-17, y-18);
      spadeSmall2(x+17, y+18);
    } else if (suit==DIAMONDS) {
      diamondSmall(x-17, y-18);
      diamondSmall2(x+17, y+18);
    } else if (suit==CLUBS) {
      clubSmall(x-17, y-18);
      clubSmall2(x+17, y+18);
    }
  }
  void queen(float x, float y, int suit) {
    if (suit==HEARTS) {
      heartSmall(x-17, y-18);
      heartSmall2(x+17, y+18);
    } else if (suit==SPADES) {
      spadeSmall(x-17, y-18);
      spadeSmall2(x+17, y+18);
    } else if (suit==DIAMONDS) {
      diamondSmall(x-17, y-18);
      diamondSmall2(x+17, y+18);
    } else if (suit==CLUBS) {
      clubSmall(x-17, y-18);
      clubSmall2(x+17, y+18);
    }
  }
  void king(float x, float y, int suit) {
    if (suit==HEARTS) {
      heartSmall(x-17, y-18);
      heartSmall2(x+17, y+18);
    } else if (suit==SPADES) {
      spadeSmall(x-17, y-18);
      spadeSmall2(x+17, y+18);
    } else if (suit==DIAMONDS) {
      diamondSmall(x-17, y-18);
      diamondSmall2(x+17, y+18);
    } else if (suit==CLUBS) {
      clubSmall(x-17, y-18);
      clubSmall2(x+17, y+18);
    }
  }
}
