<cfif structKeyExists(url, "orderId") AND structKeyExists(session, "userId") AND len(trim(url.orderId))>
    <cfset variables.orderDetails = application.userObject.getHistory(
        userId = session.userId,
        orderId = url.orderId
    )>

    <cfset local.fileName = dateTimeFormat(now(),"dd-mm-yyyy-hh-nn-ss")>
    <cfoutput>
        <cfheader name="content-disposition" value="attachment;filename=#url.orderId#(#local.fileName#).pdf">
        <cfdocument  
            format="PDF"
        >
            <cfset variables.orderDate = variables.orderDetails.orderDate.toString()>
            <table class="historyTable" padding="3">
                <tr>
                    <td colspan="3">
                        Order id
                    </td>
                    <td colspan="4" align="right">
                        #variables.orderDetails.orderId#
                    </td>
                </tr>
                <tr>
                    <th>Sl. No</th>
                    <th>Product Name</th>
                    <th>Brand</th>
                    <th>Price</th>
                    <th>Tax</th>
                    <th>Quantity</th>
                    <th>Total Price</th>
                </tr>
                <cfloop query="variables.orderDetails">
                    <tr>
                        <td>#variables.orderDetails.currentRow#</td>
                        <td>#variables.orderDetails.productName#</td>
                        <td>#variables.orderDetails.brandName#</td>
                        <td>#variables.orderDetails.unitPrice#</td>
                        <td>#variables.orderDetails.unitTax#</td>
                        <td>#variables.orderDetails.quantity#</td>
                        <td>#(variables.orderDetails.unitPrice+variables.orderDetails.unitTax)*variables.orderDetails.quantity#</td>
                    </tr>
                </cfloop>
                <tr>
                    <td colspan="3">
                        Total Price
                    </td>
                    <td colspan="4" align="right">
                        #variables.orderDetails.totalPrice+variables.orderDetails.totalTax#
                    </td>
                </tr>
                <tr>
                    <td rowspan="4" colspan="3">Delivery Address</td>
                    <td>Name</td>
                    <td align="right" colspan="3">#variables.orderDetails.firstName# #variables.orderDetails.lastName#</td>
                </tr>
                <tr>
                    <td colspan="4" align="right">
                        #variables.orderDetails.line1#, #variables.orderDetails.line2#,
                    </td>
                </tr>
                <tr>
                    <td colspan="4" align="right">
                        #variables.orderDetails.city#, #variables.orderDetails.state#,
                    </td>
                </tr>
                <tr>
                    <td colspan="4" align="right">
                        #variables.orderDetails.pincode#
                    </td>
                </tr>
                <tr>
                    <td colspan="3">
                        Phone no.
                    </td>
                    <td colspan="4" align="right">
                        #variables.orderDetails.phone#
                    </td>
                </tr>
                <tr>
                    <td colspan="3">
                        Order Date
                    </td>
                    <td colspan="4" align="right">
                        #dateFormat(variables.orderDate, "dd/mm/yyyy")#
                    </td>
                </tr>
            </table>
            <style>
                th, td {
                    padding: 10px;
                    border:1px solid black;
                }
            </style>
        </cfdocument>
    </cfoutput>
<cfelse>
    <div><center>ORDER ID NOT FOUND<center></div>
</cfif>