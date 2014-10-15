//
// Vehicle class, version 7, adds flocking behavior

//
// Implements Craig Reynold's classic autonomous 
// steering behaviors, see http://www.red3d.com/cwr/ 
// for more details. This example is based, in part, 
// on code from the book THE NATURE OF CODE by Daniel 
// Shiffman, http://natureofcode.com
//
// METHOD SUMMARY
// -----------------------------------------------------------------------
// void Vehicle (l, a, c): create vehicle at loc. l w/ acc. a & color c
// void fly (ArrayList<Vehicle> v): have the flock fly
// void update(): update location and acceleration
// void display(): draw a triangle rotated in direction of velocity
// void flock(ArrayList<Vehicle> v) implement flocking, use with Flock class
// PVector seeking(PVector t): calculate & return steering force towards t
// void seek(PVector t) calculate & apply steering force towards t
// void flee (PVector t): calculate & apply steering force away from t
// void arrive(PVector t): calculate & apply steering force towards t w/ damping
// void borders():  handle wraparound behavior 
// PVector separation (ArrayList<Vehicle> v): steer away from others, return steering vector
// void separate (ArrayList<Vehicle> v): calculate & apply steering vector away from others
// PVector alignment (ArrayList<Vehicle> v): calculate average velocity for nearby vehicles
// PVector cohesion (ArrayList<Vehicle> v): calculate steering towards center nearby vehicles
// void wander(): calculate & apply wandering path
// void applyForce(PVector force): apply an additional force to current acceleration
// void setMaxSpeed(float m): set the maximum speed to m
// void setMaxForce (float f): set the maximum force that can be applied
// void drawWanderTarget(): draw the circle associated with wandering
//

class Vehicle {

      PVector location;
      PVector velocity;
      PVector acceleration;
      float r = 6; // our size in terms of radius
      float maxForce = 0.05;    // maximum steering force
      float maxSpeed = 3;    // maximum speed
      color myColor;  // what color are we?
      // arrival variables
      float damping = 100;  // arrival damping in pixels
      // wander variables
      float wanderRadius = 25;     // radius for our "wander circle"
      float wanderDistance = 80;      // distance for our "wander circle"
      float wanderThetaChange = 0.3; // amount to change wander theta
      boolean wanderTrace = false;
      float wanderTheta;
      // cohesion variables
      float neighborDistance = 50;
      // flocking variables
      float separationWeight = 1.5;
      float alignmentWeight = 1.0;
      float cohesionWeight = 1.0;

      // --------------------------------------------------------------------
      // Vehicle (location_vector, acceleration_vector, color)
      Vehicle(PVector l, PVector a, color c) {
            // use default r, maxSpeed, maxForce
            myColor = c;
            location = new PVector(l.x, l.y);   
            acceleration = new PVector(a.x, a.y);
            velocity = new PVector(0, 0);
      }

      // --------------------------------------------------------------------
      // fly: have the flock fly by running through each vehicle in
      // the arraylist of vehicles, also takes care of update/border/display
      void fly(ArrayList<Vehicle> vehicles) {
            flock(vehicles);
            update();
            borders();
            display();
      }   

      // --------------------------------------------------------------------  
      // update: update location
      void update() {
            velocity.add(acceleration); // update velocity
            velocity.limit(maxSpeed);  // limit speed
            location.add(velocity); // add velocity to location
            acceleration.mult(0); // reset acceleration to 0 each cycle
      }  

      // --------------------------------------------------------------------
      // display: draw a triangle rotated in the direction of velocity
      void display() {
            float theta = velocity.heading2D() + radians(90);
            fill(myColor);
            stroke(0);
            strokeWeight(1);
            pushMatrix();
            translate(location.x, location.y);
            rotate(theta);
            beginShape();
            vertex(0, -r*2);
            vertex(-r, r*2);
            vertex(r, r*2);
            endShape(CLOSE);
            popMatrix();
      }

      // --------------------------------------------------------------------
      // flock: accumulate a new acceleration each time based on 
      // the three rules: 1. separation (steer to avoid crowding 
      // local flockmates); 2. alignment (steer towards the average 
      // heading of local flockmates); and 3. cohesion (steer to 
      // move toward the average position of local flockmates).
      // Each of the vehicles (or as Reynolds calls them, boids) has 
      // direct access to the whole flock, but flocking requires that 
      // each vehicle reacts only to flockmates within a small area 
      // around itself, characterized by a distance between the vehicles
      //  and an angle, measured from the vehicle's direction of movement. 
      // Flockmates outside this local area are  ignored. The area could 
      // be considered a model of limited  perception (as by fish in 
      // murky water) but it is probably more correct to think of it as 
      // defining the region in which flockmates influence a vehicle's 
      // steering, from http://www.red3d.com/cwr/boids/
      void flock(ArrayList<Vehicle> vehicles) {
            // the three forces as per Reynolds
            PVector separationForce = separation(vehicles);   
            PVector alignmentForce = alignment(vehicles);    
            PVector cohesionForce = cohesion(vehicles);   
            // arbitrarily weight these forces
            separationForce.mult(separationWeight);  
            alignmentForce.mult(alignmentWeight);          
            cohesionForce.mult(cohesionWeight);    
            // add each of the force vectors to acceleration
            applyForce(separationForce);
            applyForce(alignmentForce);
            applyForce(cohesionForce);
      }

      // --------------------------------------------------------------------
      // seeking: calculate and apply a steering force towards
      // a target, returns steering vector, see also seek
      PVector seeking(PVector target) {
            // A vector pointing from the location to the target
            PVector desired = PVector.sub(target, location);  
            // Normalize desired and scale to maximum speed
            desired.normalize();
            desired.mult(maxSpeed);
            // Steering = Desired minus Velocity
            PVector steer = PVector.sub(desired, velocity);
            steer.limit(maxForce);  // Limit to maximum steering force
            return steer;
      }

      // --------------------------------------------------------------------
      // seek: calculates and applies a steering force towards a target
      void seek(PVector target) {
            // a vector pointing from the location to the target
            PVector desired = PVector.sub(target, location);  
            // normalize desired and scale to maximum speed
            desired.normalize();
            desired.mult(maxSpeed);
            // steer = desired - velocity
            PVector steer = PVector.sub(desired, velocity);
            // limit to maximum steering force
            steer.limit(maxForce);  
            applyForce(steer);
      }

      // --------------------------------------------------------------------
      // flee: calculates and applies a steering force away from a target
      void flee(PVector t) {
            PVector desiredVelocity = new PVector();
            desiredVelocity = PVector.sub(t, location);
            desiredVelocity.normalize();
            desiredVelocity.mult(maxSpeed);
            PVector steer = desiredVelocity;
            steer.sub(velocity);
            steer.limit(maxForce); 
            acceleration.sub(steer);
      }  

      // --------------------------------------------------------------------
      // arrive: calculates a steering force towards a target with 
      // damping so we don't overshoot the target, arrive behavior 
      // demonstrates "desired minus velocity" 
      void arrive(PVector target) {
            // desired is a vector pointing from our location to the target
            PVector desired = PVector.sub(target, location);  
            float dmag = desired.mag();
            // normalize desired and scale w/ arbitrary damping within 100 pixels
            desired.normalize();
            if (dmag < damping) {
                  // we are close to the target, slooooooooow down
                  float mag = map(dmag, 0, damping, 0, maxSpeed);
                  desired.mult(mag);
            } else {
                  // otherwise proceed at full speed
                  desired.mult(maxSpeed);
            }
            // steer = desired - velocity
            PVector steer = PVector.sub(desired, velocity);
            steer.limit(maxForce);  // limit to maximum steering force
            applyForce(steer);
      } 

      // --------------------------------------------------------------------
      // borders: handle wraparound behavior 
      void borders() {
            if (location.x < -r) location.x = width+r;
            if (location.y < -r) location.y = height+r;
            if (location.x > width+r) location.x = -r;
            if (location.y > height+r) location.y = -r;
      }

      // --------------------------------------------------------------------
      // separation (for flocking behavior): checks for nearby 
      // vehicles and steers away frin them, returns steering vector
      PVector separation (ArrayList<Vehicle> vehicles) {
            float desiredseparation = 35.0f;
            PVector steer = new PVector(0, 0, 0);
            int count = 0;
            // For every vehicle in the system, check if it's too close
            for (Vehicle other : vehicles) {
                  float d = PVector.dist(location, other.location);
                  // If the distance is greater than 0 and less than an arbitrary amount (0 when you are yourself)
                  if ((d > 0) && (d < desiredseparation)) {
                        // Calculate vector pointing away from neighbor
                        PVector diff = PVector.sub(location, other.location);
                        diff.normalize();
                        diff.div(d);     // weight by distance
                        steer.add(diff);
                        count++;  // keep track of how many
                  }
            }
            // average 
            if (count > 0) {
                  steer.div((float)count);
            }
            // as long as the vector is greater than 0
            if (steer.mag() > 0) {
                  // implement Reynolds: steering = desired - velocity
                  steer.normalize();
                  steer.mult(maxSpeed);
                  steer.sub(velocity);
                  steer.limit(maxForce);
            }
            return steer;
      } 

      // --------------------------------------------------------------------
      // separate: checks for nearby vehicles and steers away from them
      // handles application of the steering force
      void separate (ArrayList<Vehicle> vehicles) {
            float desiredseparation = r*2;
            PVector sum = new PVector();
            int count = 0;
            // For every boid in the system, check if it's too close
            for (Vehicle other : vehicles) {
                  float d = PVector.dist(location, other.location);
                  // If the distance is greater than 0 and less than 
                  // an arbitrary amount (0 when you are yourself)
                  if ((d > 0) && (d < desiredseparation)) {
                        // Calculate vector pointing away from neighbor
                        PVector diff = PVector.sub(location, other.location);
                        diff.normalize();
                        diff.div(d);        // Weight by distance
                        sum.add(diff);
                        count++;            // Keep track of how many
                  }
            }
            // average -- divide by how many
            if (count > 0) {
                  sum.div(count);
                  // Our desired vector is the average scaled to maximum speed
                  sum.normalize();
                  sum.mult(maxSpeed);
                  // implement Reynolds: steering = desired - velocity
                  PVector steer = PVector.sub(sum, velocity);
                  steer.limit(maxForce);
                  applyForce(steer);
            }
      }

      // --------------------------------------------------------------------
      // alignment: for every nearby vehicle in the system, 
      // calculate the average velocity
      PVector alignment (ArrayList<Vehicle> vehicles) {
            // neighborDistance defined as an instance variable
            PVector sum = new PVector(0, 0);
            int count = 0;
            for (Vehicle other : vehicles) {
                  float d = PVector.dist(location, other.location);
                  if ((d > 0) && (d < neighborDistance)) {
                        sum.add(other.velocity);
                        count++;
                  }
            }
            if (count > 0) {
                  sum.div((float)count);
                  sum.normalize();
                  sum.mult(maxSpeed);
                  PVector steer = PVector.sub(sum, velocity);
                  steer.limit(maxForce);
                  return steer;
            } else {
                  return new PVector(0, 0);
            }
      }

      // --------------------------------------------------------------------
      // cohesion: for the average location (i.e. center) of all nearby 
      // vehicles, calculate steering vector towards that location
      PVector cohesion (ArrayList<Vehicle> vehicles) {
            // Start with empty vector to accumulate all locations
            PVector sum = new PVector(0, 0);  
            int count = 0;
            for (Vehicle other : vehicles) {
                  float d = PVector.dist(location, other.location);
                  if ((d > 0) && (d < neighborDistance)) {
                        sum.add(other.location); // Add location
                        count++;
                  }
            }
            if (count > 0) {
                  sum.div(count);
                  return seeking(sum);  // Steer towards the location
            } else {
                  return new PVector(0, 0);
            }
      }

      // --------------------------------------------------------------------
      // wander: implement Craig Reynolds' wandering vehicle behavior,
      // vehicle predicts future location as a fixed distance in the 
      // direction of its velocity, draws a circle with radius r at that 
      // location, and picks a random point along the circumference of 
      // the circle to use as the locaiton towards which it will wander
      void wander() {
            // random point on the circle
            wanderTheta += random(-wanderThetaChange, wanderThetaChange);  
            // calculate new location to steer towards on the wander circle
            PVector circleloc = velocity.get();    // start with velocity
            circleloc.normalize();   // normalize to get heading
            circleloc.mult(wanderDistance); // multiply by distance
            circleloc.add(location);  // make it relative to boid's location
            // We need to know the heading to offset wanderTheta
            float h = velocity.heading2D();        
            PVector circleOffSet = new PVector(wanderRadius*cos(wanderTheta+h), wanderRadius*sin(wanderTheta+h));
            PVector target = PVector.add(circleloc, circleOffSet);
            seek(target);
            // Render wandering circle, etc. 
            if (wanderTrace) drawWanderTarget(location, circleloc, target, wanderRadius);
      }  

      // --------------------------------------------------------------------
      // applyForce: apply an additional force to our current acceleration
      void applyForce(PVector force) {
            // add mass here if you want acceleration = force / mass
            acceleration.add(force);
      }  


      // --------------------------------------------------------------------
      // setMaxSpeed: set the maximum speed for the vehicle
      void setMaxSpeed(float m) {
            maxSpeed = m;
      }

      // --------------------------------------------------------------------
      // setMaxForce: set the maximum force that can be applied
      void setMaxForce(float f) {
            maxForce = f;
      }

      // --------------------------------------------------------------------
      // drawWanderTarget: draw the circle associated with wandering
      void drawWanderTarget(PVector location, PVector circle, PVector target, float rad) {
            stroke(188, 188, 255); 
            noFill();
            ellipseMode(CENTER);
            ellipse(circle.x, circle.y, rad*2, rad*2);
            ellipse(target.x, target.y, 4, 4);
            line(location.x, location.y, circle.x, circle.y);
            line(circle.x, circle.y, target.x, target.y);
      }
}

