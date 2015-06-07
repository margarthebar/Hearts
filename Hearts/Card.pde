class Card {
  int number;
  int suit;

  Card(int number, int suit) {
    this.number = number;
    this.suit = suit;
  }
  
  String toString(){
    return getNumberName(number) + " of " + getSuitName(suit);
  }
  
  String getNumberName(int number){
    if (number == 1){
      return "Ace";
    }else if (number <= 10){
      return "" + number;
    }else if (number == 11){
      return "Jack";
    }else if (number == 12){
      return "Queen";
    }else{
      return "King";
    }
  }
  
  String getSuitName(int suit){
    if (suit == 0){
      return "Hearts";
    }else if (suit == 1){
      return "Spades";
    }else if (suit == 2){
      return "Diamonds";
    }else{
      return "Clubs";
    }
  }
}


