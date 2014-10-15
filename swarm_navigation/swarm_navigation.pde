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
  size(displayWidth / 2, displayHeight / 2);
  swarm1 = new Swarm();
  swarm2 = new Swarm();
}

void draw() {
  background(160, 211, 224);
  swarm1.move();
  swarm2.move();
}

void mouseClicked() {
  swarm1.addVehicle(newFish(color(0)));
  swarm2.addVehicle(newFish(color(250)));
}

Vehicle newFish(color c){
  initLocation.x = displayWidth / 4;
  initLocation.y = displayHeight / 4;
  initAcceleration.x = random(-0.7, 0.7);
  initAcceleration.y = random(-0.7, 0.7);
  
  Vehicle v = new Vehicle(initLocation, initAcceleration, c);
  return v;
}
