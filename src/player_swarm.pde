class PlayerSwarm extends Swarm {
  color c;

  PlayerSwarm(){
    c = color(255, 0, 0);
  }

  void addFish(float x, float y){
    initLocation.x = x;
    initLocation.y = y;
    initAcceleration.x = random(-0.7, 0.7);
    initAcceleration.y = random(-0.7, 0.7);
  
    fishs.add(new Fish(initLocation, initAcceleration, color(255, 0, 0)));
  }

  int countFish(){
    return fishs.size();
  }

  color getColor(){
    return c;
  }

};