class Doodle {
  
  NeuralNet brain;
  
  ArrayList<Pad> pads;
  ArrayList<Pad> padPos;
  
  PVector pos;
  PImage sprite;
  
  float lifetime;
  float movement = 0;
  float padspacing;
  float w, h;
  float fitness;
  float yspeed;
  float xacc;
  
  int score = 0;
  int padCount = 10;
  int padItter = 0;
  
  boolean dead = false;
  boolean replay = false;
  
  float[] vision;
  float[] decision;
   
  Doodle() {
    lifetime = 1000;
    brain = new NeuralNet(5,hidden_nodes,3,hidden_layers);
    pads = new ArrayList<Pad>();
    padPos = new ArrayList<Pad>();
    padspacing = height/padCount;
    for(int i=padCount; i>=1; i--) {
       Pad newPad = new Pad(random(40,width-40), i*padspacing);
       pads.add(newPad);
       padPos.add(newPad.clone());
    }
    pos = new PVector(width/2, height/2);
    sprite = loadImage("/sprites/doodle.png");
    w = 80;
    h = 80;
    fitness = 0;
    yspeed = -gravity;
    xacc = 0;
  }
  
  Doodle(ArrayList<Pad> padPositions) {
    replay = true;
    lifetime = 1000;
    brain = new NeuralNet(5,hidden_nodes,3,hidden_layers);
    pads = new ArrayList<Pad>();
    padPos = padPositions;
    for(int i=1; i<=10; i++) {
       Pad newPad = padPos.get(padItter).clone();
       pads.add(newPad);
       padItter += 1;
    }
    pos = new PVector(width/2, height/2);
    sprite = loadImage("/sprites/doodle.png");
    w = 80;
    h = 80;
    fitness = 0;
    yspeed = -gravity;
    xacc = 0;
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
  
  void moveLeft() {
    if(xacc > 0) {
      moveStop();
    }
    if(xacc > -10) {
      xacc -= 0.5;
    }
  }
  
  void moveRight() {
    if(xacc < 0) {
      moveStop();
    }
    if(xacc < 10) {
      xacc += 0.5;
    }
  }
  
  void moveStop() {
     xacc = 0; 
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
      yspeed -= gravity;
      pos.x += xacc;
      //println(xacc);
      if(pos.x < 0) {
         pos.x = width; 
      } else if(pos.x > width) {
         pos.x = 0; 
      }
      if(!humanPlaying) {
        lifetime-=1;
        if(lifetime < 0) {
         dead = true; 
        }
      }
      for(int i=0; i<pads.size(); i++) {
         pads.get(i).movex();
      }
    }
  }
  
  void moveUp() {
    for(int i=0; i<pads.size(); i++) {
       pads.get(i).move(yspeed);
    }
    if(pads.get(0).pos.y > height) {
       float pady = pads.get(0).pos.y;
       pads.remove(0);
       if(pads.size() < padCount) {
         if(replay) {
              pads.add(padPos.get(padItter).clone());
              padItter += 1;
         } else {
             int choice = floor(random(0,10));
             Pad newPad;
             if(choice == 1) {
               newPad = new  MovingPad(random(40,width-40), pads.get(pads.size()-1).pos.y-padspacing); 
             } else if(choice == 2) {
               newPad = new BrokenPad(random(40,width-40), pads.get(pads.size()-1).pos.y-padspacing);
             } else {
               newPad = new Pad(random(40,width-40), pads.get(pads.size()-1).pos.y-padspacing);
             }
             pads.add(newPad);
             padPos.add(newPad.clone());
         }
       }
     } 
     score+=1;
     if(score % 1000 == 0 && padCount > 5) {
        padCount-=1; 
        padspacing = height / padCount;
     }
     lifetime = 100;
  }
  
  void moveDown() {
    if(pos.y > height) {
       dead = true;
    }
    pos.y += abs(yspeed);
    for(int i=0; i<pads.size(); i++) {
        Pad currentpad = pads.get(i);
        if(currentpad.checkCollisionBounce(pos.x-w/2,pos.y+h/2) || currentpad.checkCollisionBounce(pos.x+20, pos.y+h/2)) {
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
     while(!padCollision(vis.x, vis.y)) {
        if (vis.x < 0 || vis.x > width || vis.y < 0 || vis.y > height) {
          return 0; 
        }
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
           moveLeft();
           break;
         case 1:
           moveStop();
           break;
         case 2:
           moveRight();
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
