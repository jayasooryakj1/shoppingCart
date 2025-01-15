<cfcomponent>

    <cfset this.datasource = "shoppingCartDataSource">
    <cfset this.sessionmanagement="true">

   <cffunction  name="onRequestStart">
        <cfargument  name="requestedPage">
        <cfset local.publicPages = ["/admin/adminLogin.cfm", "/userSignUp.cfm"]>
        <cfif NOT arrayFind(local.publicPages,arguments.requestedPage) AND NOT structKeyExists(session, "userId")>
            <cflocation  url="../admin/adminLogin.cfm">
        </cfif>
    </cffunction>

    <cffunction  name="onMissingTemplate">
        <cfinclude  template="admin/errorPage.cfm">
    </cffunction>

</cfcomponent>