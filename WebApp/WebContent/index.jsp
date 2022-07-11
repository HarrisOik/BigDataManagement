<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="ISO-8859-1">
<title>Big Data Management</title>
</head>
<style>
body {text-align: center;}
</style>
<body>
<h1>Kafka Producer</h1>
<form action = "producer.jsp" method = "GET">
Provide 3 keywords (must be exactly 3; defaults to "school shooting", "mass shooting", "gun safety"):
 
<br>
Keyword 1: <input type = "text" name = "key1" size="30" /> 
<br>
Keyword 2: <input type = "text" name = "key2" size="30" /> 
<br>
Keyword 3: <input type = "text" name = "key3" size="30" /> 
<br>
<input type = "submit" value = "Produce" />
</form>
<br>
<br>
<h1>Data Preprocessing-Formatting</h1>
<form action = "formatter.jsp" method = "GET">
Wait >5 minutes to use Produced data!
<br>
Data Path to Format (.avro):
<br>
<input type = "text" name = "path" size="128" /> 
<br>
<input type = "submit" value = "Format" />
</form>
<br>
<br>
<h1>Map-Reduce Data</h1>
<form action = "mapred.jsp" method = "GET">
Map-Reduce Formatted Data:
<br>
<input type = "submit" value = "Reduce" />
</form>
<br>
<br>
<h1>Cluster Reduced Data</h1>
<form action = "kmeans.jsp" method = "GET">
Data Path to Cluster Using Kmeans:
<br>
<input type = "text" name = "path" size="128" /> 
<br>
Number of Clusters (defaults to 2): <input type = "text" name = "k" size="3" /> 
<br>
Convergence Delta (defaults to 0.5): <input type = "text" name = "convDelta" size="5" /> 
<br>
Maximum Number of Iterations (defaults to 10): <input type = "text" name = "maxIter" size="5" />
<br>
<input type = "submit" value = "Kmeans Cluster" />
</form>
</body>
</html>