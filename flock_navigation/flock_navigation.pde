// Alex Johnson - IM 2250 - Programming for Digital Media
// Programming Exploration 5 v1 | Due 10/20/14

final int margin = 40;
final int initialCount = 20;

// Global Variables
Flock flock;
PVector initLocation = new PVector(0, 0);
PVector initAcceleration = new PVector(0, 0);
color initColor =  color (0, 0, 0);

void setup() {
  size(displayWidth / 2, displayHeight / 2);
  flock = new Flock();
}

void draw() {
  background(160, 211, 224);
  flock.fly();
}

void mouseClicked() {
   addFish(); 
}

// Introduce new fish
void addFish(){
  initLocation.x = displayWidth / 4;
  initLocation.y = displayHeight / 4;
  initAcceleration.x = random(-0.7, 0.7);
  initAcceleration.y = random(-0.7, 0.7);
  
  // New fish
  Vehicle v = new Vehicle(initLocation, initAcceleration, color(51));
  flock.addVehicle(v);
}

