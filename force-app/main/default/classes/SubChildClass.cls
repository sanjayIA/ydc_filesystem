public with sharing class SubChildClass {
    public SuperSubChild[] children;
    public String name;
    public String parent;
    public String url;   
    public String objectType ;
    public SubChildClass(String name,String parent,String url,String objectType) {
    this.name = name;
    this.parent=parent;
    this.url=url;
    this.objectType=objectType;
    children = new SuperSubChild[0];
    }
}