// A Ripple for UI effects
class Ripple {
  int currentFrame = 0;
  int maxFrame = 50;
  color c;
  float x;
  float y;
  
  Ripple(float x_, float y_, color c_){
    x = x_;
    y = y_;
    c = c_;
  }
  
  void draw(){
    float alpha = 250 - (250 * ((float)currentFrame / (float)maxFrame));
   
    if (currentFrame < maxFrame){
      pushMatrix();
        strokeWeight(2);
        stroke(c, alpha);
        noFill();
        
        ellipse(x, y, currentFrame, currentFrame);
        ellipse(x, y, currentFrame / 2, currentFrame / 2);
        ellipse(x, y, currentFrame / 3, currentFrame / 3);
      popMatrix();
      
      currentFrame++;
    }
  }  
}


