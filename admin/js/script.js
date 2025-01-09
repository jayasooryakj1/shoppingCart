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