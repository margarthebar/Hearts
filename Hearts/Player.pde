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
  //The number of points over multiple rounds
  int totalPoints;
  //The cards the player has selected to pass
  ArrayList<Card> cardsToPass;
  //Whether the player is trying to shoot the moon
  boolean shootingMoon;

  Player(int num) {
    hand = new ArrayList();
    cardsWon = new ArrayList();
    cardsToPass = new ArrayList();
    playerNumber = num;
  }

  //Adds a card to the player's hand
  void addCard(Card card) {
    //hand.add(card);
    int suit = card.suit;
    boolean added = false;
    if (suit == HEARTS) {
      for (int i=0; i<numHearts; i++) {
        if (compareCards(hand.get(i), card) > 0 && !added) {
          hand.add(i, card);
          added = true;
        }
      }
      if (!added) {
        hand.add(numHearts, card);
      }
      numHearts++;
    } else if (suit == SPADES) {
      for (int i=numHearts; i<numHearts+numSpades; i++) {
        if (compareCards(hand.get(i), card) > 0 && !added) {
          hand.add(i, card);
          added = true;
        }
      }
      if (!added) {
        hand.add(numHearts+numSpades, card);
      }
      numSpades++;
    } else if (suit == DIAMONDS) {
      for (int i=numHearts+numSpades; i<numHearts+numSpades+numDiamonds; i++) {
        if (compareCards(hand.get(i), card) > 0 && !added) {
          hand.add(i, card);
          added = true;
        }
      }
      if (!added) {
        hand.add(numHearts+numSpades+numDiamonds, card);
      }
      numDiamonds++;
    } else {
      for (int i=numHearts+numSpades+numDiamonds; i<numHearts+numSpades+numDiamonds+numClubs; i++) {
        if (compareCards(hand.get(i), card) > 0 && !added) {
          hand.add(i, card);
          added = true;
        }
      }
      if (!added) {
        hand.add(numHearts+numSpades+numDiamonds+numClubs, card);
      }
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
      totalPoints++;
    }
    if (card.number == 12 && card.suit == SPADES) {
      points += 13;
      totalPoints += 13;
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
        if (played.suit==HEARTS && !heartsBroken) {
          breakHearts();
        }
        removeCard(cardNumber);
        if (playerNumber==NORTH) {
          displayNorth.playCard();
        } else if (playerNumber==SOUTH) {
          messageDisplayed = false;
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

  boolean hasHighHearts() {
    return hasCard(ACE, HEARTS) && hasCard(KING, HEARTS) && hasCard(QUEEN, HEARTS);
  }

  int getLeastCommonSuit() {
    int LCS = 0;
    for (int s=1; s<4; s++) {
      if (numOfSuit(s)<numOfSuit(LCS)) {
        LCS = s;
      }
    }
    return LCS;
  }

  int numLowerSpades() {//number of spades lower than Q
    int lowerSpades = numSpades;
    if (hasCard(ACE, SPADES) ) {
      lowerSpades--;
    }
    if (hasCard(KING, SPADES) ) {
      lowerSpades--;
    }
    if (hasCard(QUEEN, SPADES)) {
      lowerSpades--;
    }
    return lowerSpades;
  }

  int getMostCommonSuit() {
    int MCS = 0;
    for (int s=1; s<4; s++) {
      if (numOfSuit(s)>numOfSuit(MCS)) {
        MCS = s;
      }
    }
    return MCS;
  }

  int find(int num, int suit) {
    if (!hasCard(num, suit)) {
      return -1;
    }
    for (int i=0; i<hand.size (); i++) {
      if (hand.get(i)!=null) {
        if (hand.get(i).number == num && hand.get(i).suit == suit) {
          return i;
        }
      }
    }
    return -1;
  }

  int getLowestCardInRun(int suit) {//gets the lowest card the player has of a "run" of a suit (Ex.: A,K,Q,J,10 => return 10). Assumes that the player has the Ace
    int lowest = -1; 
    int lowestNumber = ACE; 
    ArrayList<Card> dummyHand = new ArrayList<Card>(); 
    for (Card c : hand) {
      dummyHand.add(c);
    }
    for (int i=0; i<numOfSuit (suit); i++) {
      if (hasCard(lowestNumber, suit)) {
        lowest = find(lowestNumber, suit); 
        lowestNumber--;
      } else {
        return lowest;
      }
    }
    return lowest;
  }

  //determines if one can shoot the moon based on original hand
  boolean canShootMoon() {
    if (passingCards) {//when passing
      int countHighs = 0; 
      for (Card c : hand) {
        if (c!=null) {
          if (c.number>=JACK) {
            countHighs++;
          }
        }
      }
      if (countHighs >= 8) {//A player needs high cards to have a chance of running the deck
        if (hasHighHearts()) {//If the player has high hearts, play those
          if (hasCard(KING, SPADES) || hasCard(ACE, SPADES)) {//to be able to take the Queen of Spades
            return true;
          }
        } else if (numHearts <= 3) {//these should be passed
          if (hasCard(KING, SPADES) || hasCard(ACE, SPADES)) {//to be able to take the Queen of Spades
            return true;
          }
        }
        return false;
      }
      return false;
    } else {//when playing
      if (numClubs==13) {
        return true;
      }
      if (numHearts==13 || numSpades==13 || numDiamonds==13) {
        return false;
      }
      return true;
    }
  }

  void passToShootMoon() {//passes the cards needed to shoot the moon
    for (int i=0; i<3- (13-hand.size ()); i++) {
      int indexLowest = -1; 
      boolean found = false; 
      for (int s=0; s<4; s++) {//finds and removes lowest cards starting with hearts, then spades, etc.
        if (!found && numOfSuit(s)>0 && getLowest(s)!=getLowestCardInRun(s)) {
          indexLowest = getLowest(s); 
          found = true;
        }
      }
      if (!found) {//if all the suits are in runs of the highest cards
        indexLowest = getLowest(getMostCommonSuit());
      }
      if (hand.get(indexLowest).suit==HEARTS) {
        numHearts--;
      } else if (hand.get(indexLowest).suit==SPADES) {
        numSpades--;
      } else if (hand.get(indexLowest).suit==DIAMONDS) {
        numDiamonds--;
      } else {
        numClubs--;
      }
      addCardToPass(indexLowest);
      //cardsToPass.add(hand.get(indexLowest)); 
      hand.set(indexLowest, null);
    }
  }

  void passHighSpades() {//passes the Ace and King of Spades, passes Queen if necessary
    int index = -1;
    if (hasCard(QUEEN, SPADES)) {//passes the Queen of Spades if it's too dangerous to keep
      if (numLowerSpades()<=2) {
        index = find(QUEEN, SPADES);
        addCardToPass(index);
        //cardsToPass.add(hand.get(index));
        hand.set(index, null);
        numSpades--;
      }
    }
    if (hasCard(ACE, SPADES)) {//passes the Ace of Spades if in hand
      index = find(ACE, SPADES);
      addCardToPass(index);
      //cardsToPass.add(hand.get(index));
      hand.set(index, null);
      numSpades--;
    }
    if (hasCard(KING, SPADES) ) {//passes the King of Spades if in hand
      index = find(KING, SPADES);
      addCardToPass(index);
      //cardsToPass.add(hand.get(index));
      hand.set(index, null);
      numSpades--;
    }
  }

  void passHighHearts() {//passes all hearts higher than Jack
    boolean done = false;
    while (cardsToPass.size ()<3 && !done) {
      if (numHearts>0 && (hasHighHearts() || hand.get(getHighest(HEARTS)).number>JACK)) {//passes high hearts (A,K,Q) if in hand
        int index = getHighest(HEARTS);
        addCardToPass(index);
        //cardsToPass.add(hand.get(index));
        hand.set(index, null);
        numHearts--;
      } else {
        done = true;
      }
    }
  }

  void voidSuit() {//void a suit if possible
    if (numDiamonds<= 3-cardsToPass.size() || numClubs<= 3-cardsToPass.size()) {//voids a suit if possible
      int index = -1;
      if (numDiamonds<numClubs) {
        while (numDiamonds>0) {
          index = getHighest(DIAMONDS);
          addCardToPass(index);
          //cardsToPass.add(hand.get(index));
          hand.set(index, null);
          numDiamonds--;
        }
        if (numClubs<= 3-cardsToPass.size()) {
          while (numClubs >0) {
            index = getHighest(CLUBS);
            addCardToPass(index);
            //cardsToPass.add(hand.get(index));
            hand.set(index, null);
            numClubs--;
          }
        }
      } else {
        while (numClubs>0) {
          index = getHighest(CLUBS);
          addCardToPass(index);
          //cardsToPass.add(hand.get(index));
          hand.set(index, null);
          numClubs--;
        }
        if (numDiamonds<= 3-cardsToPass.size()) {
          while (numDiamonds >0) {
            index = getHighest(DIAMONDS);
            addCardToPass(index);
            //cardsToPass.add(hand.get(index));
            hand.set(index, null);
            numDiamonds--;
          }
        }
      }
    }
  }

  void addCardToPass(int index) {
    boolean added = false;
    for (int i=0; i<cardsToPass.size (); i++) {
      if (!added && hand.get(index).suit<cardsToPass.get(i).suit) {
        cardsToPass.add(i, hand.get(index));
        added = true;
      } else if (!added && hand.get(index).suit==cardsToPass.get(i).suit) {
        if (compareCards(hand.get(index), cardsToPass.get(i))<0) {
          cardsToPass.add(i, hand.get(index));
          added = true;
        }
      }
    }
    if (!added) {
      cardsToPass.add(cardsToPass.size(), hand.get(index));
    }
  }

  void passHighestCards() {
    while (cardsToPass.size ()<3) {
      int index = -1;
      if (numDiamonds>0 || numClubs>0) {
        index = getHighest(DIAMONDS, CLUBS);
        if (hand.get(index).suit==DIAMONDS) {
          numDiamonds--;
        } else {
          numClubs--;
        }
        addCardToPass(index);
        hand.set(index, null);
      } else {
        index = getHighest(HEARTS);
        addCardToPass(index);
        hand.set(index, null);
        numHearts--;
      }
    }
  }

  //Picks three cards to pass (AI)
  void pickPassingCards() {
    //determine if running the deck is a viable strategy
    if (canShootMoon()) {
      shootingMoon = true;
      passToShootMoon();
    } else {
      passHighSpades();//passes high spades if they are too dangerous to keep
      passHighHearts();
      voidSuit();//voids a suit if possible (only for diamonds and clubs)
      passHighestCards();//if none of the above are true, passes highest cards
    }
  }

  //Picks a card to play (AI)
  int pickCard() {
    if (hand.size() == 1) {
      return 0;
    }
    if (shootingMoon) { //Different strategy for picking cards if the player is trying to shoot the moon
      //Checks if another player has taken a point
      if (otherPlayerHasPoints() || !canShootMoon()) {
        shootingMoon = false;
      } else {
        //AI decision-making will go here (for now, picks randomly)
        return (int)random(hand.size());
      }
    }
    if (!shootingMoon) {
      //Chooses what to do on the first trick
      if (hand.size() == 13) {
        return pickCardFirstTrick();
      }
      //Chooses what to do when leading a trick
      if (this == startingPlayer) {
        return pickCardLeadingTrick();
      }
      int startingSuit = playedCards[startingPlayer.playerNumber].suit;
      //Chooses what to do if it has the starting suit
      if (hasSuit(startingSuit)) {
        return pickCardHasSuit(startingSuit);
      }
      //Chooses what to do if it does not have the starting suit
      if (hasCard(QUEEN, SPADES)) {
        return getCard(QUEEN, SPADES);
      } else if (hasCard(ACE, SPADES) || hasCard(KING, SPADES)) {
        return getHighest(SPADES);
      } else if ((numSpades > 0 && numSpades <= 2) || (numClubs > 0 && numClubs <= 2) || (numDiamonds > 0 && numDiamonds <= 2) || (numHearts > 0 && numHearts <= 2)) {
        return getHighest(true);
      } else {
        return getHighest();
      }
    }
    return 0;
  }

  int pickCardFirstTrick() {
    //If player has the two of clubs, play it
    if (this == startingPlayer) {
      return getLowest(CLUBS);
    } else if (numClubs > 0) { //If the player has clubs, play the highest
      return getHighest(CLUBS);
    } else if (!hasCard(QUEEN, SPADES)) {
      //If the player has the king or ace of spades, play it
      if (hasCard(KING, SPADES) || hasCard(ACE, SPADES)) {
        return getHighest(SPADES);
      } else {
        return getHighest(SPADES, DIAMONDS);
      }
    } else {
      return getHighest(DIAMONDS);
    }
  }

  int pickCardLeadingTrick() {
    return pickCardLeadingTrick(false);
  }

  int pickCardLeadingTrick(boolean isProjection) {
    Card card = null;
    int toReturn;
    if (isProjection) {
      card = hand.get(getHighest(playedCards[startingPlayer.playerNumber].suit));
      removeCard(getHighest(playedCards[startingPlayer.playerNumber].suit));
    }
    if ((numSpades > 0 && numSpades <= 2) && (!hasCard(QUEEN, SPADES) && !hasCard(KING, SPADES) && !hasCard(ACE, SPADES)) && getLowest(SPADES) < 8) {
      toReturn = getLowest(SPADES);
    } else if (heartsBroken && ((numClubs > 0 && numClubs <= 2) || (numDiamonds > 0 && numDiamonds <= 2) || (numHearts > 0 && numHearts <= 2)) && getLowest(CLUBS, DIAMONDS, HEARTS, true) < 8) {
      toReturn = getLowest(CLUBS, DIAMONDS, HEARTS, true);
    } else if (!heartsBroken && ((numClubs > 0 && numClubs <= 2) || (numDiamonds > 0 && numDiamonds <= 2)) && getLowest(CLUBS, DIAMONDS, true) < 8) {
      toReturn = getLowest(CLUBS, DIAMONDS, true);
    } else if (numSpades > 0 && (!hasCard(QUEEN, SPADES) && !hasCard(KING, SPADES) && !hasCard(ACE, SPADES))) {
      toReturn = getLowest(SPADES);
    } else if (!heartsBroken && (numClubs > 0 || numDiamonds > 0)) {
      toReturn = getLowest(CLUBS, DIAMONDS);
    } else if (heartsBroken && (numClubs > 0 || numDiamonds > 0 || numHearts > 0)) {
      toReturn = getLowest(CLUBS, DIAMONDS, HEARTS);
    } else if (!heartsBroken && (numClubs > 0 || numDiamonds > 0 || numSpades > 0)) {
      toReturn = getLowest(SPADES, CLUBS, DIAMONDS);
    } else {
      toReturn = getLowest();
    }
    if (isProjection) {
      addCard(card);
    }
    return toReturn;
  }

  int pickCardHasSuit(int startingSuit) {
    if (getNextPlayer(this) == startingPlayer && !(hand.get(getHighest(startingSuit)).number == QUEEN && hand.get(getHighest(startingSuit)).suit == SPADES) && ((hand.get(pickCardLeadingTrick(true)).number < 8 && pointsCurrentlyPlayed() == 0) || hand.get(getLowest(startingSuit)).number > highestNumCurrentlyPlayed())) {
      return getHighest(startingSuit);
    } else {
      return getHighestWithoutTaking(startingSuit);
    }
  }

  boolean hasCard(int number, int suit) {
    for (int i = 0; i < hand.size (); i++) {
      if (hand.get(i)!=null) {
        Card current = hand.get(i); 
        if (current.number == number && current.suit == suit) {
          return true;
        }
      }
    }
    return false;
  }

  int getCard(int number, int suit) {
    for (int i = 0; i < hand.size (); i++) {
      Card current = hand.get(i);
      if (current.number == number && current.suit == suit) {
        return i;
      }
    }
    return -1;
  }

  boolean otherPlayerHasPoints() {
    for (int i = 0; i < 4; i++) {
      if (i != playerNumber && getPlayer(i).points != 0) {
        return true;
      }
    }
    return false;
  }

  int getHighest(int suit) {
    int high = -1; 
    int highestNumber = 0; 
    for (int i = 0; i < hand.size (); i++) {
      if (hand.get(i)!=null) {
        int currentSuit = hand.get(i).suit; 
        int currentNumber = hand.get(i).number; 
        if (currentNumber == ACE) {
          currentNumber = 14;
        }
        if (currentSuit == suit && currentNumber > highestNumber) {
          high = i; 
          highestNumber = currentNumber;
        }
      }
    }
    return high;
  }

  int getHighest(int suit1, int suit2) {
    return getHighest(suit1, suit2, false);
  }

  int getHighest(int suit1, int suit2, boolean restrict) {
    int high = -1; 
    int highestNumber = 0; 
    int numOfSuitOfHighest = 0; 
    //If there are more than 2 cards of one the the suits, it ignores that suit
    if (restrict) {
      if (numOfSuit(suit1) > 2) {
        suit1 = 4;
      }
      if (numOfSuit(suit2) > 2) {
        suit2 = 4;
      }
    }
    for (int i = 0; i < hand.size (); i++) {
      if (hand.get(i)!=null) {
        int currentSuit = hand.get(i).suit; 
        int currentNumber = hand.get(i).number; 
        if (currentNumber == ACE) {
          currentNumber = 14;
        }
        if ((currentSuit == suit1 || currentSuit == suit2) && currentNumber >= highestNumber) {
          if (currentNumber > highestNumber || numOfSuit(currentSuit) < numOfSuitOfHighest) {
            high = i; 
            highestNumber = currentNumber; 
            numOfSuitOfHighest = numOfSuit(currentSuit);
          }
        }
      }
    }
    return high;
  }

  int getHighest(int suit1, int suit2, int suit3) {
    return getHighest(suit1, suit2, suit3, false);
  }

  int getHighest(int suit1, int suit2, int suit3, boolean restrict) {
    int high = -1; 
    int highestNumber = 0; 
    int numOfSuitOfHighest = 0; 
    //If there are more than 2 cards of one the the suits, it ignores that suit
    if (restrict) {
      if (numOfSuit(suit1) > 2) {
        suit1 = 4;
      }
      if (numOfSuit(suit2) > 2) {
        suit2 = 4;
      }
      if (numOfSuit(suit3) > 2) {
        suit3 = 4;
      }
    }
    for (int i = 0; i < hand.size (); i++) {
      if (hand.get(i)!=null) {
        int currentSuit = hand.get(i).suit; 
        int currentNumber = hand.get(i).number; 
        if (currentNumber == ACE) {
          currentNumber = 14;
        }
        if ((currentSuit == suit1 || currentSuit == suit2 || currentSuit == suit3) && currentNumber >= highestNumber) {
          if (currentNumber > highestNumber || numOfSuit(currentSuit) < numOfSuitOfHighest) {
            high = i; 
            highestNumber = currentNumber; 
            numOfSuitOfHighest = numOfSuit(currentSuit);
          }
        }
      }
    }
    return high;
  }

  int getHighest() {
    return getHighest(false);
  }

  int getHighest(boolean restrict) {
    int high = -1;
    int highestNumber = 0;
    int numOfSuitOfHighest = 0;
    int suit1 = HEARTS;
    int suit2 = SPADES;
    int suit3 = DIAMONDS;
    int suit4 = CLUBS;
    //If there are more than 2 cards of one the the suits, it ignores that suit
    if (restrict) {
      if (numOfSuit(suit1) > 2) {
        suit1 = 4;
      }
      if (numOfSuit(suit2) > 2) {
        suit2 = 4;
      }
      if (numOfSuit(suit3) > 2) {
        suit3 = 4;
      }
      if (numOfSuit(suit4) > 2) {
        suit4 = 4;
      }
    }
    for (int i = 0; i < hand.size (); i++) {
      if (hand.get(i)!=null) {
        int currentSuit = hand.get(i).suit;
        int currentNumber = hand.get(i).number;
        if (currentNumber == ACE) {
          currentNumber = 14;
        }
        if ((currentSuit == suit1 || currentSuit == suit2 || currentSuit == suit3 || currentSuit == suit4) && currentNumber >= highestNumber) {
          if (currentNumber > highestNumber || numOfSuit(currentSuit) < numOfSuitOfHighest) {
            high = i;
            highestNumber = currentNumber;
            numOfSuitOfHighest = numOfSuit(currentSuit);
          }
        }
      }
    }
    return high;
  }

  int getLowest(int suit) {
    int low = -1; 
    int lowestNumber = 15; 
    for (int i = 0; i < hand.size (); i++) {
      if (hand.get(i)!=null) {
        int currentSuit = hand.get(i).suit; 
        int currentNumber = hand.get(i).number; 
        if (currentNumber == ACE) {
          currentNumber = 14;
        }
        if (currentSuit == suit && currentNumber < lowestNumber) {
          low = i; 
          lowestNumber = currentNumber;
        }
      }
    }
    return low;
  }

  int getLowest(int suit1, int suit2) {
    return getLowest(suit1, suit2, false);
  }

  int getLowest(int suit1, int suit2, boolean restrict) {
    int low = -1; 
    int lowestNumber = 15; 
    int numOfSuitOfLowest = 0; 
    //If there are more than 2 cards of one the the suits, it ignores that suit
    if (restrict) {
      if (numOfSuit(suit1) > 2) {
        suit1 = 4;
      }
      if (numOfSuit(suit2) > 2) {
        suit2 = 4;
      }
    }
    for (int i = 0; i < hand.size (); i++) {
      if (hand.get(i)!=null) {
        int currentSuit = hand.get(i).suit; 
        int currentNumber = hand.get(i).number; 
        if (currentNumber == ACE) {
          currentNumber = 14;
        }
        if ((currentSuit == suit1 || currentSuit == suit2) && currentNumber <= lowestNumber) {
          if (currentNumber < lowestNumber || numOfSuit(currentSuit) < numOfSuitOfLowest) {
            low = i; 
            lowestNumber = currentNumber; 
            numOfSuitOfLowest = numOfSuit(currentSuit);
          }
        }
      }
    }
    return low;
  }

  int getLowest(int suit1, int suit2, int suit3) {
    return getLowest(suit1, suit2, suit3, false);
  }

  int getLowest(int suit1, int suit2, int suit3, boolean restrict) {
    int low = -1; 
    int lowestNumber = 15; 
    int numOfSuitOfLowest = 0; 
    if (restrict) {
      if (numOfSuit(suit1) > 2) {
        suit1 = 4;
      }
      if (numOfSuit(suit2) > 2) {
        suit2 = 4;
      }
      if (numOfSuit(suit3) > 2) {
        suit3 = 4;
      }
    }
    for (int i = 0; i < hand.size (); i++) {
      if (hand.get(i)!=null) {
        int currentSuit = hand.get(i).suit; 
        int currentNumber = hand.get(i).number; 
        if (currentNumber == ACE) {
          currentNumber = 14;
        }
        if ((currentSuit == suit1 || currentSuit == suit2 || currentSuit == suit3) && currentNumber <= lowestNumber) {
          if (currentNumber < lowestNumber || numOfSuit(currentSuit) < numOfSuitOfLowest) {
            low = i; 
            lowestNumber = currentNumber; 
            numOfSuitOfLowest = numOfSuit(currentSuit);
          }
        }
      }
    }
    return low;
  }

  int getLowest() {
    return getLowest(false);
  }

  int getLowest(boolean restrict) {
    int low = -1;
    int lowestNumber = 15;
    int numOfSuitOfLowest = 0;
    int suit1 = HEARTS;
    int suit2 = SPADES;
    int suit3 = DIAMONDS;
    int suit4 = CLUBS;
    //If there are more than 2 cards of one the the suits, it ignores that suit
    if (restrict) {
      if (numOfSuit(suit1) > 2) {
        suit1 = 4;
      }
      if (numOfSuit(suit2) > 2) {
        suit2 = 4;
      }
      if (numOfSuit(suit3) > 2) {
        suit3 = 4;
      }
      if (numOfSuit(suit4) > 2) {
        suit4 = 4;
      }
    }
    for (int i = 0; i < hand.size (); i++) {
      if (hand.get(i)!=null) {
        int currentSuit = hand.get(i).suit;
        int currentNumber = hand.get(i).number;
        if (currentNumber == ACE) {
          currentNumber = 14;
        }
        if ((currentSuit == suit1 || currentSuit == suit2 || currentSuit == suit3 || currentSuit == suit4) && currentNumber <= lowestNumber) {
          if (currentNumber < lowestNumber || numOfSuit(currentSuit) < numOfSuitOfLowest) {
            low = i;
            lowestNumber = currentNumber;
            numOfSuitOfLowest = numOfSuit(currentSuit);
          }
        }
      }
    }
    return low;
  }

  int getHighestWithoutTaking(int suit) {
    int highestPlayed = highestNumCurrentlyPlayed();
    if (hand.get(getLowest(suit)).number > highestPlayed) {
      return getLowest(suit);
    }
    int high = -1;
    int highestNumber = 0;
    for (int i = 0; i < hand.size (); i++) {
      int currentSuit = hand.get(i).suit;
      int currentNumber = hand.get(i).number;
      if (currentNumber == ACE) {
        currentNumber = 14;
      }
      if (currentSuit == suit && currentNumber > highestNumber && currentNumber < highestPlayed) {
        high = i;
        highestNumber = currentNumber;
      }
    }
    return high;
  }

  int pointsCurrentlyPlayed() {
    int points = 0;
    for (int i = 0; i < playedCards.length; i++) {
      if (playedCards[i].number != 0 && playedCards[i].suit == HEARTS) {
        points++;
      }
      if (playedCards[i].number == QUEEN && playedCards[i].suit == SPADES) {
        points += 13;
      }
    }
    return points;
  }

  int highestNumCurrentlyPlayed() {
    int highNum = 0;
    int startingSuit = playedCards[startingPlayer.playerNumber].suit;
    for (int i = 0; i < playedCards.length; i++) {
      if (playedCards[i].number != 0 && playedCards[i].suit == startingSuit && playedCards[i].number > highNum) {
        highNum = playedCards[i].number;
      }
    }
    return highNum;
  }


  int numOfSuit(int suit) {
    if (suit == HEARTS) {
      return numHearts;
    } else if (suit == SPADES) {
      return numSpades;
    } else if (suit == CLUBS) {
      return numClubs;
    } else {
      return numDiamonds;
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
        //Points cannot be played on the first trick
        if (firstTrickPoint(card)) {
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
      messageDisplayed = true; 
      message = "The two of clubs must be played first";
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
          messageDisplayed = true; 
          message = "You must follow suit";
        }
        return false;
      }
    }
    //the cards are of the same suit
    return true;
  }

  //Returns true if the player tries to play a point on the first trick
  boolean firstTrickPoint(Card card) {
    if (hand.size() == 13) {
      if (card.suit == HEARTS || (card.suit == SPADES && card.number == QUEEN)) {
        if (playerNumber == SOUTH) {
          messageDisplayed = true; 
          message = "Points cannot be played on the first trick";
        }
        return true;
      }
    }
    return false;
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
              messageDisplayed = true; 
              message = "Hearts have not been broken";
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

  void resetPlayer() {
    hand = new ArrayList(); 
    cardsWon = new ArrayList(); 
    cardsToPass = new ArrayList(); 
    numHearts = 0; 
    numSpades = 0; 
    numDiamonds = 0; 
    numClubs = 0; 
    points = 0;
    shootingMoon = false;
  }
}

