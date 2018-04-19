
void imageCenter(PImage img, float x, float y){
  imageMode(CENTER);
  image(img, x, y);
  imageMode(CORNER);
}

void backgrounddraw(float offset){
  image(background,width/2-background.width/2,height-background.height+offset);
  image(ground_back,width/2-ground_back.width/2,height/2+offset);
  
  for( int i = 0; i < myClouds.length; i++){
    myClouds[i].draw();
  }
}

//showing input detection
void meterdraw(float offset){
  int x = width/2-250;
  int y = height/2+100+(int)offset;
  int w = 500;
  int h = 50;
  //background color
  fill(#e6bea8);
  noStroke();
  rect(x,y,w,h);
  
  //fillings
  fill(colors[0],colors[1],colors[2]);
  rect(x,y,(w/2)*carrotmeter/pushtime,h);
  fill(colors[3],colors[4],colors[5]);
  rect(x+w,y,-1*(w/2)*daikonmeter/pushtime,h);
  
  if (carrotmeter/pushtime == 1){
    textFont(fonts, 30);
    fill(0);
    textAlign(RIGHT,CENTER);
    text("Ready!",x+w/2-15,y+h/2);
  }
  if (daikonmeter/pushtime == 1){
    textFont(fonts, 30);
    fill(0);
    textAlign(LEFT,CENTER);
    text("Ready!",x+w/2+15,y+h/2);
  }
  
  //lines
  noFill();
  strokeWeight(5);
  stroke(0);
  rect(x,y,w,h);
  line(x+w/2,y,width/2,y+h);
  
  if (mode == "end"){
    textFont(fontk, 30);
    fill(0);
    textSize(40);
    textAlign(LEFT,TOP);
    text("Replay",x,y+h*1.3);
    textAlign(RIGHT,TOP);
    text("Quit",x+w,y+h*1.3);
  }
}

//for juices you finished
void bottledraw(int offset){
  for (int i=0; i<numJuices; i++){
    tint(doneJuices.get(i).x,doneJuices.get(i).y,doneJuices.get(i).z);
    image(bottle,width/2-300+bottle.width*1.5*(i%6),
          height-150 - bottle.height*(floor(i/6)) - offset);
  }
  tint(255);
}

void goaldraw(int r, int g, int b){
  fill(r,g,b);
  noStroke();
  int x = width/2-700;
  int y = 200;
  rect(x+50,y+50,150,175);
  image(order,x,y);
  image(customer,x-15,y-158);
}

void progress(){
  noStroke();
  
  float total = score[0]+score[1];
  float h = (float)(blender.height-70)/total;
  fill(255);
  rect(blendx,blendy,blender.width-50,blender.height-70);
  fill(colors[0],colors[1],colors[2]);
  for(int i=0; i<total; i++){
    if (i>=score[0]){
      fill(colors[3],colors[4],colors[5]);
    }
    rect(blendx,blendy+i*h,blender.width-50,h);
  }
  tint(#f2ffe2);
  image(blender_mask,blendx,blendy-5);
  tint(255);
  image(blender_empty,blendx,blendy);
  
  textAlign(CENTER,CENTER);
  textFont(fonts,70);
  fill(0);
  float scarrot = ((float)score[0]/(float)(score[0]+score[1]))*10;
  if (scarrot > juice[0]){
    textLeading(60);
    text("Too much\ncarrot!",width*0.275,height*0.5);
  }else if (scarrot < juice[0]){
    textLeading(60);
    text("Too much\ndaikon!",width*0.725,height*0.5);
  }
}

void result(){
  float centerx = width/2;
  float centery = height/3+50;
  float cwidth = 150;
  float cheight = 175;
  float c[] = new float[3];
  c[0] = 0; c[1] = 0; c[2] = 0;
  noStroke();
  float x=0,y=0;
  float custx=0,custy=0;
  float servx=0,servy=0;
  
  int scarrot = round(((float)score[0]/(float)(score[0]+score[1]))*10);
  
  String resulttext = "Perfect juice!";
  if (scarrot>juice[0]){
    resulttext = "Too much carrot!";
  }if (scarrot < juice[0]){
    resulttext = "Too much daikon!";
  }
  
  float xalong = centerx-order.width*3.1;
  y = centery-order.height*0.5;
  for (int i=0; i<11; i++){
    boolean unused = true;
    c [0] = colors[3]+(colors[0]-colors[3])*i/12; 
    c [1] = colors[4]+(colors[1]-colors[4])*i/12;
    c [2] = colors[5]+(colors[2]-colors[5])*i/12;
    fill(c[0],c[1],c[2]);
    
    
    x = xalong+ordersmall.width;
    
    if (i==0){
      x = xalong;
    }else if (juice[0] == (i-1) || scarrot == (i-1)){
      x = xalong + order.width;
    }
    
    xalong = x;
    
    if (juice[0] == i){
      custx=x; custy=y;
      unused = false;
    }
    if (scarrot == i){
      servx=x;servy=y;
      unused = false;
    }
    if (unused){
      rect(x+25,y+75,70,80);
      tint(215);
      image(ordersmall,x,y+50);
    }else{
      rect(x+50,y+50,cwidth,cheight);
      tint(255);
      image(order,x,y);
    }
    
    tint(255);
  }
  image(customer,custx-5,custy-145);
  image(server,servx-65,servy+125);
  
  textFont(fonts, 80);
  textAlign(CENTER,TOP);
  fill(0);
  text(resulttext,width/2,50);
}

void timerdraw(float total){
  int size = 500;
  float x=width/2;
  float y=0;
  
  noStroke();
  fill(255);
  arc(x,y,size,size,0,PI,OPEN);
  
  float left = (float)timer/total;
  
  if (left > 0.9){
    fill(255,150,150);
  }else if (left > 0.7){
    fill(255,222,50);
  }else{
    fill(175);
  }
  arc (x,y, size,size,0,left*PI);
  
  noFill();
  stroke(0);
  strokeWeight(5);
  arc(x,y,size,size,0,PI,OPEN);
  
  float angle = TWO_PI/20;
  stroke(0);
  for (int i=0; i<11; i++){
    //circumference...
    line(size/2*sin(angle*i-PI/2)+x,size/2*cos(angle*i-PI/2)+y,
        size/2*0.9f*sin(angle*i-PI/2)+x,size/2*0.9f*cos(angle*i-PI/2)+y);
  }
}

void playerdraw(float offset){
  float xscale = squatter[0].width;
  float yscale = squatter[1].height;
  float h = height-yscale-50 +offset;
  image(squatter[1], width/2+350, (int)h);
  image(squatter[0], width/2-xscale-350, (int)h);
  image(ground_front,width/2-ground_front.width/2,height/2+offset);
}

void carrotdraw(){
  float x = -100;
  float y = -100;
  float x0 = 150;
  float y0 = 100;
  float h = 250;
  float k = 25;
  if (carrotstate > -1){
    x = 150 + (350-150)*carrotstate;
    y = (y0-k)/((x0-h)*(x0-h)) * (x-h)*(x-h) + k;
    
    x = width/2-350+200*carrotstate;
    
    //QUICK FIXXXXXXXXXXXXXXXXXXX
    y = y+150;
  }
  image(carrot,x,y);
}

void daikondraw(){
  float x = -100;
  float y = -100;
  float x0 = width-150 - daikon.width;
  float y0 = 100;
  float h = width-250 - daikon.width;
  float k = 25;
  if (daikonstate > -1){
    x = width - daikon.width - 150 - (350-150)*daikonstate;
    y = (y0-k)/((x0-h)*(x0-h)) * (x-h)*(x-h) + k;
    
    x = width/2+350-200*daikonstate-100;
    
    //QUICK FIXXXXXXXXXXXXXXXXXXX
    y = y+150;
  }
  image(daikon,x,y);
}
