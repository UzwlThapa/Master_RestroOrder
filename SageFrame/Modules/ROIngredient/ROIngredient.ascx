<%@ Control Language="C#" AutoEventWireup="true" CodeFile="ROIngredient.ascx.cs" Inherits="Modules_ROIngredient_ROIngredient" %>
<div id="tabs">
          <ul>
            <li><a href="#tabs-1">Adjustment</a></li>
    
          </ul>
          <div id="tabs-1"> 
	
		<table>
            <tr>
            <th>ITId</th>
                <td><select id="ddlITId" class="required" name="ITId">
                    
                     </select>
                 </td>
             </tr>
           
		 </table>

		<hr>

		<table>
		<tr>
            <th>ITId</th>
            <td><select id="ddlITId1" class="required" name="ITId1">
             
            </select>
            </td>
		</tr>
            <tr>
                <th>Qnty</th>
                <td><input type="text" class="required" id="txtQnty" /></td>
            </tr>
            <tr>
                <th>QntyInText</th>
                <td><input type="text" class="required" id="txtQntyInText" /></td>
            </tr>
            <tr>
                <th>UnitId</th>
                <td><select id="ddlUnitId" class="required" name="UnitId">
                    </select>
                </td>
            </tr>
            <tr>
                <td>
                    <input type="button" value="Add" class="required" id="btnadd1"/>
                </td>
            </tr>
		</table>


	</div>
	<div id="AdjustmentAdd"> </div> 
</div>