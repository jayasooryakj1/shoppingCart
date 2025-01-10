if ( window.history.replaceState ) {
    window.history.replaceState( null, null, window.location.href );
}

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

function addCategory() {
    document.getElementById("staticBackdropLabel").innerHTML="ADD CATEGORY";
    document.getElementById("categoryNameField").value="";
    document.getElementById("modalSubmit").name="createCategory";
}

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