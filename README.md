ArrayCollection
===============

A custom JSON render object for ColdFusion queries

Details at blog post:

http://iknowkungfoo.com/blog/index.cfm/2012/5/11/ArrayCollectioncfc-a-custom-JSON-renderer-for-ColdFusion-queries

**Simple example**

```
<cffunction name="books" access="remote" output="false" returntype="string">
    <cfargument name="term" type="string" required="true" />
    <cfset var rs = {} />
    <cfquery name="rs.q" datasource="cfbookclub">
        SELECT DISTINCT
            bookid,
            title,
            genre
        FROM
            books
        WHERE
            title LIKE <cfqueryparam value="%#arguments.term#%" cfsqltype="cf_sql_varchar" />
        ORDER BY
            genre, title
    </cfquery>
    <cfset rs.ac = createObject("component", "ArrayCollection").init() />
    <cfset rs.ac.setData( rs.q ) />
    <cfreturn rs.ac.$renderdata() />
</cffunction>

<cfdump var="#books('Man')# />
```

**Output**
```
{    
    "data":[
        {
    		"bookid":8,
			"genre":"Fiction",
			"title":"Apparition Man"
		},
        {
			"bookid":2,
			"genre":"Non-fiction",
			"title":"Shopping Mart Mania"
		}
    ]
}
```