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
    var flag = false;
    var max = document.getElementById("max").value;
    var min = document.getElementById("min").value;
    for (let i = 1; i < 4; i++) {
        var radio = document.getElementById("range"+i);
        if (radio.checked) {
           flag = true;
           var range = radio.value;
           break;
        }else{
            if (i == 3 && flag == false){
                    var range = `["${min}","${max}"]`;
                    flag = true
            }
        }
    }
    if (flag == true) {
        $.ajax({
            type:"post",
            url:"components/user.cfc?method=getProducts",
            data:{subCategoryId:subCategoryId,range:range},
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
}

function showMore(productIds, subCategoryId,sort){
    $.ajax({
        type:"post",
        url:"components/user.cfc?method=getProducts",
        data:{productIds:productIds,subCategoryId:subCategoryId,sort:sort},
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
                if (res.count) {
                    document.getElementById("notificationCounter").innerHTML = parseInt(document.getElementById("notificationCounter").innerHTML) + 1;
                }
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