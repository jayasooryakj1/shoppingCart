<cfinclude  template="./userHeader.cfm">

    <cfoutput>
        <div class="categoryBar">
        <cfset displayResult = application.userObject.getCategory()>
        <cfloop query="displayResult">
            <div>
                #displayResult.fldCategoryName#
            </div>
        </cfloop>
        </div>
    </cfoutput>

<cfinclude  template="./userFooter.cfm">