using System;
using System.Collections.Generic;
using System.IO;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
//using Microsoft.SqlServer.Management.Smo;
using SageFrame.Web;

public partial class Modules_ROPurchaseOrder_ROCheckOrder : BaseAdministrationUserControl
{
    protected void Page_Load(object sender, EventArgs e)
    {
        string path = "/Modules/ROPurchaseOrder/";
        string fullPath = Server.MapPath(path);
        FileSystemWatcher myWatcher = new FileSystemWatcher(fullPath, "purchaseorder.Json");
        myWatcher.Changed += new FileSystemEventHandler(myWatcher_Changed);
        myWatcher.EnableRaisingEvents = true;
    }

    private void myWatcher_Changed(object source, FileSystemEventArgs e)
    {
        String status = "New Item Updated";
        lblStatus.Text = status;
    }

    protected void Timer1_OnTick(object sender, EventArgs e)
    {
        string path = "/Modules/ROPurchaseOrder/purchaseorder.Json";
        string fullPath = Server.MapPath(path);
        FileSystemWatcher myWatcher = new FileSystemWatcher(fullPath);
        myWatcher.Changed += new FileSystemEventHandler(myWatcher_Changed);
        myWatcher.EnableRaisingEvents = true;
    }
}