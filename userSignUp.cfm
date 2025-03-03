<cfif structKeyExists(form, "submit")>
    <cfset variables.result = application.userObject.userSignUp(
        firstName = form.firstName,
        lastName = form.lastName,
        email = form.email,
        phoneNumber = form.phoneNumber,
        password = form.password
    )>
</cfif>
    
<cfinclude  template="./userHeader.cfm">

    <div class="d-flex flex-column justify-content-center align-items-center">
        <form method="post">
            <div class="d-flex flex-column align-items-center justify-content-center mt-5 border rounded p-5">
                <div class="p-2">
                    <h4>SIGN UP</h4>
                </div>
                <cfif structKeyExists(form, "submit")>
                    <cfif structKeyExists(variables, "result") AND NOT variables.result>
                        <div class="text-danger">
                            Email already Exists
                        </div>
                    <cfelse>
                        <div class="text-danger">
                            User added
                        </div>
                    </cfif>
                </cfif>
                <div class="p-2 me-5">
                    First Name:
                    <input type="text" id="signupFirstName" name="firstName" required>
                    <div class="text-danger d-flex align-items-center justify-content-center" id="firstNameError"></div>
                </div>
                <div class="p-2 me-5">
                    Last Name:
                    <input type="text" id="signupLastName" name="lastName" required>
                    <div class="text-danger d-flex align-items-center justify-content-center" id="lastNameError"></div>
                </div>
                <div class="p-2 me-2">
                    Email:
                    <input type="email" id="signupEmail" name="email" required>
                    <div class="text-danger d-flex align-items-center justify-content-center" id="emailError"></div>
                </div>
                <div class="p-2 phoneInput">
                    Phone number:
                    <input type="tel" pattern="[0-9]{10}" title="Invalid phone number" id="signupPhone" name="phoneNumber" required>
                    <div class="text-danger d-flex align-items-center justify-content-center" id="phoneError"></div>
                </div>
                <div class="p-2 passwordInput">
                    Password:
                    <input type="password" id="signupPassword" name="password" minlength="8" required>
                    <div class="text-danger d-flex align-items-center justify-content-center" id="passwordError"></div>
                </div>
                <br>
                <div>
                    <button type="submit" name="submit" class="btn btn-success" onclick="return validateSignUp()">SUBMIT</button>
                </div>
            </div>
        </form>
        <div>
            <a href="./userLogin.cfm">LOGIN</a>
        </div>
    </div>

<cfinclude  template="./userFooter.cfm">