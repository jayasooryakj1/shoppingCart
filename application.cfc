<cfcomponent>

    <cfset this.datasource = "shoppingCartDataSource">
    <cfset this.sessionmanagement="true">

    <cffunction  name="onRequestStart">
        <cfargument  name="requestedPage">
        <cfset local.publicPages = ["/shoppingCart/admin/adminLogin.cfm"]>
        <cfif NOT arrayFind(local.publicPages,arguments.requestedpage) AND NOT structKeyExists(session, "userId")>
            <cflocation  url="/shoppingCart/admin/adminLogin.cfm">
        </cfif>
    </cffunction>

</cfcomponent>