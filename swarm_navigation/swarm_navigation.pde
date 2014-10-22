// Alex Johnson - IM 2250 - Programming for Digital Media
// Programming Exploration 5 v2 | Due 10/27/14

import java.util.Iterator;
import java.lang.Math;

final int margin = 40;
PVector initLocation = new PVector(0, 0);
PVector initAcceleration = new PVector(0, 0);

// Init Object Count
int startSwarms = 3;
int startFish   = 20;

// Init Objects
ArrayList<Ripple> ripples = new ArrayList<Ripple>();
ArrayList<Swarm> swarms = new ArrayList<Swarm>();
Food food;

// Limit rate of food regeneration
// 100 = 100 game ticks per new food;
int foodRegenCounter = 0;
int foodRegenThreshold = 50;

// Fish decy (starve). Amount of opacity (0-255) 
// lost per tick of not eating
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
  
  removeOldRipples();
  removeOldFish();
}

void mouseClicked(){
  println(mouseX + " " + mouseY);
}

void drawHUD() {
  // Draw stats for each swarm
  for (int i = swarms.size () - 1; i >= 0; i--) {
    
    // Get current swarm
    Swarm s = swarms.get(i);
    textSize(15);
    
    int y = 25 * i + 30; // vertical offset
    int x = 20;           // horiontal offset

    pushMatrix();
      translate(x, y);
  
      // Color box
      fill(s.getColor());
      rect(0, -10, 20, 10);
  
      // Text
      fill(240);    
      text("Swarm Score : " + s.score + " Points | " + s.vehicles.size() + " Fish", 30, 0);
  
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
     
     if (s.score > 49){
       s.score += -50;
       s.addFish(displayWidth / 4, displayHeight / 4);
     }

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
    for (int j = fish.vehicles.size() - 1; j >= 0; j--){
      Vehicle f = fish.vehicles.get(j);
      if (f.dangerLevel < 0.1){
        ripples.add(new Ripple(f.location.x, f.location.y, color(255, 255, 150)));
        fish.vehicles.remove(j);
      }
    }
  }
}




