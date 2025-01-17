<cfinclude  template="./userHeader.cfm">

    <cfoutput>
        <div class="categoryBar">
        <cfset displayCategory = application.userObject.getCategory()>
        <cfset displaySubCategory = application.userObject.getSubCategory()>
        <cfloop query="displayCategory">
            <div class="dropDown">
                #displayCategory.fldCategoryName#
                <div class="tooltiptext">
                    <cfloop query="displaySubCategory">
                        <cfif displayCategory.fldCategory_ID EQ displaySubCategory.fldCategoryId>
                            <button class="btn btn-light w-100">#displaySubCategory.fldSubCategoryName#</button>
                        </cfif>
                    </cfloop>
                </div>
            </div>
        </cfloop>
        </div>
        <div class="mt-5">
            <cfset randomProducts = application.userObject.getproductsInRandom()>
            <div class="d-flex randomProducts">
                <cfloop query="randomProducts">
                    <div class="me-5 mt-5 d-flex flex-column justify-content-center align-items-center ms-5 border p-2 rounded">
                        <div class="randomProductDiv d-flex flex-column justify-content-center align-items-center">
                            <img src="assets/productImages/#randomProducts.fldImageFileName#" alt="productImage">
                        </div>
                        <div>
                            #randomProducts.fldProductName#
                        </div>
                        <div>
                            <cfset price = randomProducts.fldPrice + randomProducts.fldTax>
                            #price#
                        </div>
                    </div>
                </cfloop>
            </div>
        </div>
    </cfoutput>

<cfinclude  template="./userFooter.cfm">