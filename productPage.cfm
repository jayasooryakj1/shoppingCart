<cfset productImages = application.userObject.getProductImages(
    productId = url.productId
)>

<cfset productDetails = application.userObject.getProduct(
    productId = url.productId
)>

<cfinclude  template="./userHeader.cfm">

    <cfoutput>
        <div class="d-flex">
            <div>
                <div id="carouselExampleControls" class="carousel d-flex align-items-center justify-content-center slide" data-bs-ride="carousel">
                    <div class="carousel-inner">
                        <cfloop query="#productImages#">
                            <cfif productImages.fldDefaultImage EQ 1>
                                <div class="carousel-item active">
                            <cfelse>
                                <div class="carousel-item">
                            </cfif>
                                    <img src="assets/productImages/#productImages.fldImageFileName#" class="d-block w-100" alt="productImage">
                                </div>
                        </cfloop>
                    </div>
                    <button class="carousel-control-prev" type="button" data-bs-target="##carouselExampleControls" data-bs-slide="prev">
                      <span class="carousel-control-prev-icon" aria-hidden="true"></span>
                      <span class="visually-hidden">Previous</span>
                    </button>
                    <button class="carousel-control-next" type="button" data-bs-target="##carouselExampleControls" data-bs-slide="next">
                      <span class="carousel-control-next-icon" aria-hidden="true"></span>
                      <span class="visually-hidden">Next</span>
                    </button>
                </div>  
                <div class="d-flex mt-5 pt-5 justify-content-center align-items-center">
                    <div class="w-50"><button type="button" name="buy" class="w-100 btn btn-warning">BUY</button></div>
                    <div class="w-50"><button type="button" onclick="addToCart(#productDetails.fldProduct_ID#)" name="add" class="w-100 ms-1 btn btn-primary">ADD TO CART</button></div>
                </div>
            </div>
            <div class="ms-5 mt-5">
                <div>
                    <h3>#productDetails.fldProductName#</h3>
                </div>
                <div>
                    <h6>#productDetails.fldBrandName#</h6>
                </div>
                <div>
                    <cfset price = productDetails.fldPrice + productDetails.fldTax>
                    <h4><i class="fa-solid fa-indian-rupee-sign"></i> #price#</h4>
                </div>
                <div>
                    #productDetails.fldDescription#
                </div>
                <br>
                <div id="response" class="res">
                </div>
            </div>
        </div>
    </cfoutput>

<cfinclude  template="./userFooter.cfm">