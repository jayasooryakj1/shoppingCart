<cfif structKeyExists(form, "subCategorySubmit")>
    <cfif form.subCategorySubmit EQ 1>
        <cfset result = application.adminObject.editSubCategory(
            categoryId = form.categoryId,
            subCategoryId = form.subCategoryId,
            subCategoryName = form.subCategoryName
        )>
        <cfif result>
            <div>Name already exists</div>
        </cfif>
    <cfelse>
        <cfset result = application.adminObject.addSubCategory(
            categoryId = form.categoryId,
            subCategoryName = form.subCategoryName
        )>
        <cfif result>
            <div>Name already exists</div>
        </cfif>
    </cfif>
</cfif>

<cfinclude  template="./adminHeader.cfm">
    <cfoutput>
        <div>
            <div class="d-flex flex-column align-items-center justify-content-center mt-5">
                <div>
                    <button type="button" class="btn btn-primary" data-bs-toggle="modal" data-bs-target="##staticBackdrop" 
                    onclick="addSubCategory({categoryId:#url.categoryId#})">
                        ADD SUB CATEGORY +
                    </button>
                </div>
            </div>

            <!--- SUB CATEGORY DISPLAY --->
            <div class="d-flex justify-content-center align-items-center">
                <cfset subCategoriesDisplay = application.adminObject.displaySubCategories(
                    categoryId = url.categoryId
                )>
                <table class="border w-50 mt-3">
                    <tr class="border">
                        <th class="w-75 subCategoryName">
                            <a href="./index.cfm">
                                #url.categoryName#
                            </a>
                        </th>
                        <th></th>
                        <th></th>
                        <th></th>
                    </tr>
                    <cfif queryRecordCount(subCategoriesDisplay)>
                        <cfloop query="subCategoriesDisplay">
                            <tr class="border" id="#subCategoriesDisplay.fldSubCategory_ID#">
                                <td class="d-flex justify-content-center align-items-center w-75 py-3">#subCategoriesDisplay.fldSubCategoryName#</td>
                                <td>
                                    <button class="btn btn-primary me-2" data-bs-toggle="modal" data-bs-target="##staticBackdrop" value="#subCategoriesDisplay.fldSubCategory_ID#" 
                                    onclick=autoPopulateSubCategory({categoryId:#url.categoryId#,subCategoryName:'#subCategoriesDisplay.fldSubCategoryName#',submitButtonValue:"edit",subCategoryId:#subCategoriesDisplay.fldSubCategory_ID#})>
                                        Edit
                                    </button>
                                </td>
                                <td><button class="btn btn-danger me-2" value="#subCategoriesDisplay.fldSubCategory_ID#" onclick="deleteSubCategory(this)">Delete</button></td>
                                <td><a href="productPage.cfm?subCategoryId=#subCategoriesDisplay.fldSubCategory_ID#&subCategoryName=#subCategoriesDisplay.fldSubCategoryName#&categoryId=#url.categoryId#&categoryName=#url.categoryName#" class="btn btn-success me-2" value="#subCategoriesDisplay.fldSubCategory_ID#">View</a></td>
                            </tr>
                        </cfloop>
                    <cfelse>
                        <tr>
                            <td>
                                NO SUB CATEGORIES
                            </td>
                        </tr>
                    </cfif>
                </table>
            </div>

            <!--- ADD/EDIT SUB CATEGORIES MODAL --->
            <div class="modal fade" id="staticBackdrop" data-bs-backdrop="static" data-bs-keyboard="false" tabindex="-1" aria-labelledby="staticBackdropLabel" aria-hidden="true">
                <div class="modal-dialog">
                    <div class="modal-content">
                        <form method="post">
                            <div class="modal-header">
                                <h5 class="modal-title" id="staticBackdropLabel"></h5>
                                <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
                            </div>
                            <div class="modal-body">
                                CATEGORY:
                                <cfset categoryDropDown = application.adminObject.autoPopulateCategoryModalDropDown()>
                                <select name="categoryId" id="categorySelect">
                                    <cfloop query="categoryDropDown">
                                        <option  value="#categoryDropdown.fldCategory_ID#">#categoryDropDown.fldCategoryName#</option>
                                    </cfloop>
                                </select>
                                <br><br>
                                SUB CATEGORY NAME: 
                                <input name="subCategoryName" id="subCategoryNameField" type="text" required>
                                <input type="hidden" name="subCategoryId" id="subCategoryIdField">
                            </div>
                            <div class="modal-footer">
                                <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Close</button>
                                <button type="submit" name="subCategorySubmit" id="modalSubmit" value="SUBMIT" class="btn btn-secondary">SUBMIT</button>
                            </div>
                        </form>
                    </div>
                </div>
            </div>
        </div>
    </cfoutput>
<cfinclude  template="./footer.cfm">