// Alex Johnson - IM 2250 - Programming for Digital Media
// Programming Exploration 5 v1 | Due 10/20/14

final int margin = 40;
PVector initLocation = new PVector(0, 0);
PVector initAcceleration = new PVector(0, 0);
color initColor =  color (0, 0, 0);

int startSwarms = 3;
int startFish   = 10;

ArrayList<Swarm> swarms = new ArrayList<Swarm>();
Food food;

void setup() {
  
  float width  = displayWidth / 3;
  float height = displayHeight;
  
  size((int)width, (int)height);
  
  food = new Food();

  // Init Swarms 
  for (int i = startSwarms; i > 0; i--){
    addSwarm();
  } 
  
  // Init Start Fish
  for (int i = startFish; i > 0; i--){
    for (Swarm s : swarms) {
      s.addFish();
    }
    
    food.addFood();
  } 
}

void draw() {
  background(200, 241, 244);
  
  food.draw();
  
  // Update swarms
  for (Swarm s : swarms) {
    s.move();
  }
  
  drawHUD();
  
}

void drawHUD() {
   for (int i = swarms.size() - 1 ; i >= 0; i--){
     Swarm s = swarms.get(i);
     
     int y = 25 * i + 30;
     
     pushMatrix();
       translate(20, y);
       
       fill(s.getColor());
       rect(0, -10, 20, 10);
       
       fill(0);
       textSize(15);
       text("Swarm Score : " + s.score, 30, 0);
     popMatrix();
   }
}

// Introduce New Swarm
void addSwarm(){
  color c = color(random(0, 255), random(0, 255), random(0, 255));
  Swarm s = new Swarm(c);
  swarms.add(s);
}
