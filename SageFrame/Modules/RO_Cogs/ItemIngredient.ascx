<%@ Control Language="C#" AutoEventWireup="true" CodeFile="ItemIngredient.ascx.cs" Inherits="Modules_RO_Cogs_ItemIngredient" %>
<script>
    $(function () {
        $(this).companyProfEDIT({});
        $("#tabs").tabs();
         $('.ItemIngrediantReceipe').owlCarousel({

                    navigation: true,
                    addClassActive: true,slideSpeed : 300,
                      paginationSpeed : 400,
                 
                      items : 1, 
                      itemsDesktop : false,
                      itemsDesktopSmall : false,
                      itemsTablet: false,
                      itemsMobile : false
                });
       
    });
</script>

<div class="RO_wrapper">     
            <table style="display:block;">
                <tr>
                    <td>Cost Center :  </td>
                    <td>
                        <select id="selCostCenter" class='sfInputbox' style='width:100px;'>
                          <%--  <option value="0" selected>--ALL--</option>
                            <option value="1">KOT</option>
                            <option value="2">BAR</option>
                            <option value="95">BAKERY</option>--%>
                         </select>
                    </td>
                           <td>Item Category:</td>
                    <td>   <select id="SelCategoryName" name="SelCategoryName" class="sfInputbox" style="width: 150px;"></select></td>
                    <td>Item :  </td>
                    <td>
                        <select id="selItem" class='sfInputbox' style='width:250px;'>
                            <option value="0" selected>--ALL--</option>
                         </select>
                    </td>
             
                  <%--  <td>Select Date :  </td>
                    <td>  <input type="text" id="targetdate" class="picker sfInputbox" /></td>--%>
                    <td>Option:</td>
                    <td> 
                        
                        <select id="btnOption" class='sfInputbox' style='width:100px;'>
                            <option value="Receipe" selected>Receipe</option>
                            <option value="Table" selected>Table</option>
                           
                         </select>
                    </td>
                    <td>
                         <button type="button" class="sfBtn restro-btn fa fa-eye" id="btnViewItemIngreident">View</button>
                    </td>
                </tr>
            </table>
        
        <div id="divItemIngreident" style="padding:0;">
        </div>
</div>

