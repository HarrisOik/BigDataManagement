<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1"%>
<%@ page import = "java.util.Properties" %>
<%@ page import = "java.util.concurrent.BlockingQueue" %>
<%@ page import = "java.util.concurrent.LinkedBlockingQueue" %>
<%@ page import = "java.util.Map" %>
<%@ page import = "com.google.common.collect.Lists" %>
<%@ page import = "com.twitter.hbc.ClientBuilder" %>
<%@ page import = "com.twitter.hbc.core.Client" %>
<%@ page import = "com.twitter.hbc.core.Constants" %>
<%@ page import = "com.twitter.hbc.core.endpoint.StatusesFilterEndpoint" %>
<%@ page import = "com.twitter.hbc.core.processor.StringDelimitedProcessor" %>
<%@ page import = "com.twitter.hbc.httpclient.auth.Authentication" %>
<%@ page import = "com.twitter.hbc.httpclient.auth.OAuth1" %>
<%@ page import = "org.apache.kafka.clients.producer.KafkaProducer" %>
<%@ page import = "org.apache.kafka.clients.producer.Producer" %>
<%@ page import = "org.apache.kafka.clients.producer.ProducerRecord" %>
<%@ page import = "com.twitter.bijection.Injection" %>
<%@ page import = "com.twitter.bijection.avro.GenericAvroCodecs" %>
<%@ page import = "org.apache.avro.Schema" %>
<%@ page import = "org.apache.avro.generic.GenericData" %>
<%@ page import = "org.apache.avro.generic.GenericRecord" %>
<%@ page import = "org.json.simple.JSONObject" %>
<%@ page import = "org.json.simple.parser.JSONParser" %>
<%@ page import = "java.io.File" %>
<%@ page import = "java.io.IOException" %>
<!DOCTYPE html>
<html>
<head>
<meta charset="ISO-8859-1">
<title>Kafka Producer</title>
</head>
<body>
	<% 
		
		Properties props = new Properties();
		props.put("bootstrap.servers", "localhost:9092");
		props.put("acks", "all");
		props.put("retries", 0);
		props.put("batch.size", 16384);
		props.put("linger.ms", 1);
		props.put("buffer.memory", 33554432);
		props.put("key.serializer", "org.apache.kafka.common.serialization.StringSerializer");
		props.put("value.serializer", "org.apache.kafka.common.serialization.ByteArraySerializer");
		
		Schema schema = new Schema.Parser().parse(new File("your_schema_path"));
		
		Injection<GenericRecord, byte[]> recordInjection = GenericAvroCodecs.toBinary(schema);
		JSONParser parser = new JSONParser();
		
		Producer<String, byte[]> producer = null; 
		try 
		{ 
			String key1 = "school shooting";
			String key2 = "mass shooting";
			String key3 = "gun safety";
			if(request.getParameter("key1") != "" && request.getParameter("key2") != "" && request.getParameter("key3") != "")
			{
				key1 = request.getParameter("key1");
				key2 = request.getParameter("key2");
				key3 = request.getParameter("key3");
			}
			
			producer = new KafkaProducer<>(props);
			String consumerKey="";
			String consumerSecret="";
			String token="";
			String secret="";
			BlockingQueue<String> queue = new LinkedBlockingQueue<String>(10000);
			StatusesFilterEndpoint endpoint = new StatusesFilterEndpoint();
			endpoint.trackTerms(Lists.newArrayList(key1,key2,key3));
			Authentication auth = new OAuth1(consumerKey, consumerSecret, token, secret);
			
			Client client = new ClientBuilder()
					.hosts(Constants.STREAM_HOST)
					.endpoint(endpoint)
					.authentication(auth)
					.processor(new StringDelimitedProcessor(queue))
					.build();
			
			client.connect();
			int i = 0;
			while (i < 100) 
			{
				String msg = queue.take();
				GenericData.Record avroRecord = new GenericData.Record(schema);
				Object obj = parser.parse(msg);
				JSONObject jo = (JSONObject) obj;
				Map user = ((Map)jo.get("user"));
				if(user.get("location") != null) 
				{
					avroRecord.put("location", user.get("location").toString());
					byte[] bytes = recordInjection.apply(avroRecord);
					ProducerRecord<String, byte[]> record = new ProducerRecord<>("my_twitter", bytes);
					producer.send(record);
					System.out.println("Sent:" + record);
					i++;
				}
			}
			producer.close();
			client.stop();
			System.out.println("Done!");
		}
		catch(Exception e) 
		{
			System.out.println(e);
		}
		
		String redirectURL = "http://localhost:8080/WebApp/index.jsp";
		response.sendRedirect(redirectURL);
	%>
</body>
</html>