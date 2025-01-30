
<cfset variables.randomProducts = application.userObject.getproductsInRandom()>

<cfinclude  template="./userHeader.cfm">

    <cfoutput>
        
        <div class="mt-5">
            <div class="d-flex randomProducts">
                <cfloop query="variables.randomProducts">
                    <div class="mt-5 d-flex flex-column justify-content-center align-items-center ms-5 border p-2 rounded">
                        <a href="productPage.cfm?productId=#variables.randomProducts.fldProduct_ID#">
                            <div class="randomProductDiv d-flex flex-column justify-content-center align-items-center mb-2 p-1">
                                <img src="assets/productImages/#variables.randomProducts.fldImageFileName#" alt="productImage">
                            </div>
                            <div>
                                #variables.randomProducts.fldProductName#
                            </div>
                            <div>
                                #variables.randomProducts.fldBrandName#
                            </div>
                            <div>
                                <i class="fa-solid fa-indian-rupee-sign"></i> #variables.randomProducts.fldPrice + variables.randomProducts.fldTax#
                            </div>
                        </a>
                    </div>
                </cfloop>
            </div>
        </div>
    </cfoutput>

<cfinclude  template="./userFooter.cfm">