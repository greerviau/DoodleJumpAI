class BrokenPad extends Pad {
  
   boolean active = true;
   
   BrokenPad(float x, float y) {
      super(x, y);
   }
   
   void show() {
     if(active) {
      fill(255,51,51);
      stroke(0);
      rectMode(CENTER);
      rect(pos.x, pos.y, w, h, 6);
     }
   }
   
   boolean checkCollisionBounce(float x, float y) {
      if(x >= pos.x-w/2 && x <= pos.x+w/2 && y >= pos.y-h/2 && y <= pos.y+h/2) {
         if(active) {
           active = false;
           return true;
         }
      }
      return false;
   }
   
   boolean checkCollision(float x, float y) {
      if(x >= pos.x-w/2 && x <= pos.x+w/2 && y >= pos.y-h/2 && y <= pos.y+h/2 && active) {
         return true; 
      }
      return false;
   }
   
   Pad clone() {
      Pad clone = new BrokenPad(pos.x,pos.y);
      return clone;
   }
}
