<cfset variables.productDetails = application.userObject.getProducts(
    categoryId = url.categoryId
)>
<cfinclude  template="./userHeader.cfm">

    <cfoutput>

        <div>
            <cfset productsPresent = 0>
                <h3 class="categoryName">
                    <a href="index.cfm">Home ></a>
                    #variables.productDetails.fldCategoryName#
                </h3>
                <cfloop query="variables.productDetails" group="fldSubCategory_ID">
                    <cfquery name="variables.subCategoryProducts" dbtype="query">
                        SELECT 
                            fldProduct_ID,
                            fldSubCategoryId,
                            fldSubCategory_ID,
                            fldProductName,
                            fldCategoryName,
                            fldPrice,
                            fldTax,
                            fldSubCategoryName,
                            fldImageFileName
                        FROM
                            variables.productDetails
                        WHERE
                            fldSubCategory_ID = #variables.productDetails.fldSubCategory_ID#
                            AND fldProduct_ID IS NOT NULL 
                            AND fldSubCategory_ID IS NOT NULL
                    </cfquery>
                    <h4 class="mt-4 subCategory">
                        <a href="userSubCategoryPage.cfm?subCategoryId=#variables.productDetails.fldSubCategory_ID#">
                            #variables.productDetails.fldSubCategoryName#
                        </a>
                    </h4>
                    <div class="d-flex">
                        <cfset count = 0>
                        <cfloop query="variables.subCategoryProducts">
                            <cfif count LT 6>
                                <cfset count = count + 1>
                                <cfset productsPresent = 1>
                                <div class="mt-5 randomProducts d-flex flex-column justify-content-center align-items-center ms-5 border p-2 rounded">
                                    <a href="productPage.cfm?productId=#variables.subCategoryProducts.fldProduct_ID#">
                                        <div class="randomProductDiv d-flex flex-column justify-content-center align-items-center mb-2 p-1">
                                            <img src="assets/productImages/#variables.subCategoryProducts.fldImageFileName#" alt="productImage">
                                        </div>
                                        <div>
                                            #variables.subCategoryProducts.fldProductName#
                                        </div>
                                        <div>
                                            <cfset price = variables.subCategoryProducts.fldPrice + variables.subCategoryProducts.fldTax>
                                            #price#
                                        </div>
                                    </a>
                                </div>
                            </cfif>
                        </cfloop>
                        <cfif productsPresent EQ 0>
                            NO PRODUCTS PRESENT
                        </cfif>
                    </div>
                </cfloop>
        </div>

    </cfoutput>

<cfinclude  template="./userFooter.cfm">