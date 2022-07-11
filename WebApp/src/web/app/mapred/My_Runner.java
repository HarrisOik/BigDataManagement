package web.app.mapred;
import java.io.IOException;
import java.io.File;
import java.time.format.DateTimeFormatter;  
import java.time.LocalDateTime; 
import org.apache.hadoop.io.IntWritable;
import org.apache.hadoop.fs.Path;
import org.apache.hadoop.io.Text;
import org.apache.hadoop.mapred.FileInputFormat;
import org.apache.hadoop.mapred.FileOutputFormat;
import org.apache.hadoop.mapred.JobClient;
import org.apache.hadoop.mapred.JobConf;
import org.apache.hadoop.mapred.TextInputFormat;
import org.apache.hadoop.mapred.TextOutputFormat;

public class My_Runner {

	public void RunRunner() {
		JobConf conf = new JobConf(My_Runner.class);
		conf.setJobName("State Count");
		
		conf.setOutputKeyClass(Text.class);
		conf.setOutputValueClass(IntWritable.class);
		
		conf.setMapperClass(My_Mapper.class);
		conf.setCombinerClass(My_Reducer.class);
		conf.setReducerClass(My_Reducer.class);
		
		conf.setInputFormat(TextInputFormat.class);
		conf.setOutputFormat(TextOutputFormat.class);
		conf.set("mapred.textoutputformat.separator", " ");
		
		DateTimeFormatter dtf = DateTimeFormatter.ofPattern("yyyy-MM-dd_HH-mm-ss");
		LocalDateTime now = LocalDateTime.now();
		
		String arguments[] = new String[2];
		arguments[0] = "C:/tmp/data/data.txt";
		arguments[1] = "hdfs://localhost:9000/MapredData/" + dtf.format(now).toString();
		
		
		FileInputFormat.setInputPaths(conf, new Path(arguments[0]));
		FileOutputFormat.setOutputPath(conf, new Path(arguments[1]));
		
		try {
			JobClient.runJob(conf);
			File file = new File("C:/tmp/data/data.txt");
			file.delete();
			System.out.println("Job was successful");
		}
		catch (Exception e) 
		{
			e.printStackTrace();
			System.out.println("Job was not successful");
		}

	}

}
