<cfif structKeyExists(form, "loginSubmit")>
    <cfset userLogin = application.userObject.userLogin(
        email = form.email,
        password = form.password
    )>
</cfif>
<cfset displayCategory = application.userObject.getCategory()>
<cfset displaySubCategory = application.userObject.getSubCategory()>
<!DOCTYPE html>
<cfoutput>

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
            <cfif NOT arrayFind(pagesWithNoSearchBar, fileName)>
                <form action="./userSubCategoryPage.cfm" method="get">
                    <div class="searchBar w-100 d-flex align-items-center">
                        <div><input type="text" name="search" placeholder="Search" class="w-100 px-4 rounded-pill border border-none" required></div>
                        <div><button class="btn btn-light ms-1 p-1">Search</butotn></div>
                        </div>
                </form>
            </cfif>
            <cfset pagesWithNoLogin = ["userSignUp.cfm", "userLogin.cfm"]>
            <cfif NOT arrayFind(pagesWithNoLogin, fileName)>
                <div>
                    <a href="./cart.cfm" class="cartIcon">
                        <i class="fa-solid fa-cart-shopping text-light"></i>
                        <cfif structKeyExists(session, "userId")>
                            <cfset cartCount = application.userObject.displayCart()>
                            <span class="badge" id="notificationCounter">
                                #queryRecordCount(cartCount)#
                            </span>
                        </cfif>
                    </a>
                </div>
            </cfif>
            <cfif NOT arrayFind(pagesWithNoLogin, fileName)>
                <cfif structKeyExists(session, "userId")>
                    <div>
                        <button class="btn btn-primary" onclick="logout()">LOGOUT</button> 
                    </div>
                <cfelse>
                    <div>
                        <a href="./userLogin.cfm">
                            <button type="button" class="btn btn-success" data-bs-toggle="modal" data-bs-target="##staticBackdrop">LOGIN</button> 
                        </a>
                    </div>
                </cfif>
            </cfif>
        </div>
        <div class="categoryBar">
        <cfloop query="displayCategory">
            <div class="dropDown">
                <a href="userCategoryPage.cfm?categoryId=#displayCategory.fldCategory_ID#">
                    #displayCategory.fldCategoryName#
                </a>
                <div class="tooltiptext">
                    <cfloop query="displaySubCategory">
                        <cfif displayCategory.fldCategory_ID EQ displaySubCategory.fldCategoryId>
                            <a href="userSubCategoryPage.cfm?subCategoryId=#displaySubCategory.fldSubCategory_ID#">
                                <button class="btn btn-light w-100">#displaySubCategory.fldSubCategoryName#</button>
                            </a>
                        </cfif>
                    </cfloop>
                </div>
            </div>
        </cfloop>
        </div>
</cfoutput>
<div class="p-3">