<!DOCTYPE html>
<html lang="en">
    <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <link rel="stylesheet" href="./css/userStyle.css">
        <link rel="stylesheet" href="../css/bootstrap-5.0.2-dist/bootstrap-5.0.2-dist/css/bootstrap.min.css">
        <link rel="stylesheet" href="./css/bootstrap-5.0.2-dist/bootstrap-5.0.2-dist/css/bootstrap.min.css">
        <link rel="stylesheet" href="../css/userStyle.css">
        <cfset fileName = listLast(cgi.HTTP_URL, '/')>
        <cfif fileName EQ "userSignUp.cfm">
            <title>User Sign Up</title>
        </cfif>
    </head>
    <body>
        <div class="userHeader d-flex align-items-center p-3">
            <div>
                <h3>SHOPPING CART</h3>
            </div>
            <cfset pagesWithNoLogin= ["userSignUp.cfm", "userLogin.cfm"]>
            <cfset fileName = listLast(cgi.SCRIPT_NAME, '/')>
            <cfif NOT arrayFind(pagesWithNoLogin, fileName)>
                <div>
                    <button class="btn btn-primary" onclick="logout()">LOGOUT</button> 
                </div>
            </cfif>
        </div>