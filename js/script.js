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