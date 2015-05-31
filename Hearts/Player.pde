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
    numHearts = 0;
    numSpades = 0;
    numDiamonds = 0;
    numClubs = 0;
  }

  //Adds a card to the player's hand
  void addCard(Card card) {
    //hand.add(card);
    int suit = card.suit;
    if (suit == HEARTS) {
      hand.add(numHearts,card);
      numHearts++;
    } else if (suit == SPADES) {
      hand.add(numHearts+numSpades,card);
      numSpades++;
    } else if (suit == DIAMONDS) {
      hand.add(numHearts+numSpades+numDiamonds,card);
      numDiamonds++;
    } else {
      hand.add(numHearts+numSpades+numDiamonds+numClubs,card);
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
  void addCardWon(Card card) {
    cardsWon.add(card);
    if (card.suit == HEARTS) {
      points++;
    }
    if (card.number == 12 && card.suit == SPADES) {
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
        if(played.suit==HEARTS && !heartsBroken){
          breakHearts();
        }
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

  //Checks if the card being played is legal
  boolean isLegalMove(int cardNumber) {
    //println("heartsBroken: " + heartsBroken);
    if (hand.size()>0) {
      Card card = hand.get(cardNumber);

      //prevents user from playing multiple cards in the same trick
      if (triesMultiplePlays(card)) {
        return false;
      }

      //If the player is starting off the trick
      if (this==startingPlayer) {//If the player is starting off the trick
        if (!firstPlayed && illegalFirstPlay(card)) {
          return false;
        }
        if (card.suit==HEARTS) {
          if (!canPlayHeart(card)) {
            return false;
          }
          if (!heartsBroken) {
            breakHearts();
          }
        }
      } else {//If the player is not starting off the trick
        //nothing can be played if the two of clubs hasn't been played
        if (!firstPlayed) {
          return false;
        }
        //Disallows the play if it does not follow suit and the player is capable of following suit
        if (!followsSuit(card)) {
          //If the card is a heart, checks to see if it is legal to play
          if (card.suit==HEARTS) {
            if (!canPlayHeart(card)) {
              return false;
            } else {
              if (!heartsBroken) {
                breakHearts();
              }
              return true;
            }
          } else {
            return false;
          }
        }
      }
      //the move isn't illegal, therefore it is legal
      return true;
    }
    //prevents an error from occurring if there are no more cards to play
    return false;
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

  //returns true is the player tries to play any card but the two of clubs first
  boolean illegalFirstPlay(Card card) {
    if (playerNumber==SOUTH) {
      println("The two of clubs must be played first");
    }
    return !firstPlayed && !(card.number == 2 && card.suit == CLUBS);
  }

  //returns true if player (user)tries to play multiple cards in the same trick
  boolean triesMultiplePlays(Card card) {
    return playedCards[playerNumber].number!=0;
  }

  //returns true if player follows suit
  boolean followsSuit(Card card) {
    int suitLed = playedCards[startingPlayer.playerNumber].suit;
    //checks to see if a card of the correct suit is contained in the hand
    if (hasSuit(suitLed)) {
      //checks if the suit is the same
      if (card.suit!=suitLed) {
        if (playerNumber==SOUTH) {
          println("You must follow suit");
        }
        return false;
      }
    }
    //the cards are of the same suit
    return true;
  }

  //returns true if the player is allowed to play a heart (if hearts are broken or if there is no other choice)
  boolean canPlayHeart(Card card) {
    if (this==startingPlayer) {
      //prevents player from leading with hearts if hearts have not been broken.
      if (!heartsBroken) {
        //accounts for the eventuality that the player's hand contains only hearts
        for (Card c : hand) {
          if (c.suit!=HEARTS) {
            //the player does have the option of playing a card that isn't a heart, so the play is illegal
            if (playerNumber==SOUTH) {
              println("Hearts have not been broken");
            }
            return false;
          }
        }
        //the player's hand contains only hearts and has no choice but to play one.
        breakHearts();
      } else {
        if (!heartsBroken) {
          breakHearts();
        }
        return true;
      }
    } else {//if player isn't the starting player
      int suitLed = playedCards[startingPlayer.playerNumber].suit;
      //if hearts have not been broken and the player can follow suit, a heart can't be played
      if (hasSuit(suitLed)) {
        return false;
      }
      //if the player is unable to follow suit, then hearts are broken and the card can be played
      if (!heartsBroken) {
        breakHearts();
      }
    }
    //it isn't illegal to play a heart, therefore it is legal
    if (!heartsBroken) {
      breakHearts();
    }
    return true;
  }
}

