<cfset variables.orderDetails = application.userObject.getHistory(
    userId = session.userId,
    orderId = url.orderId
)>

<cfset variables.slNo = 1>

<cfoutput>
    <cfdocument  
        format="PDF"
    >
        <cfloop query="variables.orderDetails" group="fldOrder_ID">
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
            <cfset variables.orderDate = variables.orderDetails.fldOrderDate.toString()>
            <table class="historyTable" padding="3">
                <tr>
                    <td colspan="3">
                        Order id
                    </td>
                    <td colspan="4" align="right">
                        #variables.orderDetails.fldOrder_ID#
                    </td>
                </tr>
                <tr>
                    <th>sl. no</th>
                    <th>Product Name</th>
                    <th>Brand</th>
                    <th>Price</th>
                    <th>Tax</th>
                    <th>Quantity</th>
                    <th>Total Price</th>
                </tr>
                <cfloop query="variables.orderItems">
                    <tr>
                        <td>#variables.slNo#</td>
                        <td>#variables.orderItems.fldProductName#</td>
                        <td>#variables.orderItems.fldBrandName#</td>
                        <td>#variables.orderItems.fldUnitPrice#</td>
                        <td>#variables.orderItems.fldUnitTax#</td>
                        <td>#variables.orderItems.fldQuantity#</td>
                        <td>#(variables.orderItems.fldUnitPrice+variables.orderItems.fldUnitTax)*variables.orderItems.fldQuantity#</td>
                        <cfset variables.slNo = variables.slNo + 1>
                    </tr>
                </cfloop>
                <tr>
                    <td colspan="3">
                        Total Price
                    </td>
                    <td colspan="4" align="right">
                        #variables.orderDetails.fldTotalPrice+variables.orderDetails.fldTotalTax#
                    </td>
                </tr>
                <tr>
                    <td rowspan="4" colspan="3">Delivery Address</td>
                    <td>Name</td>
                    <td align="right" colspan="3">#variables.orderDetails.fldFirstName# #variables.orderDetails.fldLastName#</td>
                </tr>
                <tr>
                    <td colspan="4" align="right">
                        #variables.orderDetails.fldAddressLine1#, #variables.orderDetails.fldAddressLine2#,
                    </td>
                </tr>
                <tr>
                    <td colspan="4" align="right">
                        #variables.orderDetails.fldCity#, #variables.orderDetails.fldState#,
                    </td>
                </tr>
                <tr>
                    <td colspan="4" align="right">
                        #variables.orderDetails.fldPincode#
                    </td>
                </tr>
                <tr>
                    <td colspan="3">
                        Phone no.
                    </td>
                    <td colspan="4" align="right">
                        #variables.orderDetails.fldPhoneNumber#
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
        </cfloop>
        <style>
            th, td {
                padding: 10px;
                border:1px solid black;
            }
        </style>
    </cfdocument>
</cfoutput>