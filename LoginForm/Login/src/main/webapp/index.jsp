<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<% 
    if (session != null && session.getAttribute("username") != null) {
        response.sendRedirect("pages/dashboard.jsp");
    } else {
        response.sendRedirect("pages/login.jsp");
    }
%>