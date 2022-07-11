<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1"%>
<%@ page import="web.app.mapred.My_Runner" %>
<!DOCTYPE html>
<html>
<head>
<meta charset="ISO-8859-1">
<title>Map-Reduce</title>
</head>
<body>
	<%
		My_Runner runner = new My_Runner();
		runner.RunRunner();
		String redirectURL = "http://localhost:8080/WebApp/index.jsp";
		response.sendRedirect(redirectURL);
	%>
</body>
</html>