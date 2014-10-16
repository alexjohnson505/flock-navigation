
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
    // Iterate through vehicles
    for (Vehicle fish : vehicles) {
      fish.fly(vehicles);
      
      if (food.collision(fish.location)){
        addToScore(1);
      };
    }
    
    if (selected){
      drawActiveMesh();    
    }
  }

  void drawAverageMesh(){
    float sumX = 0;
    float sumY = 0;
    
    for (Vehicle fish : vehicles) {
      sumX += fish.location.x;
      sumY += fish.location.y;
    }
    
    float avgX = sumX / vehicles.size();
    float avgY = sumY / vehicles.size();
    
    for (Vehicle fish : vehicles) {
      stroke(2);
      line(avgX, avgY, fish.location.x, fish.location.y);
    }   
  }
  
 
   
   
  void addVehicle(Vehicle v) {
    vehicles.add(v);
  }
  
  void addFish(){
    initLocation.x = displayWidth / 4;
    initLocation.y = displayHeight / 4;
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

