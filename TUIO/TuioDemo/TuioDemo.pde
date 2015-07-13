import java.util.Map;
import TUIO.*;
TuioProcessing tuioClient;

final int INIT    = 1;
final int PROCESS = 2;

int stat;

ArrayList<TuioObject> tuioObjectList;
TuioInfo info = new TuioInfo(); 
Clock test = new Clock(3000);
int testI=0;

// these are some helper variables which are used
// to create scalable graphical feedback
float cursor_size = 15;
float object_size = 60;
float table_size = 760;
float scale_factor = 1;
PFont font;

boolean verbose = false; // print console debug messages
boolean callback = true; // updates only after callbacks

float obj_size = object_size*scale_factor; 
float cur_size = cursor_size*scale_factor; 
void setup()
{
  // GUI setup
  noCursor();
  size(displayWidth,displayHeight);
  noStroke();
  fill(0);
  
  // periodic updates
  if (!callback) {
    frameRate(60); //<>//
    loop();
  } else noLoop(); // or callback updates 
  
  font = createFont("Arial", 18);
  scale_factor = height/table_size;

  tuioClient  = new TuioProcessing(this);
  
  stat = INIT;
}

void draw(){
  if(test.checkTimeout()){
    println(loadStrings("http://divaclin.github.io/coconstructionV2/TUIO/action.html?behavior=select&x=1&y=1&bid="+testI++));
  }
  background(0);
  textFont(font,18*scale_factor);
  tuioObjectList = tuioClient.getTuioObjectList();
  switch(stat){
    case INIT:
      stat=(info.init()==true?PROCESS:INIT);
      break;
    case PROCESS:
      int selectedNum = info.findSelect();
      TuioObject selected = null; 
      for(TuioObject obj : tuioObjectList){
         if(obj.getSymbolID()==selectedNum){
            selected = obj;
            break;
         }  
      }
      if(selected!=null){
      
      }
      break;
    default:
      break;
  }  
   //showTuioObj();
   //showTuioCursor();
   //showTuioBlob();
}

void printText(String str){
     background(0);
     fill(255,255,255);
     textSize(50);
     text(str,(width-textWidth(str))/2,height/2);
}

