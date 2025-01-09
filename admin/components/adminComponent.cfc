<cfcomponent>

    <cffunction  name="adminLogin">
        <cfargument  name="adminUserName">
        <cfargument  name="adminPassword">
        <cfquery name="local.check">
            SELECT
                fldUser_ID,
                fldUserSaltString,
                fldHashedPassword,
                fldActive
            FROM
                tblUser
            WHERE
                (fldEmail = <cfqueryparam value='#arguments.adminUserName#' cfsqltype="VARCHAR">
                OR fldPhone = <cfqueryparam value='#arguments.adminUserName#' cfsqltype="VARCHAR">)
                AND fldRoleId = <cfqueryparam value=1 cfsqltype="NUMERIC">
                AND fldActive = <cfqueryparam value=1 cfsqltype="NUMERIC">
        </cfquery>
        <cfif queryRecordCount(local.check)>
            <cfset local.hashedInputPassword = Hash(arguments.adminPassword & local.check.fldUserSaltString, 'SHA-512', 'utf-8', 125)>
            <cfif local.hashedInputPassword EQ local.check.fldHashedPassword>
                <cfset local.result = "true">
                <cfset session.userId = local.check.fldUser_ID>
            <cfelse>
                <cfset local.result = "Incorrect User name or password">
            </cfif>
        <cfelse>
            <cfset local.result = "Incorrect User name or password">
        </cfif>
        <cfreturn local.result>
    </cffunction>

    <cffunction  name="logoutFunction" access="remote">
        <cfset structClear(session)>
        <cfreturn true>
    </cffunction>

</cfcomponent>