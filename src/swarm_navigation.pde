
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

// Press 'W' & 'S' to change the currently selected
// swarm. Notice how a white box is drawn around their
// color in the top left of the screen. Press 'D' to 
// grant extra fish to the currently selected swarm

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
// (default) 20 game ticks per new food;
int foodRegenCounter = 0;
int foodRegenThreshold = 20;

// Fish decay (starve) over time.
// decayRate represents damage per
// tick of not eating.
float decayRate = 0.1;

void setup() {

  size(screen.width * .75, screen.height * .5);
  
  food = new Food();

  // Init NPC Swarms 
  for (int i = startSwarms; i > 0; i--) {
    swarms.add(new Swarm());
  }

  // Init Start Fish
  for (int i = startFish; i > 0; i--) {
    for (Swarm s : swarms) {
      
      // Start top right
      s.addFish(100, 100);
    }
  
    // Init a food for every starting fish in a swarm
    food.addFood();
  }


  // Init Player Swarm
  var p = new PlayerSwarm();
  p.addFish(900, 150);

  swarms.add(p);

}

void setWindowSize(int w, int h){
	println(w + " " + h);
	windowWidth = w;
	windowHeight = h;
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

     int x = screen.width / 4;
     int y = screen.height / 4;

     s.addFish(x, y);
     ripples.add(new Ripple(x, y, s.c));
  }
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
      if (f.dangerLevel < 0.2){
        ripples.add(new Ripple(f.location.x, f.location.y, color(120, 120, 120)));
        fish.fishs.remove(j);
      }
    }
  }
}

/*********************************
             FOOD
 *********************************/

// Food represents an array of targets
// that fish can eat. 

class Food {
  
  // Represent targets as PVectors
  ArrayList<PVector> food;
  
  Food(){
    food = new ArrayList<PVector>();
  }
  
  // Render each target
  void draw(){
    for (PVector v : food) {
      fill(240, 240, 240);
      noStroke();
      ellipse(v.x, v.y, 5, 5);
    }
     
     updateFoodQuantity();
  }
  
  // Limit rate of food respawn.
  // foodRegenCounter is updated every TICK.
  // when foodRegenCounter exceeds foodRegenThreshold,
  // we can introduce a new food item into the world.
  void updateFoodQuantity(){
    foodRegenCounter++;
  
    if (foodRegenCounter > foodRegenThreshold) {
      foodRegenCounter = 0;
      addFood();
    }
  }
  
  // Add new target to list
  void addFood(){
    float x = random(0, width);
    float y = random(0, height);
    
    food.add(new PVector(x, y));
    ripples.add(new Ripple(x, y, color(255)));
  }

  // Add new target to list
  void addFood(float x, float y){
    food.add(new PVector(x, y));
    ripples.add(new Ripple(x, y, color(255)));
  }
  
  void remove(int index){
    food.remove(index);
  }
  
  // Does a (the fish's location) collide with b (a food item)
  boolean collision(PVector a){
    float threshold = 5.5;
    boolean acc = false;
    
    // Iterate through food 
    for (int i = food.size() - 1; i >= 0; i--){
      PVector b = food.get(i);
     
      float horizontalDifference = abs(a.x - b.x);
      float verticalDifference = abs(a.y - b.y);
      
      boolean collision = (horizontalDifference < threshold) && (verticalDifference < threshold);
      
      if (collision){
        
        // Remove eaten food
        food.remove(i);
      }
      
      acc = collision || acc;
    }
   
    return acc;
    
  }
    
}

/*********************************
             SWARM
 *********************************/

// Swarm represents a grouping of fish. 
// Original code example from  IM 2250 Programming for Digital Media, Fall 2014
class Swarm {
  
  // Yes, I am aware "fishs" is grammatically 
  // incorrect, yet it avoids a LOT of confusion.
  ArrayList<Fish> fishs; 
  color c;
  int score;
  boolean selected;  
  
  Swarm() {
    fishs = new ArrayList<Fish>();
    c = makeNeonColor();
    score = startFish;
    selected = false;
  }

  void move() {
    ArrayList<Fish> reproducingFish = new ArrayList<Fish>();
    
    Iterator<Fish> iterator = fishs.iterator();

    // TODO: Research performance increase for using iterator
    while (iterator.hasNext()) {
       Fish fish = iterator.next();
       
       fish.fly(fishs);
       
       if (food.collision(fish.location)){
         
         // Add ripple at each eaten food
         ripples.add(new Ripple(fish.location.x, fish.location.y, fish.myColor));
        
         fish.feed();
         reproducingFish.add(fish);
         addToScore(1);
      };
    }

    if (selected){
      // drawActiveMesh();
      // Currently, does nothing.     
    }
    
    // Add a new fish for each fish that 
    // obtained food during this frame.
    while(reproducingFish.size() > 0){
       Fish parent = reproducingFish.remove(0);
       addFish(parent.location.x, parent.location.y); 
    }
  }
  
  // Generate a random neon color
  color makeNeonColor(){
    float r = random(0, 255);
    float g = random(0, 255);
    float b = random(0, 255);
  
    // Limit color choice to NEONs
    if (r + g + b < 450){
      
      // Recursively call function to create new color option
      return makeNeonColor();
    } else {
      
      // Return color
      color c = color(r,g,b);
      return c;
    }
  }
  
  void drawActiveMesh(){
    float prevX = 0;
    float prevY = 0;
    
    for (Fish fish : fishs) {
      float diffX = abs(prevX - fish.location.x);
      float diffY = abs(prevY - fish.location.y);
      
      boolean tooFar = diffX > 200 || diffY > 200;
      
      // Draw a rough mesh between selected nodes
      if (prevX != 0 || prevY != 0) {
        if (!tooFar){
          stroke(204, 102, 0);
          line(prevX, prevY, fish.location.x, fish.location.y);
        }
      }
      
      prevX = fish.location.x;
      prevY = fish.location.y;
    }
  }
  
  void addFish(Fish v) {
    fishs.add(v);
  }

  void addFish(float x, float y){
    initLocation.x = x;
    initLocation.y = y;
    initAcceleration.x = random(-0.7, 0.7);
    initAcceleration.y = random(-0.7, 0.7);
  
    Fish v = new Fish(initLocation, initAcceleration, c);
    addFish(v);
  }
  
  color getColor(){
    return c;
  }
  
  int addToScore(int i){
    score = score + i;
    return score;
  }
}

/*********************************
            RIPPLE
 *********************************/

// Ripple is a UI effect.
// Creates 3 circles that radiate outwards from
// a central location. Ripples are stored in an
// ArrayList, as to support multiple Ripples
// occuring at a single time. Ripples also maintain
// a frame count, used to calculate the current step
// in the animation.

class Ripple {
  int currentFrame = 0; // Stores state of animation
  int maxFrame = 50;    // How many frames in animation?
  color c;              // Color
  float x;              // X Position
  float y;              // Y Position
  float width = 100;    // Ripple width
  
  Ripple(float x_, float y_, color c_){
    x = x_;
    y = y_;
    c = c_;
  }
  
  void draw(){
    // Float between 0.0 and 1.0
    float scale = (float)currentFrame / (float)maxFrame;
    
    // Current Alpha transparancy
    float alpha = 250 - (250 * scale);
   
    if (currentFrame < maxFrame){
      pushMatrix();
        noFill();
        strokeWeight(2);
        stroke(c, alpha);
        
        // Triple ripples
        for (int i = 3; i > 0; i--){
          
          // Re-calculate size for each ripple
          float size = width * scale * i/3;
          ellipse(x, y, size, size);
        } 
       
      popMatrix();
    }
    
    currentFrame++;
  }  
}

/*********************************
             FISH
 *********************************/

// Fish represents a single member of a swarm.
// Fish calculates it's location, direction, and
// acceleration based on surrounding members of 
// the same swarm.

// Implements Craig Reynold's classic autonomous 
// steering behaviors, see http://www.red3d.com/cwr/ 
// for more details. This example is based, in part, 
// on code from the book THE NATURE OF CODE by Daniel 
// Shiffman, http://natureofcode.com

class Fish {

  /***************************
       STATUS VARIABLES
   ***************************/

  PVector location;
  PVector velocity;
  PVector acceleration;

  /***************************
       FISH SETTINGS
   ***************************/

  color myColor;
   
  float dangerLevel = 255; // Current Danger, from 0.0 (dead) to 255.0 (safe)  
  
  float r = 6;             // our size in terms of radius
  float maxForce = 0.03;   // maximum steering force
  float maxSpeed = 1.5;    // maximum speed

  float damping = 100;           // arrival damping in pixels
  float neighborDistance = 50;   // cohesion variables

  /***************************
      WANDER SETTINGS
   ***************************/
   
  float wanderRadius = 10;        // radius for our "wander circle"
  float wanderDistance = 80;      // distance for our "wander circle"
  float wanderThetaChange = 0.3;  // amount to change wander theta
  boolean wanderTrace = false;
  float wanderTheta;

  /***************************
      FLOCKING SETTINGS
   ***************************/
   
  float separationWeight = 3.0; // (default) 1.5
  float alignmentWeight = 1.0;
  float cohesionWeight = 1.0;

  // Construction: Fish (location_vector, acceleration_vector, color)
  Fish(PVector l, PVector a, color c) {

    // use default r, maxSpeed, maxForce
    myColor = c;
    location = new PVector(l.x, l.y);
    acceleration = new PVector(a.x, a.y);
    velocity = new PVector(0, 0);
  }

  // Fly: Iterate & update swarm. Update/border/display
  void fly(ArrayList < Fish > fishs) {
    flock(fishs);
    update();
    borders();
    display();
  }

  // Update: location & acceleration
  void update() {
    velocity.add(acceleration); // update velocity
    velocity.limit(maxSpeed);   // limit speed
    location.add(velocity);     // add velocity to location
    acceleration.mult(0);       // reset acceleration to 0 each cycle
  }
  
  // Display: Render our 'fish'
  void display() {
    float theta = velocity.heading2D() + radians(90);
    
    dangerLevel = dangerLevel - decayRate;
   
    fill(myColor, dangerLevel);
    noStroke();

    pushMatrix();
      translate(location.x, location.y);
      rotate(theta);
      beginShape();
      vertex(0, -r * 2);
      vertex(-r, r * 2);
      vertex(r, r * 2);
      endShape(CLOSE);
    popMatrix();
  }

  // --------------------------------------------------------------------
  // Flock: Accumulate new acceleration based on: 
  //   1. separation (steer to avoid crowding local flockmates)
  //   2. alignment (steer towards the average heading of local flockmates)
  //   3. cohesion (steer to move toward the average position of local flockmates).
  // 
  // Each fish only reacts to *nearby* mates. ( determined by distance & direction )
  // More information: http://www.red3d.com/cwr/boids/
  
  void flock(ArrayList < Fish > fishs) {
    
    PVector separationForce = separation(fishs); //  1.) Seperation
    PVector alignmentForce = alignment(fishs);   //  2.) Alighment
    PVector cohesionForce = cohesion(fishs);     //  3.) Cohesion
    
    // arbitrarily weight these forces
    separationForce.mult(separationWeight);
    alignmentForce.mult(alignmentWeight);
    cohesionForce.mult(cohesionWeight);
    
    // Each force vector influences acceleration
    applyForce(separationForce);
    applyForce(alignmentForce);
    applyForce(cohesionForce);
  }
  
  // Seeking:  Calculate steering vector (given target)
  PVector seeking(PVector target) {
    
    // Vector towards desired location
    PVector desired = PVector.sub(target, location);
    
    // Normalize & scale the desired vector
    desired.normalize();
    desired.mult(maxSpeed);
    
    // Subtract Velocity from Desired to calculate Steering
    PVector steer = PVector.sub(desired, velocity);
    
    steer.limit(maxForce); // Limit max steerings
    return steer;
  }

  // Seek: Applies steering force to target
  void seek(PVector target) {
    
    // Vector towards target
    PVector desired = PVector.sub(target, location);
    
    // Normalize & scale the desired vector
    desired.normalize();
    desired.mult(maxSpeed);
    
    // steer = desired - velocity
    PVector steer = PVector.sub(desired, velocity);
    
    steer.limit(maxForce); // Limit max
    applyForce(steer);
  }

  // Flee: applies steering force away from a target
  void flee(PVector t) {
    PVector desiredVelocity = new PVector();
    desiredVelocity = PVector.sub(t, location);
    desiredVelocity.normalize();
    desiredVelocity.mult(maxSpeed);
    
    PVector steer = desiredVelocity;
    steer.sub(velocity);
    steer.limit(maxForce);
    acceleration.sub(steer);
  }

  // Arrive: Calculate steering force towards a target.
  // Apply damping to avoid overshooting
  // demonstrates "desired minus velocity"
  void arrive(PVector target) {

    // desired is a vector pointing from our location to the target
    PVector desired = PVector.sub(target, location);
    float dmag = desired.mag();

    // normalize desired and scale w/ arbitrary damping within 100 pixels
    desired.normalize();
    if (dmag < damping) {

      // we are close to the target, slooooooooow down
      float mag = map(dmag, 0, damping, 0, maxSpeed);
      desired.mult(mag);
    } else {

      // otherwise proceed at full speed
      desired.mult(maxSpeed);
    }

    // steer = desired - velocity
    PVector steer = PVector.sub(desired, velocity);
    steer.limit(maxForce); // limit to maximum steering force
    applyForce(steer);
  }

  // Borders: Support wrap-around movement 
  void borders() {
    if (location.x < -r) location.x = width + r;
    if (location.y < -r) location.y = height + r;
    if (location.x > width + r) location.x = -r;
    if (location.y > height + r) location.y = -r;
  }

  // Separation: Check nearby. Steer away. 
  PVector separation(ArrayList<Fish> fishs) {
    
    float desiredseparation = 35.0f;
    PVector steer = new PVector(0, 0, 0);
    int count = 0;
    
    // Check proximity for all fishs
    for (Fish other: fishs) {
      
      float d = PVector.dist(location, other.location);
     
      // Find targets within range
      // Note: 0 = distance to self.
      if ((d > 0) && (d < desiredseparation)) {
        
        // Calculate vector pointing away from neighbor
        PVector diff = PVector.sub(location, other.location);
        diff.normalize();
        diff.div(d); // weight by distance
        steer.add(diff);
        count++; // keep track of how many
      }
    }
    
    // average 
    if (count > 0) { steer.div((float) count); }
    
    // as long as the vector is greater than 0
    if (steer.mag() > 0) {
      
      // steering = desired - velocity
      steer.normalize();
      steer.mult(maxSpeed);
      steer.sub(velocity);
      steer.limit(maxForce);
    }
    return steer;
  }

  // Seperate: Check nearby fishs. Apply force to steer away
  void separate(ArrayList < Fish > fishs) {
    float desiredseparation = r * 1.5;
    PVector sum = new PVector();
    int count = 0;

    for (int i = swarms.size() - 1; i >= 0; i--) {
      Swarm fish = swarms.get(i);
    
      // Iterate through fish
      for (int j = fish.fishs.size() - 1; j >= 0; j--){
        Fish other = fish.fishs.get(j);

        float d = PVector.dist(location, other.location);
        
        // If the distance is greater than 0 and less than 
        // an arbitrary amount (0 when you are yourself)
        if ((d > 0) && (d < desiredseparation)) {
          // Calculate vector pointing away from neighbor
          PVector diff = PVector.sub(location, other.location);
          diff.normalize();
          diff.div(d); // Weight by distance
          sum.add(diff);
          count
        }
      }

    }
    
    // // Check proximity of all fishs
    // for (Fish other: fishs) {
    //   float d = PVector.dist(location, other.location);
      
    //   // If the distance is greater than 0 and less than 
    //   // an arbitrary amount (0 when you are yourself)
    //   if ((d > 0) && (d < desiredseparation)) {
    //     // Calculate vector pointing away from neighbor
    //     PVector diff = PVector.sub(location, other.location);
    //     diff.normalize();
    //     diff.div(d); // Weight by distance
    //     sum.add(diff);
    //     count++; // Keep track of how many
    //   }
    // }
    
    // average -- divide by how many
    if (count > 0) {
      sum.div(count);
      
      // Our desired vector is the average scaled to maximum speed
      sum.normalize();
      sum.mult(maxSpeed);
      
      // implement Reynolds: steering = desired - velocity
      PVector steer = PVector.sub(sum, velocity);
      steer.limit(maxForce);
      applyForce(steer);
    }
  }


  // Alignment: Average velocity of nearby fishs
  PVector alignment(ArrayList < Fish > fishs) {

    // neighborDistance defined as an instance variable
    PVector sum = new PVector(0, 0);
    int count = 0;
    
    for (Fish other: fishs) {
      float d = PVector.dist(location, other.location);
      if ((d > 0) && (d < neighborDistance)) {
        sum.add(other.velocity);
        count++;
      }
    }
    
    if (count > 0) {

      sum.div((float) count);
      sum.normalize();
      sum.mult(maxSpeed);
      PVector steer = PVector.sub(sum, velocity);
      steer.limit(maxForce);
      return steer;
    } else {
      return new PVector(0, 0);
    }
  }

  // Cohesion: Steer towards average center location of nearby fishs
  PVector cohesion(ArrayList < Fish > fishs) {
    
    // Start with empty vector to accumulate all locations
    PVector sum = new PVector(0, 0);
    
    int count = 0;
    for (Fish other: fishs) {
      float d = PVector.dist(location, other.location);
      if ((d > 0) && (d < neighborDistance)) {
        sum.add(other.location); // Add location
        count++;
      }
    }
    if (count > 0) {
      sum.div(count);
      return seeking(sum); // Steer towards the location
    } else {
      return new PVector(0, 0);
    }
  }
  
  // Wander: implement Craig Reynolds' wandering fish behavior.
  // fish predicts future location as a fixed distance in the 
  // direction of its velocity, draws a circle with radius r at that 
  // location, and picks a random point along the circumference of 
  // the circle to use as the locaton towards which it will wander
  void wander() {
    
    // random point on the circle
    wanderTheta += random(-wanderThetaChange, wanderThetaChange);
    
    // calculate new location to steer towards on the wander circle
    PVector circleloc = velocity.get(); // start with velocity
    circleloc.normalize();              // normalize to get heading
    circleloc.mult(wanderDistance);     // multiply by distance
    circleloc.add(location);            // make it relative to boid's location
    
    // We need to know the heading to offset wanderTheta
    float h = velocity.heading2D();
    PVector circleOffSet = new PVector(wanderRadius * cos(wanderTheta + h), wanderRadius * sin(wanderTheta + h));
    PVector target = PVector.add(circleloc, circleOffSet);
    seek(target);
    
    // Render wandering circle, etc. 
    if (wanderTrace) drawWanderTarget(location, circleloc, target, wanderRadius);
  }

  // applyForce: add force to current acceleration
  void applyForce(PVector force) {

    // Note: add mass here if you want acceleration = force / mass
    acceleration.add(force);
  }

  // setMaxSpeed: set the maximum speed
  // void setMaxSpeed(float m) {
  //   maxSpeed = m;
  // }

  // setMaxForce: set the maximum force
  // void setMaxForce(float f) {
  //   maxForce = f;
  // }

  // drawWanderTarget: draw the circle associated with wandering
  void drawWanderTarget(PVector location, PVector circle, PVector target, float rad) {
    stroke(188, 188, 255);
    noFill();
    ellipseMode(CENTER);
    ellipse(circle.x, circle.y, rad * 2, rad * 2);
    ellipse(target.x, target.y, 4, 4);
    line(location.x, location.y, circle.x, circle.y);
    line(circle.x, circle.y, target.x, target.y);
  }
  
  // Fish eats. It's now full, and we can 
  // reset it's danger level
  void feed(){
    dangerLevel = 255;
  }
};

class Player extends Fish {


  Player(){

  }

};

class PlayerSwarm extends Swarm {
  ArrayList<Player> fishs; 
  color c;

  PlayerSwarm(){
    c = color(240, 240, 240);
    fishs = new ArrayList<Player>;
  }

  void addFish(float x, float y){
    initLocation.x = x;
    initLocation.y = y;
    initAcceleration.x = random(-0.7, 0.7);
    initAcceleration.y = random(-0.7, 0.7);
  
    Fish v = new Fish(initLocation, initAcceleration, color(210, 0, 0));
    addFish(v);
  }

};