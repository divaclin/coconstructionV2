class TuioInfo{
      int maxID = 80; 
      String IP = "";
      HashMap<Integer,String> TuioObjStatus;
      Clock init,select;
      
      TuioInfo(){
        TuioObjStatus = new HashMap<Integer,String>();
        init   = new Clock(7000);
        select = new Clock(500);
      }
      boolean init(){
          printText("initializing..."+init.current);
          if(!init.checkTimeout()){
             for(int i=0;i<tuioObjectList.size();i++){
                 TuioObject tobj = tuioObjectList.get(i);
                 if(this.TuioObjStatus.get(tobj.getSymbolID())==null && tobj.getSymbolID()<=maxID){
                    this.TuioObjStatus.put(tobj.getSymbolID(),"INIT");
                 }
              }
              return false;
          }
          else{
             printText("initialize completely");
             return true;
          }
      }
      int findSelect(){
           if(tuioObjectList.size()<TuioObjStatus.size() && select.checkTimeout()){
               ArrayList<Integer> List   = new ArrayList<Integer>();
               ArrayList<Integer> Status = new ArrayList<Integer>();
               
               for(int i=0;i<tuioObjectList.size();i++){
                   List.add(tuioObjectList.get(i).getSymbolID());
               }
               for(Map.Entry me : TuioObjStatus.entrySet()){
                   Status.add((Integer)me.getKey());
               }
               Status.removeAll(List);
               this.clearSelect();
               TuioObjStatus.put(Status.get(0),"SELECT");
               println(TuioObjStatus);               
               printText("obj ID:"+Status.get(0));
               return Status.get(0);
           }
           else{
               return -1;
           }
      }
      void clearSelect(){
          for(Map.Entry me : TuioObjStatus.entrySet()){
             TuioObjStatus.put((Integer)me.getKey(),"CHECKED");  
          }
     }     
      
};
