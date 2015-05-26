class Player {
  //The player's hand
  ArrayList<Card> hand;

  Player() {
    hand = new ArrayList();
  }

  //Adds a card to the player's hand
  void addCard(Card card) {
    hand.add(card);
  }

  //Plays a card
  void playCard(int cardNumber, boolean isUser) {
    if (isLegalMove(cardNumber)) {
      hand.remove(cardNumber);
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

