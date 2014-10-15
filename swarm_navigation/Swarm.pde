
// a Swarm represents a collection of fish. Parameters:
// - (ArrayList) vehicles: arrayList of fish in the swarm
// Code example from  IM 2250 Programming for Digital Media, Fall 2014
class Swarm {
  ArrayList<Vehicle> vehicles; 

  Swarm() {
    vehicles = new ArrayList<Vehicle>(); 
  }

  void move() {
    // Iterate through vehicles
    for (Vehicle v : vehicles) {
      v.fly(vehicles);
     }
  }

  void addVehicle(Vehicle v) {
    vehicles.add(v);
  }
}

