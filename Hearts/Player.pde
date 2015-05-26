class Player{
  //The player's hand
  ArrayList<Card> hand;
  
  Player(){
    hand = new ArrayList();
  }
  
  //Adds a card to the player's hand
  void addCard(Card card){
    hand.add(card);
  }
  
  //Plays a card
  void playCard(int cardNumber, boolean isPlayer){
    hand.remove(cardNumber);
    if (isPlayer){
      display.playCard();
    }
  }
}
