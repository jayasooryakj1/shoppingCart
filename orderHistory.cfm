<cfif structKeyExists(form, "searchHistory")>
    <cfset variables.orderDetails = application.userObject.getHistory(
        userId = session.userId,
        searchOrderId = form.searchOrderId
    )>
<cfelse>
    <cfset variables.orderDetails = application.userObject.getHistory(
        userId = session.userId
    )>
</cfif>

<cfinclude  template="./userHeader.cfm">
    <cfoutput>
        <div class="d-flex flex-column align-items-center justify-content-center mb-5">
            <form method="post">
                <div class="d-flex align-items-center justify-content-center m-4 w-100">
                    <div class="w-100">
                        <input class="px-2 py-1 w-100" id="historySearchInput" name="searchOrderId" type="text" placeholder="ENTER ORDER ID">
                    </div>
                    <div class="ms-1">
                        <button class="btn btn-primary p-1" name="searchHistory">SEARCH</button>
                    </div>
                    <div class="ms-1">
                        <button class="btn btn-warning p-1" name="clearSearch">CLEAR</button>
                    </div>
                </div>
            </form>
            <cfif structKeyExists(form, "searchHistory") AND structKeyExists(form, "searchOrderID") AND len(form.searchOrderID)>
                <cfif queryRecordCount(variables.orderDetails)>
                    <div>
                        <h4>SEARCH RESULTS FOR "#form.searchOrderId#"</h4><br>
                    </div>
                <cfelseif form.searchOrderId NEQ "">
                    <h4>NO SEARCH RESULTS FOUND FOR "#form.searchOrderId#"</h4><br>
                </cfif>
            </cfif>
            <cfloop query="variables.orderDetails" group="orderId">
                <div class="border d-flex flex-column justify-content-center w-75 mb-4">
                    <div class="bg-danger text-light px-5 py-1 d-flex align-items-center justify-content-between">
                        <div>
                            #variables.orderDetails.orderId#
                        </div>
                        <div>
                            <a href="invoiceDownload.cfm?orderId=#variables.orderDetails.orderId#" target="_blank">
                                <button class="btn"><i class="fa-solid fa-download"></i></button>
                            </a>
                        </div>
                    </div>
                    <cfquery name="variables.orderItems" dbtype="query">
                        SELECT
                            productId,
                            unitPrice,
                            unitTax,
                            quantity,
                            productName,
                            productId,
                            image,
                            brandName,
                            orderDate
                        FROM
                            variables.orderDetails
                        WHERE
                            orderId = '#variables.orderDetails.orderId#'
                    </cfquery>
                    <div>
                        <cfloop query="variables.orderItems">
                            <div class="d-flex border justify-content-center align-items-center py-3">
                                <div class="w-75 ms-5">
                                    <h3>#variables.orderItems.productName#</h3>
                                    <h5>#variables.orderItems.brandName#</h5>
                                    Price: #variables.orderItems.unitPrice#<br>
                                    Tax: #variables.orderItems.unitTax#<br>
                                    Quantity: #variables.orderItems.quantity#<br>
                                </div>
                                <div class="w-50">
                                    <div class="d-flex flex-column justify-content-center align-items-center mb-2 p-1 w-25">
                                        <a href="productPage.cfm?productId=#variables.orderItems.productId#">
                                            <img src="assets/productImages/#variables.orderItems.image#" alt="productImage" class="w-100">
                                        </a>
                                    </div>
                                </div>
                            </div>
                        </cfloop>
                        <div class="d-flex align-items-center justify-content-between pe-5 p-2 bg-secondary text-white">
                            <div class="ps-5 py-3">
                                Delivery Address:<br>
                            </div>
                            <div>
                                #variables.orderDetails.firstName# #variables.orderDetails.lastName#,<br>
                                #variables.orderDetails.line1#, #variables.orderDetails.line2#,<br>
                                #variables.orderDetails.city#, #variables.orderDetails.state#,#variables.orderDetails.pincode#.<br>
                                #variables.orderDetails.phone#
                            </div>
                        </div>
                        <cfset variables.orderDate = variables.orderDetails.orderDate.toString()>
                        <div class="d-flex align-items-center justify-content-between bg-dark text-light px-5 py-1">
                            <div>
                                Total Price: #variables.orderDetails.totalPrice+variables.orderDetails.totalTax#
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