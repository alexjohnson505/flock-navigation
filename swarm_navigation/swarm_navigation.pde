// Alex Johnson - IM 2250 - Programming for Digital Media
// Programming Exploration 5 v1 | Due 10/20/14

final int margin = 40;
final int initialCount = 20;

PVector initLocation = new PVector(0, 0);
PVector initAcceleration = new PVector(0, 0);
color initColor =  color (0, 0, 0);

ArrayList<Swarm> swarms = new ArrayList<Swarm>();
Food food = new Food();

void setup() {
  size(displayWidth / 3, displayHeight);

  Swarm swarm1 = new Swarm(color(0));
  Swarm swarm2 = new Swarm(color(250));
 
  swarms.add(swarm1);
  swarms.add(swarm2);
  
  // Start w/ 10 fish
  for (int i = 10; i > 0; i--){
    mouseClicked();
  } 
}

void draw() {
  background(160, 211, 224);
  
  // Update swarms
  for (Swarm s : swarms) {
    s.move();
  }

  food.draw();
}

void mouseClicked() {
  
  // Testing: Add fish to both 
  for (Swarm s : swarms) {
    s.addFish();
  }
  
  food.addFood();
}
