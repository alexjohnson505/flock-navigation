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
}


