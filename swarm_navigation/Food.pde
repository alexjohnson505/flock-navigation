// An array of targets.
class Food {
  ArrayList<PVector> food;

  
  Food(){
    food = new ArrayList<PVector>();
  }
  
  void draw(){
    for (PVector v : food) {
      ellipse(v.x, v.y, 10, 10);
     }
     
     
  }
  
  void addFood(){
    PVector f;
    f = new PVector(random(0, 500), random(0, 1000));
    food.add(f);
  }
}


