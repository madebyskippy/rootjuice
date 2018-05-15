float instruc_x, instruc_y;
float title_x, title_y;
int instruc_change = 1;
int counter;

int introtime = 6*1000;
int maxtime = 10*1000;
int starttime = 1500;
int pushtime = 1500;

int pantime = 1000;
int blenderdowntime = 1000;
int tutorialtime = 12*1000;
int[] tutorialtimes = new int[]{3000,4000,5000};
int tutx,tuty;
int goalshowtime = 3*1000;
int goalpantime = 3*1000;

int juicedonetime = 2*1000;
int juicedonetimer;
boolean juicedone;

float blendercoef = 0; //for making the blender poof down

float goalheight;
float goalwidth;
int goalsize = 100;
int playeroffset = 200; //for panning up/down
float offset;
  
int blendx;
int blendy;

int[] bcolor = new int[]{242,255,226};

int lastframetime;

void startscreen_setup(){
  title_x = width/2-title.width/2;
  title_y = 100;
  
  instruc_x = width/2-instruc.width/2;
  instruc_y = height*3/4;
}

void gamescreen_setup(){
  blendx = width/2-blender.width/2-10;
  blendy = height-blender.height-300;
  blendercoef = (float)(blendy+blender.height)/(float)(blenderdowntime*blenderdowntime);
  tutx = width/2;
  tuty = 0;
}

void startscreen(){
  backgrounddraw(0);
  if(instruc_y < height*3/4-5 || instruc_y > height*3/4+5) instruc_change *= -1;
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
  
  if (carrotdown && carrotmeterstart != 0){
    carrotmeter = min(millis()-carrotmeterstart,pushtime);
  }if (daikondown && daikonmeterstart != 0){
    daikonmeter = min(millis()-daikonmeterstart,pushtime);
  }
  
  if (carrotmeter >= pushtime && daikonmeter >= pushtime){
    mode = "intro";
    timer = 0;
    timestart = millis();
    offset = 0;
    goalheight = 0;
    goalwidth = 0;
    lastframetime = millis();
    counter = 0;
  }
  meterdraw(0);
}

void introscreen(){
  //timer = timer + 1;
  timer = millis()-timestart;
  float blendery=blendy;
  int d = -1;
  
  //this is the worst way to do an if statement for timing :^)
  
  if (timer < pantime){
    offset = offset + ((float)playeroffset/(float)pantime) * (millis()-lastframetime);
    blendery = -blender.height; //off screen
  }else if (timer < pantime+blenderdowntime){
    offset = playeroffset;
    blendery = -blender.height+blendercoef*(timer-pantime)*(timer-pantime);
  }else if (timer < pantime+blenderdowntime+tutorialtime){
    offset = playeroffset;
    int timetillnow = pantime+blenderdowntime;
    int t = timer-timetillnow;
    if (t < tutorialtimes[0]){
      d = 0;
    }else if (t < tutorialtimes[0]+tutorialtimes[1]){
      d = 1;
    }else{
      d = 2;
    }
  }else if (timer < pantime+blenderdowntime+tutorialtime+goalshowtime){
    d=3;
    offset = playeroffset;
    goalheight=0;
    goalwidth = 150;
  }else{
    d=3;
    offset = playeroffset;
    goalheight = goalsize;
    goalwidth = width;
    timer = 0;
    timestart = millis();
    mode = "play";
  }
  
  backgrounddraw(offset);
  playerdraw(offset);
  image(blender,blendx,blendery);
  
  lastframetime = millis(); 
  
  if (d>=0){
    image (dump[d],50,height/4);
    image (tut[d],tutx,tuty);
  }

}

void gamescreen(){
  
  timer = millis()-timestart;
    
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
    
  progress();
  
  tint(#f2ffe2);
  image(blender_mask,blendx,blendy-5);
  tint(255);
  
  image(ground_back,width/2-ground_back.width/2,height/2+offset);
  
  image(blender_empty,blendx,blendy);
  
  carrotdraw();
  daikondraw();
  
  playerdraw(playeroffset);
  
  timerdraw((float)maxtime);
  
  float scarrot = ((float)score[0]/(float)(score[0]+score[1]))*10;
  if (scarrot == juice[0] && !juicedone){
    //done the juice. next one
    juicedonetimer = millis();
    doneJuices.add(new PVector((int)juicecolor[0],(int)juicecolor[1],(int)juicecolor[2]));
    numJuices ++ ;
    juicedone = true;
  }
  
  if (juicedone){
    textFont(fonts,100);
    text("NICE!!!",width/2,height/2);
    int x = width/2-juicedoneimg.width/2;
    int y = height/2-juicedoneimg.height/2;
    image(juicedoneimg,x,y);
    tint((int)juicecolor[0],(int)juicecolor[1],(int)juicecolor[2]);
    image(juicedoneimgbottle,x,y);
    tint(255);
    if (millis()-juicedonetimer > juicedonetime){
      newJuice();
      score[0] = 0;
      score[1] = 0;
      juicedone = false;
    }
  }else{
    goaldraw((int)juicecolor[0],(int)juicecolor[1],(int)juicecolor[2]);
  }
  
  bottledraw(0);
  
  if (timer > maxtime-3000 && beepPlayed == 0){
    beepPlayed = 1;
    beep_noise.rewind();
    beep_noise.play();
  }if (timer > maxtime-2000 && beepPlayed == 1){
    beepPlayed = 2;
    beep_noise.rewind();
    beep_noise.play();
  }if (timer > maxtime-1000 && beepPlayed == 2){
    beepPlayed = 3;
    beep_noise.rewind();
    beep_noise.play();
  }
  
  if (timer > maxtime){
    ding_noise.rewind();
    ding_noise.play();
    mode = "end";
    carrotmeterstart = 0;
    daikonmeterstart = 0;
  }
}

void endscreen(){
  backgrounddraw(playeroffset);
  playerdraw(playeroffset);
  
  //result();
  textFont(fonts,80);
  textAlign(CENTER,CENTER);
  text("You made "+str(numJuices)+" juices!",width/2,height/2);
  bottledraw(600);
  
  if (carrotdown && carrotmeterstart != 0){
    carrotmeter = min(millis()-carrotmeterstart,pushtime);
  }if (daikondown && daikonmeterstart != 0){
    daikonmeter = min(millis()-daikonmeterstart,pushtime);
  }
  
  if (carrotmeter >= pushtime){
    reset();
    timer = 0;
    timestart = millis() - (pantime+blenderdowntime+tutorialtime+goalshowtime);
    mode = "intro";
    carrotmeterstart = 0;
    daikonmeterstart = 0;
  }if (daikonmeter >= pushtime){
    mode = "start";
    timer = 0;
    reset();
  }
  meterdraw(playeroffset);
}
