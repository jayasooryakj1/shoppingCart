<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <link rel="stylesheet" href="css/userHeaderStyle.css">
    <link rel="stylesheet" href="./css/bootstrap-5.0.2-dist/bootstrap-5.0.2-dist/css/bootstrap.min.css">
    <cfset fileName = listLast(cgi.PATH_TRANSLATED, '\')>
    <cfif fileName EQ "userSignUp.cfm">
        <title>User Sign Up</title>
    </cfif>
</head>
<body>
    <div class="userHeader">
        <h3 class="p-4">SHOPPING CART</h3>
    </div>
</body>
</html>