Doodle player;

Population pop;

final int hidden_layers = 2;
final int hidden_nodes = 4;

float acc = 0.3;
float mutationRate = 0.01; 

boolean humanPlaying = false;
boolean replayBest = true;

int highscore = 0;

void setup() {
  frameRate(120);
  size(600,1000);
  if(humanPlaying) {
    player = new Doodle();
  } else {
    pop = new Population(200); 
  }
}

void draw() {
   background(200);
   if(humanPlaying) {
     player.move();
     player.show();
     if(player.dead) {
        highscore = player.score;
        player = new Doodle(); 
     }
     fill(0);
     textAlign(CORNER,TOP);
     textSize(30);
     text("Score : "+player.score, 10, 10);
     text("Highscore : "+highscore, 10, 10);
   } else {
      if(pop.done()) {
         highscore = pop.bestDoodle.score;
         pop.calculateFitness();
         pop.naturalSelection();
      } else {
         pop.update();
         pop.show();
      }
      fill(0);
      textAlign(CORNER,TOP);
      textSize(30);
      text("Score : "+pop.bestDoodle.score, 10, 10);
      text("Highscore : "+highscore, 10, 50);
      text("Gen : "+pop.gen, 450, 10);
   }
   
}

void keyPressed() {
  if(humanPlaying) {
    if(key == CODED) {
       if(keyCode == LEFT) {
          player.movement = -10;
       }
       if(keyCode == RIGHT) {
          player.movement = 10; 
       }
    }
  }
}

void keyReleased() {
  if(humanPlaying) {
    if(key == CODED) {
       if(keyCode == LEFT && player.movement == -10) {
          player.movement = 0;
       }
       if(keyCode == RIGHT && player.movement == 10) {
          player.movement = 0; 
       }
    }
  }
}
