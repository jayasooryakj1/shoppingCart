<cfinclude  template="./adminHeader.cfm">
    <cfset productObject = createObject("component", "components.adminComponent")>
    <cfoutput>

            <div class="d-flex flex-column align-items-center justify-content-center mt-5">
                <button type="button" class="btn btn-primary" data-bs-toggle="modal" data-bs-target="##staticBackdrop"
                onclick="addProduct()">
                    ADD PRODUCT +
                </button>
            </div>

            <cfif structKeyExists(form, "productSubmitButton")>
                <cfif form.productSubmitButton EQ 1>
                    <cfset result = productObject.addProduct(
                        subCategoryId = form.subCategoryId,
                        productName = form.productName,
                        brandName = form.brandName,
                        productDescription = form.productdescription,
                        productPrice = form.productPrice,
                        productTax = form.productTax,
                        productImages = form.productImages
                    )>
                    <cfif result>
                        <div>Name already exists</div>
                    </cfif>
                <cfelse>
                </cfif>
            </cfif>

            <!--- ADD/EDIT PRODUCT MODAL --->
            <form method="post">
                <div class="modal fade" id="staticBackdrop" data-bs-backdrop="static" data-bs-keyboard="false" tabindex="-1" aria-labelledby="staticBackdropLabel" aria-hidden="true">
                    <div class="modal-dialog">
                        <div class="modal-content">
                            <div class="modal-header">
                                <h5 class="modal-title" id="staticBackdropLabel"></h5>
                                <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
                            </div>

                            <div class="modal-body">
                                <cfset categoryDropDown = productObject.autoPopulateCategoryModalDropDown()>
                                <cfset subCategoryDropDown = productObject.autoPopulateSubCategoryModal()>
                                CATEGORY:
                                <select name="categoryId" id="categorySelect">
                                    <cfloop query="categoryDropDown">
                                        <option  value="#categoryDropdown.fldCategory_ID#">#categoryDropDown.fldCategoryName#</option>
                                    </cfloop>
                                </select>
                                <br><br>
                                SUB CATEGORY:
                                <select name="subCategoryId" id="subCategorySelect">
                                    <cfloop query="subCategoryDropDown">
                                        <option  value="#subCategoryDropdown.fldSubCategory_ID#">#subCategoryDropDown.fldSubCategoryName#</option>
                                    </cfloop>
                                </select>
                                <br><br>
                                PRODUCT NAME:<br>
                                <input type="text" name="productName" required>
                                <br><br>
                                PRODUCT BRAND:<br>
                                <input type="text" name="BrandName" required>
                                <br><br>
                                PRODUCT DESCRIPTION:<br>
                                <textarea type="text" cols="60" rows="10" name="productDescription" required></textarea>
                                <br><br>
                                PRODUCT PRICE:<br>
                                <input type="number" name="productPrice" required>
                                <br><br>
                                PRODUCT TAX:<br>
                                <input type="number" name="productTax" required>
                                <br><br>
                                PRODUCT IMAGES:<br>
                                <input type="file" multiple name="productImages" required>
                                <br><br>
                            </div>

                            <div class="modal-footer">
                                <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Close</button>
                                <button type="submit" class="btn btn-primary" id="productSubmit" name="productSubmitButton">SUBMIT</button>
                            </div>
                        </div>
                    </div>
                </div>
            </form>

    </cfoutput>
<cfinclude  template="./footer.cfm">