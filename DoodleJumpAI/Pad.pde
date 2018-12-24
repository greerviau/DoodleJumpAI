<<<<<<< HEAD
class Pad {
   PVector pos;
   
   float w, h;
  
   Pad(float x, float y) {
     pos = new PVector(x, y);
     w = 80;
     h = 20;
   }
   
   void show() {
      fill(74,181,78);
      stroke(0);
      rectMode(CENTER);
      rect(pos.x, pos.y, w, h, 6);
   }
   
   void move(float yspeed) {
     pos.y+=yspeed;
   }
   
   void movex() {}
   
   boolean checkCollisionBounce(float x, float y) {
      if(x >= pos.x-w/2 && x <= pos.x+w/2 && y >= pos.y-h/2 && y <= pos.y+h/2) {
         return true; 
      }
      return false;
   }
   
   boolean checkCollision(float x, float y) {
      if(x >= pos.x-w/2 && x <= pos.x+w/2 && y >= pos.y-h/2 && y <= pos.y+h/2) {
         return true; 
      }
      return false;
   }
   
   Pad clone() {
      Pad clone = new Pad(pos.x,pos.y);
      return clone;
   }
}
=======
class Pad {
   PVector pos;
   
   float w, h;
  
   Pad(float x, float y) {
     pos = new PVector(x, y);
     w = 80;
     h = 20;
   }
   
   void show() {
      fill(74,181,78);
      stroke(0);
      rectMode(CENTER);
      rect(pos.x, pos.y, w, h, 6);
   }
   
   void move(float yspeed) {
      pos.y+=yspeed;
   }
   
   boolean checkCollision(float x, float y) {
      if(x >= pos.x-w/2 && x <= pos.x+w/2 && y >= pos.y-h/2 && y <= pos.y+h/2) {
         return true; 
      }
      return false;
   }
}
>>>>>>> 8e2b0832e06643ce049c576ec6d13ccb6eed751b
