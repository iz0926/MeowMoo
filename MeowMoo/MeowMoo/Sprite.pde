public class Sprite{
  PImage image;
  float center_x, center_y;
  float change_x, change_y;
  float w, h;
  boolean isSpecial;
  boolean isVisible;
  boolean isAnimated;
  int playerDirection = STILL;
  int feetFrameIndex = 0;
  PImage[][] animations;
  long lastFrameChangeTime;
  static final int frameChangeInterval = 10;

  public Sprite(String filename, float scale, float x, float y, boolean isSpecial){
    this.image = loadImage(filename);
    this.w = image.width * scale;
    this.h = image.height * scale;
    this.center_x = x;
    this.center_y = y;
    this.change_x = 0;
    this.change_y = 0;
    this.isSpecial = isSpecial;
    this.isVisible = true;
  }
  
  public Sprite(PImage[][] frames, float scale, float x, float y) {
      this.animations = frames;
      this.image = frames[STILL][0]; 
      this.w = image.width * scale;
      this.h = image.height * scale;
      this.center_x = x;
      this.center_y = y;
      this.isAnimated = true;
      this.isVisible = true;
      this.lastFrameChangeTime = System.currentTimeMillis();
  }
  
  public Sprite(String filename, float scale, float x, float y){
    this(filename, scale, x, y, false);
  }
  public Sprite(PImage img, float scale){
    image = img;
    w = image.width * scale;
    h = image.height * scale;
    center_x = 0;
    center_y = 0;
    change_x = 0;
    change_y = 0;
  }
  
  public void display(){
    if (this == player) {
      image(playerImages[playerDirection][feetFrameIndex], center_x, center_y, w, h); 
    } 
    else if (this == player2) {
      image(player2Images[playerDirection][feetFrameIndex], center_x, center_y, w, h);
    }
    else{
      image(image, center_x, center_y, w, h); 
    }
  }

  public void updateFeetFrames() {
      this.feetFrameIndex = (this.feetFrameIndex == 0) ? 1 : 0;
  }
  
  public void update(){
    center_x += change_x;
    center_y += change_y;
    
    if (this.isAnimated && (change_x != 0 || change_y != 0)) {
      long currentTime = System.currentTimeMillis();
      if (currentTime - lastFrameChangeTime > frameChangeInterval) {
        this.updateFeetFrames();
        lastFrameChangeTime = currentTime;
      }
    } else if (change_x == 0 && change_y == 0) {
      this.feetFrameIndex = 0;
      this.playerDirection = STILL;
    }
  }
  
  public boolean hitWall(){
    return (this.getRight() >= 1024 || this.getLeft() <= 0 || this.getBottom() >= 768 || this.getTop() <= 0);
  }

  public void moveObstacle(){
    if (this.getRight() >= width || this.getLeft() <= 0){
      this.change_x *= -1;
    }
  }

  void setLeft(float left){
    center_x = left + w/2;
  }
  float getLeft(){
    return center_x - w/2;
  }
  void setRight(float right){
    center_x = right - w/2;
  }
  float getRight(){
    return center_x + w/2;
  }
  void setTop(float top){
    center_y = top + h/2;
  }
  float getTop(){
    return center_y - h/2;
  }
  void setBottom(float bottom){
    center_y = bottom - h/2;
  }
  float getBottom(){
    return center_y + h/2;
  }
  
void stopMoving(int directionType) {
  if (directionType == HORIZONTAL) {
    change_x = 0;
  } else if (directionType == VERTICAL) {
    change_y = 0;
  }

  // Check if both horizontal and vertical movements have stopped
  if (change_x == 0 && change_y == 0) {
    playerDirection = STILL; // Set the direction to STILL
    feetFrameIndex = 0; // Reset animation to the still frame
    lastFrameChangeTime = System.currentTimeMillis();
  }
}
  
}
