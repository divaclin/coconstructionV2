class Car{
      float x;
      float y;
      int dir;
      PImage img;
      float radians = 0;
      float r;
      float speed;
      Car(float x,float y,int dir,float speed){
         this.x = x;
         this.y = y;
         this.dir = dir;
         this.img = loadImage("car"+int(random(1,4))+".png");  
         this.r = 0;
         this.speed = speed;
      }
      Car(int dir,float r){
         this.x = 615;
         this.y = 450;
         this.r = r;
         this.dir = dir;
         this.img = loadImage("car"+int(random(1,4))+".png");  
         this.speed = 0;
      }
      void show(){
        switch(dir){
          case 1:
             imageMode(CENTER);
             pushMatrix();
             translate(this.x, this.y);
             rotate(radians(90-this.radians));
             image(this.img,0,0,53.25,26.25);
             popMatrix();   
             imageMode(CORNER);
             break;
          case 2:
             pushMatrix();
             translate(this.x-53.25/2,this.y-26.25/2);
             rotate(radians(90));
             image(this.img,0,0,53.25,26.25);
             popMatrix();
             break;
          case 3:
             pushMatrix();
             translate(this.x-53.25*2,this.y-26.25/2);
             rotate(radians(-90));
             image(this.img,0,0,53.25,26.25);
             popMatrix();             
             break;
          default:
             break;
        }
      }
      void move(){
        switch(dir){
          case 1:
             this.x = 610+this.r*cos(radians(this.radians));
             this.y = 450-this.r*sin(radians(this.radians));
             this.radians++;
             break;
          case 2:
             if(this.y < -300){
               this.y = height;
             }
             this.y-=5*this.speed;
             break;
          case 3:
             if(this.y > displayHeight+300){
                this.y = 0;
             }
             this.y+=5*this.speed;
             break;
          default:
             break;
        }
      }
}

void carSetup(){
     for(int i=0;i<carNum;i++){
       vehicle[i] = (i%3==0 ?new Car(1,105+25*(i/3+1)):new Car(displayWidth*0.78472,displayHeight,i%3+1,i%3+1));
     }
}
void carRun(){
     for(int i=0;i<carNum;i++){
       vehicle[i].move();
       vehicle[i].show();
     }
}
