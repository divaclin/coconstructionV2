TuioObject getSelectObj(){
      int selectedNum = findSelect();
      TuioObject selected = current; 
      for(TuioObject obj : tuioObjectList){
         if(obj.getSymbolID()==selectedNum){
            selected = obj;
            break;
         }  
      }
      return selected;
}
int findSelect(){
    if(tuioObjectList.size()<TuioObjStatus.size()){
       ArrayList<Integer> List   = new ArrayList<Integer>();
       ArrayList<Integer> Status = new ArrayList<Integer>();
               
       for(int i=0;i<tuioObjectList.size();i++){
           List.add(tuioObjectList.get(i).getSymbolID());
       }
       for(Map.Entry me : TuioObjStatus.entrySet()){
           Status.add((Integer)me.getKey());
       }
       Status.removeAll(List);
       clearSelect();
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
      

