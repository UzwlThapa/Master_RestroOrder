using System;
using System.Collections.Generic;
using System.Data;
using SageFrame.Security;

namespace SageFrame.CostCenter
{
    public class CostCenterController
    {
        public void SaveCostCenter(CostCenterInfo dataObj)
        {
            CostCenterProvider provider = new CostCenterProvider();
            provider.SaveCostCenter(dataObj);
        }
        public List<CostCenterInfo> GetCostCenter()
        {
            CostCenterProvider provider = new CostCenterProvider();
            return provider.GetCostCenter();
        }

        public CostCenterInfo GetCostCenterById(int Id)
        {
            CostCenterProvider provider = new CostCenterProvider();
            return provider.GetCostCenterById(Id);
        }

        public void deleteCostCenter(int id)
        {
            CostCenterProvider prov = new CostCenterProvider();
            prov.deleteCostCenter(id);
        }

        public int CheckCostCenter(int id)
        {
            CostCenterProvider prov = new CostCenterProvider();
            return prov.CheckCostCenter(id);
        }



        public DataTable GetCostCenterDatatable()
        {
            CostCenterProvider prov = new CostCenterProvider();
            return prov.GetCostCenterDatatable();
        }

      
        public void SaveAssignedCostCenter(string ApplicationName, Guid userid, string UserName, string unselectedroles, string selectedRoleName, string CostCenterName ,int PortalId)
        {
            CostCenterProvider prov = new CostCenterProvider();
              RoleController role = new RoleController();
            if(unselectedroles != "")
            {
                role.ChangeUserInRoles(ApplicationName, userid, unselectedroles, selectedRoleName, PortalId);
            }
        
            prov.SaveAssignedCostCenter(UserName,CostCenterName);
        }

        public DataTable GetgridDatatable()
        {
            CostCenterProvider prov = new CostCenterProvider();
            return prov.GetgridDatatable();
        }
    }
}
