
void imageCenter(PImage img, float x, float y){
  imageMode(CENTER);
  image(img, x, y);
  imageMode(CORNER);
}

void backgrounddraw(float offset){
  image(background,width/2-background.width/2,height-background.height+offset);
  image(ground_back,width/2-ground_back.width/2,height/2+offset);
}

void goaldraw(int r, int g, int b, float h){
  fill(r,g,b);
  noStroke();
  rect(0,0,width,h);
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
  image(mountains_mask,width/2-mountains_mask.width/2-3,height/2+27);
  image(blender_empty,blendx,blendy);
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
  
  for (int i=0; i<11; i++){
    c [0] = colors[3]+(colors[0]-colors[3])*i/12; 
    c [1] = colors[4]+(colors[1]-colors[4])*i/12;
    c [2] = colors[5]+(colors[2]-colors[5])*i/12;
    fill(c[0],c[1],c[2]);
    if (i<5){
      //row 1
      x = centerx-order.width*2.5+order.width*i;
      y = centery-order.height*0.9+i/5*order.height;
    }else{
      //row 2
      x = centerx-order.width*3+order.width*(i-5);
      y = centery-order.height*0.9+order.height;
    }
    rect(x+50,y+50,cwidth,cheight);
    image(order,x,y);
    
    if (juice[0] == i){
      custx=x; custy=y;
    }
    if (scarrot == i){
      servx=x;servy=y;
    }
  }
  image(customer,custx-5,custy-145);
  image(server,servx-65,servy+125);
}

void timerdraw(float total){
  int size = 300;
  float x=width/2;
  float y=0;
  
  noStroke();
  fill(255);
  arc(x,y,size,size,0,PI,OPEN);
  
  fill(150);
  arc (x,y, size,size,0,((float)timer/total)*PI);
  
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