#pragma warning disable
using System;
using System.Collections.Generic;
namespace SageFrame.Security.Controllers {
    // Partial extension of the RoleController declared in MembershipPort.cs.
    // Only used by CostCenterController.SaveAssignedCostCenter (admin-side user/cost-center assignment),
    // which is outside the waiter-app scope. No-op parity stubs.
    public partial class RoleController {
        public void ChangeUserInRoles(string applicationName, Guid userid, string unselectedroles, string selectedRoleName, int PortalId) { /* no-op: role management out of dining scope */ }
        public bool IsRoleExist(string applicationName, string roleName) => true;
        public bool CreateRole(string applicationName, string roleName, string description) => true;
        public List<string> GetAllRoles(string applicationName) => new List<string>();
        public bool AddUserToRole(string applicationName, string userName, string roleName) => true;
        public bool RemoveUserFromRole(string applicationName, string userName, string roleName) => true;
    }
}
