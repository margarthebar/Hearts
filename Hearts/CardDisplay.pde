//// This class is for display and play purposes only.
//// The cards contain therein are only physical representations
//// of actual functional cards.
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

  CardDisplay(Player p) {
    cardWidth = imageList[0].width;
    cardHeight = imageList[0].height;
    numCards = 13;
    selected = false;
    place = p.playerNumber;
  }

  void draw() {
    hand();
    if (messageDisplayed) {
      textAlign(CENTER);
      textSize(20);
      fill(255);
      text(message, width / 2, height - 200);
    }
  }


  void selectRight() {//moves highlight (cardSelected) right
    if (cardSelected<south.hand.size()-1) {
      cardSelected++;
      messageDisplayed = false;
    }
  }

  void selectLeft() {// moves highlight (cardSelected) left
    if (cardSelected>0) {
      cardSelected--;
      messageDisplayed = false;
    }
  }


  void click() {//selects a card by clicking
    if (place==SOUTH) {
      int cardsWidth = cardWidth + (numCards-2)*30;
      for (int i=0; i<south.hand.size (); i++) {
        int x = width/2 - cardsWidth/2 + i*30 + 15;
        if (mouseY>height-85-cardHeight/2 && mouseY<height-85+cardHeight/2) {
          if (i==south.hand.size()-1) {
            if (mouseX>x && mouseX<x+cardsWidth) {
              cardSelected = i;
              messageDisplayed = false;
            }
          } else {
            if (mouseX>x-30 && mouseX<x+cardsWidth) {
              cardSelected = i;
              messageDisplayed = false;
            }
          }
        }
      }
    }
  }

  void playCard() {//plays card highlighted
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
        int x = width/2 - cardsWidth/2 + i*30 + 20;
        if (i==cardSelected) {
          selected = true;
        }
        if (south.cardsToPass.contains(south.hand.get(i))) {
          cardFront(x, height-100, south.hand.get(i).number, south.hand.get(i).suit);
        } else {
          cardFront(x, height-85, south.hand.get(i).number, south.hand.get(i).suit);
        }
        selected = false;
      }
    } else if (place==NORTH) {
      int passingCardsFound = 0;
      for (int i=0; i<north.hand.size (); i++) {
        if (north.hand.get(i)==null) {//this is if the cards to be passed have been removed but are still displayed
          int x = width/2 - cardsWidth/2 + i*30 + 20;
          //cardBack(x, 80+25);
          cardFront(x, 100, north.cardsToPass.get(passingCardsFound).number, north.cardsToPass.get(passingCardsFound).suit);
          passingCardsFound++;
        } else {
          int x = width/2 - cardsWidth/2 + i*30 + 20;
          //cardBack(x, 80);
          cardFront(x, 80, north.hand.get(i).number, north.hand.get(i).suit);
        }
      }
    } else if (place==EAST) {
      int passingCardsFound = 0;
      for (int i=0; i<east.hand.size (); i++) {
        if (east.hand.get(i)==null) {//this is if the cards to be passed have been removed but are still displayed
          int y = height/2 - cardsHeight/2 + i*30 +20;
          //cardBack2(width-150-25, y);
          cardFront(width-150-25, y, east.cardsToPass.get(passingCardsFound).number, east.cardsToPass.get(passingCardsFound).suit);
          passingCardsFound++;
        } else {
          int y = height/2 - cardsHeight/2 + i*30 +20;
          //cardBack2(width-150, y);
          cardFront(width-150, y, east.hand.get(i).number, east.hand.get(i).suit);
        }
      }
    } else if (place==WEST) {
      int passingCardsFound = 0;
      for (int i=0; i<west.hand.size (); i++) {
        if (west.hand.get(i)==null) {//this is if the cards to be passed have been removed but are still displayed
          int y = height/2 - cardsHeight/2 + i*30 +20;
          //cardBack2(150+25, y);
          cardFront(150+25, y, west.cardsToPass.get(passingCardsFound).number, west.cardsToPass.get(passingCardsFound).suit);
          passingCardsFound++;
        } else {
          int y = height/2 - cardsHeight/2 + i*30 +20;
          //cardBack2(150, y);
          cardFront(150, y, west.hand.get(i).number, west.hand.get(i).suit);
        }
      }
    }
    rectMode(CORNER);
  }

  void cardFront(float x, float y, int number, int suit) {//cards that are face up
    rectMode(CENTER);
    if (currentPlayer.playerNumber==SOUTH || passingCards) {
      cardHighlight(x, y);
    }
    //cardBorder(x, y);
    rectMode(CENTER);
    stroke(255);
    fill(255);
    rect(x, y, 43, 63);
    stroke(0);
    fill(CORNER);
    cardContent(x, y, number, suit);
  }

  void cardContent(float x, float y, int number, int suit) {//number on card
    int index = -1;
    index = 52-((number-1)*4);
    if (number==1) {
      index = 0;
    }
    if (suit==SPADES) {
      index+=1;
    } else if (suit==HEARTS) {
      index+=2;
    } else if (suit==DIAMONDS) {
      index+=3;
    }
    imageMode(CENTER);
    image(imageList[index], x, y, cardWidth, cardHeight);
  }

  void cardBack(float x, float y) {//cards that are face down and facing NORTH and SOUTH
    rectMode(CENTER);
    cardChecker(x, y);
  }

  void cardBack2(float x, float y) {//cards that are face down and facing EAST or WEST
    rectMode(CENTER);
    cardChecker2(x, y);
  }

  void cardHighlight(float x, float y) {//indicates that a card has been selected
    if (selected) {
      stroke(200, 200, 0, 200);
      fill(200, 200, 0, 200);
      rect(x, y, cardWidth+8, cardHeight+8, 6, 6, 6, 6);
      noFill();
    }
  }

  void cardChecker(float x, float y) {//creates design on card backs for cards oriented NORTH and SOUTH
    imageMode(CENTER);
    image(imageList[53], x, y);
  }

  void cardChecker2(float x, float y) {//creates design on card backs for cards oriented towards EAST and WEST
    imageMode(CENTER);
    image(imageList[52], x, y);
  }
  ///////////HEART SYMBOLS///////////

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
}

