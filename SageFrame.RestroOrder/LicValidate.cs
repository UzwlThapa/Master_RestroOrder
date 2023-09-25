using System;
using System.Collections.Generic;
using System.Text;
using System.Linq;
using System.IO;
using System.IO.Compression;
using System.Runtime.Serialization.Formatters.Binary;

namespace SageFrame.RestroOrder
{
  public  class LicValidate
    {
        private Dictionary<string, string> lic_detail;
        private string path;

        public string ValidationMessage { get; private set; }

        public LicValidate()
        {
            string basePath = System.AppDomain.CurrentDomain.BaseDirectory;
            ValidationMessage = string.Empty;
            //path = new System.IO.FileInfo(System.Reflection.Assembly.GetExecutingAssembly().Location).Directory.FullName + "\\jna.sys";
            path = basePath + "/License/jna.sys";
            lic_detail = GetLicDetail();
        }

        public LicValidate(string file_path)
        {
            ValidationMessage = string.Empty;
            path = file_path;
            lic_detail = GetLicDetail();
        }

        public bool IsLicValid()
        {
            ValidationMessage = string.Empty;
            return IsMachineValid() && IsDateValid();
        }

        private Dictionary<string, string> GetLicDetail()
        {
            if (!System.IO.File.Exists(path))
                return new Dictionary<string,string>();

            using (FileStream fs = new FileStream(path, FileMode.Open, FileAccess.Read, FileShare.Read))
            using (GZipStream gz = new GZipStream(fs, CompressionMode.Decompress))
            {
                try
                {
                    BinaryFormatter bin = new BinaryFormatter();
                    return (Dictionary<string, string>)bin.Deserialize(gz);
                }
                catch
                {
                    ValidationMessage = "Invalid License file";
                    return new Dictionary<string, string>();
                }
            }
        }

        private bool IsMachineValid()
        {
            if (lic_detail == null || lic_detail.Count == 0 || !lic_detail.ContainsKey("MACHINE_ID"))
            {
                ValidationMessage = "Invalid license file or license not installed.";
                return false;
            }

            List<string> lic_mac = lic_detail["MACHINE_ID"].Split(',').ToList();

            LicRequest req = new LicRequest();
            IEnumerable<string> mac = req.GetMacSerail();

            foreach (string m in mac)
            {
                if (lic_mac.Contains(m))
                    return true;
            }
            ValidationMessage = "License file is invalid for this machine.";
            return false;
        }

        private bool IsDateValid()
        {
            if (lic_detail == null || lic_detail.Count == 0 || !lic_detail.ContainsKey("EXPIRE_DATE") || !lic_detail.ContainsKey("TODAY_DATE"))
            {
                ValidationMessage = "Invalid license file or license not installed.";
                return false;
            }

            DateTime last_used_date = new DateTime(long.Parse(lic_detail["TODAY_DATE"]));
            DateTime lic_date = new DateTime(long.Parse(lic_detail["EXPIRE_DATE"]));

            if (DateTime.Now.Date < last_used_date.Date)
            {
                ValidationMessage = "Date setting of this machine has been tempared.";
                return false;
            }

            if (lic_date.Date < DateTime.Now.Date)
            {
                ValidationMessage = "License has expired.";
                return false;
            }

            return true;
        }

        public void UpdateLic()
        {
            if (lic_detail == null || lic_detail.Count == 0 || !lic_detail.ContainsKey("TODAY_DATE"))
                throw new InvalidOperationException("Cannot update license file.");

            lic_detail["TODAY_DATE"] = DateTime.Today.Ticks.ToString();
            
            using (FileStream fs = new FileStream(path, FileMode.Create))
            using (GZipStream gz = new GZipStream(fs, CompressionMode.Compress))
            {
                BinaryFormatter bin = new BinaryFormatter();
                bin.Serialize(gz, lic_detail);
            }
        }
    }
}
