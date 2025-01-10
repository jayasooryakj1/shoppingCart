<!DOCTYPE html>
<html lang="en">
    <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <link rel="stylesheet" href="css/adminStyle.css">
        <link rel="stylesheet" href="../css/bootstrap-5.0.2-dist/bootstrap-5.0.2-dist/css/bootstrap.min.css">
        <title>Admin Dashboard</title>
    </head>
    <body>

        <cfset categoryObject = createObject("component", "components.adminComponent")>

        <!---<div class="d-flex adminHeader p-3">
            <div>Admin Dashboard</div>
            <div class="logout"><button class="btn logoutButton" onclick="logout()">LOGOUT</button></div>
        </div>--->
        <div class="d-flex flex-column align-items-center justify-content-center mt-5">
            <div>

                <button type="button" class="btn btn-primary" data-bs-toggle="modal" data-bs-target="#staticBackdrop" onclick="addCategory()">
                    ADD CATEGORY +
                </button>
                
            </div>
        </div>

        <cfif structKeyExists(form, "createCategory")>
            <cfset result = categoryObject.addCategory(
                categoryName=form.categoryName
            )>
            <cfif result>
                <div>Name already exists</div>
            </cfif>
        </cfif>

        <cfif structKeyExists(form, "editCategory")>
            <cfset result = categoryObject.editCategory(
                categoryName=form.categoryName,
                categoryId=form.categoryId
            )>
            <cfif result>
                <div>Name already exists</div>
            </cfif>
        </cfif>

        <!--- DISPLAY CATEGORIES --->
        <div class="d-flex justify-content-center align-items-center">
            <cfset categoriesDisplay = categoryObject.dipslayCategories()>
            <table class="border w-50 mt-3">
                <tr class="border">
                    <th class="w-75 categoryName">Category Name</th>
                    <th></th>
                    <th></th>
                    <th></th>
                </tr>
                <cfoutput>
                    <cfloop query="categoriesDisplay">
                        <tr class="border" id="#categoriesDisplay.fldCategory_ID#">
                            <td class="d-flex justify-content-center align-items-center w-75 py-3">#categoriesDisplay.fldCategoryName#</td>
                            <td><button class="btn btn-primary me-2" data-bs-toggle="modal" data-bs-target="##staticBackdrop" value="#categoriesDisplay.fldCategory_ID#" onclick="autoPopulateCategory(this)">Edit</button></td>
                            <td><button class="btn btn-danger me-2" value="#categoriesDisplay.fldCategory_ID#" onclick="deleteCategory(this)">Delete</button></td>
                            <td><a href="subCategoryPage.cfm" class="btn btn-success me-2" value="#categoriesDisplay.fldCategory_ID#">View</a></td>
                        </tr>
                    </cfloop>
                </cfoutput>
            </table>
        </div>

        <!--- ADD/EDIT CATEGORIES MODAL --->
        <div class="modal fade" id="staticBackdrop" data-bs-backdrop="static" data-bs-keyboard="false" tabindex="-1" aria-labelledby="staticBackdropLabel" aria-hidden="true">
            <div class="modal-dialog">
                <div class="modal-content">
                    <form method="post">
                        <div class="modal-header">
                            <h5 class="modal-title" id="staticBackdropLabel"></h5>
                            <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
                        </div>
                        <div class="modal-body">
                            CATEGORY NAME: 
                            <input name="categoryName" id="categoryNameField" type="text" required>
                            <input type="hidden" name="categoryId" id="categoryIdField">
                        </div>
                        <div class="modal-footer">
                            <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Close</button>
                            <input type="submit" name="" id="modalSubmit" value="SUBMIT" class="btn btn-secondary">
                        </div>
                    </form>
                </div>
            </div>
        </div>

        <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js" integrity="sha384-YvpcrYf0tY3lHB60NNkmXc5s9fDVZLESaAA55NDzOxhy9GkcIdslK1eN7N6jIeHz" crossorigin="anonymous"></script>
        <script src="../js/jquery-3.7.1.js"></script>
        <script src="./js/script.js"></script>
    </body>
</html>