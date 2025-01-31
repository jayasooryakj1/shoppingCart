<cfset variables.displayCart = application.userObject.displayCart()>
<cfinclude  template="./userHeader.cfm">
    <cfoutput>
        <div class="d-flex align-item-center justify-content-center p-5">
            <div class="w-75 mb-5">
                <cfloop query="variables.displayCart">
                        <cfset unitPrice = variables.displayCart.fldPrice+variables.displayCart.fldTax>
                        <div id="itemCard#variables.displayCart.fldCart_ID#" class="d-flex p-4 align-items-center border mb-4">
                            <div class="w-25 p-2">
                                <a href="./productPage.cfm?productId=#variables.displayCart.fldProductId#"><img src="assets/productImages/#variables.displayCart.fldImageFileName#" class="w-100" alt=""></a>
                            </div>
                            <div class="w-75 ms-5">
                                <div class="link"><a href="./productPage.cfm?productId=#variables.displayCart.fldProductId#"><h4>#variables.displayCart.fldProductName#</h4></a></div>
                                <div>#variables.displayCart.fldBrandName#</div>
                                <div>
                                    Quantity: 
                                    <button class="btn btn-danger px-3" 
                                        onclick="updateQuantity(
                                            '-',
                                            #variables.displayCart.fldCart_ID#,
                                            #(variables.displayCart.fldPrice + variables.displayCart.fldTax)#
                                        )"
                                    >
                                        -
                                    </button>
                                    <span id = "cartQuantity#variables.displayCart.fldCart_ID#"> 
                                        #variables.displayCart.fldQuantity# 
                                    </span>
                                    <button class="btn btn-success" 
                                        onclick="updateQuantity(
                                            '+',
                                            #variables.displayCart.fldCart_ID#,
                                            #(variables.displayCart.fldPrice + variables.displayCart.fldTax)#
                                            
                                        )"
                                    >
                                        +
                                    </button>
                                    <button class="btn btn-outline-danger ms-5" value="#variables.displayCart.fldCart_ID#" onclick="deleteCart(this)">REMOVE</button>
                                </div>
                                <div>Price: <i class="fa-solid fa-indian-rupee-sign"></i> <span id="price#variables.displayCart.fldCart_ID#">#variables.displayCart.fldPrice#</div>
                                <div class="mt-1">Tax: <i class="fa-solid fa-indian-rupee-sign"></i> <span id="tax#variables.displayCart.fldCart_ID#">#variables.displayCart.fldTax#</span></div>
                                <div class="mt-1">Total Price: 
                                    <i class="fa-solid fa-indian-rupee-sign"></i> 
                                    <span id="total#variables.displayCart.fldCart_ID#">#(variables.displayCart.fldPrice + variables.displayCart.fldTax)*variables.displayCart.fldQuantity#</span>
                                </div>
                            </div>
                        </div>
                </cfloop>
            </div>
            <div>
                <div class="w-100 p-4 border totalCard ms-3">
                    <cfset variables.totalQuantity = 0>
                    <cfset variables.totalPrice = 0>
                    <cfset variables.actualPrice = 0>
                    <cfset variables.totalTax = 0>
                    <cfloop query="variables.displayCart">
                        <cfset variables.totalQuantity = variables.totalQuantity + variables.displayCart.fldQuantity>
                        <cfset variables.actualPrice = variables.actualPrice + (variables.displayCart.fldQuantity * variables.displayCart.fldPrice)>
                        <cfset variables.totalTax = variables.totalTax + (variables.displayCart.fldQuantity * variables.displayCart.fldTax)>
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
                <div class="ms-3 w-100 mt-4">
                    <button class="btn btn-outline-warning w-100"><b>BUY TOGETHER</b></button>
                </div>
            </div>
        </div>
    </cfoutput>
<cfinclude  template="./userFooter.cfm">