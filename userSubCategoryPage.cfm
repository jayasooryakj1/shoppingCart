<cfif structKeyExists(url, "search")>
    <cfset subCategoryProducts = application.userObject.searchFunction(
        searchName = url.search
    )>
<cfelse>
    <cfset subCategoryProducts = application.userObject.getProduct(
        subCategoryId = url.subCategoryId
    )>
    <cfset subCategoryName = application.userObject.getSubCategory(
        subCategoryId = url.subCategoryId
    )>
    <cfif structKeyExists(form, "ascending")>
        <cfset subCategoryProducts = application.userObject.getProduct(
            sort = "ASC",
            subCategoryId = url.subCategoryId
        )>
    </cfif>

    <cfif structKeyExists(form, "descending")>
        <cfset subCategoryProducts = application.userObject.getProduct(
            sort = "DESC",
            subCategoryId = url.subCategoryId
        )>
    </cfif>
</cfif>

<cfinclude  template="./userHeader.cfm">

    <cfoutput>
        <cfif structKeyExists(url, "subCategoryId")>
            <form method="post">
                <div class="py-2 d-flex align-items-center justify-content-end">
                    <div class="me-5">
                        SORT
                        <button class="btn btn-primary" type="submit" name="ascending">
                            <i class="fa-solid fa-angle-up"></i>
                        </button>
                        <button class="btn btn-primary" type="submit" name="descending">
                            <i class="fa-solid fa-angle-down"></i>
                        </button>
                    </div>
                    <div class="dropDown2 me-5">
                        FILTER
                        <div class="tooltiptext2">
                            <input type="radio" id="range1" name="priceRange" value='["0","5000"]' class="me-2">0-5000<br>
                            <input type="radio" id="range2" name="priceRange" value='["5000","10000"]' class="me-2">5000-10000<br>
                            <input type="radio" id="range3" name="priceRange" value='["10000","50000"]' class="me-2">10000-50000<br>
                            <br>OR<br><br>
                            MIN
                            <input type="number" id="min" class="w-50">
                            <br>
                            MAX
                            <input type="number" id="max" class="w-50">
                            <br>
                            <button class="btn" type="button" onclick="filter(#url.subCategoryId#)">SUBMIT</button>
                        </div>
                    </div>
                </div>
            </form>
            <div class="link">
                <h3>
                    <a href="index.cfm">
                        Home >
                    </a>
                    #subCategoryName.fldSubCategoryName#
                </h3>
            </div>
        </cfif>
        <cfif NOT queryRecordCount(subCategoryProducts) AND structKeyExists(url, "search")>
            <h4 class="mt-5 ms-3">* NO SEARCH RESULTS FOR "#url.search#" *</h4>
        </cfif>
        <div class="d-flex listProducts" id="parentDiv">
            <cfloop query="subCategoryProducts">
                <div class="mt-5 d-flex flex-column justify-content-center align-items-center ms-5 border p-2 rounded">
                    <a href="productPage.cfm?productId=#subCategoryProducts.fldProduct_ID#">
                        <div class="randomProductDiv d-flex flex-column justify-content-center align-items-center mb-2 p-1">
                            <img src="assets/productImages/#subCategoryProducts.fldImageFileName#" alt="productImage">
                        </div>
                        <div>
                            #subCategoryProducts.fldProductName#
                        </div>
                        <div>
                            <cfset price = subCategoryProducts.fldPrice + subCategoryProducts.fldTax>
                            #price#
                        </div>
                    </a>
                </div>
            </cfloop>
        </div>
    </cfoutput>

<cfinclude  template="./userFooter.cfm">