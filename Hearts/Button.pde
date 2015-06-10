class Button{
 int x, y;
 int buttonWidth, buttonHeight;
 boolean  boundaryDisplayed;
 String txt;
 
 Button(String t, int xcor, int ycor, int w, int h, boolean b){
   txt = t;
   x = xcor;
   y = ycor;
   buttonWidth = w;
   buttonHeight = h;
   boundaryDisplayed = b;
 }
 
 Button(String t, int xcor, int ycor, boolean b){
   this(t,xcor,ycor,100,50,true);
 }
 
 Button(String t, int xcor, int ycor){
   this(t,xcor,ycor,true);
 }
 
 void draw(){
   rectMode(CENTER);
   textAlign(CENTER,CENTER); 
 }
}
