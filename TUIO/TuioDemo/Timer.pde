String strArr2str(String[] strArr){
       String str = "";
       for(int i=0;i<strArr.length;i++){
         str += strArr[i];
       }
       return str;
} 
class init extends TimerTask{
      void run(){
         if(EXECUTE_TIME <= initTime*1000 && stat == INIT){
            for(int i=0;i<tuioObjectList.size();i++){
                TuioObject tobj = tuioObjectList.get(i);
                if(TuioObjStatus.get(tobj.getSymbolID())==null && tobj.getSymbolID()<=maxID){
                   TuioObjStatus.put(tobj.getSymbolID(),"INIT");
                }
            }
          }
          else{
             stat = PROCESS;
             this.cancel();
          }   
      }
}
class idle extends TimerTask{
      void run(){
         if(stat != INIT){
            IDLE=loadStrings(url+"/idle")[0].contains("1");
            startLine();
            println("idle    = "+IDLE);
            
         }
      }
}
class like extends TimerTask{
      void run(){
         if(stat != INIT){
            LIKE = !(loadStrings(url+"/like")[0].charAt(0)=='0');
            if(LIKE){
               current = Integer.parseInt(loadStrings(url+"/like")[0]);
            }
            println("like    = "+LIKE);
         }
      }
}

class dislike extends TimerTask{
      void run(){
        if(stat != INIT){
           DISLIKE = !(loadStrings(url+"/dislike")[0].charAt(0)=='0');
           if(DISLIKE){
              current = Integer.parseInt(loadStrings(url+"/dislike")[0]);
           }
           println("dislike = "+DISLIKE);
        }
      }
}
class comment extends TimerTask{
      void run(){
         if(stat != INIT){
            COMMENT=loadStrings(url+"/comment")[0].contains("1");
            println("comment = "+COMMENT);
            stopLine();
         }
      }
}
class runTime extends TimerTask{
      void run(){
         EXECUTE_TIME +=unitTime;
      }
}
class thermodynamic extends TimerTask{
      void run(){
        heat = loadJSONArray(url+"/thermodynamic");
      }
}

void stopLine(){
     String tmp = "";
     for(int i =1;updateCounter/i>0;i*=10){
         tmp+="-";
     }
     println("--------------------------------------"+tmp);
}
void startLine(){
     println("----------------"+updateCounter+++" times----------------");
}

