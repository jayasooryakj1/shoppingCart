<cfset productDetails = application.userObject.getProductDetails(
    productId = url.productId
)>

<cfinclude  template="./userHeader.cfm">

    <cfoutput>
        #productDetails.fldProduct_ID#
        #productDetails.fldSubCategoryId#
        #productDetails.fldDescription#
        #productDetails.fldProductName#
        #productDetails.fldProductImage_ID#
        #productDetails.fldImageFileName#
        #productDetails.fldPrice#
        #productDetails.fldTax#
    </cfoutput>

<cfinclude  template="./userFooter.cfm">