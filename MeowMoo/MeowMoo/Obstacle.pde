public class Obstacle extends Sprite{
  
  float change_y = 0;
  float change_x = 0;

  // static obstacles that don't move
  public Obstacle(String filename, float scale, float x, float y){
    super(filename, scale, x, y);
    this.change_x = 0;
    this.change_y = 0;
    
  }
  
  // dynamic obstacles that move
  public Obstacle(String fileName, float scale, float x, float y, float change_x, float change_y){
    super(fileName, scale, x, y);
    this.change_x = change_x;
    this.change_y = change_y;
  }
  
  public void moveObstacle() {
        center_x += change_x;
        center_y += change_y;
        
        // check for horizontal wall collisions
        if (center_x <= 0 || center_x >= width) {
            change_x = -change_x;  
            change_y += random(-1, 1);  
        }
        
        // check for vertical wall collisions
        if (center_y <= 0 || center_y >= height) {
            change_y = -change_y;  
            change_x += random(-1, 1);  
        }
    }
 
}
