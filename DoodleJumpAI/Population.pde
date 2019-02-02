class Population {
   Doodle[] doodles;
   
   Doodle bestDoodle;
  
   int gen = 0;
   
   float fitnessSum;
   float bestFitness = 0;
  
   Population(int size) {
       doodles = new Doodle[size];
       for(int i=0; i<size; i++) {
          doodles[i] = new Doodle(); 
       }
       bestDoodle = doodles[0];
   }
   
   void show() {
     if(!replayBest) {
        for(int i=0; i<doodles.length; i++) {
           doodles[i].show(); 
        }
     } else {
        bestDoodle.show(); 
        bestDoodle.brain.show(10,height-160,200,150,bestDoodle.vision,bestDoodle.decision);
     }
   }
   
   void update() {
     if(!bestDoodle.dead) {
        bestDoodle.look();
        bestDoodle.think();
        bestDoodle.move();
     }
     for(int i=0; i<doodles.length; i++) {
        if(!doodles[i].dead) {
           doodles[i].look();
           doodles[i].think();
           doodles[i].move(); 
        }
     }
   }
   
   boolean done() {
      for(int i=0; i<doodles.length; i++) {
         if(!doodles[i].dead) {
            return false; 
         }
      }
      if(!bestDoodle.dead) {
         return false; 
      }
      return true;
   }
   
   void calculateFitness() {
     fitnessSum = 0;
     for(int i=0; i<doodles.length; i++) {
        fitnessSum += doodles[i].calculateFitness(); 
     }
   }
   
   void setBestDoodle() {
      int bestIndex = 0;
      float best = 0;
      for(int i=0; i<doodles.length; i++) {
          if(doodles[i].fitness > best) {
             best = doodles[i].fitness;
             bestIndex = i;
          }
      }
      if(best > bestFitness) {
        bestFitness = best;
        bestDoodle = doodles[bestIndex].cloneReplay();
        bestDoodle.replay = true;
        println("Gen "+gen+" Best Fitness "+bestFitness);
      } else {
        bestDoodle = bestDoodle.cloneReplay(); 
      }
   }
   
   Doodle selectDoodle() {
      float rand = random(fitnessSum);
      float runSum = 0;
      for(int i=0; i<doodles.length; i++) {
        runSum += doodles[i].fitness;
        if(runSum > rand) {
            return doodles[i];
        }
      }  
      return doodles[0];
   }
   
   void naturalSelection() {
        setBestDoodle();
        
        Doodle[] newDoodles = new Doodle[doodles.length];
        newDoodles[0] = bestDoodle.clone();
        for(int i=1; i<newDoodles.length; i++) {
            Doodle child = selectDoodle().breed(selectDoodle());
            child.mutate();
            newDoodles[i] = child;
            
        }
        doodles = newDoodles.clone();
        gen+=1;
     
   }
   
   
   
   
}
