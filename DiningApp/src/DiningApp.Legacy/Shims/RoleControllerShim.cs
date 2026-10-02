#pragma warning disable
using System.Collections.Generic;
namespace SageFrame.Security.Controllers {
    public class RoleInfoX { public string RoleName { get; set; } }
    public class RoleController {
        public bool IsRoleExist(string applicationName, string roleName) => true;
        public bool CreateRole(string applicationName, string roleName, string description) => true;
        public List<string> GetAllRoles(string applicationName) => new List<string>();
        public bool AddUserToRole(string applicationName, string userName, string roleName) => true;
        public bool RemoveUserFromRole(string applicationName, string userName, string roleName) => true;
    }
}
