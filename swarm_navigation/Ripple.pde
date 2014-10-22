// A Ripple for UI effects
class Ripple {
  int currentFrame = 0;
  int framesPerSlide = 4;
  PImage[] frames = rippleImages;
  float x;
  float y;
  
  Ripple(float x_, float y_){
    x = x_;
    y = y_;
  }
  
  void draw(){
    if (currentFrame < 30){
      int i = (int)Math.floor(currentFrame / framesPerSlide);
      pushMatrix();
        tint(240, 240, 240, 100); // Transparency
        image(frames[i], x, y, 256/2, 256/2);
      popMatrix();
    }
    currentFrame++;
    
    
  }
  
}


