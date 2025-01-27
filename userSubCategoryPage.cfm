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
    <cfif structKeyExists(url, "ascending")>
        <cfset subCategoryProducts = application.userObject.getProduct(
            sort = "ASC",
            subCategoryId = url.subCategoryId
        )>
    </cfif>
    <cfif structKeyExists(url, "descending")>
        <cfset subCategoryProducts = application.userObject.getProduct(
            sort = "DESC",
            subCategoryId = url.subCategoryId
        )>
    </cfif>
</cfif>

<cfinclude  template="./userHeader.cfm">

    <cfoutput>
            <cfif structKeyExists(url, "subCategoryId")>
                <div class="d-flex justify-content-between">
                    <div class="link">
                        <h3>
                            <a href="index.cfm">
                                Home >
                            </a>
                            #subCategoryName.fldSubCategoryName#
                        </h3>
                    </div>
                    <div>
                        <form method="get">
                            <div class="py-2 d-flex align-items-center justify-content-end">
                                <div class="me-5">
                                    SORT PRICE
                                    <button class="btn btn-primary" type="submit" name="ascending">
                                        <i class="fa-solid fa-angle-up"></i>
                                    </button>
                                    <input type="hidden" value="#url.subCategoryId#" name="subCategoryId">
                                    <button class="btn btn-primary" type="submit" name="descending">
                                        <i class="fa-solid fa-angle-down"></i>
                                    </button>
                                </div>
                                
                                <div class="btn-group">
                                    <button class="btn btn-secondary dropdown-toggle" type="button" data-bs-toggle="dropdown" data-bs-auto-close="outside" aria-expanded="false">
                                        FILTER
                                    </button>
                                    <div class="dropdown-menu">
                                        <div class="d-flex flex-column align-items-center justify-content-center">
                                            <div>
                                                <input type="radio" id="range1" name="priceRange" value='["0","5000"]' class="me-2">0-5000<br>
                                                <input type="radio" id="range2" name="priceRange" value='["5000","10000"]' class="me-2">5000-10000<br>
                                                <input type="radio" id="range3" name="priceRange" value='["10000","50000"]' class="me-2">10000-50000<br>
                                            </div>
                                                <br>
                                                <div>
                                                    OR
                                                </div>
                                                <br>
                                            <div class="w-100 p-2">
                                                <input type="number" id="min" class="w-100" placeholder="MIN">
                                            </div>
                                                <br>
                                            <div class="w-100 p-2">
                                                <input type="number" id="max" class="w-100" placeholder="MAX">
                                            </div>
                                            <div class="w-100 p-2">
                                                <br>
                                                <button class="btn btn-danger w-100" type="button" onclick="clearFilter()">CLEAR</button>
                                                <br><br>
                                                <button class="btn btn-primary w-100" type="button" onclick="filter(#url.subCategoryId#)">SUBMIT</button>
                                            </div>
                                        </div>
                                    </div>
                                </div>
                            </div>
                        </form>
                    </div>
                </div>
            </cfif>
            <cfif NOT queryRecordCount(subCategoryProducts) AND structKeyExists(url, "search")>
                <h4 class="mt-5 ms-3">* NO SEARCH RESULTS FOR "#url.search#" *</h4>
            </cfif>
            <cfif queryRecordCount(subCategoryProducts) AND structKeyExists(url, "search")>
                <h4 class="mt-5 ms-3">SEARCH RESULTS FOR "#url.search#" </h4>
            </cfif>
            <cfset productIds = []>
            <div class="d-flex listProducts" id="parentDiv">
                <cfif queryRecordCount(subCategoryProducts)>
                    <cfif structKeyExists(url, "search")>
                        <cfloop query="subCategoryProducts">
                            <cfset  arrayAppend(productIds, subCategoryProducts.fldProduct_ID)>
                            <div class="d-flex flex-column justify-content-center align-items-center border p-2 rounded">
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
                    <cfelse>
                        <cfloop query="subCategoryProducts" endRow = "6">
                            <cfset  arrayAppend(productIds, subCategoryProducts.fldProduct_ID)>
                            <div class="d-flex flex-column justify-content-center align-items-center mt-5 me-5 border p-2 rounded">
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
                    </cfif>
                <cfelse>
                    NO PRODUCTS AVAILABLE
                </cfif>
            </div>
            <br>
            <cfif structKeyExists(url, "subCategoryId")>
                <cfset subCategoryId = url.subCategoryId>
            <cfelse>
                <cfset subCategoryId = 0>
            </cfif>
            <cfif queryRecordCount(subCategoryProducts) GT 6 AND NOT structKeyExists(url, "search")>
                <div class="d-flex align-items-center justify-content-center">
                    <div>
                        <button id="showMore" class="btn btn-outline-primary p-1" 
                            onclick="showMore('#arraytoList(productIds)#',
                                #subCategoryId#
                                <cfif structKeyExists(form, "ascending")>,'ASC'</cfif>
                                <cfif structKeyExists(form, "descending")>,'DESC'</cfif>
                            )">SHOW MORE
                        </button>
                    </div>
                </div>
            </cfif>
    </cfoutput>

<cfinclude  template="./userFooter.cfm">