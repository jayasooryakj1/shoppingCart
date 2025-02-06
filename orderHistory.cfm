<cfset variables.orderDetails = application.userObject.getHistory(
    userId = session.userId
)>

<cfif structKeyExists(form, "searchHistory")>
    <cfset variables.orderDetails = application.userObject.getHistory(
        userId = session.userId,
        searchOrderId = form.searchOrderId
    )>
</cfif>

<cfinclude  template="./userHeader.cfm">
    <cfoutput>
        <div class="d-flex flex-column align-items-center justify-content-center">
            <form method="post">
                <div class="d-flex align-items-center justify-content-center m-4 w-100">
                    <div class="w-100">
                        <input class="px-2 py-1 w-100" name="searchOrderId" type="text" placeholder="ENTER ORDER ID">
                    </div>
                    <div class="ms-1">
                        <button class="btn btn-primary p-1" name="searchHistory">SEARCH</button>
                    </div>
                </div>
            </form>
            <cfif structKeyExists(form, "searchHistory") AND LEN(form.searchOrderID)>
                <cfif queryRecordCount(variables.orderDetails)>
                    <div>
                        <h4>SEARCH RESULTS FOR "#form.searchOrderId#"</h4><br>
                    </div>
                <cfelseif form.searchOrderId NEQ "">
                    <h4>NO SEARCH RESULTS FOUND FOR "#form.searchOrderId#"</h4><br>
                </cfif>
            </cfif>
            <cfloop query="variables.orderDetails" group="fldOrder_ID">
                <div class="border d-flex flex-column justify-content-center w-75">
                    <div class="bg-danger text-light px-5 py-1 d-flex align-items-center justify-content-between">
                        <div>
                            #variables.orderDetails.fldOrder_ID#
                        </div>
                        <div>
                            <a href="historyDownload.cfm?orderId=#variables.orderDetails.fldOrder_ID#">
                                <button class="btn"><i class="fa-solid fa-download"></i></button>
                            </a>
                        </div>
                    </div>
                    <cfquery name="variables.orderItems" dbtype="query">
                        SELECT
                            fldProductId,
                            fldUnitPrice,
                            fldUnitTax,
                            fldQuantity,
                            fldProductName,
                            fldProductId,
                            fldImageFileName,
                            fldBrandName,
                            fldOrderDate
                        FROM
                            variables.orderDetails
                        WHERE
                            fldOrder_ID = '#variables.orderDetails.fldOrder_ID#'
                    </cfquery>
                    <div class="link">
                        <cfloop query="variables.orderItems">
                            <a href="productPage.cfm?productId=#variables.orderItems.fldProductId#">
                                <div class="d-flex border justify-content-center align-items-center py-3">
                                    <div class="w-75 ms-5">
                                        <h3>#variables.orderItems.fldProductName#</h3>
                                        <h5>#variables.orderItems.fldBrandName#</h5>
                                        Price: #variables.orderItems.fldUnitPrice#<br>
                                        Tax: #variables.orderItems.fldUnitTax#<br>
                                        Quantity: #variables.orderItems.fldQuantity#<br>
                                    </div>
                                    <div class="w-50">
                                        <div class="d-flex flex-column justify-content-center align-items-center mb-2 p-1 w-25">
                                            <img src="assets/productImages/#variables.orderItems.fldImageFileName#" alt="productImage" class="w-100">
                                        </div>
                                    </div>
                                </div>
                            </a>
                        </cfloop>
                        <div class="d-flex align-items-center justify-content-between pe-5">
                            <div class="ps-5 py-3">
                                Delivery Address:<br>
                                #variables.orderDetails.fldFirstName# #variables.orderDetails.fldLastName#,<br>
                                #variables.orderDetails.fldPhoneNumber#
                            </div>
                            <div>
                                #variables.orderDetails.fldAddressLine1#, #variables.orderDetails.fldAddressLine2#,<br>
                                #variables.orderDetails.fldCity#, #variables.orderDetails.fldState#,<br>
                                #variables.orderDetails.fldPincode#
                            </div>
                        </div>
                        <cfset variables.orderDate = variables.orderDetails.fldOrderDate.toString()>
                        <div class="d-flex align-items-center justify-content-between bg-dark text-light px-5 py-1">
                            <div>
                                Total Price: #variables.orderDetails.fldTotalPrice+variables.orderDetails.fldTotalTax#
                            </div>
                            <div>
                                Order Date: #dateFormat(variables.orderDate, "dd/mm/yyyy")#
                            </div>
                        </div>
                    </div>
                </div>
            </cfloop>
        </div>

    </cfoutput>
<cfinclude  template="./userFooter.cfm">