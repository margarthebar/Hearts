class Button {
  float x, y;
  float buttonWidth, buttonHeight;
  boolean  boundaryDisplayed;
  String txt;

  Button(String t, float xcor, float ycor, float w, float h, boolean b) {
    txt = t;
    x = xcor;
    y = ycor;
    buttonWidth = w;
    buttonHeight = h;
    boundaryDisplayed = b;
  }

  Button(String t, float xcor, float ycor, boolean b) {
    this(t, xcor, ycor, textWidth(t)*2, 50, true);
  }

  Button(String t, float xcor, float ycor) {
    this(t, xcor, ycor, true);
  }

  void draw() {
    rectMode(CENTER);
    textAlign(CENTER, CENTER); 
    fill(100);
    stroke(255);
    rect(x, y, buttonWidth, buttonHeight);
    if (hoveredOver() ){
      fill(255, 0, 0);
    } else {
      fill(255);
    }
    text(txt, x, y);
  }

  boolean hoveredOver() {
    if (mouseX>x-(buttonWidth/2) && mouseX <x+(buttonWidth /2) && mouseY>y-(buttonHeight/2) && mouseY<(y+buttonHeight/2)) {
      return true;
    }
    return false;
  }
}

