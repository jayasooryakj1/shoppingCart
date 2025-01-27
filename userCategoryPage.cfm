<cfset subCategoryName = application.userObject.getSubCategory()>
<cfset productName = application.userObject.getProduct()>
<cfset categoryName = application.userObject.getCategory()>

<cfinclude  template="./userHeader.cfm">

    <cfoutput>

        <div>
            <cfset productsPresent = 0>
            <cfset subCategoryPresent = 0>
            <cfloop query="categoryName">
                <cfif categoryName.fldCategory_ID EQ url.categoryId>
                    <h3 class="categoryName">
                        <a href="index.cfm">Home ></a>
                        #categoryName.fldCategoryName#
                    </h3>
                </cfif>
            </cfloop>
            <cfloop query="subCategoryName">    
                <cfif subCategoryName.fldCategoryId EQ url.categoryId>
                    <cfset subCategoryPresent = 1>
                    <h4 class="mt-4 subCategory">
                        <a href="userSubCategoryPage.cfm?subCategoryId=#subCategoryName.fldSubCategory_ID#">
                            #subCategoryName.fldSubCategoryName#
                        </a>
                    </h4>
                    <div class="d-flex">
                        <cfset count = 0>
                        <cfloop query="productName">
                            <cfif subCategoryName.fldSubCategory_ID EQ productName.fldSubCategoryId AND count LT 6>
                                <cfset count = count + 1>
                                <cfset productsPresent = 1>
                                <div class="mt-5 randomProducts d-flex flex-column justify-content-center align-items-center ms-5 border p-2 rounded">
                                    <a href="productPage.cfm?productId=#productName.fldProduct_ID#">
                                        <div class="randomProductDiv d-flex flex-column justify-content-center align-items-center mb-2 p-1">
                                            <img src="assets/productImages/#productName.fldImageFileName#" alt="productImage">
                                        </div>
                                        <div>
                                            #productName.fldProductName#
                                        </div>
                                        <div>
                                            <cfset price = productName.fldPrice + productName.fldTax>
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
                </cfif>
            </cfloop>
            <cfif subCategoryPresent EQ 0>
                NO SUBCATEGORIES PRESENT
            </cfif>
        </div>

    </cfoutput>

<cfinclude  template="./userFooter.cfm">