<cfif structKeyExists(form, "loginSubmit")>
    <cfset variables.result = application.userObject.userLogin(
        userName = form.userName,
        password = form.password
    )>
    <cfif variables.result>
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
                    <input name="userName" required placeholder="Email/Phone">
                </div>
                <div class="p-2 passwordInputLogin">
                    <input type="password" name="password" required placeholder="password">
                </div>
                <div>
                    <button class="btn btn-success" name="loginSubmit" type="submit">SUBMIT</button>
                </div>
            </div>
        </form>
        <cfif structKeyExists(variables, "result") AND NOT variables.result>
            <div>
                Invalid email or password
            </div>
        </cfif>
        <div>
            <a href="./userSignUp.cfm">SIGNUP</a>
        </div>
    </div>

<cfinclude  template="./userFooter.cfm">