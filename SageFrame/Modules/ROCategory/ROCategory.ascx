<%@ Control Language="C#" AutoEventWireup="true" CodeFile="ROCategory.ascx.cs" Inherits="Modules_ROCategory_ROCategory" %>

<script src="//ajax.googleapis.com/ajax/libs/jquery/1.9.1/jquery.min.js"></script>
<script src="/Modules/RoItem/js/vendor/jquery.ui.widget.js"></script>
<script src="/Modules/RoItem/js/jquery.iframe-transport.js"></script>
<script src="/Modules/RoItem/js/jquery.fileupload.js"></script>


<script type="text/javascript">
    var filename;
    $(function () {
        var imagefile = [];
        $(this).companyProfEDIT({


        });
    });
    </script>


<div class="RO_wrapper">
<div class="restro-title clearfix">
        <h3>Categories</h3>

        <input type="button" id="AddCategories" class="sfLocale icon-addnew sfBtn" value="Add">
        </div>
        <div id="categoriesTable">
            <table id="RO-category">
                <tr>
                    <td>Category Name :
                    </td>
                    <td>
                        <input type="text" id="textCategoriesName" name="abd" class="required sfInputbox" />
                    </td>
                </tr>
                <tr>
                    <td>Image :
                    </td>
                    <td>
                       
                        <%--//<input type="file" id="fileUpload" class="classupload" value="browse" style="margin-left: 79px" />--%>
                   <ul class="upload-part">
                        <li><input type="text" id="txtFile" name="path" class="required sfInputbox" /></li>
                         <li><div id="fileuploaderMain">Upload</div></li>
                       </ul>
                    </td>
                    
                        <td class="showimage">
                       <img  id="ImgPreview" width='100' height='100'/>
                    </td>
                    <%-- <td>
                        <%--<input type="file" name="filetoupload" id="filetoupload" onchange="fileselected();" />
                       
                        <input type="file" name="files[]" id="textPhotoPath" data-url="image/" />
                        <div id="progress">
                            <div class="bar" style="width: 0%;"></div>
                        </div>
                    </td>--%>
                </tr>
                <tr>
                    <td>Menu
                    </td>
                    <td>
                        <select id="ddlMenu" name="ac" class="required sfInputbox"></select>
                    </td>

                </tr>

            </table>
        </div>
        <div id="CategoriesButton">
            <label id="btnCategoriesSave" class="sfLocale icon-save sfBtn">Save</label>
            <label id="btnCategoriesCancel" class="sfLocale icon-close sfBtn">Cancel</label>
        </div>
    <div id="categoriesdata"></div>
</div>
