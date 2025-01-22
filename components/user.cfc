<cfcomponent>

    <!--- SIGN UP --->
    <cffunction  name="userSignUp" returntype="boolean">
        <cfargument  name="firstName" required="true" type="string">
        <cfargument  name="lastName" required="true" type="string">
        <cfargument  name="email" required="true" type="string">
        <cfargument  name="phoneNumber" required="true" type="string">
        <cfargument  name="password" required="true" type="string">
        <cfquery name="local.getEmail">
            SELECT
                fldEmail
            FROM
                tblUser
            WHERE
                fldEmail = <cfqueryparam value="#arguments.email#" cfsqltype="varchar">
        </cfquery>
        <cfif queryRecordCount(local.getEmail)>
            <cfreturn false>
        <cfelse>
            <cfset local.saltString = generateSecretKey("AES",128)>
            <cfset local.HashedPassword = hash("#arguments.password#"&"#local.saltString#","SHA-256","UTF-8")>
            <cfquery name="local.signUp">
                INSERT INTO
                    tblUser (
                        fldFirstName,
                        fldLastName,
                        fldEmail,
                        fldPhone,
                        fldRoleId,
                        fldHashedPassword,
                        fldUserSaltString
                    )
                VALUES (
                    <cfqueryparam value="#arguments.firstName#" cfsqltype="varchar">,
                    <cfqueryparam value="#arguments.lastName#" cfsqltype="varchar">,
                    <cfqueryparam value="#arguments.email#" cfsqltype="varchar">,
                    <cfqueryparam value="#arguments.phoneNumber#" cfsqltype="varchar">,
                    2,
                    <cfqueryparam value="#local.HashedPassword#" cfsqltype="varchar">,
                    <cfqueryparam value="#local.saltString#" cfsqltype="varchar">
                )
            </cfquery>
            <cfreturn true>
        </cfif>
    </cffunction>

    <!--- LOGIN --->
    <cffunction  name="userLogin" returntype="boolean">
        <cfargument  name="email" required="true" type="string">
        <cfargument  name="password" required="true" type="string">
        <cfquery name="local.userValidation">
            SELECT
                fldUser_ID,
                fldUserSaltString,
                fldHashedPassword
            FROM
                tblUser
            WHERE
                fldEmail = <cfqueryparam value="#arguments.email#" cfsqltype="varchar">
                AND fldActive = 1
        </cfquery>
        <cfif queryRecordCount(local.userValidation)>
            <cfset local.hashedPasswordInput = hash("#arguments.password#"&"#local.userValidation.fldUserSaltString#","SHA-256","UTF-8")>
            <cfif local.hashedPasswordInput EQ local.userValidation.fldHashedPassword>
                <cfset session.userId = local.userValidation.fldUser_ID>
                <cfreturn true>
            <cfelse>
                <cfreturn false>
            </cfif>
        <cfelse>
            <cfreturn false>
        </cfif>
    </cffunction>

    <!--- LOGOUT --->
    <cffunction  name="logoutFunction" access="remote" returntype="boolean">
        <cfset structClear(session)>
        <cfreturn true>
    </cffunction>

    <!--- GET CATEGORY --->
    <cffunction  name="getCategory" returntype="query">
        <cfquery name="local.getCategory">
            SELECT
                fldCategory_ID,
                fldCategoryName
            FROM
                tblCategory
            WHERE
                fldActive = 1
        </cfquery>
        <cfreturn local.getCategory>
    </cffunction>

    <!--- GET SUBCATEGORY --->
    <cffunction  name="getSubCategory" returntype="query">
        <cfargument  name="subCategoryId" required="false" type="numeric">
        <cfquery name="local.getSubCategory">
            SELECT
                fldSubCategory_ID,
                fldCategoryId,
                fldSubCategoryName
            FROM
                tblSubCategory
            WHERE
                fldActive = 1
                <cfif structKeyExists(arguments, "subCategoryId")>
                    AND fldSubCategory_ID = <cfqueryparam value="#arguments.subCategoryId#" cfsqltype="numeric">
                </cfif>
        </cfquery>
        <cfreturn local.getSubCategory>
    </cffunction>

    <!--- SELECT RANDOM PRODUCTS--->
    <cffunction  name="getproductsInRandom" returntype="query">
        <cfquery name="local.randomProducts">
            SELECT
                fldProduct_ID,
                fldProductName,
                fldProductImage_ID,
                fldImageFileName,
                fldPrice,
                fldTax,
                fldBrandName
            FROM
                tblProduct AS P
            LEFT JOIN tblProductImages AS I ON P.fldProduct_ID = I.fldProductId
            LEFT JOIN tblBrands AS B ON P.fldbrandId = B.fldBrand_ID
            AND P.fldActive = 1
            WHERE
                P.fldActive = 1
                AND I.fldDefaultImage = 1
            ORDER BY
                RAND()
            LIMIT 
                12
        </cfquery>
        <cfreturn local.randomProducts>
    </cffunction>

    <!--- GET PRODUCTS --->
    <cffunction  name="getProduct" returntype="any" access="remote" returnformat="json">
        <cfargument  name="subCategoryId" required="false" type="numeric">
        <cfargument  name="productId" required="false" type="numeric">
        <cfargument  name="sort" required="false" type="string">
        <cfargument  name="range" required="false">
        <cfif structKeyExists(arguments, "range")>
            <cfset local.range = deserializeJSON(arguments.range)>
        </cfif>
        <cfquery name="local.getProduct">
            SELECT
                fldProduct_ID,
                fldSubCategoryId,
                fldDescription,
                fldProductName,
                fldProductImage_ID,
                fldImageFileName,
                fldPrice,
                fldTax,
                fldBrand_ID,
                fldBrandName
            FROM tblProduct AS P
            LEFT JOIN tblProductImages AS I ON P.fldProduct_ID = I.fldProductId
            LEFT JOIN tblBrands AS B ON P.fldBrandId = B.fldBrand_ID
            WHERE
                P.fldActive = 1
                AND I.fldDefaultImage = 1
                <cfif structKeyExists(arguments, "subCategoryId")>
                    AND P.fldSubCategoryId = <cfqueryparam value="#arguments.subCategoryId#" cfsqltype="numeric">
                </cfif>
                <cfif structKeyExists(arguments, "productId")>
                    AND P.fldProduct_ID = <cfqueryparam value="#arguments.productId#" cfsqltype="numeric">
                </cfif>
                <cfif structKeyExists(arguments, "range")>
                    AND (fldPrice + fldTax) > <cfqueryparam value="#local.range[1]#" cfsqltype="numeric">
                    AND (fldPrice + fldTax) < <cfqueryparam value="#local.range[2]#" cfsqltype="numeric">
                </cfif>
                <cfif structKeyExists(arguments, "sort")>
                    <cfif arguments.sort EQ "ASC">
                        ORDER BY (fldPrice + fldTax) ASC
                    <cfelse>
                        ORDER BY (fldPrice + fldTax) DESC
                    </cfif>
                </cfif>
        </cfquery>
        <cfreturn local.getProduct>
    </cffunction>

    <!--- GET PRODUCT IMAGES --->
    <cffunction  name="getProductImages" returntype="query">
        <cfargument  name="productId" required="true" type="numeric">
        <cfquery name="local.getProductImages">
            SELECT
                fldImageFileName,
                fldDefaultImage
            FROM
                tblProductImages
            WHERE
                fldProductId = <cfqueryparam value="#arguments.productId#" cfsqltype="numeric">
                AND fldActive = 1
        </cfquery>
        <cfreturn local.getProductImages>
    </cffunction>

    <cffunction  name="searchFunction" returntype="query">
        <cfargument  name="searchName" required="true" type="string">
        <cfquery name="local.searchQuery">
            SELECT
                fldProduct_ID,
                fldSubCategoryId,
                fldDescription,
                fldProductName,
                fldProductImage_ID,
                fldImageFileName,
                fldPrice,
                fldTax,
                fldBrand_ID,
                fldBrandName
            FROM tblProduct AS P
            LEFT JOIN tblProductImages AS I ON P.fldProduct_ID = I.fldProductId
            LEFT JOIN tblBrands AS B ON P.fldBrandId = B.fldBrand_ID
            WHERE
                P.fldActive = 1
                AND I.fldDefaultImage = 1
                AND (
                    P.fldProductName LIKE <cfqueryparam value="%#arguments.searchName#%" cfsqltype="varchar">
                    OR B.fldBrandName LIKE <cfqueryparam value="%#arguments.searchName#%" cfsqltype="varchar">
                    OR P.fldDescription LIKE <cfqueryparam value="%#arguments.searchName#%" cfsqltype="varchar">
                )
        </cfquery>
        <cfreturn local.searchQuery>
    </cffunction>

</cfcomponent>