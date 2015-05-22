void setup() {
  size(700, 700);
  background(0, 100, 0);
}

void draw() {
  cardBack(200, 200);
}

void cardBack(float x, float y) {
  fill(195, 0, 0);
  rect(x, y, 50, 70);
  fill(255);
  boolean redFirst = false;
  for (int j=0; j<70; j+=3.5) {
    for (int i=0; i<50; i+=5) {
      if (redFirst) {
        fill(195, 0, 0);
        rect(x+i, y+j, 2.5, 3.5);
        fill(255);
        rect(x+i+2.5, y+j, 2.5, 3.5);
      } else {
        fill(255);
        rect(x+i, y+j, 2.5, 3.5);
        fill(195, 0, 0);
        rect(x+i+2.5, y+j, 2.5, 3.5);
      }
    }
    redFirst = !redFirst;
  }
}

