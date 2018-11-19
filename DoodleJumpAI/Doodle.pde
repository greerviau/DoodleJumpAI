class Doodle {
  
  Brain brain;
  
  ArrayList<Pad> pads;
  ArrayList<PVector> padPos;
  
  PVector pos;
  PImage sprite;
  
  float lifetime;
  float movement = 0;
  float padspacing;
  float w, h;
  float fitness;
  float yspeed;
  
  int score = 0;
  int padItter = 0;
  
  boolean dead = false;
  boolean replay = false;
  
  float[] vision;
  float[] decision;
   
  Doodle() {
    lifetime = 1000;
    brain = new Brain(5,16,2);
    pads = new ArrayList<Pad>();
    padPos = new ArrayList<PVector>();
    padspacing = height/10;
    for(int i=10; i>=1; i--) {
       Pad newPad = new Pad(random(40,width-40), i*padspacing);
       pads.add(newPad);
       padPos.add(new PVector(newPad.pos.x, newPad.pos.y));
    }
    pos = new PVector(width/2, height/2);
    sprite = loadImage("/sprites/doodle.png");
    w = 80;
    h = 80;
    fitness = 0;
    yspeed = -acc;
  }
  
  Doodle(ArrayList<PVector> padPositions) {
    replay = true;
    lifetime = 1000;
    brain = new Brain(5,16,2);
    pads = new ArrayList<Pad>();
    padPos = padPositions;
    for(int i=1; i<=10; i++) {
       PVector newPad = padPos.get(padItter);
       pads.add(new Pad(newPad.x, newPad.y));
       padItter += 1;
    }
    pos = new PVector(width/2, height/2);
    sprite = loadImage("/sprites/doodle.png");
    w = 80;
    h = 80;
    fitness = 0;
    yspeed = -acc;
  }
  
  void show() {
    for(int i=0; i<pads.size(); i++) {
      pads.get(i).show(); 
    }
    imageMode(CENTER);
    image(sprite, pos.x, pos.y, w, h);
  }
  
  void catchUp() {
     pos.y -= yspeed; 
  }
  
  void move() {
    if(!dead) {
      if(yspeed > 0) {
        if(pos.y > height/2) {
           catchUp(); 
        } else {
           moveUp();
        }
      }
      if(yspeed < 0) {
         moveDown();
      }
      yspeed -= acc;
     
      pos.x += movement;
      if(pos.x < 0) {
         pos.x = width; 
      } else if(pos.x > width) {
         pos.x = 0; 
      }
      lifetime-=1;
      if(lifetime < 0) {
         dead = true; 
      }
    }
  }
  
  void moveUp() {
     for(int i=0; i<pads.size(); i++) {
       pads.get(i).move(yspeed);
     }
     for(int i=0; i<pads.size(); i++) {
        if(pads.get(i).pos.y > height) {
           float pady = pads.get(i).pos.y;
           pads.remove(i);
           if(replay) {
              PVector newPad = padPos.get(padItter);
              pads.add(new Pad(newPad.x, newPad.y));
              padItter += 1;
           } else {
             Pad newPad = new Pad(random(40,width-40), pady-height);
             pads.add(newPad);
             padPos.add(new PVector(newPad.pos.x, newPad.pos.y));
           }
        }
     } 
     score+=1;
     lifetime = score;
  }
  
  void moveDown() {
    if(pos.y > height) {
       dead = true;
    }
    pos.y += abs(yspeed);
    for(int i=0; i<pads.size(); i++) {
        Pad currentpad = pads.get(i);
        if(currentpad.checkCollision(pos.x-w/2,pos.y+h/2) || currentpad.checkCollision(pos.x+20, pos.y+h/2)) {
            yspeed = 15;
        }
    } 
  }
  
  boolean padCollision(float x, float y) {
    for(int i=0; i<pads.size(); i++) {
      if(pads.get(i).checkCollision(x,y)) {
        return true;
      }
    }
    return false;
    
  }
  
  void look() {
      vision = new float[5];
      vision[0] = lookInDirection(new PVector(10,0));
      vision[1] = lookInDirection(new PVector(10,10));
      vision[2] = lookInDirection(new PVector(0,10));
      vision[3] = lookInDirection(new PVector(-10,10));
      vision[4] = lookInDirection(new PVector(-10,0));
  }
  
  float lookInDirection(PVector direction) {
     float look = 0;
     PVector vis = new PVector(pos.x, pos.y);
     float distance = 0;
     while(!padCollision(vis.x, vis.y) && (vis.x > 0 && vis.x < width && vis.y > 0 && vis.y < height)) {
        vis.add(direction);
        distance+=1;
        /*  Used to see vision
        if(replay) {
          fill(0);
          noStroke();
          ellipse(vis.x,vis.y,3,3);
        }*/
     }
     look = 1/distance;
     return look;
  }
  
  void think() {
      decision = brain.output(vision);
      int maxIndex = 0;
      float max = 0;
      for(int i=0; i< decision.length; i++) {
         if(decision[i] > max) {
            max = decision[i];
            maxIndex = i;
         }
      }
      
      switch(maxIndex) {
         case 0:
           movement = -10;
           break;
         case 1:
           movement = 10;
           break;
      }
  }
  
  float calculateFitness() {
     fitness = score; 
     return fitness;
  }
  
  void mutate() {
     brain.mutate(mutationRate); 
  }
  
  Doodle clone() {
     Doodle clone = new Doodle();
     clone.brain = brain.clone();
     return clone;
  }
  
  Doodle cloneReplay() {
     Doodle clone = new Doodle(padPos);
     clone.brain = brain.clone();
     return clone;
  }
  
  Doodle breed(Doodle parent) {
     Doodle child = new Doodle();
     child.brain = brain.crossover(parent.brain);
     return child;
  }
}
