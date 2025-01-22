<cfif structKeyExists(form, "loginSubmit")>
    <cfset userLogin = application.userObject.userLogin(
        email = form.email,
        password = form.password
    )>
</cfif>

<!DOCTYPE html>
<html lang="en">
    <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <link rel="stylesheet" href="./css/userStyle.css">
        <link rel="stylesheet" href="../css/bootstrap-5.0.2-dist/bootstrap-5.0.2-dist/css/bootstrap.min.css">
        <link rel="stylesheet" href="./css/bootstrap-5.0.2-dist/bootstrap-5.0.2-dist/css/bootstrap.min.css">
        <link rel="stylesheet" href="../css/userStyle.css">
        <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.7.2/css/all.min.css" integrity="sha512-Evv84Mr4kqVGRNSgIGL/F/aIDqQb7xQ2vcrdIwxfjThSH8CSR7PBEakCr51Ck+w+/U6swU2Im1vVX0SVk9ABhg==" crossorigin="anonymous" referrerpolicy="no-referrer" />
        <cfset fileName = listLast(cgi.HTTP_URL, '/')>
        <cfif fileName EQ "userSignUp.cfm">
            <title>User Sign Up</title>
        </cfif>
    </head>
    <body>
        <div class="userHeader d-flex align-items-center p-3">
            <div class="link">
                <h3><a href="index.cfm"> SHOPPING CART </a></h3>
            </div>
            <cfset fileName = listLast(cgi.SCRIPT_NAME, '/')>
            <cfset pagesWithNoSearchBar = ["userSignUp.cfm", "userLogin.cfm"]>
            <cfif NOT arrayFind(pagesWithNoSearchBAr, fileName)>
                <form action="./userSubCategoryPage.cfm" method="get">
                    <div class="searchBar w-100 d-flex align-items-center">
                        <div><input type="text" name="search" placeholder="Search" class="w-100 px-4 rounded-pill border border-none"></div>
                        <div><button class="btn btn-light ms-1 p-1">Search</butotn></div>
                        </div>
                </form>
            </cfif>
            <cfset pagesWithNoLogin = ["userSignUp.cfm", "userLogin.cfm"]>
            <cfif NOT arrayFind(pagesWithNoLogin, fileName)>
                <cfif structKeyExists(session, "userId")>
                    <div>
                        <button class="btn btn-primary" onclick="logout()">LOGOUT</button> 
                    </div>
                <cfelse>
                    <div>
                        <button type="button" class="btn btn-success" data-bs-toggle="modal" data-bs-target="#staticBackdrop">LOGIN</button> 
                    </div>
                </cfif>
            </cfif>
        </div>

        <form method="post">
            <div class="modal fade" id="staticBackdrop" data-bs-backdrop="static" data-bs-keyboard="false" tabindex="-1" aria-labelledby="staticBackdropLabel" aria-hidden="true">
                <div class="modal-dialog">
                    <div class="modal-content">
                    <div class="modal-header">
                        <h5 class="modal-title" id="staticBackdropLabel">LOGIN</h5>
                        <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
                    </div>
                    <div class="modal-body">
                        <div class="d-flex flex-column justify-content-center align-items-center">
                            <div class="ms-3">
                                EMAIL:
                                <input type="text" name="email" required>
                                <br><br>
                            </div>
                            <div class="me-4">
                                PASSWORD:
                                <input type="password" name="password" required>
                                <br><br>
                            </div>
                        </div>
                    </div>
                    <div class="modal-footer">
                        <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Close</button>
                        <button type="submit" class="btn btn-success" name="loginSubmit">LOGIN</button>
                    </div>
                    </div>
                </div>
            </div>
        </form>