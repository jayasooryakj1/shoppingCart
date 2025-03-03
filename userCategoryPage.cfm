<cfset variables.productDetails = application.userObject.getProducts(
    categoryId = url.categoryId
)>
<cfinclude  template="./userHeader.cfm">

    <div>
        <cfset productsPresent = 0>
            <cfoutput>
                <h3 class="categoryName">
                    <a href="index.cfm">Home ></a>
                    #variables.productDetails.fldCategoryName#
                </h3>
            </cfoutput>
            <cfoutput query="variables.productDetails" group="fldSubCategory_ID">
                <h4 class="mt-4 subCategory">
                    <a href="userSubCategoryPage.cfm?subCategoryId=#variables.productDetails.fldSubCategory_ID#">
                        #variables.productDetails.fldSubCategoryName#
                    </a>
                </h4>
                <div class="d-flex">
                    <cfset count = 0>
                    <cfoutput>
                        <cfif variables.productDetails.fldProduct_ID NEQ "">
                            <cfif count LT 6>
                                <cfset count = count + 1>
                                <cfset productsPresent = 1>
                                <div class="mt-5 randomProducts d-flex flex-column justify-content-center align-items-center ms-5 border p-2 rounded">
                                    <a href="productPage.cfm?productId=#variables.productDetails.fldProduct_ID#">
                                        <div class="randomProductDiv d-flex flex-column justify-content-center align-items-center mb-2 p-1">
                                            <img src="assets/productImages/#variables.productDetails.fldImageFileName#" alt="productImage">
                                        </div>
                                        <div>
                                            #variables.productDetails.fldProductName#
                                        </div>
                                        <div>
                                            <cfset price = variables.productDetails.fldPrice + variables.productDetails.fldTax*variables.productDetails.fldPrice/100>
                                            #price#
                                        </div>
                                    </a>
                                </div>
                            </cfif>
                        </cfif>
                    </cfoutput>
                    <cfif productsPresent EQ 0>
                        NO PRODUCTS PRESENT
                    </cfif>
                </div>
            </cfoutput>
    </div>

<cfinclude  template="./userFooter.cfm">