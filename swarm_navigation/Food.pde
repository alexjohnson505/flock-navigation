// An array of targets.
class Food {
  // Represent targets as PVectors
  ArrayList<PVector> food;
  
  Food(){
    food = new ArrayList<PVector>();
  }
  
  // Render each target
  void draw(){
    for (PVector v : food) {
      fill(240, 240, 240);
      noStroke();
      ellipse(v.x, v.y, 5, 5);
    }
     
     updateFoodQuantity();
  }
  
  // Limit rate of food respawn.
  // foodRegenCounter is updated every TICK.
  // when foodRegenCounter exceeds foodRegenThreshold,
  // we can introduce a new food item into the world.
  void updateFoodQuantity(){
    foodRegenCounter++;
  
    if (foodRegenCounter > foodRegenThreshold) {
      foodRegenCounter = 0;
      addFood();
    }
  }
  
  // Add new target to list
  void addFood(){
    float x = random(0, width);
    float y = random(0, height);
    
    food.add(new PVector(x, y));
    ripples.add(new Ripple(x, y, color(255)));
  }

  // Add new target to list
  void addFood(float x, float y){
    food.add(new PVector(x, y));
    ripples.add(new Ripple(x, y, color(255)));
  }
  
  void remove(int index){
    food.remove(index);
  }
  
  // Does a (the fish's location) collide with b (a food item)
  boolean collision(PVector a){
    float threshold = 5.5;
    boolean acc = false;
    
    
    // Iterate through food 
    for (int i = food.size() - 1; i >= 0; i--){
      PVector b = food.get(i);
     
      float horizontalDifference = abs(a.x - b.x);
      float verticalDifference = abs(a.y - b.y);
      
      boolean collision = (horizontalDifference < threshold) && (verticalDifference < threshold);
      
      if (collision){
        
        // Remove eaten food
        food.remove(i);
      }
      
      acc = collision || acc;
    }
   
    
    return acc;
    
  }
    
}


