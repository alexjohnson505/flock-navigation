/*********************************
             FISH
 *********************************/

// Fish represents a single member of a swarm.
// Fish calculates it's location, direction, and
// acceleration based on surrounding members of 
// the same swarm.

// Implements Craig Reynold's classic autonomous 
// steering behaviors, see http://www.red3d.com/cwr/ 
// for more details. This example is based, in part, 
// on code from the book THE NATURE OF CODE by Daniel 
// Shiffman, http://natureofcode.com

class Fish {

  /***************************
       STATUS VARIABLES
   ***************************/

  PVector location;
  PVector velocity;
  PVector acceleration;

  /***************************
       FISH SETTINGS
   ***************************/

  color myColor;
   
  float dangerLevel = 255; // Current Danger, from 0.0 (dead) to 255.0 (safe)  
  
  float r = 6;             // our size in terms of radius
  float maxForce = 0.03;   // maximum steering force
  float maxSpeed = 1.5;    // maximum speed

  float damping = 100;           // arrival damping in pixels
  float neighborDistance = 50;   // cohesion variables

  boolean player;                // Is this fish player controlled?
  boolean nearPlayer;            // Is this fish near a player controlled fish?

  /***************************
      WANDER SETTINGS
   ***************************/
   
  float wanderRadius = 10;        // radius for our "wander circle"
  float wanderDistance = 80;      // distance for our "wander circle"
  float wanderThetaChange = 0.3;  // amount to change wander theta
  float wanderTheta;

  /***************************
      FLOCKING SETTINGS
   ***************************/
   
  float separationWeight = 3; // (default) 1.5
  float alignmentWeight = 2;  // (default) 1.0
  float cohesionWeight = 2;   // (default) 1.0

  // Construction: Fish (location_vector, acceleration_vector, color)
  Fish(PVector l, PVector a, color c) {
    myColor = c;
    location = new PVector(l.x, l.y);
    acceleration = new PVector(a.x, a.y);
    velocity = new PVector(0, 0);
  }

  // Fly: Iterate & update swarm. Update/border/display
  void fly(ArrayList < Fish > fishs) {
    flock(fishs);
    update();
    borders();
    display();
  }

  // Update: location & acceleration
  void update() {
    velocity.add(acceleration); // update velocity
    velocity.limit((player) ? 2.2 : maxSpeed);   // limit speed (let players go faster)
    location.add(velocity);     // add velocity to location
    acceleration.mult(0);       // reset acceleration to 0 each cycle
  }
  
  // Display: Render our 'fish'
  void display() {
    float theta = velocity.heading2D() + radians(90);
    
    dangerLevel = dangerLevel - decayRate;

    // if (player){
    //   stroke(myColor);
    //   strokeWeight(2);
    //   fill(0, dangerLevel);
    // } else if (nearPlayer){
    //   stroke(255);
    //   strokeWeight(2);
    //   fill(myColor, dangerLevel);
    // } else {
    //   noStroke();  
    //   fill(myColor, dangerLevel);
    // }

    strokeWeight(2);
    stroke(myColor, dangerLevel);

    if (player){
      fill(myColor, dangerLevel);
    } else if (nearPlayer){
      fill(myColor, dangerLevel);
    } else {
      fill(0, dangerLevel);
    }
    
    pushMatrix();
      translate(location.x, location.y);
      rotate(theta);
      beginShape();

      if (player){
        r = 9;
      };

      vertex(0, -r * 2);
      vertex(-r, r * 2);
      vertex(r, r * 2);
      endShape(CLOSE);
    popMatrix();

    noStroke();
  }

  // --------------------------------------------------------------------
  // Flock: Accumulate new acceleration based on: 
  //   1. separation (steer to avoid crowding local flockmates)
  //   2. alignment (steer towards the average heading of local flockmates)
  //   3. cohesion (steer to move toward the average position of local flockmates).
  // 
  // Each fish only reacts to *nearby* mates. ( determined by distance & direction )
  // More information: http://www.red3d.com/cwr/boids/
  
  void flock(ArrayList < Fish > fishs) {

    if (player) return;
    
    PVector separationForce = separation(fishs); //  1.) Seperation
    PVector alignmentForce = alignment(fishs);   //  2.) Alighment
    PVector cohesionForce = cohesion(fishs);     //  3.) Cohesion
    
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
  PVector separation(ArrayList<Fish> fishs) {
    
    float desiredseparation = 35.0f;
    PVector steer = new PVector(0, 0, 0);
    int count = 0;
    
    // Check proximity for all fishs
    for (Fish other: fishs) {
      
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
    if (count > 0) { steer.div((float) count); }
    
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

  // Seperate: Check nearby fishs. Apply force to steer away
  void separate(ArrayList < Fish > fishs) {
    float desiredseparation = r * 1.5;
    PVector sum = new PVector();
    int count = 0;

    // Check proximity for ALL fish
    for (int i = swarms.size() - 1; i >= 0; i--) {
      Swarm swarm = swarms.get(i);
    
      // Iterate through fish
      for (int j = swarm.fishs.size() - 1; j >= 0; j--){
        Fish other = swarm.fishs.get(j);

        float d = PVector.dist(location, other.location);
        
        // If the distance is greater than 0 and less than 
        // an arbitrary amount (0 when you are yourself)
        if ((d > 0) && (d < desiredseparation)) {
          // Calculate vector pointing away from neighbor
          PVector diff = PVector.sub(location, other.location);
          diff.normalize();
          diff.div(d); // Weight by distance
          sum.add(diff);
          // count TODO
        }
      }
    }
    
    // // Check proximity of all fishs
    // for (Fish other: fishs) {
    //   float d = PVector.dist(location, other.location);
      
    //   // If the distance is greater than 0 and less than 
    //   // an arbitrary amount (0 when you are yourself)
    //   if ((d > 0) && (d < desiredseparation)) {
    //     // Calculate vector pointing away from neighbor
    //     PVector diff = PVector.sub(location, other.location);
    //     diff.normalize();
    //     diff.div(d); // Weight by distance
    //     sum.add(diff);
    //     count++; // Keep track of how many
    //   }
    // }
    
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

  // Alignment: Average velocity of nearby fishs
  PVector alignment(ArrayList < Fish > fishs) {

    // neighborDistance defined as an instance variable
    PVector sum = new PVector(0, 0);
    int count = 0;

    nearPlayer = false;
    
    for (Fish other : fishs) {
      float d = PVector.dist(location, other.location);

      if ((d > 0) && (d < getNeighborDistance(other))) {
        sum.add(other.velocity);  
        count++;

        if (other.player) {
          nearPlayer = true;

          sum = new PVector(0, 0);
          sum.add(other.velocity);  
          count = 1;

          break;
        }
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

  // Cohesion: Steer towards average center location of nearby fishs
  PVector cohesion(ArrayList < Fish > fishs) {
    
    // Start with empty vector to accumulate all locations
    PVector sum = new PVector(0, 0);
    
    int count = 0;

    for (Fish other: fishs) {
      float d = PVector.dist(location, other.location);
      if ((d > 0) && (d < getNeighborDistance(other))) {
        sum.add(other.location);
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

  // Boids are more likely to recognize player
  // as a neighbor to respect.
  float getNeighborDistance(other){
    
    // If other boid is the player, allow
    // for a much farther distance leniency
    if (other.player){
      return neighborDistance * 2;
    
    // If other boid is near the player,
    // slightly increase distance leniency
    } if (other.nearPlayer) {
      return neighborDistance * 1.5;
    
    // If boid is no where near a player,
    // return the normal distance threshold
    } else {
      return neighborDistance;
    }
  }

  // applyForce: add force to current acceleration
  void applyForce(PVector force) {

    // Note: add mass here if you want acceleration = force / mass
    acceleration.add(force);
  }
  
  // Fish eats. It's now full, and we can 
  // reset it's danger level
  void feed(){
    dangerLevel = 255;
  }

  // Player controlled movement
  void turn(int i){

    // If player initializes movement, set
    // the selected boid to "player". If
    // player = true, then the boid will take
    // less influence from neighbors
    player = true;

    debug(location.x, location.y);

    // Create 2D PVectory. Apply rotate
    v = new PVector(velocity.x, velocity.y);
    v.rotate(HALF_PI * i * .025);

    // Convert 2D PVector into 3D
    velocity = new PVector(v.x, v.y, 0);

  }
  
  // Player controlled acceleration
  void accelerate(int i){
    player = true;

    debug(location.x, location.y);
    velocity.mult(1.0 + (i * .2));
  }

  // Print data about a specific boid
  void debug(float x, float y){
    

    pushMatrix();
      noFill();
      strokeWeight(2);
      stroke(204, 102, 0);
      ellipse(location.x, location.y, 50, 50);
    popMatrix();

  }
};
