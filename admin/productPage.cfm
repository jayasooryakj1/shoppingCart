<cfinclude  template="./adminHeader.cfm">
    <cfset productObject = createObject("component", "components.adminComponent")>
    <cfoutput>

            <div class="d-flex flex-column align-items-center justify-content-center mt-5">
                <button type="button" class="btn btn-primary" data-bs-toggle="modal" data-bs-target="##staticBackdrop"
                onclick="addProduct({subCategoryId:#url.subCategoryId#,categoryId:#url.categoryId#})">
                    ADD PRODUCT +
                </button>
            </div>

            <cfif structKeyExists(form, "productSubmitButton")>
                <cfif form.productSubmitButton EQ 1>
                    <cfset result = productObject.addProduct(
                        subCategoryId = form.subCategoryId,
                        productName = form.productName,
                        brandId = form.brandId,
                        productDescription = form.productDescription,
                        productPrice = form.productPrice,
                        productTax = form.productTax,
                        productImages = form.productImages
                    )>
                    <cfif result>
                        <div>Name already exists</div>
                    </cfif>
                <cfelse>
                    <cfif isDefined("form.productImages") AND form.productImages IS NOT "">
                        <cfset result = productObject.editProduct(
                            subCategoryId = form.subCategoryId,
                            productName = form.productName,
                            brandId = form.brandId,
                            productDescription = form.productDescription,
                            productPrice = form.productPrice,
                            productTax = form.productTax,
                            productId = form.hiddenModalProductId,
                            productImages = form.productImages
                        )>
                    <cfelse>
                        <cfset result = productObject.editProduct(
                            subCategoryId = form.subCategoryId,
                            productName = form.productName,
                            brandId = form.brandId,
                            productDescription = form.productDescription,
                            productPrice = form.productPrice,
                            productTax = form.productTax,
                            productId = form.hiddenModalProductId
                        )>
                    </cfif>
                    <cfif result>
                        <div>name already exists</div>
                    </cfif>
                </cfif>
            </cfif>

            <!--- DISPLAY PRODUCT --->
            <div class="d-flex align-items-center justify-content-center">
                <cfset productDisplay = productObject.displayProduct(
                    subCategoryId = url.subCategoryId
                )>
                <table class="border w-50 mt-3">
                    <tr class="border">
                    <th class="w-75 productName">
                        <a href="./subCategoryPage.cfm?categoryId=#url.categoryId#&categoryName=#url.CategoryName#">
                            <cfoutput>
                                #url.subCategoryName#
                            </cfoutput>
                        </a>
                    </th>
                    <th></th>
                    <th></th>
                    <th></th>
                </tr>
                <cfloop query="productDisplay">
                    <tr class="border" id="#productDisplay.fldProduct_ID#">
                        <td class="d-flex justify-content-center align-items-center w-75 py-3">#productDisplay.fldProductName#</td>
                        <td class="d-flex justify-content-center align-items-center w-75 py-3">#productDisplay.fldBrandName#</td>
                        <td class="d-flex justify-content-center align-items-center w-75 py-3">#productDisplay.fldPrice#</td>
                        <td class="d-flex justify-content-center align-items-center w-75 py-3">
                            <button type="button" class="btn" data-bs-toggle="modal" data-bs-target="##staticBackdropImages" value="#productDisplay.fldProduct_ID#"
                            onclick="editImage({productId:#productdisplay.fldProduct_ID#})">
                                <img src="../assets/productImages/#productDisplay.fldImageFileName#" alt="productImage" width="100">
                            </button>
                        </td>
                        <td>
                            <button class="btn btn-primary me-2" data-bs-toggle="modal" data-bs-target="##staticBackdrop" value="#productDisplay.fldProduct_ID#"
                            onclick="autoPopulateProduct({categoryId:#url.categoryId#,subCategoryId:#productDisplay.fldSubCategoryId#,productName:'#productDisplay.fldProductName#',productBrand:#productDisplay.fldBrandId#,productDescription:'#productDisplay.fldDescription#',productPrice:#productDisplay.fldPrice#,productTax:#productDisplay.fldTax#,productId:#productDisplay.fldProduct_ID#})">
                                Edit
                            </button>
                        </td>
                        <td><button class="btn btn-danger me-2" value="#productDisplay.fldProduct_ID#" onclick="deleteProduct(this)">Delete</button></td>
                    </tr>
                </cfloop>
                </table>
            </div>

            <!--- EDIT IMAGE --->
            <div class="modal fade" id="staticBackdropImages" data-bs-backdrop="static" data-bs-keyboard="false" tabindex="-1" aria-labelledby="staticBackdropLabel" aria-hidden="true">
                <div class="modal-dialog">
                    <div class="modal-content">
                    <div class="modal-header">
                        <h5 class="modal-title" id="staticBackdropLabel">EDIT THUMBNAIL</h5>
                        <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
                    </div>
                    <div class="modal-body">
                        <div id="carouselExampleControls" class="carousel slide" data-bs-ride="carousel">
                            <div class="carousel-inner d-flex" id="carousel-inner">
                            </div>
                            <button class="carousel-control-prev" type="button" data-bs-target="##carouselExampleControls" data-bs-slide="prev">
                                <span class="carousel-control-prev-icon" aria-hidden="true"></span>
                                <span class="visually-hidden">Previous</span>
                            </button>
                            <button class="carousel-control-next" type="button" data-bs-target="##carouselExampleControls" data-bs-slide="next">
                                <span class="carousel-control-next-icon" aria-hidden="true"></span>
                                <span class="visually-hidden">Next</span>
                            </button>
                            </div>
                    </div>
                    <div class="modal-footer">
                        <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Close</button>
                        <button type="button" class="btn btn-primary">SUBMIT</button>
                    </div>
                    </div>
                </div>
            </div>

            <!--- ADD/EDIT PRODUCT MODAL --->
            <form method="post" enctype="multipart/form-data">
                <div class="modal fade" id="staticBackdrop" data-bs-backdrop="static" data-bs-keyboard="false" tabindex="-1" aria-labelledby="staticBackdropLabel" aria-hidden="true">
                    <div class="modal-dialog">
                        <div class="modal-content">
                            <div class="modal-header">
                                <h5 class="modal-title" id="staticBackdropLabel"></h5>
                                <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close" onclick="clearForm()"></button>
                            </div>

                            <div class="modal-body">
                                <cfset categoryDropDown = productObject.autoPopulateCategoryModalDropDown()>
                                <cfset subCategoryDropDown = productObject.autoPopulateSubCategoryModal(
                                    categoryId = url.categoryId
                                )>
                                <cfset brandDropDown = productObject.autoPopulateBrand()>
                                CATEGORY:
                                <select name="categoryId" id="categorySelect" onchange="dropDownChange()">
                                    <cfloop query="categoryDropDown">
                                        <option  value="#categoryDropdown.fldCategory_ID#">#categoryDropDown.fldCategoryName#</option>
                                    </cfloop>
                                </select>
                                <br><br>
                                SUB CATEGORY:
                                <select name="subCategoryId" id="subCategorySelect">
                                    <cfloop collection="#subCategoryDropDown#" item="subCategoryId">
                                        <option  value="#subCategoryId#">#subCategoryDropDown[subCategoryId]#</option>
                                    </cfloop>
                                </select>
                                <br><br>
                                PRODUCT NAME:<br>
                                <input type="text" id="modalProductName" name="productName" required>
                                <br><br>
                                PRODUCT BRAND:
                                <select name="brandId" id="brandSelect">
                                    <cfloop query="brandDropDown">
                                        <option value="#brandDropDown.fldBrand_ID#">#brandDropDown.fldBrandName#</option>
                                    </cfloop>
                                </select>
                                <br><br>
                                PRODUCT DESCRIPTION:<br>
                                <textarea type="text" cols="60" rows="10" name="productDescription" id="modalProductDescription" required></textarea>
                                <br><br>
                                PRODUCT PRICE:<br>
                                <input type="number" name="productPrice" required id="modalProductPrice">
                                <br><br>
                                PRODUCT TAX:<br>
                                <input type="number" name="productTax" required id="modalProductTax">
                                <br><br>
                                PRODUCT IMAGES:<br>
                                <input type="file" multiple name="productImages" required id="modalProductImages">
                                <br><br>
                                <input type="hidden" name="hiddenModalProductId" id="modalProductId" value="">
                            </div>

                            <div class="modal-footer">
                                <button type="button" class="btn btn-secondary" data-bs-dismiss="modal" onclick="clearForm()">Close</button>
                                <button type="submit" class="btn btn-primary" id="productSubmit" name="productSubmitButton">SUBMIT</button>
                            </div>
                        </div>
                    </div>
                </div>
            </form>

    </cfoutput>
<cfinclude  template="./footer.cfm">