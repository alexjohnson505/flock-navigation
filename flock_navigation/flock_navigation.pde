// Alex Johnson - IM 2250
// Programming Exploration 5 (Interactive Toy)
// Version 1 due 10/20/14

// Provide "visual delight"
// Take user interaction (changes something significant)

// Fish swarm to targets.  
// Upon 'catching food', level up options are provided:
// - More fish
// - More swarms
// - Faster
// - Larger Fish

// Inspiration and code from ss5_7_flock, and in class example program.

// ss5_7_flock: vehicles observe flocking behavior
// following the rules of: cohesion, separation, 
// and alignment
// IM 2250 Programming for Digital Media, Fall 2014
//
// Implements Craig Reynold's classic autonomous 
// steering behaviors, see http://www.red3d.com/cwr/ 
// for more details. This example is based, in part, 
// on code from the book THE NATURE OF CODE by Daniel 
// Shiffman, http://natureofcode.com

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

