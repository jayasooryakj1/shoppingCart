<cfif structKeyExists(form, "addAddress")>
    <cfset variables.addAddress = application.userObject.addAddresses(
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

<cfset variables.address = application.userObject.getAddresses(
    userId = session.userId
)>

<cfset variables.userDetails = application.userObject.getUserDetails(
    userId = session.userId
)>

<cfinclude  template="./userHeader.cfm">

    <cfoutput>
        <div class=" border d-flex flex-column justify-content-center align-items-center">
            <div class="border w-75 d-flex justify-content-center align-items-center p-4 m-3">
                <div class="d-flex w-25 flex-column justify-content-center align-items-center">
                    <div>
                        <h4 id="profileUserName">#variables.userDetails.fldFirstName#</h4>
                    </div>
                    <div>   
                        email: <span id="profileUserMailId">#variables.userDetails.fldEmail#</span>
                    </div>
                </div>
                <div>
                    <button type="button" class="btn p-2" data-bs-toggle="modal" data-bs-target="##staticBackdrop2">
                        <i class="fa-solid fa-pen-to-square" style="color: ##74C0FC;"></i>
                    </button>
                </div>
            </div>
                <div class="d-flex w-50 align-items-center justify-content-between">
                    <div>
                        <button type="button" class="btn btn-outline-primary m-2 p-2" data-bs-toggle="modal" data-bs-target="##staticBackdrop">
                            ADD ADDRESS +
                        </button>
                    </div>
                    <div>
                        <a href="orderHistory.cfm">
                            <button type="button" class="btn btn-outline-success m-2 p-2">
                                ORDER HISTORY
                            </button>
                        </a>
                    </div>
                </div>
            <cfloop query="variables.address">
                <div class="border w-75 mt-3 mb-3 p-3 d-flex" id="address#variables.address.fldAddress_ID#">
                    <div class="w-25 d-flex justify-content-center">
                        #variables.address.fldFirstName# #variables.address.fldLastName#<br>
                        #variables.address.fldPhoneNumber#
                    </div>
                    <div class="w-50 d-flex justify-content-center align-items-center">
                        #variables.address.fldAddressLine1#,<br>
                        #variables.address.fldAddressLine2#,<br>
                        #variables.address.fldCity#,<br>
                        #variables.address.fldState#,<br>
                        #variables.address.fldPincode#.
                    </div>
                    <div class="w-25 d-flex justify-content-center align-items-center">
                        <button class="btn btn-outline-danger" value="#variables.address.fldAddress_ID#" onclick="deleteAddress(this)">REMOVE</button>
                    </div>
                </div>
            </cfloop>
        </div>

        <!--- EDIT USER PROFILE MODAL --->
        <form method="post"
            onsubmit="return editUser(#session.userId#)" 
        >
            <div class="modal fade" id="staticBackdrop2" data-bs-backdrop="static" data-bs-keyboard="false" tabindex="-1" aria-labelledby="staticBackdropLabel" aria-hidden="true">
                <div class="modal-dialog">
                    <div class="modal-content">
                    <div class="modal-header">
                        <h5 class="modal-title" id="staticBackdropLabel">EDIT USER DETAILS</h5>
                        <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
                    </div>
                        <div class="modal-body d-flex flex-column align-items-center justify-content-center">
                            <div>
                                First Name
                                <input type="text" id="modalFirstName" name="firstName" value="#userDetails.fldFirstName#" placeholder="FIRST NAME" class="form-control mb-2">
                            </div>
                            <br>
                            <div>
                                Last Name
                                <input type="text" id="modalLastName" name="lastName" value="#userDetails.fldLastName#" placeholder="LAST NAME" class="form-control mb-2">
                            </div>
                            <br>
                            <div>
                                Email
                                <input type="text" id="modalEmail" name="email" value="#userDetails.fldEmail#" placeholder="EMAIL" class="form-control mb-2">
                            </div>
                            <br>
                            <div>
                                Phone Number
                                <input type="number" id="modalPhone" name="phone" value="#userDetails.fldPhone#" placeholder="PHONE NUMBER" class="form-control mb-2">
                            </div>
                        </div>
                        <div class="modal-footer">
                            <button type="submit" name="editUserButton" class="btn btn-primary">
                                SUBMIT
                            </button>
                        </div>     
                    </div>
                </div>
            </div>
        </form>

        <!-- ADD ADDRESS MODAL -->
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

    </cfoutput>

<cfinclude  template="./userFooter.cfm">