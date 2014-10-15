
// a Swarm represents a collection of fish. These
// fish are stored in the Swarm's arrayList.
// Code example from  IM 2250 Programming for Digital Media, Fall 2014

class Flock {
  ArrayList<Vehicle> vehicles; 

  Flock() {
    vehicles = new ArrayList<Vehicle>(); 
  }

  void fly() {
    for (Vehicle v : vehicles) {
      v.fly(vehicles);
     }
  }

  void addVehicle(Vehicle v) {
    vehicles.add(v);
  }
}

