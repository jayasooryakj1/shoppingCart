<cfif structKeyExists(form, "submit")>
    <cfset result = application.userObject.userSignUp(
        firstName = form.firstName,
        lastName = form.lastName,
        email = form.email,
        phoneNumber = form.phoneNumber,
        password = form.password
    )>
    <cfif structKeyExists(variables, "result") AND result>
        <div>
            Email already Exists
        </div>
    <cfelse>
        <div>
            User added
        </div>
    </cfif>
</cfif>
    
<cfinclude  template="./userHeader.cfm">

    <div class="d-flex flex-column justify-content-center align-items-center">
        <form method="post">
            <div class="d-flex flex-column align-items-center justify-content-center mt-5 border rounded p-5">
                <div class="p-2">
                    <h4>SIGN UP</h4>
                </div>
                <div class="p-2 me-5">
                    First Name:
                    <input type="text" name="firstName" required>
                </div>
                <div class="p-2 me-5">
                    Last Name:
                    <input type="text" name="lastName" required>
                </div>
                <div class="p-2 me-2">
                    Email:
                    <input type="email" name="email" required>
                </div>
                <div class="p-2 phoneInput">
                    Phone number:
                    <input type="tel" pattern="[0-9]{10}" name="phoneNumber" required>
                </div>
                <div class="p-2 passwordInput">
                    Password:
                    <input type="password" name="password" minlength="8" required>
                </div>
                <br>
                <div>
                    <button type="submit" name="submit" class="btn btn-success">SUBMIT</button>
                </div>
            </div>
        </form>
        <div>
            <a href="./userLogin.cfm">LOGIN</a>
        </div>
    </div>

<cfinclude  template="./userFooter.cfm">