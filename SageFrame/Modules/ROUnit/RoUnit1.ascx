<%@ Control Language="C#" AutoEventWireup="true" CodeFile="RoUnit1.ascx.cs" Inherits="Modules_ROUnit_RoUnit1" %>

<script type="text/javascript">
    $(function () {

        $(this).companyProfEDIT({


        });

    });


</script>

<style type="text/css">
    
    div#unittable_wrapper.dataTables_wrapper , div#unittableSecond_wrapper.dataTables_wrapper{
        padding: 0;
    }
</style>

<div class="RO_wrapper">
<div id="tabss" style="display:none;">
  <ul>
    <li><a href="#tabs-1"> Units</a></li>
    <li><a href="#tabs-2"> Conversion</a></li>
    
  </ul>
  <div id="tabs-1">
      <input type="button"  value="Add" class="sfLocale icon-addnew sfBtn" id="btnadd" style="margin-left:10px;margin-top:10px;" />
      
    <table class="Unit1" style="display:block;">
    <tr>
        <td>
            Unit Description :
        </td>
        <td>
            <input type="text" id="txtUnitDescription" class="sfInputbox required" name="UnitDescription" />
        </td>
        </tr><tr>
        <td>
            Symbol :
        </td>
        <td>
            <input type="text" id="txtSymbol" class="required sfInputbox" name="symbol" />
        </td></tr>
        <tr><td></td>
        <td>
            <input type="button"  value="Save" class="sfLocale icon-save sfBtn" id="btnUnit1Save"  />
            <input type="button"  value="Cancel" class="sfLocale icon-close sfBtn" id="btnUnit1Cancel"  />
        </td>
    </tr>
        
</table>
      <div  id="getUnit1"></div>
  </div>
    <div id="tabs-2"> 
        <input type="button"  value="Add" class="sfLocale icon-addnew sfBtn" id="btnUnitadd"  style="margin-left:10px;margin-top:10px;"/>
         <table class="unit2" style="display:block;">
        <tr>
            <td>
                Large Unit :
            </td>
            <td>
                <select id="ddFirstUnit" class="fsUnit required sfInputbox" name="firstunit" style="width:200px;"></select>
                  <%--<input type="text" id="txtFirstUnit" class="required sfInputbox" name="FirstUnit" />--%>
            </td>
            </tr>
        <tr>
              <td>
                Conversion :
            </td>
            <td>
                  <input type="text" id="txtConversion" class="required sfInputbox" name="Conversion" />
            </td>
            </tr>
        <tr>
            <td>
                Small Unit :
            </td>
             
            <td>
                 <select id="ddlSecondtUnit"  class="fsUnit required sfInputbox" name="secondunit" style="width:200px;"></select>
                  <%--<input type="text" id="txtSecondUnit" class="required sfInputbox" name="SecondUnit" />--%>
            </td>
            </tr>
        <tr>
            <td>

            </td>
            <td>
            <input type="button"  value="Save" class="sfLocale icon-save sfBtn" id="btnUnit2Save"  />
                <input type="button"  value="Cancel" class="sfLocale icon-close sfBtn" id="btnUnit2Cancel"  />
        </td>
        </tr>
    </table>   
    <div  id="getUnit2"></div>
    </div>
     

    </div>
    </div>