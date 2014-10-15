
// a Swarm represents a collection of fish. Parameters:
// - (ArrayList) vehicles: arrayList of fish in the swarm
// Code example from  IM 2250 Programming for Digital Media, Fall 2014
class Swarm {
  ArrayList<Vehicle> vehicles;
  color c; 

  Swarm() {
    vehicles = new ArrayList<Vehicle>();
    c = color(140);  
  }
  
  Swarm(color c_) {
    vehicles = new ArrayList<Vehicle>();
    c = c_;  
  }

  void move() {
    // Iterate through vehicles
    for (Vehicle v : vehicles) {
      v.fly(vehicles);
      if (v.collision()){
      }
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
}

