class Clock{
      int start;
      int end;
      int current;
      
      Clock(int delay){
        start=current=millis();
        end=delay;
      }
      boolean checkTimeout(){
        current=millis();
        if(current-start>=end){
          start=current;
          return true;
        }
        else{
          return false;
        }
      }     
};
