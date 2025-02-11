function logout(){
    if(confirm("Logout?")){
        $.ajax({
            type:"post",
            url:"components/user.cfc?method=logoutFunction",
            success:function(result){
                if(result){
                    location.reload();
                }
            }
        })
    }
}

function filter(subCategoryId) {
    let max = document.getElementById("max").value;
    let min = document.getElementById("min").value;
    const radioIds = ["range1", "range2", "range3"];
    for (let id of radioIds) {
        let radioButton = document.getElementById(id);
        if (radioButton && radioButton.checked) {
            [min, max] = JSON.parse(radioButton.value);
        }
    }
    if (min == "") {
        min=-1;
        max=-1;
    }
    $.ajax({
        type:"post",
        url:"components/user.cfc?method=getProductsAsJson",
        data:{subCategoryId:subCategoryId,priceFrom:min,priceTo:max},
        success:function(result){
            $("#parentDiv").empty()
            var filterQuery = JSON.parse(result);
            let productItem 
            filterQuery.DATA.forEach(element => {
                productItem = `<div class="mt-5 d-flex flex-column justify-content-center align-items-center ms-5 border p-2 rounded">
                                    <a href="productPage.cfm?productId=${element[0]}">
                                        <div class="randomProductDiv d-flex flex-column justify-content-center align-items-center mb-2 p-1">
                                            <img src="assets/productImages/${element[13]}" alt="productImage">
                                        </div>
                                        <div>
                                            ${element[3]}
                                        </div>
                                        <div> 
                                            ${element[7] + element[8]}
                                        </div>
                                    </a>
                                </div>`
                $("#parentDiv").append(productItem)
                $("#showMore").remove();
            });
        }
    })
}

function showMore(excludedProductIds, subCategoryId,sort){
    $.ajax({
        type:"post",
        url:"components/user.cfc?method=getProducts",
        data:{excludedProductIds:excludedProductIds,subCategoryId:subCategoryId,sort:sort},
        success:function (result) {
            var filterQuery = JSON.parse(result);
                let productItem 
                filterQuery.DATA.forEach(element => {
                    productItem = `<div class="mt-5 d-flex flex-column justify-content-center align-items-center ms-5 border p-2 rounded">
                                        <a href="productPage.cfm?productId=${element[0]}">
                                            <div class="randomProductDiv d-flex flex-column justify-content-center align-items-center mb-2 p-1">
                                                <img src="assets/productImages/${element[13]}" alt="productImage">
                                            </div>
                                            <div>
                                                ${element[3]}
                                            </div>
                                            <div> 
                                                ${element[7] + element[7]}
                                            </div>
                                        </a>
                                    </div>`
                    $("#parentDiv").append(productItem)
                });
            $("#showMore").remove();
        }
    })
}

function addToCart(productId) {
    $.ajax({
        type:"post",
        url:"components/user.cfc?method=addToCart",
        data:{productId:productId},
        success:function (result) {
            var res = JSON.parse(result);
            if (res.redirect) {
                location.href="../userLogin.cfm?productId="+productId;
            }else{
                document.getElementById("notificationCounter").innerHTML = res.count;
                document.getElementById("response").innerHTML="Item added to cart"
            }
        }
    })
}

function clearFilter() {
    $('[name=priceRange]'). prop('checked', false);
    $("#min").val("");
    $("#max").val("");
}

function updateQuantity(updateType, cartId, unitPrice) {
    $.ajax({
        type:"post",
        url:"components/user.cfc?method=updateCart",
        data:{updateType:updateType,cartId:cartId},
        success:function (result) {
            let res = JSON.parse(result)
            if (res.result) {
                if (updateType == "+") {
                    document.getElementById("cartQuantity"+cartId).innerHTML = Number(document.getElementById("cartQuantity"+cartId).innerHTML)+1;
                    document.getElementById("total"+cartId).innerHTML = Number(document.getElementById("total"+cartId).innerHTML)+unitPrice;
                    document.getElementById("totalQuantity").innerHTML = Number(document.getElementById("totalQuantity").innerHTML)+1;
                    document.getElementById("totalActualPrice").innerHTML = Number(document.getElementById("totalActualPrice").innerHTML) + Number(document.getElementById("price"+cartId).innerHTML)
                    document.getElementById("totalTax").innerHTML = Number(document.getElementById("totalTax").innerHTML) + Number(document.getElementById("tax"+cartId).innerHTML);
                    document.getElementById("totalPrice").innerHTML = (Number(document.getElementById("totalActualPrice").innerHTML)) + (Number(document.getElementById("totalTax").innerHTML));
                }else if (updateType == "-") {
                    document.getElementById("cartQuantity"+cartId).innerHTML = Number(document.getElementById("cartQuantity"+cartId).innerHTML)-1;
                    document.getElementById("total"+cartId).innerHTML = Number(document.getElementById("total"+cartId).innerHTML)-unitPrice;
                    document.getElementById("totalQuantity").innerHTML = Number(document.getElementById("totalQuantity").innerHTML)-1;
                    document.getElementById("totalActualPrice").innerHTML = Number(document.getElementById("totalActualPrice").innerHTML) - Number(document.getElementById("price"+cartId).innerHTML)
                    document.getElementById("totalTax").innerHTML = Number(document.getElementById("totalTax").innerHTML) - Number(document.getElementById("tax"+cartId).innerHTML);
                    document.getElementById("totalPrice").innerHTML = Number(document.getElementById("totalActualPrice").innerHTML) + Number(document.getElementById("totalTax").innerHTML);
                    if (document.getElementById("cartQuantity"+cartId).innerHTML == 0) {
                        deleteCart({value:cartId})
                    }
                }
            }else{
                alert("Error updating cart")
            }
        }
    })
}

function deleteCart(cartId) {
    $.ajax({
        type:"post",
        url:"components/user.cfc?method=deleteCart",
        data:{cartId:cartId.value},
        success:function(result){
            let res = JSON.parse(result)
            if (res.success) {
                document.getElementById("totalQuantity").innerHTML = Number(document.getElementById("totalQuantity").innerHTML) - (Number(document.getElementById("cartQuantity"+cartId.value).innerHTML));
                document.getElementById("totalActualPrice").innerHTML = Number(document.getElementById("totalActualPrice").innerHTML) - (Number(document.getElementById("cartQuantity"+cartId.value).innerHTML)*Number(document.getElementById("price"+cartId.value).innerHTML));
                document.getElementById("totalTax").innerHTML = Number(document.getElementById("totalTax").innerHTML) - (Number(document.getElementById("cartQuantity"+cartId.value).innerHTML)*Number(document.getElementById("tax"+cartId.value).innerHTML));
                document.getElementById("totalPrice").innerHTML = Number(document.getElementById("totalActualPrice").innerHTML) + Number(document.getElementById("totalTax").innerHTML);
                document.getElementById("itemCard"+cartId.value).remove();
                document.getElementById("notificationCounter").innerHTML = res.count;
                var quantity = Number(document.getElementById("totalQuantity").innerHTML);
                if (quantity == 0) {
                    document.getElementById("paymentButton").remove();
                }
            }else{
                alert("Delete unsuccessfull");
            }
        }
    })
}

function deleteAddress(addressId) {
    if(confirm("Delete address?")){
        $.ajax({
            type:"post",
            url:"components/user.cfc?method=deleteAddress",
            data:{addressId:addressId.value},
            success:function(result){
                let res = JSON.parse(result);
                if (res.success) {
                    document.getElementById("address"+addressId.value).remove();
                }else{
                    alert("Error deleting address")
                }
            }
        })
    }
}

function editUser(userId) {
    let firstName = document.getElementById("modalFirstName").value;
    let lastName =  document.getElementById("modalLastName").value;
    let email =  document.getElementById("modalEmail").value;
    let phone = document.getElementById("modalPhone").value;
    $.ajax({
        type:"post",
        url:"components/user.cfc?method=editUser",
        data:{userId:userId,firstName:firstName,lastName:lastName,email:email,phone:phone},
        success:function (result) {
            var res = JSON.parse(result);
            if (res.error) {
                alert(res.error)
            }else{
                alert(res.success)
                document.getElementById("profileUserName").innerHTML=res.firstName;
                document.getElementById("modalLastName").value=res.lastName;
                document.getElementById("modalFirstName").value=res.firstName;
                document.getElementById("profileUserMailId").innerHTML=res.email;
                document.getElementById("modalPhone").value=res.phoneNumber;
            }
        }
    })
    return false;
}