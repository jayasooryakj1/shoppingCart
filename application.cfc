<cfcomponent>

    <cfset this.name = "shoppingCart">
    <cfset this.datasource = "shoppingCartDataSource">
    <cfset this.sessionmanagement="true">
    <cfset this.sessionTimeout=CreateTimeSpan(0,0,45,0)>
    <cfset this.applicationTimeout=createTimespan(0,0,45, 0)>

    <cffunction  name="onApplicationStart" returntype="boolean">
        <cfset application.adminObject = createObject("component","admin.components.adminComponent")>
        <cfset application.userObject = createObject("component", "components.user")>
        <cfreturn true>
    </cffunction>

   <cffunction  name="onRequestStart" returntype="boolean">
        <cfargument  name="requestedPage">
        <cfset local.publicPages = ["/admin/adminLogin.cfm", "/admin/errorPage.cfm"]>
        <cfset local.publicUserPages = ["/index.cfm", "/userCategoryPage.cfm", "/userSubCategoryPage.cfm", "/productPage.cfm", "/components/user.cfc", "/userSignUp.cfm", "/userLogin.cfm"]>
        
            <cfif listFirst(cgi.SCRIPT_NAME, '/') EQ "admin">
                <cfif NOT arrayFind(local.publicPages,arguments.requestedPage) AND NOT structKeyExists(session, "adminId")>
                    <cflocation  url="../admin/adminLogin.cfm">
                </cfif>
            <cfelse>
                <cfif NOT arrayFind(local.publicUserPages,arguments.requestedPage) AND NOT structKeyExists(session, "userId")>
                    <cflocation  url="./userLogin.cfm">
                </cfif>
            </cfif>
        <cfif structKeyExists(url, "reload") AND url.reload EQ true>
            <cfset  onApplicationStart()>
        </cfif>
        <cfreturn true>
    </cffunction>

    <!---<cffunction  name="onMissingTemplate" returntype="boolean">
        <cfinclude  template="admin/errorPage.cfm">
        <cfreturn true>
    </cffunction>--->

    
    <!---<cffunction name="onError" returnType="void">
        <cfargument name="Exception" required=true/>
        <cfargument name="EventName" type="String" required=true/>
        <cfmail  from="jayasoorya@gmail.com"  subject="Error"  to="abc@gmail.com">
            Error Occured
            Error event: #arguments.eventName#
            Error message: #arguments.exception.message#
            Error line: #arguments.exception.tagcontext[1].line#
            Error raw_trace: #arguments.exception.tagcontext[1].raw_trace#
        </cfmail>
        <cflocation  url="./admin/errorPage.cfm">
    </cffunction>--->

</cfcomponent>