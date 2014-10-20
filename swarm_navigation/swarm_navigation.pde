// Alex Johnson - IM 2250 - Programming for Digital Media
// Programming Exploration 5 v1 | Due 10/20/14

final int margin = 40;
PVector initLocation = new PVector(0, 0);
PVector initAcceleration = new PVector(0, 0);
color initColor =  color (0, 0, 0);

int startSwarms = 4;
int startFish   = 50;

ArrayList<Swarm> swarms = new ArrayList<Swarm>();
Food food;

void setup() {

  float width  = displayWidth / 3;
  float height = displayHeight;

  size((int)width, (int)height);

  food = new Food();

  // Init Swarms 
  for (int i = startSwarms; i > 0; i--) {
    addSwarm();
  } 

  // Init Start Fish
  for (int i = startFish; i > 0; i--) {
    for (Swarm s : swarms) {
      s.addFish();
    }

    food.addFood();
  }
}

void draw() {
  background(0,0,0);

  food.draw();

  // Update swarms
  for (Swarm s : swarms) {
    s.move();
  }

  drawHUD();
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
      text("Swarm Score : " + s.score, 30, 0);
  
      if (s.selected) {
        noFill();
        stroke(2);
        rect(-5, -16, 175, 22);
      }
     
    popMatrix();
    noStroke();
  }
}

// Introduce New Swarm
void addSwarm() {
  float r = random(0, 255);
  float g = random(0, 255);
  float b = random(0, 255);
  
  // Ensure NEON colors
  // (Prevents Dark colors
  if (r + g + b < 450){
    addSwarm();
  } else {
    color c = color(r,g,b);
    Swarm s = new Swarm(c);
    swarms.add(s);
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
       s.addFish();
       s.addFish();
       s.addFish();
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



