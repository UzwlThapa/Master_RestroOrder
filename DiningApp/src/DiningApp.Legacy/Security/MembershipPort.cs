// Ported subset of SageFrame.Security Membership stack used by ROLoginWebService.
#pragma warning disable
using System;
using System.Collections.Generic;
using System.Data;
using Microsoft.Data.SqlClient;
using SageFrame.Web.Utilities;
using SageFrame.Security.Entities;

namespace SageFrame.Security.Providers {
    public class MembershipDataProvider {
        // Faithful port of the reader-based GetUserDetails (usp_GetUserDetails @UserName,@PortalID).
        public static UserInfo GetUserDetails(string UserName, int PortalID) {
            string sp = "[dbo].[usp_GetUserDetails]";
            var sagesql = new SQLHandler();
            var ps = new SQLParameterCollection();
            ps.AddParameter("@UserName", UserName);
            ps.AddParameter("@PortalID", PortalID);
            var ds = sagesql.ExecuteAsDataSet(sp, ps);
            var obj = new UserInfo();
            if (ds.Tables.Count > 0 && ds.Tables[0].Rows.Count > 0) {
                DataRow reader = ds.Tables[0].Rows[0];
                Func<string, object> col = name => {
                    foreach (DataColumn c in ds.Tables[0].Columns)
                        if (string.Equals(c.ColumnName, name, StringComparison.OrdinalIgnoreCase)) return reader[c];
                    return DBNull.Value;
                };
                obj.UserID = new Guid(col("userid").ToString());
                obj.UserName = col("Username").ToString();
                obj.Password = col("Password").ToString();
                obj.PasswordSalt = col("PasswordSalt").ToString();
                obj.PasswordFormat = int.Parse(col("PasswordFormat").ToString());
                obj.FirstName = col("FirstName").ToString();
                obj.LastName = col("LastName").ToString();
                obj.Email = col("Email").ToString();
                obj.CreatedDate = DateTime.Parse(col("CreateDate").ToString());
                obj.LastPasswordChangeDate = DateTime.Parse(col("LastPasswordChangedDate").ToString());
                obj.LastActivityDate = DateTime.Parse(col("LastActivityDate").ToString());
                obj.LastLoginDate = DateTime.Parse(col("LastLoginDate").ToString());
                obj.IsApproved = bool.Parse(col("IsApproved").ToString());
                obj.UserExists = true;
            }
            return obj;
        }
        public static List<SettingInfo> GetSettings() {
            var sagesql = new SQLHandler();
            return sagesql.ExecuteAsList<SettingInfo>("[dbo].[usp_getAllSettings]");
        }
    }
}
namespace SageFrame.Security.Controllers {
    using SageFrame.Security.Providers;
    public class MembershipController {
        public UserInfo GetUserDetails(int PortalID, string UserName) => MembershipDataProvider.GetUserDetails(UserName, PortalID);
    }
    public partial class RoleController {
        // Roles are fetched via RestrOrderController.GetUsersDetail in the login path; kept for signature parity.
        public List<RoleInfo> GetRoles(int PortalID) => new List<RoleInfo>();
    }
}
