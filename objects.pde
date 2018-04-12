class Cloud{
  float x, y, speed;
  PImage img;
  
  Cloud(float x, float y, float speed, int i){
    this.x = x;
    this.y = y;
    this.speed = speed;
    
    img = loadImage("cloud"+str(i)+".png");
  }
  
  void update(){
    x += speed;
    if(x > width) reset("");
  }
  
  void draw(){
    update();
    image(img, x, y);
  }
  
  void reset(String type){
    if(type == "full") x = random(-100, width);
    else{
      x = random(-500, -100);
      y = random(-220, 0.1 * height); // 0 to 60% of screen height
      speed = random(1, 4);
    }
  }
}