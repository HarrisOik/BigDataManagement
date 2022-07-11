<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1"%>
<%@ page import = "java.io.File" %>
<%@ page import = "java.io.FileWriter" %>
<%@ page import = "org.apache.avro.Schema" %>
<%@ page import = "org.apache.avro.file.DataFileReader" %>
<%@ page import = "org.apache.avro.generic.GenericDatumReader" %>
<%@ page import = "org.apache.avro.generic.GenericRecord" %>
<%@ page import = "org.apache.avro.io.DatumReader" %>
<%@ page import = "org.apache.avro.mapred.FsInput" %>
<%@ page import = "org.apache.hadoop.conf.Configuration" %>
<%@ page import = "org.apache.hadoop.fs.Path" %>
<!DOCTYPE html>
<html>
<head>
<meta charset="ISO-8859-1">
<title>Data Formatter</title>
</head>
<body>
	<%
		String path = request.getParameter("path");
		File file = new File("C:/tmp/data/data.txt");
		file.createNewFile();
		FileWriter output = new FileWriter("C:/tmp/data/data.txt");
		Configuration conf = new Configuration();
		FsInput in = new FsInput(new Path(path), conf);
		
		Schema schema = new Schema.Parser().parse(new File("your_schema_path"));
		DatumReader<GenericRecord> datumReader = new GenericDatumReader<GenericRecord>(schema);
		
		DataFileReader<GenericRecord> dataFileReader = new DataFileReader<GenericRecord>(in, datumReader);
		GenericRecord loc = null;
		String[] alphaCode = {"TX","AL","AK","AZ","AR","CA","CO","CT","DE","DC","FL","GA","HI","ID","IL","IN","IA","KS","KY","LA","ME","MD","MA","MI","MN","MS","MO","MT","NE","NV","NH","NJ","NM","NY","NC","SC","ND","SD","OH","OK","OR","PA","RI","TN","UT","VT","WV","VA","WA","WI","WY"};
		String[] state = {"Texas","Alabama","Alaska","Arizona","Arkansas","California","Colorado","Connecticut","Delaware","District of Columbia", "Florida","Georgia","Hawaii","Idaho","Illinois","Indiana","Iowa","Kansas","Kentucky","Louisiana","Maine","Maryland","Massachusetts","Michigan","Minnesota","Mississippi","Missouri","Montana","Nebraska","Nevada","New Hampshire","New Jersey","New Mexico","New York","North Carolina","South Carolina","North Dakota","South Dakota","Ohio","Oklahoma","Oregon","Pennsylvania","Rhode Island","Tennessee","Utah","Vermont","West Virginia","Virginia","Washington","Wisconsin","Wyoming"};
		int[] num = {48,1,2,4,5,6,8,9,10,11,12,13,15,16,17,18,19,20,21,22,23,24,25,26,27,28,29,30,31,32,33,34,35,36,37,45,38,46,39,40,41,42,44,47,49,50,54,51,53,55,56};
		while(dataFileReader.hasNext()) 
		{
			String data = "0";
			loc = dataFileReader.next(loc);
			for (int i = 0; i < alphaCode.length; i++) 
			{
				if(loc.get("location").toString().contains(alphaCode[i]) || loc.get("location").toString().contains(state[i])) 
				{
					data = loc.get("location").toString().replace(loc.get("location").toString(), String.valueOf(num[i]));
				}
			}		
			if(data != "0") 
			{
				if(dataFileReader.hasNext())
					output.write(data + "\n");
				else
					output.write(data);
			}
				
		}
		dataFileReader.close();
		output.close();
		System.out.println("Data Parsed Successfully!");
		String redirectURL = "http://localhost:8080/WebApp/index.jsp";
		response.sendRedirect(redirectURL);
	%>
</body>
</html>