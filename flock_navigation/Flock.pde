//
// Flock class manages the ArrayList of all the
// vehicles in the flock
// IM 2250 Programming for Digital Media, Fall 2014
//
// Based, in part, on code from the book THE NATURE 
// OF CODE by Daniel Shiffman, http://natureofcode.com


class Flock {
      // An ArrayList for all the vehicles in the flock
      ArrayList<Vehicle> vehicles; 

      Flock() {
            vehicles = new ArrayList<Vehicle>(); 
      }

      void fly() {
            for (Vehicle v : vehicles) {
                  // we pass the entire list of vehicles in the flock 
                  // to each vehicle individually
                  v.fly(vehicles);
            }
      }

      void addVehicle(Vehicle v) {
            vehicles.add(v);
      }
}

