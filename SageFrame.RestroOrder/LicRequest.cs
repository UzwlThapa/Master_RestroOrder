using System;
using System.Collections.Generic;
using System.Management;
using System.Text;
using System.IO;
using System.Runtime.Serialization.Formatters.Binary;

namespace SageFrame.RestroOrder
{
  public  class LicRequest
    {
        public void CreateReqFile(string req_file)
        {
            List<string> sys_info = new List<string>();
                        
            sys_info.AddRange(GetMacSerail());

            using (FileStream mem = new FileStream(req_file,FileMode.Create))
            {
                BinaryFormatter bin = new BinaryFormatter();
                bin.Serialize(mem, sys_info);
            }
        }
        
        //public IEnumerable<string> GetHDSerail()
        //{
        //    List<string> hd_serial = new List<string>();

        //    ManagementObjectSearcher searcher = new ManagementObjectSearcher("SELECT * FROM Win32_PhysicalMedia");
            
        //    foreach (ManagementObject wmi_HD in searcher.Get())
        //    {
        //        if (wmi_HD["SerialNumber"] != null)
        //        {
        //            hd_serial.Add(wmi_HD["SerialNumber"].ToString());
        //        }
        //    }
        //    return hd_serial;
        //}

        public IEnumerable<string> GetMacSerail()
        {
            List<string> mac_serial = new List<string>();

            ManagementObjectSearcher searcher = new ManagementObjectSearcher("SELECT * FROM Win32_NetworkAdapterConfiguration");

            foreach (ManagementObject wmi_HD in searcher.Get())
            {
                if (wmi_HD["MacAddress"] != null && !mac_serial.Contains(wmi_HD["MacAddress"].ToString()))
                    mac_serial.Add(wmi_HD["MacAddress"].ToString());
            }
            return mac_serial;
        }
    }
}
