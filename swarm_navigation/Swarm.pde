
// Original code example from  IM 2250 Programming for Digital Media, Fall 2014
// a Swarm represents a collection of fish. Parameters:
// - (ArrayList) vehicles: arrayList of fish in the swarm

class Swarm {
  ArrayList<Vehicle> vehicles;
  color c;
  int score;
  boolean selected;  
  
  Swarm() {
    vehicles = new ArrayList<Vehicle>();
    c = makeNeonColor();
    score = startFish;
    selected = false;
  }

  void move() {
    ArrayList<Vehicle> reproducingFish = new ArrayList<Vehicle>();
    
    Iterator<Vehicle> iterator = vehicles.iterator();

    while (iterator.hasNext()) {
       Vehicle fish = iterator.next();
       
       fish.fly(vehicles);
       
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
    }
    
    while(reproducingFish.size() > 0){
       Vehicle parent = reproducingFish.remove(0);
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
    
    for (Vehicle fish : vehicles) {
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
  
  void addVehicle(Vehicle v) {
    vehicles.add(v);
  }

  void addFish(float x, float y){
    initLocation.x = x;
    initLocation.y = y;
    initAcceleration.x = random(-0.7, 0.7);
    initAcceleration.y = random(-0.7, 0.7);
  
    Vehicle v = new Vehicle(initLocation, initAcceleration, c);
    addVehicle(v);
  }
  
  color getColor(){
    return c;
  }
  
  int addToScore(int i){
    score = score + i;
    return score;
  }
}

