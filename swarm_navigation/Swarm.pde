
// a Swarm represents a collection of fish. Parameters:
// - (ArrayList) vehicles: arrayList of fish in the swarm
// Code example from  IM 2250 Programming for Digital Media, Fall 2014
class Swarm {
  ArrayList<Vehicle> vehicles;
  color c;
  int score;
  boolean selected;  
  
  Swarm(color c_) {
    vehicles = new ArrayList<Vehicle>();
    c = c_;
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
         reproducingFish.add(fish);
         addToScore(1);
      };
    }

    if (selected){
      drawActiveMesh();    
    }
    
    while(reproducingFish.size() > 0){
       Vehicle parent = reproducingFish.remove(0);
       addFish(parent.location.x, parent.location.y); 
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

