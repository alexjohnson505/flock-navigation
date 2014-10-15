// Alex Johnson - IM 2250 - Programming for Digital Media
// Programming Exploration 5 v1 | Due 10/20/14

// constants
final int margin = 40;
final int initialCount = 20;

// globals
Flock flock;
PVector initLocation = new PVector(0, 0);
PVector initAcceleration = new PVector(0, 0);
color initColor =  color (0, 0, 0);

void setup() {
  size(displayWidth, displayHeight);
  smooth();
  flock = new Flock();
  smooth();
}

void draw() {
  background(255);
  flock.fly();
}

void mouseDragged() {
  initLocation.x = mouseX;
  initLocation.y = mouseY;
  initAcceleration.x = random (-0.7, 0.7);
  initAcceleration.y = random (-0.7, 0.7);
  initColor = color (random (0, 255), random(0, 190), random(128, 255));
  Vehicle v = new Vehicle(initLocation, initAcceleration, initColor);
  flock.addVehicle(v);
}

