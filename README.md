# Hearts
Team <3's

Description: This project will be the card game Hearts. The user will play against three AI opponents.

Development Log
<br>5/25/15:
 - Each player is dealt a random hand of 13 cards
 - The cards the user is dealt are displayed
 - The user can select a card to play using the arrow keys

5/26/15:
 - The user can play a card into the center of the playing area
 - The opponents each select a random card to play

5/27/15:
 - The two of clubs must be played first
 - The opponents play cards automatically
 - The game cycles through tricks

5/28/15:
 - Played cards are cleared after a trick is finished
 - There are delays between cards being played
 - The player can only play one card during a turn

5/29/15:
 - Played cards must follow suit if possible
 - Hearts cannot lead a trick until hearts are broken

5/30/15:
 - The correct player wins the trick
 - The player that wins the trick starts the next trick
 - Points are earned

5/31/15:
 - The cards are sorted by suit and number in each hand
 - Bug fixes with breaking hearts and trick winning
 
6/1/15:
 - The winner of a round is determined
 - A new round begins automatically
 - The game recognizes shooting the moon

6/2/15:
 - The game resets once a player reaches 100 points
 - The game recognizes tied rounds

6/3/15:
 - Points are displayed next to the hand
 - Cards can be selected by clicking
 - An animation is played when hearts are broken
 
6/4/15:
 - At the end of each round the results for the round are displayed
 - The user must press enter to go to the next round
 
6/5/15:
 - Changes to the hearts breaking animation

6/6/15:
 - The game winner is determined once a player reaches 100 points
 - The results for the whole game are displayed at the end

6/7/15:
 - Cards are passed at the beginning of each round
 - Cards move towards the trick winner at the end of each trick
 - Bug fixes with card and results display
 - Error messages are displayed onscreen if the user selects an illegal card

6/8/15:
 - Points cannot be played on the first trick
 - Started work on a directions screen
 
6/9/15:
 - The opponents make intelligent decisions on the first trick
 
6/10/15:
 - The opponents make intelligent decisions when leading a trick
 - A main menu is displayed with options to go to a rule screen or direction screen
 - Buttons can be pressed in menus
 
6/11/15:
 - The opponents make intelligent decisions when they must follow suit
 - Started work on an AI for passing cards
 
6/12/15:
 - General improvements to the AI
 
6/13/15:
 - The opponents make intelligent decisions when not leading a trick
 - The opponents decide whether to try shooting the moon
 - The opponents pass cards intelligently
 - The card images and background are loaded from files
 - The rules are displayed at the beginning of each round
 
6/14/15:
 - Bug fixes with counting number of each suit
 - Bug fixes with shooting the moon
 - Adjustments to the display

Project Plan

Done:
 - Build the basic playing area in Processing 
 - Card class
 - Display of cards on screen
 - Allow the user to select a card to play into the center
 - Restrict user to legal plays only
 - Automatic and random play for the three opponents
 - Turns/normal gameplay
 - Mouse interaction with cards
 - End the game and declare a winner
 - Restart game
 - AI algorithms
 - Menus
 - Polished display and animation
 
Demo Versions 
<br>6/1/15: https://github.com/margarthebar/Hearts/tree/774a817426dafed94b7b6c1c0dccc41c4d2c24f4/Hearts
<br>The user can play the game by selecting a card with the left and right arrow keys and pressing up to play that card. The opponents play random cards from their hand that follow the rules of the game. Points earned by each player are counted.
<br>6/8/15: https://github.com/margarthebar/Hearts/tree/d77062dad69f587b8b3585f2e3051f5f4df6687c/Hearts
<br>Error messages and points for each player are displayed in the game. At the end of each round, results for the round are displayed and the user can move on to the next round. A winner is determined at the end of the game and the user can restart. All of the gameplay aspects have been implemented, but there is no AI and the opponents play random moves that follow the rules.
<br>6/15/15: https://github.com/margarthebar/Hearts/tree/master/Hearts
<br>The opponents play intelligent moves and try to win the game. The card images and background have been improved to look more professional. The user is first taken to a main menu and can select whether to play the game or to view rules. While in the game, the user is given directions and can go back to the main menu at any time. 
