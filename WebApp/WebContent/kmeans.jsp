<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1"%>
<%@ page import="web.app.mapred.MyKmeansClusterer" %>
<!DOCTYPE html>
<html>
<head>
<meta charset="ISO-8859-1">
<title>Kmeans Clustering</title>
</head>
<body>
	<%
		MyKmeansClusterer runner = new MyKmeansClusterer();
		runner.RunKmeans(request.getParameter("path"),request.getParameter("k"),request.getParameter("convDelta"),request.getParameter("maxIter"));
		String redirectURL = "http://localhost:8080/WebApp/index.jsp";
		response.sendRedirect(redirectURL);
	%>
</body>
</html>