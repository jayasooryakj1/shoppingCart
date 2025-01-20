<cfset displayCategory = application.userObject.getCategory()>
<cfset displaySubCategory = application.userObject.getSubCategory()>
<cfset randomProducts = application.userObject.getproductsInRandom()>

<cfinclude  template="./userHeader.cfm">

    <cfoutput>
        <div class="categoryBar">
        <cfloop query="displayCategory">
            <div class="dropDown">
                <a href="userCategoryPage.cfm?categoryId=#displayCategory.fldCategory_ID#">
                    #displayCategory.fldCategoryName#
                </a>
                <div class="tooltiptext">
                    <cfloop query="displaySubCategory">
                        <cfif displayCategory.fldCategory_ID EQ displaySubCategory.fldCategoryId>
                            <a href="userSubCategoryPage.cfm?subCategoryId=#displaySubCategory.fldSubCategory_ID#">
                                <button class="btn btn-light w-100">#displaySubCategory.fldSubCategoryName#</button>
                            </a>
                        </cfif>
                    </cfloop>
                </div>
            </div>
        </cfloop>
        </div>
        <div class="mt-5">
            <div class="d-flex randomProducts">
                <cfloop query="randomProducts">
                    <div class="mt-5 d-flex flex-column justify-content-center align-items-center ms-5 border p-2 rounded">
                        <a href="productPage.cfm?productId=#randomProducts.fldProduct_ID#">
                            <div class="randomProductDiv d-flex flex-column justify-content-center align-items-center mb-2 p-1">
                                <img src="assets/productImages/#randomProducts.fldImageFileName#" alt="productImage">
                            </div>
                            <div>
                                #randomProducts.fldProductName#
                            </div>
                            <div>
                                <cfset price = randomProducts.fldPrice + randomProducts.fldTax>
                                #price#
                            </div>
                        </a>
                    </div>
                </cfloop>
            </div>
        </div>
    </cfoutput>

<cfinclude  template="./userFooter.cfm">