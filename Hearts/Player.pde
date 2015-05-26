class Player {
  //The player's hand
  ArrayList<Card> hand;
  //The player's number (0, 1, 2, or 3)
  int playerNumber;

  Player(int num) {
    hand = new ArrayList();
    playerNumber = num;
  }

  //Adds a card to the player's hand
  void addCard(Card card) {
    hand.add(card);
  }

  //Plays a card
  void playCard(int cardNumber, boolean isUser) {
    if (isLegalMove(cardNumber)) {
      playedCards[playerNumber] = hand.remove(cardNumber);
      if (isUser) {
        display.playCard();
      }
    }
  }
  
  //Checks if the card being played is legal
  boolean isLegalMove(int cardNumber){
    Card card = hand.get(cardNumber);
    return true;
  }
}

