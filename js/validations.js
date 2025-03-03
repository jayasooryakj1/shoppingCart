function validateText(textInput, errorId) {
    let input = document.getElementById(textInput).value;
    if (input == "" || input.match(/^ *$/) !== null) {
        document.getElementById(errorId).innerHTML = "INPUT REQUIRED";
        return false;
    }else{
        document.getElementById(errorId).innerHTML = "";
        return true;
    }
}

function validateNumber(numberInput, errorId, digit = 0) {
    let input = document.getElementById(numberInput).value;
    if (input == "" || input.match(/^ *$/) !== null) {
        document.getElementById(errorId).innerHTML = "INPUT REQUIRED";
        return false;
    }else if(isNaN(input) == true){
        document.getElementById(errorId).innerHTML = "INPUT MUST BE A NUMBER";
        return false;
    }else if (digit == 0) {
        document.getElementById(errorId).innerHTML = "";
        return true;
    }else if(input.toString().length != 0){
        if(input.toString().length != digit){
            document.getElementById(errorId).innerHTML = "INPUT MUST BE A "+digit+" DIGIT NUMBER";
            return false;
        }
        else{
            document.getElementById(errorId).innerHTML = "";
            return true;
        }
    }else{
        document.getElementById(errorId).innerHTML = "";
        return true;
    }
}

function validateProduct() {
    let productImage = document.getElementById("modalProductImages").files;
    let allowedExtensions = /(\.jpg|\.jpeg|\.png)$/i;
    let flag = true;
    const maxSize = 1048576;
    if (productImage.length === 0) {
        document.getElementById("imageWarning").innerHTML="Product image should be added";
    }else {
        var file = productImage[0];  
        var fileName = file.name;  
        if (!allowedExtensions.test(fileName)) {
            document.getElementById("imageWarning").innerHTML="Allowed extensions are JPG/JPEG/PNG";
            flag = false;
        } else if (file.size > maxSize) {
            document.getElementById("imageWarning").innerHTML="File size should not exceed 1MB";
            flag = false;
        } else {
            document.getElementById("imageWarning").innerHTML="";
        }
    }
    if (flag==false) {
        event.preventDefault();
    }

    let productResult = validateText('modalProductName','productNameError');
    let brandResult = validateText('brandSelect','brandError');
    let descResult =  validateText('modalProductDescription','descriptionError');
    let priceResult = validateNumber('modalProductPrice','priceError');
    let taxResult = validateNumber('modalProductTax','taxError');
    if (productResult != true || brandResult != true || descResult != true || priceResult != true || taxResult != true) {
        return false;
    }else {
        document.getElementById(errorId).innerHTML = "";
        return true;
    }
}

function validateSignUp(){
    let firstNameResult = validateText('signupFirstName', 'firstNameError');
    let lastNameResult = validateText('signupLastName', 'lastNameError');
    let emailResult = validateText('signupEmail', 'emailError');
    let phoneResult = validateNumber('signupPhone', 'phoneError', 10);
    let passwordResult = validateText('signupPassword', 'passwordError');
    if (firstNameResult != true || lastNameResult != true || emailResult != true || phoneResult != true || passwordResult != true) {
        return false;
    }else {
        document.getElementById(errorId).innerHTML = "";
        return true;
    }
}

function validateEditProfile(){
    let firstNameResult = validateText('modalFirstName', 'profileFirstNameError');
    let lastNameResult = validateText('modalLastName', 'profileLastNameError');
    let emailResult = validateText('modalEmail', 'profileEmailError');
    let phoneResult = validateNumber('modalPhone', 'profilePhoneError', 10);
    if (firstNameResult != true || lastNameResult != true || emailResult != true || phoneResult != true) {
        return false;
    }else {
        document.getElementById(errorId).innerHTML = "";
        return true;
    }
}

function validateAddAddress(){
    let firstNameResult = validateText('firstNameAddress', 'addressFirstNameError');
    let lastNameResult = validateText('lastNameAddress', 'addressLastNameError');
    let line1Result = validateText('line1Address', 'addressLine1Error');
    let line2Result = validateText('line2Address', 'addressLine2Error');
    let cityResult = validateText('cityAddress', 'addressCityError');
    let stateResult = validateText('stateAddress', 'addressStateError');
    let pincodeResult = validateNumber('pincodeAddress', 'addressPincodeError', 6);
    let phoneResult = validateNumber('phoneAddress', 'addressPhoneError', 10);
    if (firstNameResult != true || lastNameResult != true || phoneResult != true || line1Result != true || line2Result != true || cityResult != true || stateResult != true || pincodeResult != true) {
        return false;
    }else {
        document.getElementById(errorId).innerHTML = "";
        return true;
    }
}