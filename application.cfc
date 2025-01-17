<cfcomponent>

    <cfset this.datasource = "shoppingCartDataSource">
    <cfset this.sessionmanagement="true">

    <cffunction  name="onApplicationStart" returntype="boolean">
        <cfset application.adminObject = createObject("component","admin.components.adminComponent")>
        <cfset application.userObject = createObject("component", "components.user")>
        <cfreturn true>
    </cffunction>

   <cffunction  name="onRequestStart" returntype="boolean">
        <cfargument  name="requestedPage">
        <cfset local.publicPages = ["/admin/adminLogin.cfm", "/userSignUp.cfm", "/userLogin.cfm", "/admin/errorPage.cfm", "/index.cfm"]>
        <cfif NOT arrayFind(local.publicPages,arguments.requestedPage) AND NOT structKeyExists(session, "userId")>
            <cfif listFirst(cgi.SCRIPT_NAME, '/') EQ "admin">
                <cflocation  url="../admin/adminLogin.cfm">
            <cfelse>
                <cflocation  url="./userLogin.cfm">
            </cfif>
        </cfif>
        <cfif structKeyExists(url, "reload") AND url.reload EQ true>
            <cfset  onApplicationStart()>

        </cfif>
        <cfreturn true>
    </cffunction>

    <cffunction  name="onMissingTemplate" returntype="boolean">
        <cfinclude  template="admin/errorPage.cfm">
        <cfreturn true>
    </cffunction>

    
    <!---<cffunction name="onError" returnType="void">
        <cfargument name="Exception" required=true/>
        <cfargument name="EventName" type="String" required=true/>
        <cfmail  from="jayasoorya@gmail.com"  subject="Error"  to="abc@gmail.com">
            Error Occured
            Error event: #arguments.eventName#
            Error details: #arguments.exception#
        </cfmail>
        <cflocation  url="./admin/errorPage.cfm">
    </cffunction>--->

</cfcomponent>