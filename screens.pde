float instruc_x, instruc_y;
float title_x, title_y;
int instruc_change = 1;
int counter;

int introtime = 350;
int maxtime = 800;
int starttime = 75;

int pantime = 100;
int blenderdowntime = 100;
float blendercoef = 0; //for making the blender poof down
int goalshowtime = 50;
int goalpantime = 100;

float goalheight;
int goalsize = 100;
int playeroffset = 200; //for panning up/down
float offset;
  
int blendx;
int blendy;

int[] bcolor = new int[]{242,255,226};

void startscreen_setup(){
  title_x = width/2-title.width/2;
  title_y = height*2/3;
  
  instruc_x = width/2-instruc.width/2;
  instruc_y = height/3;
}
void gamescreen_setup(){
  blendx = width/2-blender.width/2-10;
  blendy = height-blender.height-300;
  blendercoef = (float)(blendy+blender.height)/(float)(blenderdowntime*blenderdowntime);
}

void startscreen(){
  backgrounddraw(0);
  if(instruc_y < height/3-5 || instruc_y > height/3+5) instruc_change *= -1;
  instruc_y += instruc_change;
  
  pushMatrix();
  translate(title_x+title.width/2, title_y+title.height/2);
  rotate(counter*TWO_PI/360);
  image(title_bg, -title_bg.width/2, -title_bg.height/2);
  popMatrix();
  counter++;
 
  //imageCenter(title_bg, title_x+title.width/2, title_y+title.height/2);
  image(title, title_x, title_y,title.width,title.height);
  image(instruc, instruc_x, instruc_y,instruc.width,instruc.height);

  playerdraw(0);
  
  if (carrotdown && daikondown){
    timer += 1;
  }if (!carrotdown || !daikondown){
    timer = 0;
  }
  if (timer > starttime){
    mode = "intro";
    timer = 0;
    offset = 0;
    goalheight = 0;
  }
  
  timerdraw((float)starttime);
}

void introscreen(){
  timer = timer + 1;
  float blendery=0;
  if (timer < pantime){
    offset = offset + ((float)playeroffset/(float)pantime);
    blendery = -blender.height; //off screen
  }else if (timer < pantime+blenderdowntime){
    blendery = -blender.height+blendercoef*(timer-pantime)*(timer-pantime);
  }else if (timer < pantime+blenderdowntime+goalshowtime){
    offset = playeroffset;
    goalheight=height;
    blendery = blendy;
  }else if (timer < pantime+blenderdowntime+goalshowtime+goalpantime){
    offset = playeroffset;
    goalheight = goalheight - (float)(height-goalsize)/(float)goalpantime;
    blendery = blendy;
  }else{
    offset = playeroffset;
    goalheight = goalsize;
    blendery = blendy;
  }
  
  goaldraw((int)juicecolor[0],(int)juicecolor[1],(int)juicecolor[2],goalheight);
  backgrounddraw(offset);
  playerdraw(offset);
  image(blender,blendx,blendery);
  
  timerdraw((float)(introtime+pantime));
  
  if (timer > introtime){
    timer = 0;
    mode = "play";
  }
}

void gamescreen(){
  
  timer = timer + 1;
    
  if (carrotstate > -1){
    carrotstate += .025;
    if (carrotstate > 1){
      carrotstate = -1;
    }
  }
  if (daikonstate > -1){
    daikonstate += .025;
    if (daikonstate > 1){
      daikonstate = -1;
    }
  }
  
  backgrounddraw(playeroffset);
  
  goaldraw((int)juicecolor[0],(int)juicecolor[1],(int)juicecolor[2],goalsize);
    
  progress();
  
  tint(#f2ffe2);
  image(blender_mask,blendx,blendy-5);
  tint(255);
  image(mountains_mask,width/2-mountains_mask.width/2-3,height/2+27);
  
  image(ground_back,width/2-ground_back.width/2,height/2+offset);
  
  image(blender_empty,blendx,blendy);
  
  carrotdraw();
  daikondraw();
  
  playerdraw(playeroffset);
  
  timerdraw((float)maxtime);
  
  if (timer > maxtime){
    mode = "end";
  }
}

void endscreen(){
  backgrounddraw(playeroffset);
  playerdraw(playeroffset);
  
  result();
  
  if (carrotdown && daikondown){
    timer += 1;
  }if (!carrotdown || !daikondown){
    timer = 0;
  }
  if (timer > starttime){
    mode = "start";
    timer = 0;
    reset();
  }
  
  timerdraw((float)starttime);
}