public class ParentData {
 public ChildData[] children;
    public String name;
    public String parent;
    public String url; 
    public String objectType; 
    public String relationshipName;
    public ParentData(String name,String parent,String url,String objectType,String relationshipName) {
        this.name = name;
        this.parent=parent;
        this.url=url;
        this.objectType=objectType; 
        this.relationshipName=relationshipName;
        children = new ChildData[0];
    }
}