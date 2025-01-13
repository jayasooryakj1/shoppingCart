if ( window.history.replaceState ) {
    window.history.replaceState( null, null, window.location.href );
}

// ADMIN LOGIN
function adminLoginValidation(){
    document.getElementById("adminUserNameError").innerHTML=""
    document.getElementById("adminPasswordError").innerHTML=""
    var adminUserName = document.getElementById("adminUserName").value;
    var adminPassword = document.getElementById("adminPassword").value;
    if (adminUserName=="") {
        document.getElementById("adminUserNameError").innerHTML="Enter User Name";
        document.getElementById("adminUserNameError").style.color="red";
        event.preventDefault();
    }
    if (adminPassword=="") {
        document.getElementById("adminPasswordError").innerHTML="Enter Password";
        document.getElementById("adminPasswordError").style.color="red";
        event.preventDefault();
    }
}

// ADMIN LOGOUT
function logout(){
    if(confirm("Logout?")){
        $.ajax({
            type:"post",
            url:"components/adminComponent.cfc?method=logoutFunction",
            success:function(result){
                if(result){
                    location.reload();
                }
            }
        })
    }
}

// CATEGORY
// ADD CATEGORY
function addCategory() {
    document.getElementById("staticBackdropLabel").innerHTML="ADD CATEGORY";
    document.getElementById("categoryNameField").value="";
    document.getElementById("modalSubmit").name="createCategory";
}

// AUTO POPULATE CATEGORY
function autoPopulateCategory(editCategoryId) {
    document.getElementById("staticBackdropLabel").innerHTML="EDIT CATEGORY";
    document.getElementById("modalSubmit").name="editCategory";
    document.getElementById("categoryIdField").value=editCategoryId.value;
    $.ajax({
        type:"POST",
        url:"./Components/adminComponent.cfc?method=autoPopulateCategory",
        data:{editCategoryId:editCategoryId.value},
        success: function(result) {
            document.getElementById("categoryNameField").value=result;
        }
    });
}

// DELETE CATEGORY
function deleteCategory(deleteCategoryId) {
    if (confirm("Delete category?")) {
        $.ajax({
            type:"post",
            url:"components/adminComponent.cfc?method=deleteCategory",
            data:{deleteCategoryId:deleteCategoryId.value},
            success:function(){
                    document.getElementById(deleteCategoryId.value).remove()
            }
        })
    }
}

// SUB CATEGORY
// ADD SUB CATEGORY
function addSubCategory(subCategoryStuct) {
    document.getElementById("categorySelect").value=subCategoryStuct.categoryId;
    document.getElementById("staticBackdropLabel").innerHTML="ADD SUB CATEGORY";
    document.getElementById("subCategoryNameField").value="";
    document.getElementById("subCategorySubmit").value=0;
}

// AUTO POPULATE SUB CATEGORY
function autoPopulateSubCategory(subCategoryStruct) {
    document.getElementById("categorySelect").value=subCategoryStruct.categoryId;
    document.getElementById("subCategoryNameField").value=subCategoryStruct.subCategoryName;
    document.getElementById("modalSubmit").value=1;
    document.getElementById("subCategoryIdField").value=subCategoryStruct.subCategoryId;
}

// DELETE SUB CATEGORY
function deleteSubCategory(deleteSubCategoryId) {
    if (confirm("Delete sub category?")) {
        $.ajax({
            type:"post",
            url:"components/adminComponent.cfc?method=deleteSubCategory",
            data:{deleteSubCategoryId:deleteSubCategoryId.value},
            success:function(){
                    document.getElementById(deleteSubCategoryId.value).remove()
            }
        })
    }
}

// PRODUCT
// ADD PRODUCT
function addProduct(productStruct) {
    document.getElementById("staticBackdropLabel").innerHTML="ADD PRODUCT";
    document.getElementById("productSubmit").value=1;
}

// 