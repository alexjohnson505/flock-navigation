/*********************************
            RIPPLE
 *********************************/

// Ripple is a UI effect.
// Creates 3 circles that radiate outwards from
// a central location. Ripples are stored in an
// ArrayList, as to support multiple Ripples
// occuring at a single time. Ripples also maintain
// a frame count, used to calculate the current step
// in the animation.

class Ripple {
  int currentFrame = 0; // Stores state of animation
  int maxFrame = 50;    // How many frames in animation?
  color c;              // Color
  float x;              // X Position
  float y;              // Y Position
  float width = 100;    // Ripple width
  
  Ripple(float x_, float y_, color c_){
    x = x_;
    y = y_;
    c = c_;
  }
  
  void draw(){
    // Float between 0.0 and 1.0
    float scale = (float)currentFrame / (float)maxFrame;
    
    // Current Alpha transparancy
    float alpha = 250 - (250 * scale);
   
    if (currentFrame < maxFrame){
      pushMatrix();
        noFill();
        strokeWeight(2);
        stroke(c, alpha);
        
        // Triple ripples
        for (int i = 3; i > 0; i--){
          
          // Re-calculate size for each ripple
          float size = width * scale * i/3;
          ellipse(x, y, size, size);
        } 
       
      popMatrix();
    }
    
    currentFrame++;
  }  
}

