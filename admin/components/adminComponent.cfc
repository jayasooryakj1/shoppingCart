<cfcomponent>

    <!--- ADMIN LOGIN --->
    <cffunction  name="adminLogin">
        <cfargument  name="adminUserName" required="true">
        <cfargument  name="adminPassword" required="true">
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
        <cfargument  name="categoryName" required="true">
        <cfset local.categoryExistence = checkCategoryExistence(
            categoryName = arguments.categoryName
        )>
        <cfif NOT local.categoryExistence>
            <cfquery name="local.addCategory">
                INSERT INTO tblcategory (
                    fldCategoryName,
                    fldCreatedBy
                )
                VALUES (
                    <cfqueryparam value='#arguments.categoryName#' cfsqltype="VARCHAR">,
                    <cfqueryparam value='#session.userId#' cfsqltype="VARCHAR">
                )
            </cfquery>
        </cfif>
        <cfreturn local.categoryExistence>
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
        <cfargument  name="editCategoryId" required="true">
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
    <cffunction  name="checkCategoryExistence">
        <cfargument  name="categoryName" required="true">
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
        <cfargument  name="categoryName" required="true">
        <cfargument  name="categoryId" required="true">
        <cfset local.categoryExistence = checkCategoryExistence(
            categoryName = arguments.categoryName
        )>
        <cfif NOT local.categoryExistence>
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
        <cfreturn local.categoryExistence>
    </cffunction>

    <!--- DELETE CATEGORY --->
    <cffunction  name="deleteCategory" access="remote">
        <cfargument  name="deleteCategoryId" required="true">
        <cfquery name="local.deleteCategory">
            UPDATE
                tblCategory
            SET
                fldActive = 0
            WHERE
                fldCategory_ID = <cfqueryparam value="#arguments.deleteCategoryId#" cfsqltype="VARCHAR">
        </cfquery>
    </cffunction>


    <!--- SUB CATEGORY FUNCTIONS --->

    <!--- SUB CATEGORY DISPLAY --->
    <cffunction  name="displaySubCategories">
        <cfargument  name="categoryId" required="true">
        <cfquery name="local.displaySubCategories">
            SELECT 
                fldSubCategory_ID,
                fldSubCategoryName
            FROM
                tblSubCategory
            WHERE
                fldCategoryId = <cfqueryparam value="#arguments.categoryId#" cfsqltype="NUMERIC">
                AND fldActive = 1
        </cfquery>
        <cfreturn local.displaySubCategories>
    </cffunction>

    <!--- CHECK IF SUB CATEGORY EXISTS --->
    <cffunction  name="checkSubCategoryExistence">
        <cfargument  name="subCategoryName" required="true">
        <cfargument  name="categoryId" required="true">
        <cfquery name="local.checkSubCategoryExistence">
            SELECT
                fldSubCategoryName
            FROM
                tblSubCategory
            WHERE
                fldSubCategoryName = <cfqueryparam value="#arguments.subCategoryName#" cfsqltype="VARCHAR">
                AND fldCategoryId = <cfqueryparam value="#arguments.categoryId#" cfsqltype="NUMERIC">
                AND fldActive = 1
        </cfquery>
        <cfif queryRecordCount(local.checkSubCategoryExistence)>
            <cfreturn true>
        <cfelse>
            <cfreturn false>
        </cfif>
    </cffunction>

    <!--- AUTO POPULATE CATEGORY IN MODAL --->
    <cffunction  name="autoPopulateCategoryModalDropDown">
        <cfquery name="local.autoPopulateCategory">
            SELECT
                fldCategory_ID,
                fldCategoryName
            FROM
                tblCategory
            WHERE
                fldActive= 1
        </cfquery>
        <cfreturn local.autoPopulateCategory>
    </cffunction>

    <!--- ADD SUB CATEGORY --->
    <cffunction  name="addSubCategory">
        <cfargument  name="categoryId" required="true">
        <cfargument  name="subCategoryName" required="true">
        <cfset local.subCategoryExistence = checkSubCategoryExistence(
            subCategoryName = arguments.subCategoryName,
            categoryId = arguments.categoryId
        )>
        <cfif NOT local.subCategoryExistence>
            <cfquery name="local.addSubCategory">
                INSERT INTO
                    tblSubCategory (
                        fldCategoryId, 
                        fldSubCategoryName, 
                        fldCreatedBy
                    )
                VALUES (
                    <cfqueryparam value="#arguments.categoryId#" cfsqltype="NUMERIC">,
                    <cfqueryparam value="#arguments.subCategoryName#" cfsqltype="VARCHAR">,
                    <cfqueryparam value="#session.userId#" cfsqltype="NUMERIC">
                )
            </cfquery>
        </cfif>
        <cfreturn local.subCategoryExistence>
    </cffunction>

    <!--- EDIT SUB CATEGORY --->
    <cffunction  name="editSubCategory">
        <cfargument  name="categoryId" required="true">
        <cfargument  name="subCategoryId" required="true">
        <cfargument  name="subCategoryName" required="true">
        <cfset local.subCategoryExistence = checkSubCategoryExistence(
            subCategoryName = arguments.subCategoryName,
            categoryId = arguments.categoryId
        )>
        <cfif NOT local.subCategoryExistence>
            <cfquery name="updateSubCategory">
                UPDATE
                    tblSubCategory
                SET
                    fldSubCategoryName = <cfqueryparam value="#arguments.subCategoryName#" cfsqltype="VARCHAR">,
                    fldcategoryId = <cfqueryparam value="#arguments.categoryId#" cfsqltype="NUMERIC">,
                    fldUpdatedBy = <cfqueryparam value="#session.userId#" cfsqltype="NUMERIC">
                WHERE
                    fldSubCategory_ID = <cfqueryparam value="#arguments.subCategoryId#" cfsqltype="NUMERIC">
            </cfquery>
        </cfif>
        <cfreturn local.subCategoryExistence>
    </cffunction>

    <!--- DELETE SUB CATEGORY --->
    <cffunction  name="deleteSubCategory" access="remote">
        <cfargument  name="deleteSubCategoryId" required="true">
        <cfquery name="deleteSubCategory">
            UPDATE
                tblSubCategory
            SET
                fldUpdatedBy = <cfqueryparam value="#session.userId#" cfsqltype="NUMERIC">,
                fldActive = 0
            WHERE
                fldSubCategory_ID = <cfqueryparam value="#arguments.deleteSubCategoryId#" cfsqltype="NUMERIC">
        </cfquery>
    </cffunction>

    <!--- PRODUCTS --->
    <!--- AUTO POPULATE SUB CATEGORY NAME --->
    <cffunction  name="autoPopulateSubCategoryModal">
        <cfquery name="local.autoPopulateSubCategory">
            SELECT
                fldSubCategory_ID,
                fldSubCategoryName
            FROM
                tblSubCategory
            WHERE
                fldActive= 1
        </cfquery>
        <cfreturn local.autoPopulateSubCategory>
    </cffunction>

    <!--- CHECK IF PRODUCT EXISTS --->
    <cffunction  name="checkProductExistence">
        <cfargument  name="subCategoryId">
        <cfargument  name="productName">
        <cfquery name="local.productExistence">
            SELECT
                fldProductName
            FROM
                tblProduct
            WHERE
                fldSubCategoryId = <cfqueryparam value="#arguments.subCategoryId#" cfsqltype="NUMERIC">
                AND fldProductName = <cfqueryparam value="#arguments.productName#" cfsqltype="VARCHAR">
        </cfquery>
        <cfif queryRecordCount(local.productExistence)>
            <cfreturn true>
        <cfelse>
            <cfreturn false>
        </cfif>
    </cffunction>

    <!--- ADD PRODUCT --->
    <cffunction  name="addProduct">
        <cfargument  name="subCatgeoryId">
        <cfargument  name="productName">
        <cfargument  name="brandName">
        <cfargument  name="productDescription">
        <cfargument  name="productPrice">
        <cfargument  name="productTax">
        <cfargument  name="productImages">
        <cfset local.productExistence = checkProductExistence(
            subCategoryId = arguments.subCatgeoryId,
            productName = arguments.productName
        )>
        <cfif NOT local.productExistence>
            <cfquery name="addProduct">
                INSERT INTO
                    tblProduct (
                        fldSubCategoryId,
                        fldProductName,
                        fldDescription,
                        fldPrice,
                        fldTax,
                        fldCreatedBy
                    )
                VALUES (
                    <cfqueryparam value="#arguments.subCategoryId#" cfsqltype="NUMERIC">,
                    <cfqueryparam value="#arguments.productName#" cfsqltype="VARCHAR">,
                    <cfqueryparam value="#arguments.productDescription#" cfsqltype="VARCHAR">,
                    <cfqueryparam value="#arguments.productPrice#" cfsqltype="NUMERIC">,
                    <cfqueryparam value="#arguments.productTax#" cfsqltype="NUMERIC">,
                    <cfqueryparam value="#session.userId#" cfsqltype="NUMERIC">
                )
            </cfquery>
        </cfif>
        <cfreturn local.productExistence>
    </cffunction>

</cfcomponent>