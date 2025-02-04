<cfif structKeyExists(form, "addAddress")>
    <cfset variables.addAddress = application.userObject.addAddress(
        userId = session.userId,
        firstName = form.addressFirstName,
        lastName = form.addresslastName,
        line1 = form.addressLine1,
        line2 = form.addressLine2,
        city = form.addressCity,
        state = form.addressState,
        pincode = form.addressPincode,
        phone = form.addressPhone
    )>
</cfif>

<cfset variables.address = application.userObject.getAddress(
    userId = session.userId
)>

<cfset variables.orderSummary = application.userObject.displayCart(
    userId = session.userId
)>

<cfif structKeyExists(form, "makePayment")>
    <cfset variables.payment = application.userObject.makePayment(
        userId = session.userId,
        cardNumber = form.cardNumber,
        cardCcv = form.cardCcv,
        addressId = form.selectedAddress
    )>
</cfif>


<cfinclude  template="./userHeader.cfm">

    <cfoutput>
        <cfif queryRecordCount(variables.orderSummary)>
            <form method="post">
                <div class="d-flex">
                    <div class="accordion w-75" id="accordionExample">
                        <div class="accordion-item">
                            <h2 class="accordion-header py-2" id="headingOne">
                                <button class="accordion-button" type="button" data-bs-toggle="collapse" data-bs-target="##collapseOne" aria-expanded="true" aria-controls="collapseOne">
                                    <h4>Select Address</h4>
                                </button>
                            </h2>
                            <div id="collapseOne" class="accordion-collapse collapse show" aria-labelledby="headingOne" data-bs-parent="##accordionExample">
                                <div class="accordion-body">
                                    <div>
                                        <button type="button" class="btn btn-outline-primary m-2 p-2" data-bs-toggle="modal" data-bs-target="##staticBackdrop">
                                            ADD ADDRESS +
                                        </button>
                                    </div>
                                    <cfloop query="variables.address">
                                        <div class="border w-100 mb-3 p-3 d-flex" name="addressId" value="#variables.address.fldAddress_ID#" id="address#variables.address.fldAddress_ID#">
                                            <div>
                                                <input type="radio" name="selectedAddress" value="#variables.address.fldAddress_Id#" checked="checked">
                                            </div>
                                            <div class="w-25 d-flex justify-content-center">
                                                #variables.address.fldFirstName# #variables.address.fldLastName#<br>
                                                #variables.address.fldPhoneNumber#
                                            </div>
                                            <div class="w-50 d-flex justify-content-center align-items-center">
                                                #variables.address.fldAddressLine1#,
                                                #variables.address.fldAddressLine2#,<br>
                                                #variables.address.fldCity#,
                                                #variables.address.fldState#,<br>
                                                #variables.address.fldPincode#.
                                            </div>
                                        </div>
                                    </cfloop>
                                </div>
                            </div>
                        </div>
                        <div class="accordion-item">
                            <h2 class="accordion-header py-2 border-top" id="headingTwo">
                                <button class="accordion-button collapsed" type="button" data-bs-toggle="collapse" data-bs-target="##collapseTwo" aria-expanded="false" aria-controls="collapseTwo">
                                    <h4>Order Summary</h4>
                                </button>
                            </h2>
                            <div id="collapseTwo" class="accordion-collapse collapse" aria-labelledby="headingTwo" data-bs-parent="##accordionExample">
                                <div class="accordion-body">
                                    <cfloop query="variables.orderSummary">
                                        <cfset unitPrice = variables.orderSummary.fldPrice+variables.orderSummary.fldTax>
                                        <div id="itemCard#variables.orderSummary.fldCart_ID#" class="d-flex p-4 align-items-center border mb-4 m-2">
                                            <div class="w-25 p-2">
                                                <a href="./productPage.cfm?productId=#variables.orderSummary.fldProductId#"><img src="assets/productImages/#variables.orderSummary.fldImageFileName#" class="w-100" alt=""></a>
                                            </div>
                                            <div class="w-75 ms-5">
                                                <div class="link"><a href="./productPage.cfm?productId=#variables.orderSummary.fldProductId#"><h4>#variables.orderSummary.fldProductName#</h4></a></div>
                                                <div>#variables.orderSummary.fldBrandName#</div>
                                                <div>
                                                    Quantity: 
                                                    <button class="btn btn-danger px-3" 
                                                        onclick="updateQuantity(
                                                            '-',
                                                            #variables.orderSummary.fldCart_ID#,
                                                            #(variables.orderSummary.fldPrice + variables.orderSummary.fldTax)#
                                                        )"
                                                    >
                                                        -
                                                    </button>
                                                    <span id = "cartQuantity#variables.orderSummary.fldCart_ID#"> 
                                                        #variables.orderSummary.fldQuantity# 
                                                    </span>
                                                    <button class="btn btn-success" 
                                                        onclick="updateQuantity(
                                                            '+',
                                                            #variables.orderSummary.fldCart_ID#,
                                                            #(variables.orderSummary.fldPrice + variables.orderSummary.fldTax)#
                                                            
                                                        )"
                                                    >
                                                        +
                                                    </button>
                                                    <button class="btn btn-outline-danger ms-5" value="#variables.orderSummary.fldCart_ID#" onclick="deleteCart(this)">REMOVE</button>
                                                </div>
                                                <div>Price: <i class="fa-solid fa-indian-rupee-sign"></i> <span id="price#variables.orderSummary.fldCart_ID#">#variables.orderSummary.fldPrice#</div>
                                                <div class="mt-1">Tax: <i class="fa-solid fa-indian-rupee-sign"></i> <span id="tax#variables.orderSummary.fldCart_ID#">#variables.orderSummary.fldTax#</span></div>
                                                <div class="mt-1">Total Price: 
                                                    <i class="fa-solid fa-indian-rupee-sign"></i> 
                                                    <span id="total#variables.orderSummary.fldCart_ID#">#(variables.orderSummary.fldPrice + variables.orderSummary.fldTax)*variables.orderSummary.fldQuantity#</span>
                                                </div>
                                            </div>
                                        </div>
                                    </cfloop>
                                </div>
                            </div>
                        </div>
                        <div class="accordion-item">
                            <h2 class="accordion-header py-2 border-top" id="headingThree">
                                <button class="accordion-button collapsed" type="button" data-bs-toggle="collapse" data-bs-target="##collapseThree" aria-expanded="false" aria-controls="collapseThree">
                                    <h4>Payment</h4>
                                </button>
                            </h2>
                            <div id="collapseThree" class="accordion-collapse collapse" aria-labelledby="headingThree" data-bs-parent="##accordionExample">
                                <div class="accordion-body">
                                    <div class="d-flex">
                                        <div class="d-flex align-items-center justify-content-around w-100">
                                            <div>
                                                CARD NUMBER <input name="cardNumber" type="numeric" title="input 16 digit card number" maxlength="16" pattern="[0-9]{16}" required> 
                                            </div>
                                            <div>
                                                CVV <input name="cardCcv" type="password" title="enter 3 digit cvv" maxlength="3" pattern="[0-9]{3}" inputmode="numeric" required>
                                            </div>
                                        </div>
                                    </div>
                                </div>
                                <div class="p-3 d-flex align-items-center justify-content-center">
                                    <cfif queryRecordCount(address)>
                                        <div>
                                            <button class="btn btn-warning" type="submit" name="makePayment" id="paymentButton">MAKE PAYMENT</button>
                                        </div>
                                    <cfelse>
                                        <div class="text-danger">
                                            ADD AN ADDRESS TO CONTINUE PAYMENT
                                        </div>
                                    </cfif>
                                    <cfif structKeyExists(variables, "payment")>
                                        <cfif variables.payment>
                                                <cflocation  url="orderHistory.cfm">
                                        <cfelse>
                                            <div class="text-danger ms-5">
                                                Payment Credentials mismatch
                                            </div>
                                        </cfif>
                                    </cfif>
                                </div>
                            </div>
                        </div>
                    </div>
                    <div class="border p-4 border totalCard ms-2">
                        <cfset variables.totalQuantity = 0>
                        <cfset variables.totalPrice = 0>
                        <cfset variables.actualPrice = 0>
                        <cfset variables.totalTax = 0>
                        <cfloop query="variables.orderSummary">
                            <cfset variables.totalQuantity = variables.totalQuantity + variables.orderSummary.fldQuantity>
                            <cfset variables.actualPrice = variables.actualPrice + (variables.orderSummary.fldQuantity * variables.orderSummary.fldPrice)>
                            <cfset variables.totalTax = variables.totalTax + (variables.orderSummary.fldQuantity * variables.orderSummary.fldTax)>
                            <cfset variables.totalPrice = variables.actualPrice + variables.totalTax>
                        </cfloop>
                        <h5>Total Quantity : <span id="totalQuantity">#totalQuantity#</span></h5>
                        <br>
                        <h5>Actual Price : <i class="fa-solid fa-indian-rupee-sign"></i> <span id="totalActualPrice">#actualPrice#</span></h5>
                        <br>
                        <h5>Total Tax : <i class="fa-solid fa-indian-rupee-sign"></i> <span id="totalTax">#totalTax#</span></h5>
                        <br>
                        <h5>Total Price : <i class="fa-solid fa-indian-rupee-sign"></i> <span id="totalPrice">#totalPrice#</span></h5>
                    </div>
                </div>
            </form>

            <div class="modal fade" id="staticBackdrop" data-bs-backdrop="static" data-bs-keyboard="false" tabindex="-1" aria-labelledby="staticBackdropLabel" aria-hidden="true">
                <div class="modal-dialog">
                    <div class="modal-content">
                        <div class="modal-header">
                            <h5 class="modal-title" id="staticBackdropLabel">ADD ADDRESS</h5>
                            <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
                        </div>
                        <form method="post">
                            <div class="modal-body d-flex flex-column justify-content-center align-items-center">
                                <div>
                                    <input type="text" placeholder="FIRST NAME" name="addressFirstName" class="form-control mb-3" required>
                                </div>
                                <div>
                                    <input type="text" placeholder="LAST NAME" name="addressLastName" class="form-control mb-3" required>
                                </div>
                                <div>
                                    <input type="text" placeholder="ADDRESS LINE 1" name="addressLine1" class="form-control mb-3" required>
                                </div>
                                <div>
                                    <input type="text" placeholder="ADDRESS LINE 2" name="addressLine2" class="form-control mb-3" required>
                                </div>
                                <div>
                                    <input type="text" placeholder="CITY" name="addressCity" class="form-control mb-3" required>
                                </div>
                                <div>
                                    <input type="text" placeholder="STATE" name="addressState" class="form-control mb-3" required>
                                </div>
                                <div>
                                    <input type="tel" placeholder="PINCODE" name="addressPincode" pattern="[0-9]{6}" class="form-control mb-3" required>
                                </div>
                                <div>
                                    <input type="tel" placeholder="PHONE NUMBER" name="addressPhone" pattern="[0-9]{10}" class="form-control mb-3" required>
                                </div>
                            </div>
                            <div class="modal-footer">
                                <button type="submit" name="addAddress" class="btn btn-primary">SUBMIT</button>
                            </div>
                        </form>
                    </div>
                </div>
            </div>
        <cfelse>
            NO PRODUCTS ADDED TO BUY
        </cfif>
    </cfoutput>

<cfinclude  template="./userFooter.cfm">