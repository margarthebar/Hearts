CardDisplay display;
ArrayList<Card> deck; //The deck of cards
Card[] playedCards; //The cards currently played (length 4, with indices corresponding to player number)
//The 4 players
Player south;
Player north;
Player east;
Player west;
//The number of the player that will start (is dealt the 2 of clubs)
int startingPlayer;

void setup() {
  size(700, 700);
  background(0, 100, 0);
  deck = new ArrayList();
  playedCards = new Card[4];
  for (int i = 0; i < 4; i++){
    playedCards[i] = new Card(1, 0);
  }
  south = new Player(SOUTH);
  north = new Player(NORTH);
  east = new Player(EAST);
  west = new Player(WEST);
  setDeck();
  deal();
  display = new CardDisplay(south.hand);
}

void draw() {
  //displays cards
  display.draw();
  println(playedCards[0].number + " " + playedCards[0].suit);
  println(playedCards[1].number + " " + playedCards[1].suit);
  println(playedCards[2].number + " " + playedCards[2].suit);
  println(playedCards[3].number + " " + playedCards[3].suit);
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
    south.playCard(cardSelected, true);
    //For now, plays a random card from each opponent's hand
    north.playCard((int)random(north.hand.size()), false);
    east.playCard((int)random(east.hand.size()), false);
    west.playCard((int)random(west.hand.size()), false);
  }
}

void mouseClicked() {
}

//Creates the deck
void setDeck() {
  for (int i = 1; i <= 13; i++) {
    for (int j = 0; j < 4; j++) {
      deck.add(new Card(i, j));
    }
  }
}


//Separates the deck into 4 hands
void deal() {
  while (deck.size () > 0) {
    Card randomCard = deck.remove((int)random(deck.size()));
    int playerDealtTo = deck.size() % 4;
    if (randomCard.number == 2 && randomCard.suit == CLUBS) {
      startingPlayer = playerDealtTo;
    }
    if (playerDealtTo == NORTH) {
      north.addCard(randomCard);
    } else if (playerDealtTo == SOUTH) {
      south.addCard(randomCard);
    } else if (playerDealtTo == EAST) {
      east.addCard(randomCard);
    } else {
      west.addCard(randomCard);
    }
  }
}

