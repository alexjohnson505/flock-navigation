// Alex Johnson - IM 2250 - Programming for Digital Media
// Programming Exploration 5 v2 | Due 10/27/14

/*******************************
     USER INTERACTION
 *******************************/
// Swarms navigate the environment. When a fish
// collects a food, they reproduce, and their health
// is refreshed. When a fish goes too long without
// eating, they will fade away and die (yellow ripple).

// Click on the screen to place a new food item
// at the center of your cursor.

// Press 'W' & 'S' to change the currently selected
// swarm. Notice how a white box is drawn around their
// color in the top left of the screen.

// Press 'D' to grant extra fish to the currently
// selected swarm.
 
// Updated features include:
// Ripples for Fish Spawn
// Ripples for Food spawn
// Ripples for Fish Death
// Constant Rate of food spawn
// Opacities for starving fish
// Re-names objects to be more appropriate
// Refactored code
// Users can now manually drop food
// Display fish count in GUI

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

int startSwarms = 3;   // Starting Swarms
int startFish   = 20;  // Initial fish per swarm

// Limit rate of food regeneration
// (default) 20 game ticks per new food;
int foodRegenCounter = 0;
int foodRegenThreshold = 20;

// Fish decay (starve) over time.
// decayRate represents damage per
// tick of not eating. 
float decayRate = 0.1;

void setup() {

  float width  = displayWidth / 3;
  float height = displayHeight;

  size((int)width, (int)height);
  
  food = new Food();

  // Init Swarms 
  for (int i = startSwarms; i > 0; i--) {
    Swarm s = new Swarm();
    swarms.add(s);
  } 

  // Init Start Fish
  for (int i = startFish; i > 0; i--) {
    for (Swarm s : swarms) {
      s.addFish(displayWidth / 4, displayHeight / 4);
    }
  
    // Init a food for every starting fish in a swarm
    food.addFood();
  }
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

void mouseClicked(){
  food.addFood(mouseX, mouseY);
}

// Create informational GUI for user.
// Display stats on current swarms
void drawHUD() {
  
  // Draw stats for each swarm
  for (int i = swarms.size () - 1; i >= 0; i--) {
    
    // Get current swarm
    Swarm s = swarms.get(i);
    textSize(15);
    
    int y = 25 * i + 30;  // vertical offset
    int x = 20;           // horiontal offset

    pushMatrix();
      translate(x, y);
  
      // Color box
      fill(s.getColor());
      rect(0, -10, 20, 10);
  
      // Text
      fill(240);    
      
      // More info:
      // text("Swarm Score : " + s.score + " Points | " + s.fishs.size() + " Fish", 30, 0);
      
      // Basic info: fish count
      text(s.fishs.size(), 30, 0);
  
      // Display indicator for currently selected swarm 
      if (s.selected) {
        noFill();
        stroke(2);
        stroke(240, 240, 240);
        rect(-5, -16, 29, 22);
      }
     
    popMatrix();
    noStroke();
  }
}

void keyPressed(){
  if (key == 's'){
    changeSelected(1);
  }
  if (key == 'w'){
    changeSelected(-1);
  }
  
  if (key == 'd'){
     int i = selectedSwarmIndex();
     Swarm s = swarms.get(i);
     
     s.score += -10;
     int x = displayWidth / 4;
     int y = displayHeight / 4;
     s.addFish(x, y);
     ripples.add(new Ripple(x, y, s.c));
  }
}

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
      if (f.dangerLevel < 0.2){
        ripples.add(new Ripple(f.location.x, f.location.y, color(255, 255, 150)));
        fish.fishs.remove(j);
      }
    }
  }
}


