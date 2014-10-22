
class Vehicle {

  /***************************
      STATUS VARIABLES SETTINGS
   ***************************/

  PVector location;
  PVector velocity;
  PVector acceleration;

  /***************************
      VEHICLE SETTINGS
   ***************************/

  color myColor;
  
  float dangerLevel = 255;   // Current Danger, from 0.0 (dead) to 255.0 (safe)
  
  float r = 6;             // our size in terms of radius
  float maxForce = 0.03;   // maximum steering force
  float maxSpeed = 1.5;    // maximum speed

  float damping = 100; // arrival damping in pixels
  float neighborDistance = 50; // cohesion variables

  /***************************
      WANDER SETTINGS
   ***************************/
   
  float wanderRadius = 10;       // radius for our "wander circle"
  float wanderDistance = 80;     // distance for our "wander circle"
  float wanderThetaChange = 0.3; // amount to change wander theta
  boolean wanderTrace = false;
  float wanderTheta;

  /***************************
      FLOCKING SETTINGS
   ***************************/
   
  float separationWeight = 1.5;
  float alignmentWeight = 1.0;
  float cohesionWeight = 1.0;

  // Construction: Vehicle (location_vector, acceleration_vector, color)
  Vehicle(PVector l, PVector a, color c) {

    // use default r, maxSpeed, maxForce
    myColor = c;
    location = new PVector(l.x, l.y);
    acceleration = new PVector(a.x, a.y);
    velocity = new PVector(0, 0);
  }

  // Fly: Iterate & update swarm. Update/border/display
  void fly(ArrayList < Vehicle > vehicles) {
    flock(vehicles);
    update();
    borders();
    display();
  }

  // Update: location & acceleration
  void update() {
    velocity.add(acceleration); // update velocity
    velocity.limit(maxSpeed);   // limit speed
    location.add(velocity);     // add velocity to location
    acceleration.mult(0);       // reset acceleration to 0 each cycle
  }
  
  // Display: Render our 'fish'
  void display() {
    float theta = velocity.heading2D() + radians(90);
    
    // dangerLevel = dangerLevel - decayRate;
   
    fill(myColor, dangerLevel);
    noStroke();

    pushMatrix();
      translate(location.x, location.y);
      rotate(theta);
      beginShape();
      vertex(0, -r * 2);
      vertex(-r, r * 2);
      vertex(r, r * 2);
      endShape(CLOSE);
    popMatrix();
  }

  // --------------------------------------------------------------------
  // Flock: Accumulate new acceleration based on: 
  //   1. separation (steer to avoid crowding local flockmates)
  //   2. alignment (steer towards the average heading of local flockmates)
  //   3. cohesion (steer to move toward the average position of local flockmates).
  // 
  // Each vehicle only reacts to *nearby* mates. ( determined by distance & direction )
  // More information: http://www.red3d.com/cwr/boids/
  
  void flock(ArrayList < Vehicle > vehicles) {
    
    PVector separationForce = separation(vehicles); //  1.) Seperation
    PVector alignmentForce = alignment(vehicles);   //  2.) Alighment
    PVector cohesionForce = cohesion(vehicles);     //  3.) Cohesion
    
    // arbitrarily weight these forces
    separationForce.mult(separationWeight);
    alignmentForce.mult(alignmentWeight);
    cohesionForce.mult(cohesionWeight);
    
    // Each force vector influences acceleration
    applyForce(separationForce);
    applyForce(alignmentForce);
    applyForce(cohesionForce);
  }
  
  // Seeking:  Calculate steering vector (given target)
  PVector seeking(PVector target) {
    
    // Vector towards desired location
    PVector desired = PVector.sub(target, location);
    
    // Normalize & scale the desired vector
    desired.normalize();
    desired.mult(maxSpeed);
    
    // Subtract Velocity from Desired to calculate Steering
    PVector steer = PVector.sub(desired, velocity);
    
    steer.limit(maxForce); // Limit max steerings
    return steer;
  }

  // Seek: Applies steering force to target
  void seek(PVector target) {
    
    // Vector towards target
    PVector desired = PVector.sub(target, location);
    
    // Normalize & scale the desired vector
    desired.normalize();
    desired.mult(maxSpeed);
    
    // steer = desired - velocity
    PVector steer = PVector.sub(desired, velocity);
    
    steer.limit(maxForce); // Limit max
    applyForce(steer);
  }

  // Flee: applies steering force away from a target
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

  // Arrive: Calculate steering force towards a target.
  // Apply damping to avoid overshooting
  
  // ... arrive behavior 
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
    steer.limit(maxForce); // limit to maximum steering force
    applyForce(steer);
  }

  // Borders: Support wrap-around movement 
  void borders() {
    if (location.x < -r) location.x = width + r;
    if (location.y < -r) location.y = height + r;
    if (location.x > width + r) location.x = -r;
    if (location.y > height + r) location.y = -r;
  }

  // Separation: Check nearby. Steer away. 
  PVector separation(ArrayList < Vehicle > vehicles) {
    
    float desiredseparation = 35.0f;
    PVector steer = new PVector(0, 0, 0);
    int count = 0;
    
    // Check proximity for all vehicles
    for (Vehicle other: vehicles) {
      
      float d = PVector.dist(location, other.location);
     
      // Find targets within range
      // Note: 0 = distance to self.
      if ((d > 0) && (d < desiredseparation)) {
        
        // Calculate vector pointing away from neighbor
        PVector diff = PVector.sub(location, other.location);
        diff.normalize();
        diff.div(d); // weight by distance
        steer.add(diff);
        count++; // keep track of how many
      }
    }
    
    // average 
    if (count > 0) {
      steer.div((float) count);
    }
    
    // as long as the vector is greater than 0
    if (steer.mag() > 0) {
      
      // steering = desired - velocity
      steer.normalize();
      steer.mult(maxSpeed);
      steer.sub(velocity);
      steer.limit(maxForce);
    }
    return steer;
  }

  // Seperate: Check nearby vehicles. Apply force to steer away
  void separate(ArrayList < Vehicle > vehicles) {
    float desiredseparation = r * 1.5;
    PVector sum = new PVector();
    int count = 0;
    
    // Check proximity of all vehicles
    for (Vehicle other: vehicles) {
      float d = PVector.dist(location, other.location);
      
      // If the distance is greater than 0 and less than 
      // an arbitrary amount (0 when you are yourself)
      if ((d > 0) && (d < desiredseparation)) {
        // Calculate vector pointing away from neighbor
        PVector diff = PVector.sub(location, other.location);
        diff.normalize();
        diff.div(d); // Weight by distance
        sum.add(diff);
        count++; // Keep track of how many
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
  // Alignment: Average velocity of nearby vehicles
  PVector alignment(ArrayList < Vehicle > vehicles) {
    // neighborDistance defined as an instance variable
    PVector sum = new PVector(0, 0);
    int count = 0;
    
    for (Vehicle other: vehicles) {
      float d = PVector.dist(location, other.location);
      if ((d > 0) && (d < neighborDistance)) {
        sum.add(other.velocity);
        count++;
      }
    }
    
    if (count > 0) {
      sum.div((float) count);
      sum.normalize();
      sum.mult(maxSpeed);
      PVector steer = PVector.sub(sum, velocity);
      steer.limit(maxForce);
      return steer;
    } else {
      return new PVector(0, 0);
    }
  }

  // Cohesion: Steer towards average center location of nearby vehicles
  PVector cohesion(ArrayList < Vehicle > vehicles) {
    
    // Start with empty vector to accumulate all locations
    PVector sum = new PVector(0, 0);
    
    int count = 0;
    for (Vehicle other: vehicles) {
      float d = PVector.dist(location, other.location);
      if ((d > 0) && (d < neighborDistance)) {
        sum.add(other.location); // Add location
        count++;
      }
    }
    if (count > 0) {
      sum.div(count);
      return seeking(sum); // Steer towards the location
    } else {
      return new PVector(0, 0);
    }
  }
  
  // Wander: implement Craig Reynolds' wandering vehicle behavior.
  // vehicle predicts future location as a fixed distance in the 
  // direction of its velocity, draws a circle with radius r at that 
  // location, and picks a random point along the circumference of 
  // the circle to use as the locaton towards which it will wander
  void wander() {
    
    // random point on the circle
    wanderTheta += random(-wanderThetaChange, wanderThetaChange);
    
    // calculate new location to steer towards on the wander circle
    PVector circleloc = velocity.get(); // start with velocity
    circleloc.normalize(); // normalize to get heading
    circleloc.mult(wanderDistance); // multiply by distance
    circleloc.add(location); // make it relative to boid's location
    
    // We need to know the heading to offset wanderTheta
    float h = velocity.heading2D();
    PVector circleOffSet = new PVector(wanderRadius * cos(wanderTheta + h), wanderRadius * sin(wanderTheta + h));
    PVector target = PVector.add(circleloc, circleOffSet);
    seek(target);
    
    // Render wandering circle, etc. 
    if (wanderTrace) drawWanderTarget(location, circleloc, target, wanderRadius);
  }

  // applyForce: add force to current acceleration
  void applyForce(PVector force) {
    // Note: add mass here if you want acceleration = force / mass
    acceleration.add(force);
  }


  // setMaxSpeed: set the maximum speed
  void setMaxSpeed(float m) {
    maxSpeed = m;
  }

  // setMaxForce: set the maximum force
  void setMaxForce(float f) {
    maxForce = f;
  }

  // drawWanderTarget: draw the circle associated with wandering
  void drawWanderTarget(PVector location, PVector circle, PVector target, float rad) {
    stroke(188, 188, 255);
    noFill();
    ellipseMode(CENTER);
    ellipse(circle.x, circle.y, rad * 2, rad * 2);
    ellipse(target.x, target.y, 4, 4);
    line(location.x, location.y, circle.x, circle.y);
    line(circle.x, circle.y, target.x, target.y);
  }
  
  // Fish eats. Reset danger
  void feed(){
    dangerLevel = 255;
  }
}
