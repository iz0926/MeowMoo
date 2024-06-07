/*
Images and sounds came from OpenGameArt.org, cow and cat from Sprout Lands - Asset Pack, peaches from SciGho's Fruity Booty Bodega
*/

import java.util.Timer;
import java.util.TimerTask;
import java.util.ArrayList;
import java.util.Iterator;
import ddf.minim.*;

final static float CRATE_SCALE = 0.8; 
final static float COLLECTIBLES_SCALE = 0.4;
final static float FRUIT_SCALE = 1.7;
final static float OBSTACLE_SCALE = 0.3; 
final static float PLAYER_SCALE = 1.8;

Sprite player;
Sprite player2;

static final int STILL = 0, LEFT = 1, RIGHT = 2, UP = 3, DOWN = 4;
final int NUM_DIRECTIONS = 5;
final int FRAMES_PER_DIRECTION = 2;
PImage[][] playerImages = new PImage[NUM_DIRECTIONS][FRAMES_PER_DIRECTION];
PImage[][] player2Images = new PImage[NUM_DIRECTIONS][FRAMES_PER_DIRECTION];
static final int HORIZONTAL = 0;
static final int VERTICAL = 1;

Obstacle man;
Obstacle fighterCat;

ArrayList<Sprite> coins; 
ArrayList<Obstacle> poisons;
ArrayList<hiderObject> crates;
float MOVE_SPEED;
float MOVE_SPEED2;
static int catScore = 0; 
static int mouseScore = 0;
final int BANNER_HEIGHT = 60;

int initialCoinCount;
int initialPoisonCount;
boolean catIsIt;
boolean isGameOver = false; 

PFont font1, font2, font3, font4;
final int STATE_LANDINGPAGE = 0;
final int STATE_GAMEPLAY = 1;
int gameState = STATE_LANDINGPAGE;

int lastSpawnTime = 0;
int spawnInterval = 100000; // spawn every 100,000 millisec

Minim minim;
AudioPlayer taggedSound;
AudioPlayer coinCollectSound;
PImage bgImage;

void drawLandingPage() {
  background(242,169,183);  // light pink background
  fill(255); 
  
  textAlign(CENTER, CENTER);
  
  textFont(font2, 35);
  text("Welcome to MeowMoo :D", width / 2, height / 5);
  
  textFont(font4, 30);   
  text("A game of tag, hide, and seek", width / 2, height / 5 + 35);
  
  textFont(font4, 26);  
  text("How to Win:", width / 2, height / 5 + 90);
  text("- WASD moves the Mouse, and Arrow Keys control the Cat.", width / 2, height / 5 + 120);
  text("- Dodge the Fighter Cat and Man, or lose speed!", width / 2, height / 5 + 150);
  text("- Collisions with the Fighter Cat and Man nudge you towards the center.", width / 2, height / 5 + 180);
  text("- Grab the peaches to speed up, but watch out for poisons!", width / 2, height / 5 + 210);
  text("- Use crates for hiding or as shields from the Fighter Cat and Man.", width / 2, height / 5 + 240);
  text("- Hitting a wall? The round restarts, so stay sharp!", width / 2, height / 5 + 270);
  text("- Keep track of your victories in the top banner.", width / 2, height / 5 + 300);
  text("- The top right of the banner shows who is 'It'.", width / 2, height / 5 + 330);
  text("- If 'It' tags the other player, they win a point.", width / 2, height / 5 + 360);
  text("- Collect the golden coin to become invisible for 3 seconds.", width / 2, height / 5 + 390);
  text("- Press Spacebar to restart and reset scores anytime.", width / 2, height / 5 + 420);
  
  int buttonX = width / 2 - 60;
  int buttonY = 5 * height / 6;
  int buttonWidth = 120;
  int buttonHeight = 40;
  // semi transparent shadow
  fill(50, 50, 50, 100); 
  // shadow with rounded corners
  rect(buttonX + 3, buttonY + 3, buttonWidth, buttonHeight, 10); 
  
  // button with rounded corners
  rect(buttonX, buttonY, buttonWidth, buttonHeight, 10);
  fill(255);  // button color
  
  if (overButton(buttonX, buttonY, buttonWidth, buttonHeight)) {
      fill(247, 207, 224);  // hover color
  } else {
      fill(255);
  } 
  
  textFont(font2, 20); 
  rect(width / 2 - 60, 5 * height / 6, 120, 40, 10);  // draw button
  fill(0);
  text("Start", width / 2, 5 * height / 6 + 16);  // button text
}

boolean overButton(int x, int y, int w, int h) {
  return mouseX >= x && mouseX <= x + w && mouseY >= y && mouseY <= y + h;
}

void mousePressed() {
  if (gameState == STATE_LANDINGPAGE && mouseX > width / 2 - 60 && mouseX < width / 2 + 60 &&
    mouseY > 5 * height / 6 && mouseY < 5 * height / 6 + 40) {
    gameState = STATE_GAMEPLAY; 
  }
}

void setup(){
  size(1030, 768);
  imageMode(CENTER);
  //bgImage = loadImage("images/Grass.png");
  //bgImage.resize(width, height);
  
  font1 = createFont("fonts/Urbanist-Black.ttf", 16);    
  font2 = createFont("fonts/Kenney Blocks.ttf", 16);
  font3 = createFont("fonts/Kenney Mini Square.ttf", 16);
  font4 = createFont("fonts/Kenney Pixel.ttf", 16);
  
  minim = new Minim(this);
  taggedSound = minim.loadFile("sounds/converted_tag.wav");
  coinCollectSound = minim.loadFile("sounds/converted_invisible.wav");
  
  playerImages[STILL][0] = loadImage("images/cat_still.png");
  playerImages[LEFT][0] = loadImage("images/cat_left_1.png");
  playerImages[LEFT][1] = loadImage("images/cat_left_2.png");
  playerImages[RIGHT][0] = loadImage("images/cat_right_1.png");
  playerImages[RIGHT][1] = loadImage("images/cat_right_2.png");
  playerImages[UP][0] = loadImage("images/cat_up_1.png");
  playerImages[UP][1] = loadImage("images/cat_up_2.png");
  playerImages[DOWN][0] = loadImage("images/cat_down_1.png");
  playerImages[DOWN][1] = loadImage("images/cat_down_2.png");
  
  player2Images[STILL][0] = loadImage("images/player2_still.png");
  player2Images[LEFT][0] = loadImage("images/player2_left_1.png");
  player2Images[LEFT][1] = loadImage("images/player2_left_2.png");
  player2Images[RIGHT][0] = loadImage("images/player2_right_1.png");
  player2Images[RIGHT][1] = loadImage("images/player2_right_2.png");
  player2Images[UP][0] = loadImage("images/player2_up_1.png");
  player2Images[UP][1] = loadImage("images/player2_up_2.png");
  player2Images[DOWN][0] = loadImage("images/player2_down_1.png");
  player2Images[DOWN][1] = loadImage("images/player2_down_2.png");
  
  resetGame();
  isGameOver = false;
  initializeCollectibles();
  initialCoinCount = coins.size();
  initialPoisonCount = poisons.size();
  spawnSpecialCoin();
  lastSpawnTime = millis();
}

boolean isTooClose(float x, float y, float playerX, float playerY) {
  float safeDistance = 50;  
  return dist(x, y, playerX, playerY) < safeDistance;
}

void initializeCollectibles() {
  coins = new ArrayList<Sprite>();
  poisons = new ArrayList<Obstacle>();
  crates = new ArrayList<hiderObject>();
  float x, y;

  // initialize crates
  for (int i = 0; i < 15; i++) {
      do {
          x = random(width);
          y = random(BANNER_HEIGHT, height);
      } while (isTooClose(x, y, player.center_x, player.center_y) || isTooClose(x, y, player2.center_x, player2.center_y));
      crates.add(new hiderObject("images/crate.png", CRATE_SCALE, x, y));
  }

  // initialize coins
  for (int i = 0; i < 110; i++) {
      do {
          x = random(width);
          y = random(BANNER_HEIGHT, height);
      } while (isTooClose(x, y, player.center_x, player.center_y) || isTooClose(x, y, player2.center_x, player2.center_y));
      coins.add(new Sprite("images/fruit.png", FRUIT_SCALE, x, y));
  }

    // initialize poisons
  for (int i = 0; i < 35; i++) {
      do {
          x = random(width);
          y = random(BANNER_HEIGHT, height);
      } while (isTooClose(x, y, player.center_x, player.center_y) || isTooClose(x, y, player2.center_x, player2.center_y));
      poisons.add(new Obstacle("images/poison.png", COLLECTIBLES_SCALE, x, y));
  }
}

void spawnSpecialCoin() {
  float specialX = random(50, width - 50);
  float specialY = random(50, height - 50);
  coins.add(new Sprite("images/coin.png", COLLECTIBLES_SCALE, specialX, specialY, true));
}

void resetGame() {
  //background(bgImage);
  
  MOVE_SPEED = 2;
  MOVE_SPEED2 = 2;
  
  player = new Sprite(playerImages, PLAYER_SCALE, width-40, Math.max(height - 730, BANNER_HEIGHT + 10));
  player2 = new Sprite(player2Images, PLAYER_SCALE, width-980, Math.max(height - 40, BANNER_HEIGHT + 10)); 
  
  catIsIt = random(1) < 0.5;
  
  man = randomObstacle("images/man.png", OBSTACLE_SCALE);
  fighterCat = randomObstacle("images/fighterCat.png", OBSTACLE_SCALE);
  
}

Obstacle randomObstacle(String filename, float scale) {
  float startX, startY, velocityX, velocityY;

  do {
      startX = random(50, width - 50);  
      startY = random(50, height - 50);
  } while (isTooClose(startX, startY, player.center_x, player.center_y) || isTooClose(startX, startY, player2.center_x, player2.center_y));

  velocityX = random(-3, 3);  
  velocityY = random(-3, 3); 

  return new Obstacle(filename, scale, startX, startY, velocityX, velocityY);
}

void draw() {
  switch (gameState) {
    case STATE_LANDINGPAGE:
      drawLandingPage();
      break;
    case STATE_GAMEPLAY:
      clearScreen();
      if (!isGameOver) {
        updateGameObjects();
        displayGameObjects();
        handleCollisions();
        updateGameState();
  
        //setup();
        displayScores();
        checkSpecialCoinSpawn();
      } else {
        //displayGameOverScreen();
        setup();
        //resetGame();
        } 
      break;
  }
}

void checkSpecialCoinSpawn() {
  int currentTime = millis();
  if (currentTime - lastSpawnTime > spawnInterval) {
      spawnSpecialCoin();
      lastSpawnTime = currentTime;
  }
}

void clearScreen() {
  background(255); 
}

void regenerateCoins(int numCoins) {
  for (int i = 0; i < numCoins; i++) {
      float x, y;
      do {
          x = random(width);
          y = random(BANNER_HEIGHT, height);
      } while (isTooClose(x, y, player.center_x, player.center_y) || isTooClose(x, y, player2.center_x, player2.center_y));
      coins.add(new Sprite("images/fruit.png", FRUIT_SCALE, x, y));
  }
}

void checkForCoinRegen() {
  if (coins.size() <= initialCoinCount / 2) {
      regenerateCoins((initialCoinCount - coins.size()) + (initialCoinCount / 2));
  }
}

void regeneratePoisons(int numPoisons) {
  for (int i = 0; i < numPoisons; i++) {
      float x, y;
      do {
          x = random(width);
          y = random(BANNER_HEIGHT, height);
      } while (isTooClose(x, y, player.center_x, player.center_y) || isTooClose(x, y, player2.center_x, player2.center_y));
      poisons.add(new Obstacle("images/poison.png", OBSTACLE_SCALE, x, y));
  }
}

void checkForPoisonRegen() {
  if (poisons.size() <= initialPoisonCount / 2) {
      regeneratePoisons((initialPoisonCount - poisons.size()) + (initialPoisonCount / 4));  // Add back 1/4th of the initial count
  }
}

void updateGameObjects() {
  player.update();
  player2.update();
  man.moveObstacle();
  man.update();
  fighterCat.moveObstacle();
  fighterCat.update();
  checkForCoinRegen();
  checkForPoisonRegen();
}

void displayGameObjects() {
  if (player.isVisible)
    player.display();
  if (player2.isVisible)
    player2.display();
  displayCollection(coins);
  displayCollection(poisons);
  displayCollection(crates);
  man.moveObstacle();
  man.display();
  fighterCat.moveObstacle();
  fighterCat.display();
}

void displayCollection(ArrayList<?> collection) {
  for (Object item : collection) {
      if (item instanceof Sprite) {
          ((Sprite)item).display();
      } else if (item instanceof Obstacle) {
          ((Obstacle)item).display();
      }
  }
}

void handleCollisions() {
  checkPlayerCollisions();
  handleCoinCollisions();
  handlePoisonCollisions();
  handlePlayerObstacleCollisions();
}

void handleCoinCollisions() {
  MOVE_SPEED = handleCollisionsWithCoins(player, MOVE_SPEED);
  MOVE_SPEED2 = handleCollisionsWithCoins(player2, MOVE_SPEED2);
}

float handleCollisionsWithCoins(Sprite player, float speed) {
  ArrayList<Sprite> collisions = checkCollisionList(player, coins);
  for (Sprite coin : collisions) {
    if (coin.isSpecial) {
      coinCollectSound.play();
      activateInvisibility(player);
    }
    if (player.isVisible || coin.isSpecial) {
      coins.remove(coin); 
      speed += 0.5;
    }    
  }
  return speed;
}

void activateInvisibility(Sprite player) {
  player.isVisible = false;  
  int duration = 4000;  // 5 seconds in millisec
  
  Timer timer = new Timer();
    timer.schedule(new TimerTask() {
        @Override
        public void run() {
            player.isVisible = true; 
            timer.cancel();  
        }
    }, duration);
  
}

void handlePoisonCollisions() {  
  ArrayList<Obstacle> x = checkCollisionL(player, poisons);
  ArrayList<Obstacle> y = checkCollisionL(player2, poisons);
  
  Iterator<Obstacle> itX = x.iterator();
  while (itX.hasNext()) {
      Obstacle poison = itX.next();
      if (player.isVisible && !isCoveredByCrate(player)) {
          poisons.remove(poison);
          MOVE_SPEED--;
      }
  }

  Iterator<Obstacle> itY = y.iterator();
  while (itY.hasNext()) {
      Obstacle poison = itY.next();
      if (player2.isVisible && !isCoveredByCrate(player2)) {
          poisons.remove(poison); 
          MOVE_SPEED2--;
      }
  } 
}

void handlePlayerObstacleCollisions() {
  handleSinglePlayerObstacleCollision(player, man);
  handleSinglePlayerObstacleCollision(player2, man);
  handleSinglePlayerObstacleCollision(player, fighterCat);
  handleSinglePlayerObstacleCollision(player2, fighterCat);
}

void handleSinglePlayerObstacleCollision(Sprite player, Obstacle obstacle) {
  if (checkCollision(obstacle,player) && player.isVisible && !isCoveredByCrate(player)){
      reactToCollision(player);
  }
}

void reactToCollision(Sprite player) {
  // center of the screen
  float centerX = width / 2;
  float centerY = height / 2;
  
  float nudgeAmount = 10;
  
  if (player.center_x < centerX) {
    player.center_x += nudgeAmount;  
  } else {
    player.center_x -= nudgeAmount; 
  }
  
  if (player.center_y < centerY) {
    player.center_y += nudgeAmount;  
  } else {
    player.center_y -= nudgeAmount;  
  }
  
  float speedReduction = 0.5;
  if (player == this.player) {
    MOVE_SPEED = Math.max(0, MOVE_SPEED - speedReduction);
  } else if (player == this.player2) {
    MOVE_SPEED2 = Math.max(0, MOVE_SPEED2 - speedReduction);
  }
}

boolean isCoveredByCrate(Sprite sprite) {
  for (hiderObject crate : crates) {
      if (checkCollision(crate, sprite)) {
          return true;  
      }
  }
  return false; 
}

void checkPlayerCollisions() {
  if (checkCollision(player, player2)) {
      if (catIsIt) {
          taggedSound.play();
          catScore++; 
      } else {
          taggedSound.play();
          mouseScore++; 
      }
      isGameOver = true;
  }
  if (player.hitWall() || player2.hitWall()) {
      setup();
  }
}
  
void updateGameState() {
  if (MOVE_SPEED == 0 || MOVE_SPEED2 == 0 || (MOVE_SPEED <= 1 && checkCollision(man, player)) || (MOVE_SPEED2 <= 1 && checkCollision(fighterCat, player2))) {
      isGameOver = true;
      //setup();
  }
}
 
void displayScores() {
  int bannerHeight = 60;
  fill(0,0,0,150);
  rect(0,0,width,bannerHeight);
    
  fill(255, 192, 203);
  
  textFont(font3);
  
  textAlign(CENTER, CENTER);
  text("Mouse Speed: " + MOVE_SPEED2, width * 0.3f, 20);
  text("Mouse Score: " + mouseScore, width * 0.3f, 40);
  
  textAlign(CENTER, CENTER);
  text("Cat Speed: " + MOVE_SPEED, width * 0.55f, 20);
  text("Cat Score: " + catScore, width * 0.55f, 40);
  
  textAlign(RIGHT, CENTER);
  text(catIsIt ? "Cat is It" : "Mouse is It", width * 0.75f, 20);
  text("Press spacebar to restart.", width * 0.75f, 40);
  
}

void displayGameOverScreen() {
  background(0);
  fill(255);
  textSize(50);
  text("GAME OVER! \nClick the spacebar to restart.", 330, 300);
}
 
/**
   This method accepts a Sprite s and an ArrayList of Sprites and returns
   the collision list(ArrayList) which consists of the Sprites that collide with the given Sprite. 
   
*/ 
public ArrayList<Sprite> checkCollisionList(Sprite s, ArrayList<Sprite> list){
  
  ArrayList<Sprite> collision_list = new ArrayList<Sprite>();
  for (Sprite p: list){
    if (checkCollision(s, p))
      collision_list.add(p);
  }
  return collision_list;
}

public ArrayList<Obstacle> checkCollisionL(Sprite s, ArrayList<Obstacle> l){
  ArrayList<Obstacle> collision_list = new ArrayList<Obstacle>();
  for (Obstacle p: l){
    if (checkCollision(s, p))
      collision_list.add(p);
    
  }
  return collision_list;
}

// checkCollision for Obstacle and Sprite objects 
public boolean checkCollision(Obstacle s1, Sprite s2){                                    
  boolean xOverlap = s2.getRight() > s1.getLeft() && s2.getLeft() < s1.getRight(); 
  boolean yOverlap = s2.getBottom() > s1.getTop() && s2.getTop() < s1.getBottom();
   return xOverlap && yOverlap;
}

public boolean checkCollision(Sprite s1, Sprite s2){                                     
  boolean xOverlap = s2.getRight() > s1.getLeft() && s2.getLeft() < s1.getRight(); 
  boolean yOverlap = s2.getBottom() > s1.getTop() && s2.getTop() < s1.getBottom();
  return xOverlap && yOverlap;
}

/* direct seeking where fighterCat and man go toward player
void moveTowardsTarget(Sprite target, Obstacle mover) {
  float targetX = target.center_x;
  float targetY = target.center_y;
  float moveX = 0;
  float moveY = 0;

  if (mover.center_x < targetX) {
      moveX = mover.change_x; 
  } else if (mover.center_x > targetX) {
      moveX = -mover.change_x;
  }

  if (mover.center_y < targetY) {
      moveY = mover.change_y;
  } else if (mover.center_y > targetY) {
      moveY = -mover.change_y;
  }

  // Check for collisions with obstacles
  if (checkFutureCollision(mover, moveX, moveY)) {
      moveX = (moveX != 0) ? 0 : ((random(1) < 0.5) ? -mover.change_x : mover.change_x);
      moveY = (moveY != 0) ? 0 : ((random(1) < 0.5) ? -mover.change_y : mover.change_y);
  }

  mover.center_x += moveX;
  mover.center_y += moveY;
}

boolean checkFutureCollision(Obstacle mover, float moveX, float moveY) {
  float newX = mover.center_x + moveX;
  float newY = mover.center_y + moveY;
  Obstacle simulatedMover = new Obstacle("images/fighterCat.png", OBSTACLE_SCALE, newX, newY, fighterCat.change_x, fighterCat.change_y);

  for (hiderObject crate : crates) {
      if (checkCollision(simulatedMover, crate)) {
          return true; 
      }
  }
  for (Obstacle poison : poisons) {
      if (checkCollision(simulatedMover, poison)) {
          return true; // collision detected with a poison
      }
  }

  for (Sprite coin : coins) {
      if (checkCollision(simulatedMover, coin)) {
          return true; // collision detected with a coin
      }
  }

  return false; // no collision detected with any object
}
*/
  
void keyPressed(){
  if(keyCode == 39){
    player.change_x = MOVE_SPEED;
    player.playerDirection = RIGHT;
  }
  else if(keyCode == 37){
    player.change_x = -MOVE_SPEED;
    player.playerDirection = LEFT;
  }
  else if(keyCode == 38){
    player.change_y = -MOVE_SPEED;
    player.playerDirection = UP;
  }
  else if(keyCode == 40){
    player.change_y = MOVE_SPEED;
    player.playerDirection = DOWN;
  }
  if (keyCode == 32){
    catScore = 0;
    mouseScore = 0;
    setup();
  }
}

void keyTyped(){
  if(key == 'd'){
    player2.change_x = MOVE_SPEED2;
    player2.playerDirection = RIGHT;
  }
  else if(key == 'a'){
    player2.change_x = -MOVE_SPEED2;
    player2.playerDirection = LEFT;
  }
  else if(key == 'w'){
    player2.change_y = -MOVE_SPEED2;
    player2.playerDirection = UP;
  }
  else if(key == 's'){
    player2.change_y = MOVE_SPEED2;
    player2.playerDirection = DOWN;
  }
}

void keyReleased() {
  if (keyCode == 39 || keyCode == 37) { // right or left arrow keys
    player.stopMoving(HORIZONTAL);
  }
  if (keyCode == 38 || keyCode == 40) { // up or down arrow keys
    player.stopMoving(VERTICAL);
  }
  
  // Stop player2 if 'd', 'a', 'w', or 's' keys are released
  if (key == 'd' || key == 'a') { // right or left for player2
    player2.stopMoving(HORIZONTAL);
  }
  if (key == 'w' || key == 's') { // up or down for player2
    player2.stopMoving(VERTICAL);
  }
}
