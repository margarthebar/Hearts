int cardWidth;
int cardHeight;

void setup() {
  size(700, 700);
  background(0, 100, 0);
  cardWidth = 50;
  cardHeight = 70;
}

void draw() {
  for (int i=0; i<13; i++) {
    //could be a draw method in the card class?
    //cardBack(145+(i*30), 550);
  }
  
  rectMode(CENTER);
  //rect(width/2-15,550,cardWidth,cardHeight);
  //rect(width/2+15,550,cardWidth,cardHeight);
  //cardBack(width/2-15,550);
  cardBack(width/2+15,550);
  rectMode(CORNER);
}

//varying in orientation based on player
void cardBack(float x, float y) {
  boolean redFirst = true;
  rectMode(CENTER);
  for (int j=0; j<69; j+=3.5) {
    for (int i=0; i<50; i+=5) {
      if (redFirst) {
        fill(195, 0, 0);
        stroke(195,0,0);
        rect(x-cardWidth/2+i+2, y-cardHeight/2+j+2, 2.5, 3.5);
        fill(255);
        stroke(255);
        rect(x-cardWidth/2+i+2.5+2, y-cardHeight/2+j+2, 2.5, 3.5);
      } else {
        fill(255);
        stroke(255);
        rect(x-cardWidth/2+i+2, y-cardHeight/2+j+2, 2.5, 3.5);
        fill(195, 0, 0);
        stroke(195,0,0);
        rect(x-cardWidth/2+i+2.5+2, y-cardHeight/2+j+2, 2.5, 3.5);
      }
    }
    redFirst = !redFirst;
  }
  stroke(255);
  noFill();
  rect(x, y, 50, 70);
  rect(x, y, 48, 68);
  rect(x, y, 46, 66);
  stroke(195,0,0);
  strokeWeight(1.5);
  rect(x, y, 44, 64);
  strokeWeight(1);
  stroke(0);
  rectMode(CORNER);
}

void mouseClicked() {
//  for (int i=0; i<13; i++) {
//    int cardX = 145+(i*30);
//    int cardY = 550;
//      if (mouseX>cardX+2 && mouseX<cardX+48 &&
//      mouseY>cardY+2 && mouseY<cardY+48) {
//      stroke(150,150,0);
//      strokeWeight(6);
//      noFill();
//      rect(cardX-2, cardY-2, 54, 74);
//      strokeWeight(1);
//      stroke(0);
//      print("here");
//    }
//  }
}

