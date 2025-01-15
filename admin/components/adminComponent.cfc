<cfcomponent>

    <!--- ADMIN LOGIN --->
    <cffunction  name="adminLogin" returntype="string">
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
    <cffunction  name="logoutFunction" access="remote" returntype="boolean">
        <cfset structClear(session)>
        <cfreturn true>
    </cffunction>

    <!--- CATEGORY FUNCTIONS--->

    <!--- ADD CATEGORY --->
    <cffunction  name="addCategory" returntype="boolean">
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
    <cffunction  name="dipslayCategories" returntype="query">
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
    <cffunction  name="checkCategoryExistence" returntype="boolean">
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
    <cffunction  name="editCategory" returntype="boolean">
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
    <cffunction  name="deleteCategory" access="remote" returntype="boolean">
        <cfargument  name="deleteCategoryId" required="true">
        <cfquery name="local.deleteCategory">
            UPDATE
                tblCategory
            SET
                fldActive = 0
            WHERE
                fldCategory_ID = <cfqueryparam value="#arguments.deleteCategoryId#" cfsqltype="VARCHAR">
        </cfquery>
        <cfreturn true>
    </cffunction>


    <!--- SUB CATEGORY FUNCTIONS --->

    <!--- SUB CATEGORY DISPLAY --->
    <cffunction  name="displaySubCategories" returntype="query">
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
    <cffunction  name="checkSubCategoryExistence" returntype="boolean">
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
        <cfquery name="local.autoPopulateCategory" returntype="query">
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
    <cffunction  name="addSubCategory" returntype="boolean">
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
    <cffunction  name="editSubCategory" returntype="boolean">
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
    <cffunction  name="deleteSubCategory" access="remote" returntype="boolean">
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
        <cfreturn true>
    </cffunction>

    <!--- PRODUCTS --->
    <!--- DISPLAY PRODUCT --->
    <cffunction  name="displayProduct" returntype="query">
        <cfargument  name="subCategoryId" required="true">
        <cfquery name="local.displayProduct">
            SELECT 
                fldProduct_ID,
                fldProductName,
                fldSubCategoryId,
                fldPrice,
                fldTax,
                fldBrandName,
                fldBrandId,
                fldDescription,
                fldImageFileName
            FROM
                tblProduct
            LEFT JOIN 
                tblBrands
            ON
                tblProduct.fldBrandId = tblBrands.fldBrand_ID
            LEFT JOIN
                tblProductImages
            ON
                tblProduct.fldProduct_ID = tblProductImages.fldProductId
                AND tblProductImages.fldDefaultImage = 1
            WHERE
                tblProduct.fldSubCategoryId = <cfqueryparam value="#arguments.subCategoryId#" cfsqltype="NUMERIC">
                AND tblProduct.fldActive = 1
        </cfquery>
        <cfreturn local.displayProduct>
    </cffunction>

    <!--- AUTO POPULATE SUB CATEGORY NAME --->
    <cffunction  name="autoPopulateSubCategoryModal" access="remote" returnformat="JSON">
        <cfargument  name="categoryId" required="true">
        <cfquery name="local.autoPopulateSubCategory">
            SELECT
                fldSubCategory_ID,
                fldSubCategoryName
            FROM
                tblSubCategory
            WHERE
                fldActive= 1
                AND fldCategoryId = <cfqueryparam value="#arguments.categoryId#" cfsqltype="NUMERIC">
        </cfquery>
        <cfloop query="local.autoPopulateSubCategory">
            <cfset local.returnStruct[local.autoPopulateSubCategory.fldSubCategory_ID] = local.autoPopulateSubCategory.fldSubCategoryName>
        </cfloop>
        <cfreturn local.returnStruct>
    </cffunction>

    <!--- AUTO POPULATE BRAND --->
    <cffunction  name="autoPopulateBrand" returntype="query">
        <cfquery name="local.autoPopulateBrand">
            SELECT
                fldBrand_ID,
                fldBrandName
            FROM
                tblBrands
            WHERE
                fldActive = 1
        </cfquery>
        <cfreturn local.autoPopulateBrand>
    </cffunction>

    <!--- CHECK IF PRODUCT EXISTS --->
    <cffunction  name="checkProductExistence" returntype="boolean">
        <cfargument  name="subCategoryId" required="true">
        <cfargument  name="productName" required="true">
        <cfargument  name="productId" required="true">
        <cfquery name="local.productExistence">
            SELECT
                fldProductName
            FROM
                tblProduct
            WHERE
                fldSubCategoryId = <cfqueryparam value="#arguments.subCategoryId#" cfsqltype="NUMERIC">
                AND fldProductName = <cfqueryparam value="#arguments.productName#" cfsqltype="VARCHAR">
                AND fldActive = 1
                <cfif structKeyExists(arguments, "productId")>
                    AND NOT fldProduct_ID = <cfqueryparam value="#arguments.productId#" cfsqltype="NUMERIC">
                </cfif>
        </cfquery>
        <cfif queryRecordCount(local.productExistence)>
            <cfreturn true>
        <cfelse>
            <cfreturn false>
        </cfif>
    </cffunction>

    <!--- ADD PRODUCT --->
    <cffunction  name="addProduct" returntype="boolean">
        <cfargument  name="subCategoryId" required="true">
        <cfargument  name="productName" required="true">
        <cfargument  name="brandId" required="true">
        <cfargument  name="productDescription" required="true">
        <cfargument  name="productPrice" required="true">
        <cfargument  name="productTax" required="true">
        <cfargument  name="productImages" required="true">
        <cfset local.productExistence = checkProductExistence(
            subCategoryId = arguments.subCategoryId,
            productName = arguments.productName
        )>
        <cfif NOT local.productExistence>
            <cffile  action="uploadall"
                destination=#expandPath("../assets/productImages")#
                result="local.uploadedFiles"
                nameconflict="makeunique"
            >
            <cfquery result="local.addProduct">
                INSERT INTO
                    tblProduct (
                        fldSubCategoryId,
                        fldProductName,
                        fldBrandId,
                        fldDescription,
                        fldPrice,
                        fldTax,
                        fldCreatedBy
                    )
                VALUES (
                    <cfqueryparam value="#arguments.subCategoryId#" cfsqltype="NUMERIC">,
                    <cfqueryparam value="#arguments.productName#" cfsqltype="VARCHAR">,
                    <cfqueryparam value="#arguments.brandId#" cfsqltype="NUMERIC">,
                    <cfqueryparam value="#arguments.productDescription#" cfsqltype="VARCHAR">,
                    <cfqueryparam value="#arguments.productPrice#" cfsqltype="DECIMAL" scale="2">,
                    <cfqueryparam value="#arguments.productTax#" cfsqltype="DECIMAL" scale="2">,
                    <cfqueryparam value="#session.userId#" cfsqltype="NUMERIC">
                )
            </cfquery>
            <cfset local.defaultImage = 1>
            <cfloop array="#local.uploadedFiles#" item="item">
                <cfquery name="local.insertImages">
                    INSERT INTO
                        tblProductImages (
                            fldProductId,
                            fldImageFileName,
                            fldDefaultImage,
                            fldCreatedBy
                        )
                    VALUES (
                        <cfqueryparam value="#local.addProduct.generatedKey#" cfsqltype="NUMERIC">,
                        <cfqueryparam value="#item.serverfile#" cfsqltype="VARCHAR">,
                        <cfqueryparam value="#local.defaultImage#" cfsqltype="NUMERIC">,
                        <cfqueryparam value="#session.userId#" cfsqltype="NUMERIC">
                    )
                </cfquery>
                <cfset local.defaultImage = 0>
            </cfloop>
        </cfif>
        <cfreturn local.productExistence>
    </cffunction>

    <!--- DELETE PRODUCT --->
    <cffunction  name="deleteProduct" access="remote" returntype="boolean">
        <cfargument  name="deleteProductId" required="true">
        <cfquery name="local.deleteProduct">
            UPDATE
                tblProduct
            SET
                fldActive = 0,
                fldUpdatedBy = <cfqueryparam value="#session.userId#" cfsqltype="NUMERIC">
            WHERE
                fldProduct_ID = <cfqueryparam value="#arguments.deleteProductId#" cfsqltype="NUMERIC">
        </cfquery>
        <cfreturn true>
    </cffunction>

    <!--- EDIT PRODUCT --->
    <cffunction  name="editProduct">
        <cfargument  name="subCategoryId" required="true">
        <cfargument  name="productName" required="true">
        <cfargument  name="brandId" required="true">
        <cfargument  name="productDescription" required="true">
        <cfargument  name="productPrice" required="true">
        <cfargument  name="productTax" required="true">
        <cfargument  name="productId" required="true">
        <cfargument  name="productImages" required="true">
        <cfset local.productExistence = checkProductExistence(
            subCategoryId = arguments.subCategoryId,
            productName = arguments.productName,
            productId = arguments.productId
        )>
        <cfif NOT local.productExistence>
            <cfquery name="local.editProduct">
                UPDATE
                    tblProduct
                SET
                    fldSubCategoryId = <cfqueryparam value="#arguments.subCategoryId#" cfsqltype="NUMERIC">,
                    fldProductName = <cfqueryparam value="#arguments.productName#" cfsqltype="VARCHAR">,
                    fldBrandId = <cfqueryparam value="#arguments.brandId#" cfsqltype="NUMERIC">,
                    fldDescription = <cfqueryparam value="#arguments.productdescription#" cfsqltype="VARCHAR">,
                    fldPrice = <cfqueryparam value="#arguments.productPrice#" cfsqltype="DECIMAL" scale="2">,
                    fldTax = <cfqueryparam value="#arguments.productTax#" cfsqltype="DECIMAL" scale="2">
                WHERE
                    fldProduct_ID = <cfqueryparam value="#arguments.productId#" cfsqltype="NUMERIC">
            </cfquery>
            <cfif structKeyExists(arguments, "productImages")>
                <cffile  action="uploadall"
                    destination=#expandPath("../assets/productImages")#
                    result="local.uploadedFiles"
                    nameconflict="makeunique"
                >
                <cfloop array="#local.uploadedFiles#" item="item">
                    <cfquery name="local.insertNewImages">
                        INSERT INTO
                            tblProductImages (
                                fldProductId,
                                fldImageFileName,
                                fldDefaultImage,
                                fldCreatedBy
                            )
                        VALUES (
                            <cfqueryparam value="#arguments.productId#" cfsqltype="NUMERIC">,
                            <cfqueryparam value="#item.serverfile#" cfsqltype="VARCHAR">,
                            0,
                            <cfqueryparam value="#session.userId#" cfsqltype="NUMERIC">
                        )
                    </cfquery>
                </cfloop>
            </cfif>
        </cfif>
        <cfreturn local.productExistence>
    </cffunction>

    <!--- SELECT IMAGE USING PRODUCT ID --->
    <cffunction  name="editProductImageAutoPopulate" access="remote" returnformat="JSON">
        <cfargument  name="editProductId" required="true">
        <cfquery name="local.autoPopulateImage">
            SELECT
                fldProductImage_ID,
                fldImageFileName
            FROM
                tblProductImages
            WHERE
                fldProductId = <cfqueryparam value="#arguments.editProductId#" cfsqltype="NUMERIC">
                AND fldActive = 1
        </cfquery>
        <cfloop query="local.autoPopulateImage">
            <cfset local.imageStruct[local.autoPopulateImage.fldProductImage_ID] = local.autoPopulateImage.fldImageFileName>
        </cfloop>
        <cfreturn local.imageStruct>
    </cffunction>

    <!--- DELETE IMAGE --->
    <cffunction  name="deleteProductImage" access="remote" returntype="true">
        <cfargument  name="imageId" required="true">
        <cfquery name="local.deleteImage" result="local.deleteResult">
            UPDATE
                tblProductImages
            SET
                fldActive = 0
            WHERE
                fldProductImage_ID = <cfqueryparam value="#arguments.imageId#" cfsqltype="NUMERIC">
                AND fldDefaultImage = 0
        </cfquery>
        <cfreturn true>
    </cffunction>

    <!--- SET DEFAULT IMAGE --->
    <cffunction  name="setDefaultProductImage" access="remote" returntype="boolean">
        <cfargument  name="imageId" required="true">
        <cfargument  name="productId" required="true">
        <cfquery name="local.setAll">
            UPDATE
                tblProductImages
            SET
                fldDefaultImage = 0
            WHERE
                fldProductId = <cfqueryparam value="#arguments.productId#">
        </cfquery>
        <cfquery name="local.setDefault">
            UPDATE
                tblProductImages
            SET
                fldDefaultImage = 1
            WHERE
                fldProductImage_ID = <cfqueryparam value="#arguments.imageId#" cfsqltype="NUMERIC">
        </cfquery>
        <cfreturn true>
    </cffunction>

</cfcomponent>