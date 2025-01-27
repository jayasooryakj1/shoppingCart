<cfif structKeyExists(form, "loginSubmit")>
    <cfset result = application.userObject.userLogin(
        email = form.email,
        password = form.password
    )>
    <cfif result>
        <cfif structKeyExists(url, "productId")>
            <cfset addItemToCart = application.userObject.addToCart(
                productId = url.productId
            )>
            <cflocation  url="./productPage.cfm?productId=#url.productId#">
        <cfelse>
            <cflocation  url="index.cfm">
        </cfif>
    </cfif>
</cfif>


<cfinclude  template="./userHeader.cfm">

    <div class="d-flex justify-content-center align-items-center flex-column">
        <form method="post">
            <div class="d-flex justify-content-center align-items-center border rounded p-5 mt-5 flex-column">
                <div>
                    <h4>LOGIN</h4>
                </div>
                <div class="p-2">
                    Email:
                    <input type="email" name="email" required>
                </div>
                <div class="p-4 passwordInputLogin">
                    password:
                    <input type="password" name="password" required>
                </div>
                <div>
                    <button class="btn btn-success" name="loginSubmit" type="submit">SUBMIT</button>
                </div>
            </div>
        </form>
        <cfif structKeyExists(variables, "result") AND NOT result>
            <div>
                Invalid email or password
            </div>
        </cfif>
        <div>
            <a href="./userSignUp.cfm">SIGNUP</a>
        </div>
    </div>

<cfinclude  template="./userFooter.cfm">