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
      if (!firstPlayed) {
        startingPlayer = this;
        firstPlayed = true;
      }
      if (!isUser && !turnPending) {
        lastPlayed = cardNumber;
        turnPending = true;
        time = millis();
      }
      if (isUser || time + 500 < millis()) {
        turnPending = false;
        Card played = hand.get(cardNumber);
        playedCards[playerNumber] = played;
        hand.remove(cardNumber);
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
    for (Card c : hand) {
      if (c.suit==desiredSuit) {
        return true;
      }
    }
    return false;
  }

  //Checks if the card being played is legal
  boolean isLegalMove(int cardNumber) {
    Card card = hand.get(cardNumber);
    if (!firstPlayed && !(card.number == 2 && card.suit == CLUBS)) {
      //println("The two of clubs must be played first");
      return false;
    } else {
      if (this!=startingPlayer && firstPlayed) {
        int suitLed = playedCards[startingPlayer.playerNumber].suit;
        //checks to see if a card of the correct suit is contained in the hand
        if (hasSuit(suitLed)) {
          //checks if the suit is the same
          if (card.suit!=suitLed) {
            println("You must follow suit");
            return false;
          }
        }
      }
      return true;
    }
  }
}

