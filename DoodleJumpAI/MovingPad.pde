class MovingPad extends Pad {
  
  float xspd = 3;
  
  MovingPad(float x, float y) {
    super(x, y);
  }
  
  void show() {
      fill(51,153,255);
      stroke(0);
      rectMode(CENTER);
      rect(pos.x, pos.y, w, h, 6);
   }
  
  void move(float yspeed) {
      pos.y+=yspeed;
  }
  
  void movex() {
     if(pos.x < 40) {
          xspd = 3;
      } else if(pos.x > width - 40) {
          xspd = -3;
      }
      pos.x+=xspd; 
  }
  
  Pad clone() {
      Pad clone = new MovingPad(pos.x,pos.y);
      return clone;
   }
}
