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
      fill(240, 0, 0);
      ellipse(v.x, v.y, 10, 10);
     }
  }
  
  // Add new target to list
  void addFood(){
    PVector f;
    f = new PVector(random(0, 500), random(0, 1000));
    food.add(f);
  }
  
  void remove(int index){
    food.remove(index);
  }
  
  boolean collision(PVector a){
    for (int i = food.size() - 1; i >= 0; i--){
      PVector b = food.get(i);
     
      float x1 = abs(a.x - b.x);
      float x2 = abs(a.y - b.y);
      
      boolean x;
      x = (x1 < 10) && (x2 < 10);
      
      
      if (x){
        food.remove(i);
        return x;
      }
      
    }
    
    return false;

  }
    
}


