<cfcomponent accessors="true">

	<!---
		Author: Adrian J. Moreno
		Site: http://iknowkungfoo.com
		Twitter: @iknowkungfoo
		Description: A custom JSON render object for ColdFusion queries.
		Repo: https://github.com/iknowkungfoo/ArrayCollection
		Blog post: http://cfml.us/Ce
	--->

	<cfproperty name="data" type="query" required="true" />
	<cfproperty name="contentType" type="string" required="true" />
	<cfproperty name="dataHandle" type="boolean" required="true" />
	<cfproperty name="dataKeys" type="boolean" required="true" />
	<cfproperty name="dataHandleName" type="string" required="true" />
	<cfproperty name="dataKeyCase" type="string" required="false" default="lower" />

    <cffunction name="init" access="public" output="false" returntype="ArrayCollection">
        <cfset setContentType("json") />
        <cfset setDataKeys(true) />
		<cfset setDataKeyCase("lower") />
        <cfset setDataHandle(true) />
        <cfset setDataHandleName("data") />
        <cfreturn this />
    </cffunction>

    <cffunction name="$renderdata" access="public" output="false" returntype="string" hint="">
		<cfset aData = [] />
		<cfset stData = {} />
        <cfif getDataKeys()>
			<cfset aData = queryToArrayOfStructs() />
        <cfelse>
			<cfset aData = queryToArrayOfArrays() />
        </cfif>
		<cfif getDataHandle()>
			<cfset stData[getDataHandleName()] = aData />
			<cfreturn serializeJSON(stData) />
		<cfelse>
			<cfreturn serializeJSON(aData) />
		</cfif>
    </cffunction>

    <cffunction name="queryToArrayOfStructs" access="private" output="false" returntype="array" hint="convert a query to an array of structs">
    	<cfset var q = getData() />
		<cfset var columnList = getColumnList() />
		<cfset var results = [] />
		<cfset var temp = {} />
		<cfset var col = "" />
		<cfloop query="q">
            <cfset temp = {} />
            <cfloop list="#columnList#" index="col">
                <cfset temp[col] = q[col][q.currentrow] />
            </cfloop>
            <cfset arrayAppend( results, temp ) />
        </cfloop>
		<cfreturn results />
    </cffunction>

    <cffunction name="queryToArrayOfArrays" access="private" output="false" returntype="array" hint="convert a query to an array of arrays">
    	<cfset var q = getData() />
		<cfset var columnList = getColumnList() />
		<cfset var results = [] />
		<cfset var temp = [] />
		<cfset var col = "" />
		<cfloop query="q">
            <cfset temp = [] />
            <cfloop list="#columnList#" index="col">
				<cfset arrayAppend( temp, q[col][q.currentrow] ) />
            </cfloop>
            <cfset arrayAppend( results, temp ) />
        </cfloop>
		<cfreturn results />
    </cffunction>

    <cffunction name="getColumnList" access="private" output="false" returntype="string">
		<cfset var columns = listSort( getData().columnlist, "textnocase" ) />
		<cfif getDataKeyCase() IS "lower">
			<cfreturn lcase( columns ) />
		<cfelse>
			<cfreturn ucase( columns ) />
		</cfif>
    </cffunction>

</cfcomponent>
