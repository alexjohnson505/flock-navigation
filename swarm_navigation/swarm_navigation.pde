// Alex Johnson - IM 2250 - Programming for Digital Media
// Programming Exploration 5 v1 | Due 10/20/14

final int margin = 40;
final int initialCount = 20;

// Global Variables
Swarm swarm1;
Swarm swarm2;
PVector initLocation = new PVector(0, 0);
PVector initAcceleration = new PVector(0, 0);
color initColor =  color (0, 0, 0);

void setup() {
  size(displayWidth / 3, displayHeight);
  swarm1 = new Swarm(color(0));
  swarm2 = new Swarm(color(250));
}

void draw() {
  background(160, 211, 224);
  
  // Update swarms
  swarm1.move();
  swarm2.move();
}

void mouseClicked() {
  
  // Testing: Add fish to both 
  swarm1.addFish();
  swarm2.addFish();
}


