class Player {
  //The player's hand
  ArrayList<Card> hand;
  //The player's number (0, 1, 2, or 3)
  int playerNumber;
  //The cards the player has won
  ArrayList<Card> cardsWon;
  //The number of each suit in the player's hand
  int numHearts, numSpades, numDiamonds, numClubs;
  //The number of points the player has won
  int points;

  Player(int num) {
    hand = new ArrayList();
    cardsWon = new ArrayList();
    playerNumber = num;
  }

  //Adds a card to the player's hand
  void addCard(Card card) {
    hand.add(card);
    int suit = card.suit;
    if (suit == HEARTS) {
      numHearts++;
    } else if (suit == SPADES) {
      numSpades++;
    } else if (suit == DIAMONDS) {
      numDiamonds++;
    } else {
      numClubs++;
    }
  }

  void removeCard(int cardNumber) {
    int suit = hand.get(cardNumber).suit;
    if (suit == HEARTS) {
      numHearts--;
    } else if (suit == SPADES) {
      numSpades--;
    } else if (suit == DIAMONDS) {
      numDiamonds--;
    } else {
      numClubs--;
    }
    hand.remove(cardNumber);
  }
  
  //Adds a card to the cards won
  void addCardWon(Card card){
    cardsWon.add(card);
    if (card.suit == HEARTS){
      points++;
    }
    if (card.number == 12 && card.suit == SPADES){
      points += 13;
    }
  }

  //Plays a card
  void playCard(int cardNumber, boolean isUser) {
    if (isLegalMove(cardNumber)) {
      if (!firstPlayed) {
        firstPlayed = true;
        startingPlayer = this;
      }
      if (!isUser && !turnPending) {
        lastPlayed = cardNumber;
        turnPending = true;
        time = millis();
      }
      if (isUser || time + 500 < millis()) {
        turnPending = false;
        Card played = hand.get(cardNumber);
        if (playedCards[0].number == 0 && playedCards[1].number == 0 && playedCards[2].number == 0 && playedCards[3].number == 0) {
          startingPlayer = this;
        }
        playedCards[playerNumber] = played;
        removeCard(cardNumber);
        if (playerNumber==NORTH) {
          displayNorth.playCard();
        } else if (playerNumber==SOUTH) {
          displaySouth.playCard();
        } else if (playerNumber==EAST) {
          displayEast.playCard();
        } else if (playerNumber==WEST) {
          displayWest.playCard();
        }
        currentPlayer = getNextPlayer(currentPlayer);
      }
    }
  }

  //Checks to see if the player's hand contains a card of the correct suit
  boolean hasSuit(int desiredSuit) {
    if (desiredSuit == HEARTS && numHearts > 0) {
      return true;
    } else if (desiredSuit == SPADES && numSpades > 0) {
      return true;
    } else if (desiredSuit == DIAMONDS && numDiamonds > 0) {
      return true;
    } else if (desiredSuit == CLUBS && numClubs > 0) {
      return true;
    } else {
      return false;
    }
  }

  //Checks if the card being played is legal
  boolean isLegalMove(int cardNumber) {
    Card card = hand.get(cardNumber);
    if (!firstPlayed && !(card.number == 2 && card.suit == CLUBS)) {
      //println("The two of clubs must be played first");
      return false;
    } else if (this!=startingPlayer && firstPlayed) {
      int suitLed = playedCards[startingPlayer.playerNumber].suit;
      //if a card of the correct suit is contained in the hand, checks if the suit is the same
      if (hasSuit(suitLed) && card.suit!=suitLed) {
        //println("You must follow suit");
        return false;
      } else if (card.suit==HEARTS) {
        heartsBroken = true;
      }
    } else if (!heartsBroken && card.suit==HEARTS) {
        return false;
    }
    return true;
  }
}
