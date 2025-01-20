<cfset subCategoryName = application.userObject.getSubCategory(
    subCategoryId = url.subCategoryId
)>
<cfset subCategoryProducts = application.userObject.getProductName(
    subCategoryId = url.subCategoryId
)>

<cfinclude  template="./userHeader.cfm">
<div class="py-2 d-flex align-items-center justify-content-end">
    <div class="me-5">
        <button class="btn btn-secondary">
            SORT
        </button>
    </div>
    <div class="dropDown2 me-5">
        FILTER
        <div class="tooltiptext2">
            <input type="radio" name="priceRange" value="1" class="me-2">0-5000<br>
            <input type="radio" name="priceRange" value="2" class="me-2">5000-10000<br>
            <input type="radio" name="priceRange" value="3" class="me-2">10000-50000<br>
            <br>OR<br><br>
            MAX
            <input type="number" class="w-50"><br>
            MIN
            <input type="number" class="w-50">
            <br>
            <button class="btn">SUBMIT</button>
        </div>
    </div>
</div>
    <cfoutput>
        <div class="link">
            <h3>
                <a href="index.cfm">
                    Home >
                </a>
                #subCategoryName.fldSubCategoryName#
            </h3>
        </div>
        <div class="d-flex listProducts">
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