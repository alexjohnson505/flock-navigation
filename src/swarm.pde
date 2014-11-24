
/*********************************
             SWARM
 *********************************/

// Swarm represents a grouping of fish. 
// Original code example from  IM 2250 Programming for Digital Media, Fall 2014
class Swarm {
  
  // Yes, I am aware "fishs" is grammatically 
  // incorrect, yet it avoids a LOT of confusion.
  ArrayList<Fish> fishs; 
  color c;
  int score;
  boolean selected;  
  
  Swarm(color c_) {
    fishs = new ArrayList<Fish>();
    c = c_;
    score = startFish;
    selected = false;
  }

  int countFish(){
    return fishs.size();
  }

  void move() {
    ArrayList<Fish> reproducingFish = new ArrayList<Fish>();
    
    Iterator<Fish> iterator = fishs.iterator();

    // TODO: Research performance increase for using iterator
    while (iterator.hasNext()) {
       Fish fish = iterator.next();
       
       fish.fly(fishs);
       
       if (food.collision(fish.location)){
         
         // Add ripple at each eaten food
         ripples.add(new Ripple(fish.location.x, fish.location.y, fish.myColor));
        
         fish.feed();
         reproducingFish.add(fish);
         addToScore(1);
      };
    }

    // Add a new fish for each fish that 
    // obtained food during this frame.
    while(reproducingFish.size() > 0){
       Fish parent = reproducingFish.remove(0);
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
  
  void addFish(Fish v) {
    fishs.add(v);
  }

  void addFish(float x, float y){
    initLocation.x = x;
    initLocation.y = y;
    initAcceleration.x = random(-0.7, 0.7);
    initAcceleration.y = random(-0.7, 0.7);
  
    Fish v = new Fish(initLocation, initAcceleration, c);
    addFish(v);
  }
  
  color getColor(){
    return c;
  }
  
  int addToScore(int i){
    score = score + i;
    return score;
  }
}

