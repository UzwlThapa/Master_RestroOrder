<%@ WebService Language="C#" Class="RoiItem" %>
using System;
using System.Collections.Generic;
using System.Linq;
using System.Web.Services;
using SageFrame.RestroOrder;
using System.Web.Script.Serialization;
using System.Web.Script.Services;
using Newtonsoft.Json;

/// <summary>
/// Summary description for RoiItem
/// </summary>
[WebService(Namespace = "http://tempuri.org/")]
[WebServiceBinding(ConformsTo = WsiProfiles.BasicProfile1_1)]
// To allow this Web Service to be called from script, using ASP.NET AJAX, uncomment the following line. 
[System.Web.Script.Services.ScriptService]
public class RoiItem : System.Web.Services.WebService
{
    [WebMethod]
    public string GetExtraItemsList()
    {
        try
        {
            RestrOrderController rocobj = new RestrOrderController();
            List<extraItem> extralist = rocobj.GetExtraItemList().Where(p => p.IsDeleted == false).ToList();
            return JsonConvert.SerializeObject(extralist);
        }
        catch (Exception)
        {

            throw;
        }
    }
    [WebMethod]
    public List<extraItem> getExtraItemByItemID(int id)
    {
        try
        {
            RestrOrderController rocobj = new RestrOrderController();
            return rocobj.getExtraItemforItem().Where(p => p.ItemID == id && p.IsDeleted == false).ToList();
        }
        catch (Exception)
        {
            throw;
        }
    }

    [WebMethod]
    public void DeleteGroupItemByID(int ids)
    {
        RestrOrderController roc = new RestrOrderController();
        roc.DeleteGroupItemByID(ids);
    }

    [WebMethod]
    public string ViewItemByID(int ids)
    {
        RestrOrderController roc = new RestrOrderController();
        List<ROInvItem> itembtid = roc.ViewItemByID(ids);
        return JsonConvert.SerializeObject(itembtid);
    }

    [WebMethod]
    public List<GroupWithItem> getGroupByID(int ids)
    {
        try
        {
            RestrOrderController roc = new RestrOrderController();
            return roc.getGroupByID(ids);
        }
        catch (Exception ex)
        {
            throw ex;
        }
    }

    [WebMethod]
    public void deleteGroupByID(int ids)
    {
        try
        {
            RestrOrderController roc = new RestrOrderController();
            roc.deleteGroupByID(ids);

        }
        catch (Exception ex)
        {
            throw ex;
        }
    }

    [WebMethod]
    public List<ItemGroup> getGroupList()
    {
        try
        {
            RestrOrderController roc = new RestrOrderController();
            return roc.getGroupList();

        }
        catch (Exception ex)
        {

            throw ex;
        }
    }
    [WebMethod]
    public int saveGroupItem(ItemGroup group)
    {
        try
        {
            RestrOrderController roc = new RestrOrderController();
            return roc.saveGroupItem(group);
        }
        catch (Exception ex)
        {
            throw ex;
        }
    }

    [WebMethod]
    public string GetItemForSearch()
    {
        try
        {
            RestrOrderController roc = new RestrOrderController();
            List<MvPurchaseDetails> searchList = roc.GetItemForSearch();
            return JsonConvert.SerializeObject(searchList);
        }
        catch (Exception)
        {
            throw;
        }
    }

    [WebMethod]
    public string CheckItemExistence(string item, string categoryid)
    {
        RestrOrderController roc = new RestrOrderController();
        List<ROInvItem> lst = roc.GetItemList().Where(x => x.ITName == item && x.IsCategory == false && x.PITId == (Convert.ToInt32(categoryid) > 0 ? Convert.ToInt32(categoryid) : 0)).ToList();
        return JsonConvert.SerializeObject(lst);
    }

    [WebMethod]
    public string CheckItemExistenceForCategory(string item)
    {
        RestrOrderController roc = new RestrOrderController();
        List<ROInvItem> lst = roc.GetRoiItemForCategoryHirerchy().Where(x => x.ITName == item).ToList();
        return JsonConvert.SerializeObject(lst);
    }

    [WebMethod]
    public void DeleteItem(int Itemid, string userName)
    {
        RestrOrderController roc = new RestrOrderController();
        roc.DeleteROIiTEM(Itemid, userName);
    }

    [WebMethod]
    public List<extraItem> extraItemData(int id)
    {
        RestrOrderController roc = new RestrOrderController();
        return roc.extraItemData(id);
    }

    [WebMethod]
    public List<itemWithUnit> ItemWithUnitList(int id)
    {
        RestrOrderController roc = new RestrOrderController();
        return roc.ItemWithUnitList(id);
    }

    [WebMethod]
    public itemDetailsData getDetails(int id)
    {
        itemDetailsData obj = new itemDetailsData();
        RestrOrderController roc = new RestrOrderController();
        obj.extra = roc.extraItemData(id);
        obj.units = roc.ItemWithUnitList(id);
        obj.storeitemstock = roc.getstoreitemforstock(id);

        return obj;
    }

    [WebMethod]
    public string GetItemList()
    {
        RestrOrderController roc = new RestrOrderController();
        List<ROInvItem> invItem = roc.GetItemList();
        return JsonConvert.SerializeObject(invItem);
    }

    [WebMethod]
    public string GetInventoryItemList()
    {
        RestrOrderController roc = new RestrOrderController();
        List<ROInvItem> invItem = roc.GetInventoryItemList();
        return JsonConvert.SerializeObject(invItem);
    }

    [WebMethod]
    public string CheckItemExistenceForInventory(string item)
    {
        RestrOrderController roc = new RestrOrderController();
        List<ROInvItem> lst = roc.GetInventoryItemList().Where(x => x.ITName == item).ToList();
        return JsonConvert.SerializeObject(lst);
    }

    [WebMethod]
    public int saveItems(ROInvItem itemObject, string extraItemList)
    {
        try
        {
            List<extraItem> extraItemListNew = new List<extraItem>();
            if (extraItemList != null && extraItemList != "" && extraItemList != "[]")
            {
                extraItemListNew = JsonConvert.DeserializeObject<List<extraItem>>(extraItemList);
            }

            RestrOrderController roc = new RestrOrderController();
            return roc.saveItems(itemObject, extraItemListNew);
        }
        catch (Exception ex)
        {
            throw ex;
        }
    }

    [WebMethod]
    public int saveInventoryItems(ROInvItem itemObject, string extraItemList)
    {
        try
        {
            List<extraItem> extraItemListNew = new List<extraItem>();
            if (extraItemList != null && extraItemList != "" && extraItemList != "[]")
            {
                extraItemListNew = JsonConvert.DeserializeObject<List<extraItem>>(extraItemList);
            }

            RestrOrderController roc = new RestrOrderController();
            return roc.saveInventoryItems(itemObject, extraItemListNew);
        }
        catch (Exception ex)
        {
            throw ex;
        }
    }

    [WebMethod]
    public string getOnlySmallUnit()
    {
        RestrOrderController roc = new RestrOrderController();
        List<unitclassforitem> smallunit = roc.getOnlySmallUnit();
        return JsonConvert.SerializeObject(smallunit);
    }

    [WebMethod]
    public string GetUNITbySmallUnit(int unit)
    {
        RestrOrderController roc = new RestrOrderController();
        List<unitclassforitem> bysmallunit = roc.GetUNITbySmallUnit(unit);
        return JsonConvert.SerializeObject(bysmallunit);
    }

    [WebMethod]
    public string GetCategoryName(bool IsMenu = true)
    {
        RestrOrderController roc = new RestrOrderController();
        List<unitclassforitem> parent = roc.GetPareintItem(IsMenu);
        return JsonConvert.SerializeObject(parent);
    }

    [WebMethod]
    public string GetCostCenter()
    {
        RestrOrderController roc = new RestrOrderController();
        List<costCenter> costcenter = roc.getcostcenter();
        return JsonConvert.SerializeObject(costcenter);
    }

    [WebMethod]
    public void GetAllUnitforItem()
    {
        try
        {
            RestrOrderController roc = new RestrOrderController();
            List<ROInvItemForApi> itemList = new List<ROInvItemForApi>();
            itemList = roc.getItemListForApi();
            foreach (var item in itemList)
            {
                if (item.IsCombo == false)
                {
                    item.extradata = roc.GetItemExtraListByItemID(item.ItemId);
                }
            }

            JavaScriptSerializer jss = new JavaScriptSerializer();

            string orderJson = jss.Serialize(itemList);
            dynamic parsedJson = JsonConvert.DeserializeObject(orderJson);
            var jsonFormatted = JsonConvert.SerializeObject(parsedJson, Formatting.Indented);
            Context.Response.Clear();
            Context.Response.ContentType = "application/json";
            Context.Response.Write("{statusCode:200, message:\"Success\", data:" + jsonFormatted + "}");
        }
        catch (Exception ex)
        {
            Context.Response.Write("{statusCode:100, message:\"" + ex.Message + "\"}");
        }
    }

    [WebMethod]
    public string GetInventoryItemWithSmallUnit()
    {
        try
        {
            RestrOrderController roc = new RestrOrderController();
            List<MvPurchaseDetails> invwithUnit = roc.GetInventoryItemWithSmallUnit();
            return JsonConvert.SerializeObject(invwithUnit);
        }
        catch (Exception)
        {
            throw;
        }
    }

    [WebMethod]
    public string getIngredientByID(int id)
    {
        try
        {
            RestrOrderController roc = new RestrOrderController();
            List<IngredientItems> ingid = roc.getIngredientByID(id);
            return JsonConvert.SerializeObject(ingid);
        }
        catch (Exception)
        {
            throw;
        }
    }

    [WebMethod]
    public void DeleteIngredientItemByID(int IngredientID, int ItemID)
    {
        try
        {
            RestrOrderController roc = new RestrOrderController();
            roc.DeleteIngredientItemByID(IngredientID, ItemID);
        }
        catch (Exception)
        {
            throw;
        }
    }

    [WebMethod]
    public string GetUnitOfItemByID(int ids)
    {
        try
        {
            RestrOrderController roc = new RestrOrderController();
            List<MvPurchaseDetails> getbyId = roc.getUnitsWithConvertion(ids);
            return JsonConvert.SerializeObject(getbyId);
        }
        catch (Exception)
        {
            throw;
        }
    }

    [WebMethod]
    [ScriptMethod(ResponseFormat = ResponseFormat.Json)]
    public void UpdateItemStockStatus(string json)
    {
        JavaScriptSerializer jss = new JavaScriptSerializer();
        var itemInfo = jss.Deserialize<ROInvItemForApi>(json);
        RestrOrderController roc = new RestrOrderController();

        Context.Response.Clear();
        Context.Response.ContentType = "application/json";
        try
        {
            roc.UpdateItemStockStatus(itemInfo);
            Context.Response.Write("{statusCode:200, message:\"Success\"}");
        }
        catch (Exception ex)
        {
            Context.Response.Write("{statusCode:100, message:\"" + ex.Message + "\"}");
        }
    }

    [WebMethod]
    public string getIssueToDDlHirerchy()
    {
        try
        {
            RestrOrderController roc = new RestrOrderController();
            List<roistore> store = roc.getIssueToDDlHirerchy();
            return JsonConvert.SerializeObject(store);
        }
        catch (Exception)
        {
            throw;
        }
    }

    [WebMethod]
    public List<StoreItemStock> getstoreitemforstock(int id)
    {
        RestrOrderController roc = new RestrOrderController();
        return roc.getstoreitemforstock(id);
    }

    [WebMethod]
    public void saveBevearge(List<ROInvItem> itemlist, string extraItemList)
    {
        try
        {
            List<extraItem> extraItemListNew = new List<extraItem>();
            if (extraItemList != null && extraItemList != "" && extraItemList != "[]")
            {
                extraItemListNew = JsonConvert.DeserializeObject<List<extraItem>>(extraItemList);
            }

            RestrOrderController roc = new RestrOrderController();
            roc.saveBevearge(itemlist, extraItemListNew);
        }
        catch (Exception ex)
        {
            throw ex;
        }
    }
}
