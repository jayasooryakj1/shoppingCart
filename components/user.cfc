<cfcomponent>

    <!--- SIGN UP --->
    <cffunction  name="userSignUp" returntype="boolean">
        <cfargument  name="firstName" required="true" type="string">
        <cfargument  name="lastName" required="true" type="string">
        <cfargument  name="email" required="true" type="string">
        <cfargument  name="phoneNumber" required="true" type="string">
        <cfargument  name="password" required="true" type="string">
        <cfquery name="local.getEmail">
            SELECT
                fldEmail
            FROM
                tblUser
            WHERE
                fldEmail = <cfqueryparam value="#arguments.email#" cfsqltype="varchar">
        </cfquery>
        <cfif queryRecordCount(local.getEmail)>
            <cfreturn false>
        <cfelse>
            <cfset local.saltString = generateSecretKey("AES",128)>
            <cfset local.HashedPassword = hash("#arguments.password#"&"#local.saltString#","SHA-256","UTF-8")>
            <cfquery name="local.signUp">
                INSERT INTO
                    tblUser (
                        fldFirstName,
                        fldLastName,
                        fldEmail,
                        fldPhone,
                        fldRoleId,
                        fldHashedPassword,
                        fldUserSaltString
                    )
                VALUES (
                    <cfqueryparam value="#arguments.firstName#" cfsqltype="varchar">,
                    <cfqueryparam value="#arguments.lastName#" cfsqltype="varchar">,
                    <cfqueryparam value="#arguments.email#" cfsqltype="varchar">,
                    <cfqueryparam value="#arguments.phoneNumber#" cfsqltype="varchar">,
                    2,
                    <cfqueryparam value="#local.HashedPassword#" cfsqltype="varchar">,
                    <cfqueryparam value="#local.saltString#" cfsqltype="varchar">
                )
            </cfquery>
            <cfreturn true>
        </cfif>
    </cffunction>

    <!--- LOGIN --->
    <cffunction  name="userLogin" returntype="boolean">
        <cfargument  name="userName" required="true" type="string">
        <cfargument  name="password" required="true" type="string">
        <cfquery name="local.userValidation">
            SELECT
                fldUser_ID,
                fldUserSaltString,
                fldHashedPassword
            FROM
                tblUser
            WHERE
                (fldEmail = <cfqueryparam value="#arguments.userName#" cfsqltype="varchar"> 
                OR fldPhone = <cfqueryparam value="#arguments.userName#" cfsqltype="varchar">
                )
                AND fldActive = 1
        </cfquery>
        <cfif queryRecordCount(local.userValidation)>
            <cfset local.hashedPasswordInput = hash("#arguments.password#"&"#local.userValidation.fldUserSaltString#","SHA-256","UTF-8")>
            <cfif local.hashedPasswordInput EQ local.userValidation.fldHashedPassword>
                <cfset session.userId = local.userValidation.fldUser_ID>
                <cfreturn true>
            <cfelse>
                <cfreturn false>
            </cfif>
        <cfelse>
            <cfreturn false>
        </cfif>
    </cffunction>

    <!--- LOGOUT --->
    <cffunction  name="logoutFunction" access="remote" returntype="boolean">
        <cfset structClear(session)>
        <cfreturn true>
    </cffunction>
    
    <!--- SELECT RANDOM PRODUCTS --->
    <cffunction  name="getproductsInRandom" returntype="query">
        <cfquery name="local.randomProducts">
            SELECT
                fldProduct_ID,
                fldProductName,
                fldProductImage_ID,
                fldImageFileName,
                fldPrice,
                fldTax,
                fldBrandName
            FROM
                tblProduct AS P
            LEFT JOIN tblSubCategory AS S ON P.fldSubCategoryId = S.fldSubCategory_ID
            LEFT JOIN tblCategory AS C ON C.fldCategory_ID = S.fldCategoryId
            LEFT JOIN tblProductImages AS I ON P.fldProduct_ID = I.fldProductId
            LEFT JOIN tblBrands AS B ON P.fldbrandId = B.fldBrand_ID
            AND P.fldActive = 1
            WHERE
                P.fldActive = 1
                AND S.fldActive = 1
                AND C.fldActive = 1
                AND I.fldDefaultImage = 1
            ORDER BY
                RAND()
            LIMIT 
                12
        </cfquery>
        <cfreturn local.randomProducts>
    </cffunction>

    <!--- GET PRODUCT IMAGES --->
    <cffunction  name="getProductImages" returntype="query">
        <cfargument  name="productId" required="true" type="numeric">
        <cfquery name="local.getProductImages">
            SELECT
                fldImageFileName,
                fldDefaultImage
            FROM
                tblProductImages
            WHERE
                fldProductId = <cfqueryparam value="#arguments.productId#" cfsqltype="numeric">
                AND fldActive = 1
        </cfquery>
        <cfreturn local.getProductImages>
    </cffunction>

    <!--- GET PRODUCTS --->
    <cffunction  name="getProducts" returntype="query" access="remote" returnformat="json">
        <cfargument  name="search" required="false" type="string">
        <cfargument  name="categoryId" required="false" type="integer">
        <cfargument  name="subCategoryId" required="false" type="integer">
        <cfargument  name="productIds" required="false" type="string">
        <cfargument  name="sort" required="false" type="string">
        <cfargument  name="productId" required="false" type="integer">
        <cfargument  name="range" required="false" type="string">
        <cfargument  name="limit" required="false" type="integer">
        <cfif structKeyExists(arguments, "range")>
            <cfset local.range = deserializeJSON(arguments.range)>
        </cfif>
        <cfquery name="local.getProducts">
            SELECT
                fldProduct_ID,
                fldSubCategoryId,
                fldSubCategory_ID,
                fldProductName,
                fldBrandId,
                fldDescription,
                fldCategoryName,
                fldPrice,
                fldTax,
                fldCategory_ID,
                fldBrandName,
                fldBrandId,
                fldSubCategoryName,
                fldImageFileName
            FROM
                tblSubCategory AS S
            INNER JOIN tblCategory AS C ON C.fldCategory_ID = S.fldCategoryId AND C.fldActive = 1
            LEFT JOIN tblProduct AS P ON S.fldSubCategory_ID = P.fldSubCategoryId AND P.fldActive = 1
            LEFT JOIN tblProductImages AS I ON I.fldProductId = P.fldProduct_ID AND I.fldDefaultImage = 1
            LEFT JOIN tblBrands AS B ON P.fldBrandId = B.fldBrand_ID AND B.fldActive = 1
            WHERE
                S.fldActive = 1
                <cfif structKeyExists(arguments, "productId")>
                    AND P.fldProduct_ID = <cfqueryparam value="#arguments.productId#" cfsqltype="numeric">
                </cfif>

                <!--- FILTER --->
                <cfif structKeyExists(arguments, "range") AND (val(local.range[1]) OR val(local.range[2]))>
                    AND (fldPrice + fldTax) > <cfqueryparam value="#local.range[1]#" cfsqltype="numeric">
                    AND (fldPrice + fldTax) < <cfqueryparam value="#local.range[2]#" cfsqltype="numeric">
                </cfif>

                <!--- EXCLUDE  PRODUCTS --->
                <cfif structKeyExists(arguments, "productIds")>
                    AND P.fldProduct_ID NOT IN (<cfqueryparam value="#arguments.productIds#" cfsqltype="integer" list="true">)
                </cfif>

                <cfif structKeyExists(arguments, "categoryId")>
                    AND C.fldCategory_Id = <cfqueryparam value="#arguments.categoryId#" cfsqltype="numeric">
                </cfif>

                <cfif structKeyExists(arguments, "subCategoryId")>
                    AND S.fldSubCategory_Id = <cfqueryparam value="#arguments.subCategoryId#" cfsqltype="numeric">
                </cfif>

                <!--- SEARCH --->
                <cfif structKeyExists(arguments, "search")>
                    AND (
                        P.fldProductName LIKE <cfqueryparam value="%#arguments.search#%" cfsqltype="varchar">
                        OR B.fldBrandName LIKE <cfqueryparam value="%#arguments.search#%" cfsqltype="varchar">
                        OR P.fldDescription LIKE <cfqueryparam value="%#arguments.search#%" cfsqltype="varchar">
                    )
                </cfif>

                <!--- SORT --->
                <cfif structKeyExists(arguments, "sort")>
                    <cfif arguments.sort EQ "ASC">
                        ORDER BY (fldPrice + fldTax) ASC
                    <cfelse>
                        ORDER BY (fldPrice + fldTax) DESC
                    </cfif>
                <cfelse>
                    ORDER BY
                        fldSubCategoryId,
                        RAND()
                </cfif>
                <cfif structKeyExists(arguments, "limit")>
                    LIMIT
                        <cfqueryparam value="#arguments.limit#" cfsqltype="numeric">
                </cfif>
        </cfquery>
        <cfreturn local.getProducts>
    </cffunction>

    <!--- GET PRODUCT COUNT --->
    <cffunction  name="getProductsCount" returntype="query" access="remote" returnformat="json">
        <cfargument  name="search" required="false" type="string">
        <cfargument  name="subCategoryId" required="false" type="integer">
        <cfargument  name="sort" required="false" type="string">
        <cfif structKeyExists(arguments, "range")>
            <cfset local.range = deserializeJSON(arguments.range)>
        </cfif>
        <cfquery name="local.getProducts">
            SELECT
                COUNT(*) AS count
            FROM
                tblSubCategory AS S
            INNER JOIN tblCategory AS C ON C.fldCategory_ID = S.fldCategoryId AND C.fldActive = 1
            INNER JOIN tblProduct AS P ON S.fldSubCategory_ID = P.fldSubCategoryId AND P.fldActive = 1
            LEFT JOIN tblProductImages AS I ON I.fldProductId = P.fldProduct_ID AND I.fldDefaultImage = 1
            LEFT JOIN tblBrands AS B ON P.fldBrandId = B.fldBrand_ID AND B.fldActive = 1
            WHERE
                S.fldActive = 1
                <cfif structKeyExists(arguments, "subCategoryId")>
                    AND S.fldSubCategory_Id = <cfqueryparam value="#arguments.subCategoryId#" cfsqltype="numeric">
                </cfif>

                <!--- SEARCH --->
                <cfif structKeyExists(arguments, "search")>
                    AND (
                        P.fldProductName LIKE <cfqueryparam value="%#arguments.search#%" cfsqltype="varchar">
                        OR B.fldBrandName LIKE <cfqueryparam value="%#arguments.search#%" cfsqltype="varchar">
                        OR P.fldDescription LIKE <cfqueryparam value="%#arguments.search#%" cfsqltype="varchar">
                    )
                </cfif>

                <!--- SORT --->
                <cfif structKeyExists(arguments, "sort")>
                    <cfif arguments.sort EQ "ASC">
                        ORDER BY (fldPrice + fldTax) ASC
                    <cfelse>
                        ORDER BY (fldPrice + fldTax) DESC
                    </cfif>
                </cfif>
        </cfquery>
        <cfreturn local.getProducts>
    </cffunction>


    <!--- GET CATEGORY AND SUBCATEGORY --->
    <cffunction  name="getCategory" returntype="query">
        <cfquery name="local.getCategory">
            SELECT
                fldCategory_ID,
                fldCategoryName,
                fldSubCategory_ID,
                fldSubCategoryName
            FROM
                tblSubCategory AS S
            INNER JOIN tblCategory AS C ON C.fldCategory_ID = S.fldCategoryId AND S.fldActive = 1
            WHERE
                C.fldActive = 1
            ORDER BY
                fldCategory_ID  
        </cfquery>
        <cfreturn local.getCategory>
    </cffunction>

    <!--- DISPLAY CART --->
    <cffunction  name="displayCart" returntype="query" access="remote">
        <cfargument  name="userId" required="false" type="numeric">
        <cfargument  name="productId" required="false" type="numeric">
        <cfquery name="local.displayCart">
            SELECT
                fldCart_ID,
                C.fldProductId,
                fldProductName,
                fldPrice,
                fldTax,
                fldBrandName,
                fldQuantity,
                fldImageFileName
            FROM
                tblCart AS C
            LEFT JOIN tblProduct AS P ON C.fldProductId = P.fldProduct_ID
            LEFT JOIN tblProductImages AS I ON C.fldProductId = I.fldProductId
                AND I.fldDefaultImage = 1
            LEFT JOIN tblBrands AS B ON P.fldBrandId = b.fldBrand_ID
            WHERE C.fldUserId = <cfqueryparam value="#session.userId#" cfsqltype="numeric">
            <cfif structKeyExists(arguments, "productId")>
                AND C.fldProductId = <cfqueryparam value="#arguments.productId#" cfsqltype="numeric">
            </cfif>
        </cfquery>
        <cfreturn local.displayCart>
    </cffunction>

    <!--- ADD TO CART --->
    <cffunction  name="addToCart" returntype="struct" returnformat="JSON" access="remote">
        <cfargument  name="productId" required="true" type="numeric">
        <cfif structKeyExists(session, "userId")>
            <cfset local.productInCart = displayCart(
                productId = arguments.productId
            )>
            <cfif queryRecordCount(local.productInCart)>
                <cfset local.updateCart = updateCart(
                    updateType="+",
                    cartId=local.productInCart.fldCart_ID
                )>
            <cfelse>
                <cfset local.resultStruct["count"] = 1>
                <cfquery name="local.addToCart">
                    INSERT INTO
                        tblCart (
                            fldUserId,
                            fldProductId,
                            fldQuantity
                        )
                    VALUES (
                        <cfqueryparam value="#session.userId#" cfsqltype="numeric">,
                        <cfqueryparam value="#arguments.productId#" cfsqltype="numeric">,
                        1
                    )
                </cfquery>
            </cfif>
            <cfset local.resultStruct["success"]=true>
        <cfelse>
            <cfset local.resultStruct["redirect"]=true>
        </cfif>
        <cfreturn local.resultStruct>
    </cffunction>

    <!--- UPDATE CART --->
    <cffunction  name="updateCart" access="remote" returntype="boolean">
        <cfargument  name="updateType" required="true" type="string">
        <cfargument  name="cartId" required="true" type="numeric">
        <cfquery name="local.updateCartQuery">
            UPDATE
                tblCart
            SET
                <cfif arguments.updateType EQ "-">
                    fldQuantity = fldQuantity - 1
                <cfelse>
                    fldQuantity = fldQuantity + 1
                </cfif>
            WHERE
                fldCart_ID = <cfqueryparam value="#arguments.cartId#" cfsqltype="numeric">
        </cfquery>
        <cfquery name="local.checkZero">
            SELECT 
                fldQuantity
            FROM
                tblCart
            WHERE
                fldCart_ID = <cfqueryparam value="#arguments.cartId#" cfsqltype="numeric">
        </cfquery>
        <cfif local.checkZero.fldQuantity EQ 0>
            <cfset deleteCart = deleteCart(
                cartId = arguments.cartId
            )>
        </cfif>
        <cfreturn true>
    </cffunction>

    <!--- DELETE CART --->
    <cffunction  name="deleteCart" access="remote" returntype="boolean">
        <cfargument  name="cartId" required="true" type="numeric">
        <cfquery name="local.deleteCart">
            DELETE FROM
                tblCart
            WHERE
                fldCart_ID = <cfqueryparam value="#arguments.cartId#" cfsqltype="numeric">
        </cfquery>
        <cfreturn true>
    </cffunction>

    <!--- GET USER DETAILS --->
    <cffunction  name="getUserDetails" returntype="query">
        <cfargument  name="userId" required="false" type="numeric">
        <cfargument  name="email" required="false" type="string">
        <cfquery name="local.userDetails">
            SELECT
                fldUser_ID,
                fldFirstName,
                fldLastName,
                fldEmail,
                fldPhone
            FROM
                tbluser
            WHERE
                <cfif structKeyExists(arguments, "userId")>
                    fldUser_ID = <cfqueryparam value="#arguments.userId#" cfsqltype="numeric">
                <cfelse>
                    fldEmail = <cfqueryparam value="#arguments.email#" cfsqltype="varchar">
                </cfif>
        </cfquery>
        <cfreturn local.userDetails>
    </cffunction>

    <!--- EDIT USER --->
    <cffunction  name="editUser" returntype="boolean">
        <cfargument  name="userId" type="numeric">
        <cfargument  name="firstName" type="string">
        <cfargument  name="lastName" type="string">
        <cfargument  name="email" type="string">
        <cfargument  name="phone" type="string">
        <cfset local.emailExists = getUserDetails(
            email = arguments.email
        )>
        <cfif queryRecordCount(local.emailExists) AND local.emailExists.fldUser_ID NEQ arguments.userId>
            <cfreturn false>
        <cfelse>
            <cfquery name="local.editUser">
                UPDATE
                    tblUser
                SET
                    fldFirstName = <cfqueryparam value="#arguments.firstName#" cfsqltype="varchar">,
                    fldLastName = <cfqueryparam value="#arguments.lastName#" cfsqltype="varchar">,
                    fldEmail = <cfqueryparam value="#arguments.email#" cfsqltype="varchar">,
                    fldPhone = <cfqueryparam value="#arguments.phone#" cfsqltype="varchar">
                WHERE
                    fldUser_ID = <cfqueryparam value="#arguments.userId#" cfsqltype="integer">
            </cfquery>
            <cfreturn true>
        </cfif>
    </cffunction>

    <!--- ADD ADDRESS --->
    <cffunction  name="addAddress" returntype="boolean">
        <cfargument  name="userId" required="true" type="numeric">
        <cfargument  name="firstName" required="true" type="string">
        <cfargument  name="lastName" required="true" type="string">
        <cfargument  name="line1" required="true" type="string">
        <cfargument  name="line2" required="true" type="string">
        <cfargument  name="city" required="true" type="string">
        <cfargument  name="state" required="true"type="string">
        <cfargument  name="pincode" required="true" type="string">
        <cfargument  name="phone" required="true" type="string">
        <cfquery name="local.addAddress">
            INSERT INTO
                tblAddress(
                    fldUserId,
                    fldFirstName,
                    fldLastName,
                    fldAddressLine1,
                    fldAddressLine2,
                    fldCity,
                    fldState,
                    fldPincode,
                    fldPhoneNumber
                )VALUES(
                    <cfqueryparam value="#arguments.userId#" cfsqltype="integer">,
                    <cfqueryparam value="#arguments.firstName#" cfsqltype="varchar">,
                    <cfqueryparam value="#arguments.lastName#" cfsqltype="varchar">,
                    <cfqueryparam value="#arguments.line1#" cfsqltype="varchar">,
                    <cfqueryparam value="#arguments.line2#" cfsqltype="varchar">,
                    <cfqueryparam value="#arguments.city#" cfsqltype="varchar">,
                    <cfqueryparam value="#arguments.state#" cfsqltype="varchar">,
                    <cfqueryparam value="#arguments.pincode#" cfsqltype="varchar">,
                    <cfqueryparam value="#arguments.phone#" cfsqltype="varchar">
            )
        </cfquery>
        <cfreturn true>
    </cffunction>

    <!--- GET ADDRESS --->
    <cffunction  name="getAddress" returntype="query">
        <cfargument  name="userId" required="true" type="numeric">
        <cfquery name="local.getAddress">
            SELECT
                fldAddress_ID,
                fldFirstName,
                fldLastName,
                fldAddressLine1,
                fldAddressLine2,
                fldCity,
                fldState,
                fldPincode,
                fldPhoneNumber
            FROM
                tblAddress
            WHERE
                fldUserId = <cfqueryparam value="#arguments.userId#" cfsqltype="integer">
                AND fldActive = 1
        </cfquery>
        <cfreturn local.getAddress>
    </cffunction>

    <!--- DELETE ADDRESS --->
    <cffunction  name="deleteAddress" returntype="boolean" access="remote">
        <cfargument  name="addressId" required="true" type="numeric">
        <cfquery name="local.deleteAddress">
            UPDATE
                tblAddress
            SET
                fldActive = 0
            WHERE
                fldAddress_ID = <cfqueryparam value="#arguments.addressId#" cfsqltype="numeric">
        </cfquery>
        <cfreturn true>
    </cffunction>

    <!--- MAKE PAYMENT --->
    <cffunction  name="makePayment" returntype="boolean">
        <cfargument  name="userId" required="true" type="numeric">
        <cfargument  name="cardNumber" required="true" type="numeric">
        <cfargument  name="cardCcv" required="true" type="numeric">
        <cfargument  name="addressId" required="true" type="numeric">
        <cfset local.number = 1234567890123456>
        <cfset local.ccv = 123>
        <cfset local.uuid = createUUID()>
        <cfif arguments.cardNumber EQ local.number AND arguments.cardCcv EQ local.ccv>
            <cfset local.user = getUserDetails(
                userId = arguments.userId
            )>
            <cfquery name="local.checkout">
                CALL checkout(
                    <cfqueryparam value="#arguments.userId#" cfsqltype="integer">,
                    <cfqueryparam value="#arguments.addressId#" cfsqltype="integer">,
                    3456,
                    <cfqueryparam value="#local.uuid#" cfsqltype="varchar">
                )
            </cfquery>
            <cfmail  from="abc@gmail.com"  subject="Order Placed"  to="#local.user.fldEmail#"> 
                Dear #local.user.fldFirstName#,
                    Your order, order id: #local.uuid#, has been successfully placed
            </cfmail>
            <cfreturn true>
        <cfelse>
            <cfreturn false>
        </cfif>
    </cffunction>

    <!--- GET HISTORY --->
    <cffunction  name="getHistory" returntype="query">
        <cfargument  name="userId" required="true" type="integer">
        <cfargument  name="orderId" required="false" type="string">
        <cfargument  name="searchOrderId" required="false" type="string">
        <cfquery name="local.historyDetails">
            SELECT
                fldOrder_ID,
                OI.fldProductId,
                fldTotalPrice,
                fldTotalTax,
                fldOrderDate,
                fldProductName,
                fldImageFileName,
                fldUnitPrice,
                fldUnitTax,
                OI.fldQuantity,
                fldBrand_ID,
                fldBrandName,
                fldFirstName,
                fldLastName,
                fldAddressLine1,
                fldAddressLine2,
                fldCity,
                fldState,
                fldPincode,
                fldPhoneNumber
            FROM
                tblProduct AS P
            LEFT JOIN tblOrderItems AS OI ON P.fldProduct_ID = OI.fldProductId
            LEFT JOIN tblOrder AS O ON OI.fldOrderId = O.fldOrder_ID
            LEFT JOIN tblProductImages AS PI ON PI.fldProductId = P.fldProduct_ID AND PI.fldDefaultImage = 1
            LEFT JOIN tblBrands AS B ON P.fldBrandId = B.fldBrand_ID
            LEFT JOIN tblAddress AS A ON O.fldAddressId = A.fldAddress_ID
            WHERE
                O.fldUserId = <cfqueryparam value="#arguments.userId#" cfsqltype="integer">
            <cfif structKeyExists(arguments, "orderId")>
                AND O.fldOrder_ID = <cfqueryparam value="#arguments.orderId#">
            <cfelseif structKeyExists(arguments, "searchOrderId")>
                AND O.fldOrder_ID LIKE <cfqueryparam value="%#arguments.searchOrderId#%" cfsqltype="varchar">
            </cfif>
        </cfquery>
        <cfreturn local.historyDetails>
    </cffunction>

</cfcomponent>