package web.app.mapred;
import org.apache.hadoop.conf.Configuration;
import org.apache.hadoop.fs.Path;
import org.apache.mahout.clustering.conversion.InputDriver;
import org.apache.mahout.clustering.kmeans.KMeansDriver;
import org.apache.mahout.clustering.kmeans.RandomSeedGenerator;
import org.apache.mahout.common.distance.DistanceMeasure;
import org.apache.mahout.common.distance.EuclideanDistanceMeasure;
import org.apache.mahout.utils.clustering.ClusterDumper;
import java.time.format.DateTimeFormatter;  
import java.time.LocalDateTime;

public class MyKmeansClusterer {

	public void RunKmeans(String path, String k, String convDelta, String maxIter) throws Exception {
		Configuration conf = new Configuration();
		DateTimeFormatter dtf = DateTimeFormatter.ofPattern("yyyy-MM-dd_HH-mm-ss");
		LocalDateTime now = LocalDateTime.now();
		Path input = new Path(path);
		Path output = new Path("hdfs://localhost:9000/MahoutData/" + dtf.format(now).toString());
		
		if(k == "")
			k = "2";
		if(convDelta == "")
			convDelta = "0.5";
		if(maxIter == "")
			maxIter = "10";
		
		int clusterSize = Integer.parseInt(k);
		double convergenceDelta = Double.parseDouble(convDelta);
		int maxIterations = Integer.parseInt(maxIter);
		
		
		run(conf, input, output, new EuclideanDistanceMeasure(), clusterSize, convergenceDelta, maxIterations);
	}
	
	public static void run(Configuration conf, Path input, Path output, DistanceMeasure measure, int k, double convergenceDelta, int maxIterations) throws Exception
	{
		Path directoryContainingConvertedInput = new Path(output, "KmeansOutputData");
		InputDriver.runJob(input, directoryContainingConvertedInput, "org.apache.mahout.math.RandomAccessSparseVector");
		
		Path clusters = new Path(output,"random-seeds");
		clusters = RandomSeedGenerator.buildRandom(conf, directoryContainingConvertedInput, clusters, k, measure);
		
		KMeansDriver.run(conf, directoryContainingConvertedInput, clusters, output, convergenceDelta, maxIterations, true, 0.0, false);
		
		Path outGlob = new Path(output, "clusters-*-final");
		Path clusteredPoints = new Path(output, "clusteredPoints");
		
		ClusterDumper clusterDumper = new ClusterDumper(outGlob, clusteredPoints);
		clusterDumper.printClusters(null);
	}

}
