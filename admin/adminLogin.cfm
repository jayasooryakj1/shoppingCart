<!DOCTYPE html>
<html lang="en">
    <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <link rel="stylesheet" href="../css/bootstrap-5.0.2-dist/bootstrap-5.0.2-dist/css/bootstrap.min.css">
        <link rel="stylesheet" href="css/adminLoginStyle.css">
        <title>Admin Login</title>
    </head>
    <body>
        <div class="p-3 adminLoginHeader">
            <h4>SHOPPING CART</h4>
        </div>
        <div class="d-flex justify-content-center align-items-center flex-column">
            <div class="adminLoginBody d-flex justify-content-center align-items-center flex-column pt-5">
                <h5><u>ADMIN LOGIN</u></h5>
                <div>
                    <form action="" method="post" class="d-flex justify-content-center align-items-center flex-column mt-2">
                        <div class="mt-3"><input class="adminInputBox ps-3" id="adminUserName" name="adminUserName" type="text" placeholder="User Name"></div>
                        <div id="adminUserNameError"></div>
                        <div class="mt-3"><input class="adminInputBox ps-3" id="adminPassword" name="adminPassword" type="password" placeholder="Password"></div>
                        <div id="adminPasswordError"></div>
                        <div class="mt-4 mb-5"><input type="submit" class="px-5 btn submitButton" name="submit" onclick="adminLoginValidation()"></div>
                    </form>   
                </div>
            </div>
        </div>
        <cfif structKeyExists(form, "submit")>
            <cfset adminObject = createObject("component","components.adminComponent")>
            <cfset result = adminObject.adminlogin(
                adminUserName=form.adminUserName,
                adminPassword=form.adminPassword
            )>
            <cfif result=="true">
                <cflocation  url="./index.cfm">
            <cfelse>
                <div class="d-flex justify-content-center">
                    <cfoutput>
                        #result#
                    </cfoutput>
                </div>
            </cfif>
        </cfif>
        <script src="./js/script.js"></script>
    </body>
</html>