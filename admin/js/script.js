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

// CLEAR FROM
function clearFom() {
    form.reset();
}

// PRODUCT
// ADD PRODUCT
function addProduct(productStruct) {
    document.getElementById("staticBackdropLabel").innerHTML="ADD PRODUCT";
    document.getElementById("productSubmit").value=1;
    document.getElementById("categorySelect").value=productStruct.categoryId;
    document.getElementById("subCategorySelect").value=productStruct.subCategoryId;
    document.getElementById("brandSelect").value="";
    document.getElementById("modalProductDescription").value="";
    document.getElementById("modalProductPrice").value="";
    document.getElementById("modalProductTax").value="";
}

// 
function dropDownChange() {
    var categoryId = document.getElementById("categorySelect").value;
    var subCategorySelect = document.getElementById("subCategorySelect");
    $.ajax({
        type:"GET",
        url:"components/adminComponent.cfc?method=autoPopulateSubCategoryModal",
        data:{categoryId : categoryId},
        success:function(result){
            if(result)
            {
                subCategoryDetails=JSON.parse(result)
                while (subCategorySelect.options.length) {
                    subCategorySelect.remove(0);
                }
                for (var key in subCategoryDetails) {
                    if (subCategoryDetails.hasOwnProperty(key)) {
                      var option = document.createElement('option');
                      option.value = key; 
                      option.textContent = subCategoryDetails[key];
                      subCategorySelect.appendChild(option);
                    }
                }
            }else{
                alert("Error")
            }
        }
    });
}

// DELETE PRODUCT
function deleteProduct(deleteProductId) {
    if (confirm("Delete product?")) {
        $.ajax({
            type:"post",
            url:"components/adminComponent.cfc?method=deleteProduct",
            data:{deleteProductId:deleteProductId.value},
            success:function(){
                    document.getElementById(deleteProductId.value).remove()
            }
        })
    }
}

// EDIT PRODUCT AUTO POPULATE
function autoPopulateProduct(productStruct) {
    document.getElementById("staticBackdropLabel").innerHTML="EDIT PRODUCT";
    document.getElementById("categorySelect").value=productStruct.categoryId;
    document.getElementById("subCategorySelect").value=productStruct.subCategoryId;
    document.getElementById("modalProductName").value=productStruct.productName;
    document.getElementById("brandSelect").value=productStruct.productBrand;
    document.getElementById("modalProductDescription").value=productStruct.productDescription;
    document.getElementById("modalProductPrice").value=productStruct.productPrice;
    document.getElementById("modalProductTax").value=productStruct.productTax;
    document.getElementById("modalProductId").value=productStruct.productId;
    document.getElementById("productSubmit").value=0;
    document.getElementById("modalProductImages").removeAttribute("required");
}

// AUTO POPULATE EDIT IMAGE
function editImage(productStruct) {
    var editProductId = productStruct.productId;
    $.ajax({
        type:"post",
        url:"components/adminComponent.cfc?method=editProductImageAutoPopulate",
        data:{editProductId:editProductId},
        success:function(result){
            productImages=JSON.parse(result)
            var active = 1;
            for (var key in productImages) {
                if (productImages.hasOwnProperty(key)) {
                    var sliderBody = document.createElement('div');
                    var sliderImage = document.createElement('img');
                    sliderBody.value = key;
                    if (active == 1) {
                        sliderBody.classList.add("active");
                        active=0;
                    }
                    sliderBody.classList.add("carousel-item");
                    sliderImage.src="../assets/productimages/"+productImages[key];
                    sliderImage.width=350;
                    sliderBody.appendChild(sliderImage)
                    console.log(sliderBody)
                    document.getElementById("carousel-inner").appendChild(sliderBody)
                }
            }
        }
    })
}