<cfcomponent>

	<!---
		Author: Adrian J. Moreno
		Site: http://iknowkungfoo.com
		Twitter: @iknowkungfoo
		Description: A custom JSON render object for ColdFusion queries.
		Repo: https://github.com/iknowkungfoo/ArrayCollection
		Blog post: http://cfml.us/Ce
	--->

    <cffunction name="init" access="public" output="false" returntype="ArrayCollection">
        <cfset setContentType("json") />
        <cfset setDataHandle(true) />
        <cfset setDataHandleName("data") />
        <cfreturn this />
    </cffunction>

    <cffunction name="$renderdata" access="public" output="false" returntype="string" hint="convert a query to an array of structs">
        <cfset var rs = {} />
        <cfset rs.q = variables.data />
        <cfset rs.results = [] />
        <cfset rs.columnList = lcase(listSort(rs.q.columnlist, "text" )) />
        <cfloop query="rs.q">
            <cfset rs.temp = {} />
            <cfloop list="#rs.columnList#" index="rs.col">
                <cfset rs.temp[rs.col] = rs.q[rs.col][rs.q.currentrow] />
            </cfloop>
            <cfset arrayAppend( rs.results, rs.temp ) />
        </cfloop>
        <cfset rs.data = {} />
        <cfif hasDataHandle()>
            <cfset rs.data[getDataHandleName()] = rs.results />
        <cfelse>
            <cfset rs.data = rs.results />
        </cfif>
        <cfreturn serializeJSON(rs.data) />
    </cffunction>

    <cffunction name="setData" access="public" output="false" returntype="void">
        <cfargument name="data" type="query" required="true">
        <cfset variables.data = arguments.data />
    </cffunction>

    <cffunction name="setContentType" access="private" output="false" returntype="void">
        <cfargument name="contenttype" type="string" required="true" />
        <cfset variables.contentType = arguments.contentType />
    </cffunction>
    <cffunction name="getContentType" access="public" output="false" returntype="string">
        <cfreturn variables.contentType />
    </cffunction>

    <cffunction name="setDataHandle" access="public" output="false" returntype="void">
        <cfargument name="datahandle" type="boolean" required="true" />
        <cfset variables.dataHandle = arguments.datahandle />

    </cffunction>
    <cffunction name="hasDataHandle" access="public" output="false" returntype="boolean">
        <cfreturn variables.dataHandle />
    </cffunction>

    <cffunction name="setDataHandleName" access="public" output="false" returntype="void">
        <cfargument name="dataHandleName" type="string" required="true" />
        <cfset variables.dataHandleName = arguments.dataHandleName />
    </cffunction>
    <cffunction name="getDataHandleName" access="public" output="false" returntype="string">
        <cfreturn variables.dataHandleName />
    </cffunction>

</cfcomponent>