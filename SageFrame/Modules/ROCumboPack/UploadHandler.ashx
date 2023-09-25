<%@ WebHandler Language="C#" Class="UploadHandler" %>

using System;
using System.Web;
using System.IO;

public class UploadHandler : IHttpHandler {

    public void ProcessRequest(HttpContext context)
    {

        string realFilePath = "";
        string fileName = "";
        string fileFullPathToFolder = "";
        string fileType = "";


        if (context.Request.Files.Count <= 0)
        {
            context.Response.Write("No file uploaded");
        }
        else
        {
            int i, type = 0;
            HttpPostedFile receiveFile = context.Request.Files[0];
            fileType = receiveFile.ContentType;
            string[] fileTypeChecker = fileType.Split('/');
            if (fileTypeChecker[0] == "image")
            {
                string[] checkValidityForImg = { "jpg", "jpeg", "png", "gif" };
                for (i = 0; i < checkValidityForImg.Length; i++)
                {
                    if (fileTypeChecker[1] == checkValidityForImg[i])
                    {
                        type = 1;
                        break;
                    }
                }
            }
            else if (fileTypeChecker[0] == "application")
            {
                string[] checkValidityForResume = { "pdf" };
                for (i = 0; i < checkValidityForResume.Length; i++)
                {
                    if (fileTypeChecker[1] == checkValidityForResume[i])
                    {
                        type = 2;
                        break;
                    }
                }
            }
            if (type == 0)
            {
                context.Response.StatusCode = 500;
                context.Response.Write("File Format Not Supported");
            }

            else
            {
                if (type == 1)
                {
                    realFilePath = HttpContext.Current.Server.MapPath("~/Modules/ROCumboPack/images/");
                }
                else if (type == 2)
                {
                    realFilePath = HttpContext.Current.Server.MapPath("~/Modules/ROCumboPack/images/");
                }

                fileName = receiveFile.FileName.Replace("_","-").Replace(" ","-");

                fileFullPathToFolder = realFilePath + fileName;
                string[] renamer = fileName.Split('.');
                i = 1;
                while (true)
                {
                    FileInfo fileInformation = new FileInfo(fileFullPathToFolder);
                    if (fileInformation.Exists)
                    {

                        fileName = renamer[0] + "-copy" + i + "." + renamer[1];
                        fileFullPathToFolder = realFilePath + fileName;
                        i++;
                    }
                    else
                        break;
                }

                receiveFile.SaveAs(fileFullPathToFolder);

                context.Response.Write(fileName);

            }

        }
    }

    //public void ProcessRequest (HttpContext context) {
    //    context.Response.ContentType = "text/plain";
    //    context.Response.Write("Hello World");
    //}

    public bool IsReusable {
        get {
            return false;
        }
    }

}