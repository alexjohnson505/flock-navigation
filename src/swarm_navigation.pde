
// SWARM NAVIGATION 
// Simulation of Flocking AI

// Updated by Alex Johnson. More info on:
// github.com/alexjohnson505/swarm-navigation

/*******************************
     USER INTERACTION
 *******************************/

// Swarms navigate the environment. When a fish
// collects a food, they reproduce, and their health
// is refreshed. When a fish goes too long without
// eating, they will fade away and die.

// Click on the screen to place a new food item
// at the center of your cursor.

/********************************/

import java.util.Iterator;
import java.lang.Math;

final int margin = 40;

PVector initLocation = new PVector(0, 0);
PVector initAcceleration = new PVector(0, 0);

// Init Objects
ArrayList<Ripple> ripples = new ArrayList<Ripple>();
ArrayList<Swarm> swarms = new ArrayList<Swarm>();

Food food;

/*******************************
     EDITABLE PARAMETERS
 *******************************/

int startSwarms = 4;   // Starting Swarms
int startFish   = 20;  // Initial fish per swarm

// Rate of food regeneration
int foodRegenCounter = 0;
int foodRegenThreshold = 15;

// Fish decay (starve) over time.
// decayRate represents damage per
// tick of not eating.
float decayRate = 0.1;

// Accumulate momentum when turning
float turnMomentum = 1;

// Enables additional developer settings
boolean debug = false;

void setup() {

  if (debug){
    size(1000, 500);
  } else {
    size(screen.width, screen.height);
  }
  
  food = new Food();

  // Hard-code pastel colors for swarms
  ArrayList<color> colors = [#f2635d,#fab567,#fdda7c,#b3d88b,#75bfc2,#016f94];

  // Init NPC Swarms 
  for (int i = startSwarms; i > 0; i--) {
    swarms.add(new Swarm(colors[i]));
  }

  // Init Start Fish
  for (Swarm s : swarms) {
    for (int i = startFish; i > 0; i--) {
      s.addFish(random(0, screen.width), random(screen.height));
    }
  } 

  // Initialize player fish.
  // player = true, then the boid will take
  // less influence from neighbors, as well
  // as be controlled via keyboard controls

  f = swarms.get(0).fishs.get(0);
  f.player = true;

  // Help player find their controlable fish
  ripples.add(new Ripple(f.location.x, f.location.y, color(255, 255, 355)));

}

void draw() {
  background(0,0,0);
  
  for (Ripple r : ripples){ r.draw(); } // Draw Ripples
  for (Swarm s : swarms) { s.move(); }  // Draw Swarms
  
  food.draw(); // Draw Food
  drawHUD();   // Draw HUD
  
  removeOldRipples(); // Garbage Collect
  removeOldFish();    // Garbage Collect
}

void mouseDragged(){
  food.addFood(mouseX, mouseY);
}

// Create informational GUI for user.
// Display stats on current swarms
void drawHUD() {
  
  // Draw stats for each swarm
  for (int i = swarms.size() - 1; i >= 0; i--) {
    
    Swarm s = swarms.get(i); // Get current swarm

    renderHUDitem(s, i);
  }
}

void renderHUDitem(Swarm s, int i){
  
  int y = 25 * i + 30;  // vertical offset
  int x = 20;           // horiontal offset

  pushMatrix();
    translate(x, y);

    // Color box
    fill(s.getColor());
    rect(0, -10, 20, 10);

    // Text
    fill(255);    
    textSize(15);

    // More info:
    text(s.countFish(), 30, 0);
   
  popMatrix();
  noStroke();
}

void keyPressed(){

  if (key == 's'){
    changeSelected(1);
  }
  if (key == 'w'){
    changeSelected(-1);
  }

  // Check for arrow keys
  // Control player boid
  if (key == CODED) {
    
    // Get first fish of first swarm
    f = swarms.get(0).fishs.get(0);

    turnMomentum += .2;

    if (keyCode == RIGHT) {
      f.turn(1 * turnMomentum);
    } else if (keyCode == LEFT) {
      f.turn(-1 * turnMomentum);
    } else if (keyCode == UP){
      f.accelerate(1 * turnMomentum);
    } else if (keyCode == DOWN){
      f.accelerate(-1 * turnMomentum);
    }
  }
};

void keyReleased(){
  turnMomentum = 1;

}

// Change the current 'active' swarm
void changeSelected(int x){
  int i = selectedSwarmIndex();
  int size = swarms.size();
  
  Swarm s = swarms.get(i);
  s.selected = false;
  
  i = (i + x) % size;
  
  // Stupid Processing Modulo fix.
  //  (0 - 1) % 6 = 5 in Math
  //  println((0 - 1) % 6) = -1 in Processing
  if (i < 0){
    i = size - 1;
  }
  
  Swarm s2 = swarms.get(i);
  s2.selected = true;
}

// Find the currently selected swarm's index
int selectedSwarmIndex(){
  int acc = 0;
  
  for (int i = swarms.size () - 1; i >= 0; i--) {
    if (swarms.get(i).selected == true) {
      acc = i;
    } 
  }
  
  return acc;
}

// Garbage collect expired ripples
void removeOldRipples(){
  for (int i = ripples.size() - 1; i >= 0; i--){
    Ripple r = ripples.get(i);
    if (r.currentFrame > 50){
      ripples.remove(i);
    }
    
  }
}

// Garbage collect dead fish
void removeOldFish(){

  // Iterate through Swarms
  for (int i = swarms.size() - 1; i >= 0; i--) {
    Swarm fish = swarms.get(i);
    
    // Iterate through fish
    for (int j = fish.fishs.size() - 1; j >= 0; j--){
      Fish f = fish.fishs.get(j);
      if (!f.player && f.dangerLevel < 0.2){
        ripples.add(new Ripple(f.location.x, f.location.y, color(120, 120, 120)));
        fish.fishs.remove(j);
      }
    }
  }
}

