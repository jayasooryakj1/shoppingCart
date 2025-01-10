<cfcomponent>

    <!--- ADMIN LOGIN --->
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
                AND fldRoleId = 1
                AND fldActive = 1
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

    <!--- LOGOUT --->
    <cffunction  name="logoutFunction" access="remote">
        <cfset structClear(session)>
        <cfreturn true>
    </cffunction>

    <!--- CATEGORY FUNCTIONS--->

    <!--- ADD CATEGORY --->
    <cffunction  name="addCategory">
        <cfargument  name="categoryName">
        <cfset local.categoryExistance = checkCategoryExistance(
            categoryName = arguments.categoryName
        )>
        <cfif NOT local.categoryExistance>
            <cfquery name="local.addCategory">
                INSERT INTO tblcategory (
                    fldCategoryName,
                    fldCreatedBy
                )
                VALUES(
                    <cfqueryparam value='#arguments.categoryName#' cfsqltype="VARCHAR">,
                    <cfqueryparam value='#session.userId#' cfsqltype="VARCHAR">
                )
            </cfquery>
        </cfif>
        <cfreturn local.categoryExistance>
    </cffunction>

    <!--- DISPLAY CATEGORIES --->
    <cffunction  name="dipslayCategories">
        <cfquery name="local.displayCategories">
            SELECT 
                fldCategory_ID,
                fldCategoryName
            FROM
                tblCategory
            WHERE
                fldActive = 1
        </cfquery>
        <cfreturn local.displayCategories>
    </cffunction>

    <!--- AUTO POPULATE CATEGORY--->
    <cffunction  name="autoPopulateCategory" access="remote" returnformat="plain">
        <cfargument  name="editCategoryId">
        <cfquery name="local.selectCategoryName">
            SELECT
                fldCategoryName
            FROM
                tblCategory
            WHERE
                fldCategory_ID = <cfqueryparam value=#arguments.editCategoryId# cfsqltype="INTEGER">
        </cfquery>
        <cfreturn local.selectCategoryName.fldCategoryName>
    </cffunction>

    <!--- CHECK IF CATEGORY EXISTS --->
    <cffunction  name="checkCategoryExistance">
        <cfargument  name="categoryName">
        <cfquery name="local.checkCategory">
            SELECT
                fldCategoryName
            FROM
                tblCategory
            WHERE
                fldCategoryName = <cfqueryparam value="#arguments.categoryName#" cfsqltype="VARCHAR">
                AND fldActive = 1
        </cfquery>
        <cfif queryRecordCount(local.checkCategory)>
            <cfreturn true>
        <cfelse>
            <cfreturn false>
        </cfif>
    </cffunction>

    <!--- EDIT CATEGORY --->
    <cffunction  name="editCategory">
        <cfargument  name="categoryName">
        <cfargument  name="categoryId">
        <cfset local.categoryExistance = checkCategoryExistance(
            categoryName = arguments.categoryName
        )>
        <cfif NOT local.categoryExistance>
            <cfquery name="local.editCategoryName">
                UPDATE
                    tblCategory
                SET
                    fldCategoryName = <cfqueryparam value="#arguments.categoryName#" cfsqltype="VARCHAR">,
                    fldUpdatedBy = <cfqueryparam value="#session.userId#" cfsqltype="VARCHAR">
                WHERE
                    fldCategory_ID = <cfqueryparam value="#arguments.categoryId#" cfsqltype="INTEGER">
            </cfquery>
        </cfif>
        <cfreturn local.categoryExistance>
    </cffunction>

    <!--- DELETE CATEGORY --->
    <cffunction  name="deleteCategory" access="remote">
        <cfargument  name="deleteCategoryId">
        <cfquery name="deleteCategory">
            UPDATE
                tblCategory
            SET
                fldActive = 0
            WHERE
                fldCategory_ID = <cfqueryparam value="#arguments.deleteCategoryId#" cfsqltype="VARCHAR">
        </cfquery>
    </cffunction>

</cfcomponent>