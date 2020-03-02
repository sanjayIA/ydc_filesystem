public class TableauSyncAPINew {  
    public String token{get;set;}
    public String JSONResponse{get;set;}
    public static string TokenAPI(){
        string token;        
        Http http = new Http();
        HttpRequest request = new HttpRequest();
        request.setEndpoint('https://prod-useast-a.online.tableau.com/api/3.6/auth/signin');
        request.setMethod('POST');
        request.setHeader('Content-Type', 'application/json;charset=UTF-8');
        request.setHeader('Accept', 'application/json;charset=UTF-8');
        String body='{ "credentials": { "name": "yraghavendra@information-asset.com","password": "Redcar88!","site": {"contentUrl": "raghu"}}}';
        request.setBody(body);
        HttpResponse response = http.send(request);
        // Parse the JSON response
        if (response.getStatusCode() != 200) {
            System.debug('The status code returned was not expected: ' +
                         response.getStatusCode() + ' ' + response.getStatus());
        } else {
            System.debug(response.getBody());
            Map<String, Object> result = (Map<String, Object>) JSON.deserializeUntyped(response.getBody());
            Map<String, Object> tokenMap = (Map<String, Object>) result.get('credentials');
            token= (String) tokenMap.get('token');
            //system.debug('X-Tableau-Auth-Token: '+token);
            
        }
        return token;
    }

    public  static void tableauQueryAPI(){
        String tableUGraphqlQuery='"{tableauSites {name uri id workbooks {id name projectName description createdAt updatedAt projectVizportalUrlId site {id name } owner {id name username email}sheets {id name  path createdAt updatedAt sheetFieldInstances { id name description __typename referencedByCalculations { id name formula description dataType } upstreamColumns { id name description upstreamTables { id name description database { id name description } }} }} } }}"';
        Http http = new Http();
        HttpRequest request = new HttpRequest();
        request.setEndpoint('https://prod-useast-a.online.tableau.com/api/metadata/graphql');
        request.setMethod('POST');
        request.setHeader('Content-Type', 'application/json;charset=UTF-8');
        request.setHeader('Accept', 'application/json;charset=UTF-8');
        request.setHeader('X-Tableau-Auth', TokenAPI());
        String body='{"query":'+ tableUGraphqlQuery+'}';
        request.setBody(body);
        HttpResponse response = http.send(request);
        // Parse the JSON response
        if (response.getStatusCode() != 200) {
            System.debug('The status code returned was not expected: ' +
                         response.getStatusCode() + ' ' + response.getStatus());
        } else {
            System.debug(response.getBody());
         //   JSONResponse = response.getBody();
       JSONParser parser = JSON.createParser(response.getBody());
        while (parser.nextToken() != null) {
            // Start at the array of workbooks.
           // if (parser.getCurrentToken() == JSONToken.START_ARRAY) {{
            if(parser.getCurrentToken()==JSONToken.FIELD_NAME && parser.getCurrentName()=='workbooks'){
                while (parser.nextToken() != null) {
                    // Advance to the start object marker to
                              if (parser.getCurrentToken() == JSONToken.START_OBJECT) {
                        // Read entire workbook object.
                        workbook wb = (workbook)parser.readValueAs(workbook.class);
                        system.debug('WB.Id: ' + wb.id);
                        system.debug('WB.name: ' + wb.name);
                        system.debug('Sites: ' + wb.site);
                        system.debug('Owner: ' + wb.owner);
                        system.debug('Size of sheets: ' + wb.sheets.size());
                        for(sheet eachsheet:wb.sheets){
                            system.debug('eachsheet value: ' + eachsheet);
                            system.debug('eachsheet path: ' + eachsheet.path);
                        }
                        // For debugging purposes, serialize again to verify what was parsed.
                        String s = JSON.serialize(wb);
                        system.debug('Serialized workbook instance: ' + s);
    
                        // Skip the child start array and start object markers.
                        //parser.skipChildren();
                    }
                }
            } 
        }          
    } 
}
// Inner classes used for serialization by readValuesAs(). 

public class workbook {
    public string id;
    public string  name;
    public string  description;
    public string projectName;
    List<sheet> sheets;
    site site;
    owner owner;
    
    
    public workbook(string id, string  name,string  description, string projectName,list<sheet>sheetList,site site,owner owner) {
        id = id;
        name = name;
        description = description;
        projectName = projectName;
        sheets = sheetList.clone();
        site = site;
        owner=owner;
    }
}  
public class sheet {
    public string id;
    public string  name;
    public string  description;
     public string  path;
}
 public class site {
    public string id;
    public string  name;
} 
    public class owner {
    public string id;
    public string  name;
        public string  username;
        public string  email;
} 
}