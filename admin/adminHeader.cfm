<!DOCTYPE html>
<html lang="en">
    <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <link rel="stylesheet" href="css/adminStyle.css">
        <link rel="stylesheet" href="css/adminLoginStyle.css">
        <link rel="stylesheet" href="../css/bootstrap-5.0.2-dist/bootstrap-5.0.2-dist/css/bootstrap.min.css">
        <title>Admin Dashboard</title>
    </head>
    <body>

        <div class="d-flex adminHeader p-3">
            <div>Admin Dashboard</div>
            <cfset fileName = listLast(cgi.SCRIPT_NAME, '/')>
            <cfif fileName NEQ "adminLogin.cfm">
                <div class="logout"><button class="btn logoutButton" onclick="logout()">LOGOUT</button></div>
            </cfif>
        </div>